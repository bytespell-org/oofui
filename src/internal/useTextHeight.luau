--!strict
local TextService = game:GetService("TextService")
local React = require(script.Parent.Parent.Dependencies).React
-- AutomaticSize can retain a one-line height after a nested layout narrows a
-- styled label. Supply a measured minimum using resolved font metrics. Events
-- keep this correct after theme/font/width edits without per-frame polling.
local function useTextHeight(ref, text, enabled)
	local height, setHeight = React.useState(0)
	React.useEffect(function()
		local label = ref.current
		if not enabled or label == nil then
			return nil
		end
		local previous = ""
		local revision = 0
		local active = true
		local function measure()
			local scale = 1
			local ancestor = label
			while ancestor do
				local uiScale = ancestor:FindFirstChildWhichIsA("UIScale")
				if uiScale then
					scale *= uiScale.Scale
				end
				ancestor = ancestor.Parent
			end
			if scale <= 0 then
				return
			end
			local width = math.floor(label.AbsoluteSize.X / scale)
			if width <= 0 then
				return
			end
			local font, size = label:GetStyled("FontFace"), label:GetStyled("TextSize")
			local signature = tostring(width) .. "/" .. tostring(font) .. "/" .. tostring(size)
			if signature == previous then
				return
			end
			previous = signature
			revision += 1
			local current = revision
			task.spawn(function()
				local params = Instance.new("GetTextBoundsParams")
				params.Text, params.Font, params.Size, params.Width = text, font, size, width
				local ok, bounds = pcall(function()
					return TextService:GetTextBoundsAsync(params)
				end)
				params:Destroy()
				if active and revision == current and ok then
					setHeight(if bounds.Y > size * 1.5 then math.ceil(bounds.Y) + 2 else 0)
				end
			end)
		end
		local connections = {
			label:GetPropertyChangedSignal("AbsoluteSize"):Connect(measure),
			label:GetStyledPropertyChangedSignal("FontFace"):Connect(measure),
			label:GetStyledPropertyChangedSignal("TextSize"):Connect(measure),
		}
		measure()
		return function()
			active = false
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { text, enabled })
	return if enabled then height else 0
end
return useTextHeight
