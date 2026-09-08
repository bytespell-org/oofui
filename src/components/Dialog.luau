--!strict

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Container = require(script.Parent.Container)
local Dependencies = require(script.Parent.Parent.Dependencies)
local IconButton = require(script.Parent.IconButton)
local Tags = require(script.Parent.Parent.internal.Tags)
local Text = require(script.Parent.Text)

local React = Dependencies.React
local e = React.createElement
local nextDialogActionId = 0
local CLOSE_ICON = "rbxasset://textures/ui/ScreenshotHud/Close@2x.png"

export type Props = {
	open: boolean,
	title: string,
	description: string?,
	closeLabel: string?,
	dismissOnBackdrop: boolean?,
	dismissOnEscape: boolean?,
	dismissOnGamepadBack: boolean?,
	initialFocusRef: { current: GuiObject? }?,
	onOpenChange: ((boolean) -> ())?,
	children: any?,
	footer: { [string]: any }?,
	tag: string?,
	rootRef: any?,
}

local function Dialog(props: Props): any
	local closeRef = React.useRef(nil :: ImageButton?)
	local previousSelectionRef = React.useRef(nil :: GuiObject?)
	local dismissOnEscapeRef = React.useRef(props.dismissOnEscape)
	local dismissOnGamepadBackRef = React.useRef(props.dismissOnGamepadBack)
	local initialFocusRefRef = React.useRef(props.initialFocusRef)
	local onOpenChangeRef = React.useRef(props.onOpenChange)
	local dismissActionName = React.useMemo(function()
		nextDialogActionId += 1
		return "OofUiDialogDismiss_" .. tostring(nextDialogActionId)
	end, {})
	dismissOnEscapeRef.current = props.dismissOnEscape
	dismissOnGamepadBackRef.current = props.dismissOnGamepadBack
	initialFocusRefRef.current = props.initialFocusRef
	onOpenChangeRef.current = props.onOpenChange

	local requestClose = React.useCallback(function()
		local onOpenChange = onOpenChangeRef.current
		if onOpenChange ~= nil then
			local previous = previousSelectionRef.current
			if previous == nil or previous:IsDescendantOf(game) then
				GuiService.SelectedObject = previous
			end
			onOpenChange(false)
		end
	end, {})

	-- Capture the opener before the engine processes selection for the new modal.
	React.useLayoutEffect(function()
		if props.open then
			previousSelectionRef.current = GuiService.SelectedObject
		end
	end, { props.open })

	React.useEffect(function()
		if not props.open then
			return nil
		end

		local active = true
		task.spawn(function()
			-- Roblox can recalculate automatic selection while a newly mounted
			-- modal settles. Wait for that pass before choosing the dialog target.
			for _ = 1, 6 do
				RunService.Heartbeat:Wait()
				if not active then
					return
				end
			end
			local requestedRef = initialFocusRefRef.current
			local requested = if requestedRef ~= nil then requestedRef.current else nil
			if requested ~= nil and not requested:IsDescendantOf(game) then
				requested = nil
			end
			local fallback = closeRef.current
			if fallback ~= nil and not fallback:IsDescendantOf(game) then
				fallback = nil
			end
			local target = requested or fallback
			if target ~= nil then
				GuiService.SelectedObject = target
			end
		end)

		-- CoreGui owns Escape and consumes ContextActionService bindings. Observe
		-- the native event even when processed; the Roblox menu may also open.
		local escapeConnection = UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape and dismissOnEscapeRef.current ~= false then
				requestClose()
			end
		end)

		ContextActionService:BindActionAtPriority(
			dismissActionName,
			function(_actionName: string, inputState: Enum.UserInputState)
				if inputState ~= Enum.UserInputState.Begin or dismissOnGamepadBackRef.current == false then
					return Enum.ContextActionResult.Pass
				end
				requestClose()
				return Enum.ContextActionResult.Sink
			end,
			false,
			Enum.ContextActionPriority.High.Value,
			Enum.KeyCode.ButtonB
		)

		return function()
			active = false
			escapeConnection:Disconnect()
			ContextActionService:UnbindAction(dismissActionName)
			local previous = previousSelectionRef.current
			if previous == nil or previous:IsDescendantOf(game) then
				GuiService.SelectedObject = previous
			end
			previousSelectionRef.current = nil
		end
	end, { dismissActionName, props.open, requestClose })

	if not props.open then
		return nil
	end

	local footerChildren: { [string]: any }? = nil
	if props.footer ~= nil then
		footerChildren = table.clone(props.footer)
		footerChildren.Layout = e("UIListLayout", { [React.Tag] = "oof-ui-dialog-footer-layout" })
	end

	return e("Frame", {
		[React.Tag] = Tags.join("oof-ui-dialog", props.tag),
		ref = props.rootRef,
	}, {
		Backdrop = e("TextButton", {
			[React.Tag] = "oof-ui-dialog-backdrop",
			Selectable = false,
			[React.Event.Activated] = if props.dismissOnBackdrop == false then nil else requestClose,
		}),
		Surface = e("TextButton", {
			-- A native button absorbs clicks in empty modal space; a Frame lets
			-- those clicks activate the full-screen backdrop underneath.
			AutoButtonColor = false,
			Selectable = false,
			Text = "",
			[React.Tag] = "oof-ui-dialog-surface",
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionGroup = true,
		}, {
			Constraint = e("UISizeConstraint", {
				[React.Tag] = "oof-ui-dialog-constraint",
			}),
			Container = e(Container, {
				automaticSize = Enum.AutomaticSize.Y,
				size = UDim2.fromScale(1, 0),
				tag = "oof-ui-dialog-container",
				variant = "raised",
			}, {
				Header = e("Frame", { [React.Tag] = "oof-ui-dialog-header" }, {
					Layout = e("UIListLayout", { [React.Tag] = "oof-ui-dialog-header-layout" }),
					TitleRow = e("Frame", { [React.Tag] = "oof-ui-dialog-title-row" }, {
						Layout = e("UIListLayout", { [React.Tag] = "oof-ui-dialog-title-row-layout" }),
						Title = e("Frame", { [React.Tag] = "oof-ui-dialog-title-container" }, {
							Flex = e("UIFlexItem", { [React.Tag] = "oof-ui-dialog-title-flex" }),
							Text = e(Text, {
								text = props.title,
								variant = "heading",
								tag = "oof-ui-dialog-title",
							}),
						}),
						Close = e(IconButton, {
							icon = CLOSE_ICON,
							label = props.closeLabel or "Close dialog",
							variant = "ghost",
							size = "small",
							shape = "square",
							rootRef = closeRef,
							onActivated = requestClose,
							tag = "oof-ui-dialog-close",
						}),
					}),
					Description = if props.description ~= nil
						then e(Text, {
							text = props.description,
							variant = "body",
							tone = "muted",
							tag = "oof-ui-dialog-description",
						})
						else nil,
				}),
				Content = e("Frame", { [React.Tag] = "oof-ui-dialog-content" }, props.children),
				Footer = if footerChildren ~= nil
					then e("Frame", { [React.Tag] = "oof-ui-dialog-footer" }, footerChildren)
					else nil,
			}),
		}),
	})
end

return Dialog
