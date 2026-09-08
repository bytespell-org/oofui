--!strict

local ButtonBadge = require(script.Parent.Parent.internal.ButtonBadge)
local ControlChrome = require(script.Parent.Parent.internal.ControlChrome)
local Dependencies = require(script.Parent.Parent.Dependencies)
local Icon = require(script.Parent.Parent.internal.Icon)
local ProgressBar = require(script.Parent.ProgressBar)
local RadialProgress = require(script.Parent.RadialProgress)
local Tags = require(script.Parent.Parent.internal.Tags)
local Text = require(script.Parent.Text)
local Types = require(script.Parent.Parent.types)
local inputsMatch = require(script.Parent.Parent.internal.inputsMatch)
local useSelectionState = require(script.Parent.Parent.internal.useSelectionState)

local React = Dependencies.React
local e = React.createElement
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

type IconSpec = Types.IconSpec
type Phase = "idle" | "holding" | "complete" | "cancelled"
type Variant = "primary" | "secondary" | "destructive"
type ControlSize = "small" | "medium" | "large"
type Indicator = "linear" | "radial"

export type Props = Types.CommonControlProps & {
	badge: (boolean | number)?,
	badgeMax: number?,
	text: string,
	leadingIcon: IconSpec?,
	variant: Variant?,
	size: ControlSize?,
	fullWidth: boolean?,
	duration: number?,
	indicator: Indicator?,
	cancelOnPointerLeave: boolean?,
	resetOnCancel: boolean?,
	onHoldStarted: (() -> ())?,
	onHoldProgressChanged: ((number) -> ())?,
	onHoldCancelled: (() -> ())?,
	onCompleted: (() -> ())?,
}

local function isPointerInput(input: InputObject): boolean
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isConfirmInput(input: InputObject): boolean
	return input.KeyCode == Enum.KeyCode.Space
		or input.KeyCode == Enum.KeyCode.Return
		or input.KeyCode == Enum.KeyCode.KeypadEnter
		or input.KeyCode == Enum.KeyCode.ButtonA
end

local function HoldButton(props: Props): any
	local variant = props.variant or "primary"
	local size = props.size or "medium"
	local indicator = props.indicator or "linear"
	local duration = math.max(props.duration or 1, 0.05)
	local disabled = props.disabled == true
	local selection = useSelectionState(props.rootRef)
	local phase, setPhaseState = React.useState("idle" :: Phase)
	local progress, setProgress = React.useState(0)
	local phaseRef = React.useRef("idle" :: Phase)
	local activeInputRef = React.useRef(nil :: InputObject?)
	local startedAtRef = React.useRef(0)
	local lastReportedRef = React.useRef(-1)
	local completedRef = React.useRef(false)
	local function setPhase(nextPhase: Phase)
		phaseRef.current = nextPhase
		setPhaseState(nextPhase)
	end

	local function resetToIdle()
		activeInputRef.current = nil
		completedRef.current = false
		lastReportedRef.current = -1
		setProgress(0)
		setPhase("idle")
	end

	local cancelHold = React.useCallback(function()
		if phaseRef.current ~= "holding" or completedRef.current then
			return
		end
		activeInputRef.current = nil
		setPhase("cancelled")
		if props.resetOnCancel ~= false then
			setProgress(0)
		end
		if props.onHoldCancelled ~= nil then
			props.onHoldCancelled()
		end
	end, { props.onHoldCancelled, props.resetOnCancel })

	local function beginHold(input: InputObject)
		if disabled or phaseRef.current == "holding" or phaseRef.current == "complete" then
			return
		end
		if not isPointerInput(input) and not (selection.isSelected() and isConfirmInput(input)) then
			return
		end
		activeInputRef.current = input
		startedAtRef.current = os.clock()
		completedRef.current = false
		lastReportedRef.current = -1
		setProgress(0)
		setPhase("holding")
		if props.onHoldStarted ~= nil then
			props.onHoldStarted()
		end
	end

	-- GuiObject.InputBegan does not deliver keyboard confirmation to a selected
	-- button. Read native selection at event time, before React's next render.
	local beginHoldRef = React.useRef(beginHold)
	beginHoldRef.current = beginHold
	React.useEffect(function()
		local connection = UserInputService.InputBegan:Connect(function(input)
			if
				isConfirmInput(input)
				and not isPointerInput(input)
				and UserInputService:GetFocusedTextBox() == nil
				and not GuiService.MenuIsOpen
			then
				beginHoldRef.current(input)
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if phase ~= "holding" then
			return nil
		end
		local connection = RunService.Heartbeat:Connect(function()
			if phaseRef.current ~= "holding" then
				return
			end
			local nextProgress = math.clamp((os.clock() - startedAtRef.current) / duration, 0, 1)
			if nextProgress - lastReportedRef.current >= 0.01 or nextProgress >= 1 then
				lastReportedRef.current = nextProgress
				setProgress(nextProgress)
				if props.onHoldProgressChanged ~= nil then
					props.onHoldProgressChanged(nextProgress)
				end
			end
			if nextProgress >= 1 and not completedRef.current then
				completedRef.current = true
				setPhase("complete")
				if props.onCompleted ~= nil then
					props.onCompleted()
				end
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, { duration, phase, props.onCompleted, props.onHoldProgressChanged })

	React.useEffect(function()
		-- Subscribe before a press; a quick release may precede the holding render.
		local connection = UserInputService.InputEnded:Connect(function(input)
			if not inputsMatch(activeInputRef.current, input) then
				return
			end
			if phaseRef.current == "complete" then
				resetToIdle()
			else
				cancelHold()
			end
		end)
		local blur = UserInputService.WindowFocusReleased:Connect(cancelHold)
		local menu = GuiService.MenuOpened:Connect(cancelHold)
		return function()
			connection:Disconnect()
			blur:Disconnect()
			menu:Disconnect()
		end
	end, { cancelHold })

	React.useEffect(function()
		if disabled then
			cancelHold()
		end
	end, { cancelHold, disabled })

	React.useEffect(function()
		return function()
			activeInputRef.current = nil
		end
	end, {})

	local function handleSelectionLost()
		selection.onSelectionLost()
		cancelHold()
	end

	local tags = Tags.join(
		"oof-ui-button",
		Tags.when(props.disabled == true, "oof-ui-button-disabled"),
		"oof-ui-button-" .. variant,
		"oof-ui-button-" .. size,
		Tags.when(props.fullWidth ~= true, "oof-ui-button-fixed-" .. size),
		"oof-ui-hold-button",
		"oof-ui-hold-button-" .. phase,
		"oof-ui-hold-button-indicator-" .. indicator,
		Tags.when(props.fullWidth == true, "oof-ui-button-full-width"),
		Tags.when(props.fullWidth == true, "oof-ui-button-full-width-" .. size),
		Tags.when(selection.focusVisible, "oof-ui-button-focused"),
		Tags.when(props.leadingIcon ~= nil, "oof-ui-button-has-leading-icon"),
		props.tag
	)

	return e(
		"TextButton",
		{
			[React.Tag] = tags,
			ref = selection.rootRef,
			AutoButtonColor = false,
			Interactable = not disabled,
			LayoutOrder = props.layoutOrder,
			Selectable = not disabled,
			SelectionOrder = props.selectionOrder,
			Text = "",
			[React.Event.InputBegan] = function(_button: GuiObject, input: InputObject)
				if isPointerInput(input) then
					beginHold(input)
				end
			end,
			[React.Event.MouseLeave] = if props.cancelOnPointerLeave == false then nil else cancelHold,
			[React.Event.SelectionGained] = selection.onSelectionGained,
			[React.Event.SelectionLost] = handleSelectionLost,
		},
		ControlChrome({
			prefix = "oof-ui-button",
			selectionImageRef = selection.selectionImageRef,
			content = {
				Content = e("Frame", { [React.Tag] = "oof-ui-button-content" }, {
					Padding = e("UIPadding", { [React.Tag] = "oof-ui-button-content-padding" }),
					Layout = e("UIListLayout", { [React.Tag] = "oof-ui-button-content-layout" }),
					Badge = e(ButtonBadge, { value = props.badge, maximum = props.badgeMax }),
					LeadingIcon = e(Icon, {
						icon = props.leadingIcon,
						tag = "oof-ui-button-leading-icon",
					}),
					RadialProgress = if indicator == "radial"
						then e(RadialProgress, {
							value = progress,
							showTrack = true,
							layoutOrder = 1,
							tag = "oof-ui-hold-button-radial-progress",
						})
						else nil,
					Label = e(Text, {
						text = props.text,
						tone = if variant == "primary" or variant == "destructive" then "onAccent" else "default",
						automaticSize = Enum.AutomaticSize.X,
						layoutOrder = 2,
						size = UDim2.fromScale(0, 1),
						textWrapped = false,
						tag = "oof-ui-button-label",
					}),
				}),
				LinearProgress = if indicator == "linear" and phase == "holding"
					then e(ProgressBar, {
						value = progress,
						tag = "oof-ui-hold-button-linear-progress",
					})
					else nil,
			},
		})
	)
end

return HoldButton
