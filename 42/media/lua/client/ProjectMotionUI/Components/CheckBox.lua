require "ProjectMotionUI/Core/BaseElement"
require "ProjectMotionUI/Core/Theme"

PMUI = PMUI or {}
PMUI.Checkbox = PMUI.BaseElement:derive("PMUI_Checkbox")

--- Creates a new checkbox element with the specified label and initial state.
---@param labelText string|nil Text displayed next to the checkbox.
---@param initialState boolean|nil Whether the checkbox is initially checked.
---@return PMUI.Checkbox
function PMUI.Checkbox:new(labelText, initialState)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    local theme = PMUI.GetTheme()
    o.passThroughClicks = false
    o.checked = initialState or false
    o.labelText = labelText or ""
    o.font = UIFont.Small
    o.onChangeCallback = nil

    -- Initialize checkbox colors from the active UI theme.
    o.boxColor = { r = theme.inputBg.r, g = theme.inputBg.g, b = theme.inputBg.b, a = 1.0 }
    o.activeColor = { r = theme.accent.r, g = theme.accent.g, b = theme.accent.b, a = 1.0 }
    o.borderColor = { r = theme.windowBorder.r, g = theme.windowBorder.g, b = theme.windowBorder.b, a = 1.0 }
    o.textColor = { r = theme.textPrimary.r, g = theme.textPrimary.g, b = theme.textPrimary.b, a = 1.0 }

    -- Calculate the element width based on the checkbox and label dimensions.
    local textW = getTextManager():MeasureStringX(o.font, o.labelText)
    o.offsetW = 24 + (o.labelText ~= "" and (textW + 8) or 0)
    o.offsetH = 22
    return o
end

--- Sets the checkbox state and optionally notifies the change callback.
---@param state boolean New checked state.
---@param triggerCallback boolean|nil Whether to invoke the registered callback.
---@return PMUI.Checkbox
function PMUI.Checkbox:SetChecked(state, triggerCallback)
    self.checked = state and true or false
    if triggerCallback and self.onChangeCallback then
        self.onChangeCallback(self.checked, self)
    end
    return self
end

--- Returns whether the checkbox is currently checked.
---@return boolean
function PMUI.Checkbox:IsChecked()
    return self.checked
end

--- Registers a callback invoked whenever the checkbox state changes through a notified update.
--- The callback receives the new state and the checkbox instance.
---@param callback function|nil Function invoked after a state change.
---@return PMUI.Checkbox
function PMUI.Checkbox:OnChange(callback)
    self.onChangeCallback = callback
    return self
end

--- Handles mouse release and toggles the checkbox if the pointer is over the element.
--- Triggers the change callback, plays the toggle sound, and applies a bounce animation.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Whether the mouse event was handled.
function PMUI.Checkbox:onMouseUp(x, y)
    if self:isMouseOver() then
        self:SetChecked(not self.checked, true)
        self.anim:Bounce(4, 0.2)
        if getSoundManager() then
            getSoundManager():playUISound("UIToggleTick")
        end
    end
    return true
end

--- Renders the checkbox background, border, check indicator, and optional label.
--- The check indicator is displayed only when the checkbox is checked.
function PMUI.Checkbox:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local boxSize = 18
    local boxY = math.floor((self:getHeight() - boxSize) / 2)

    self:drawRect(0, boxY, boxSize, boxSize, self.boxColor.a * self.alpha, self.boxColor.r, self.boxColor.g, self.boxColor.b)
    self:drawRectBorder(0, boxY, boxSize, boxSize, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    if self.checked then
        self:drawRect(4, boxY + 4, boxSize - 8, boxSize - 8, self.activeColor.a * self.alpha, self.activeColor.r, self.activeColor.g, self.activeColor.b)
    end

    if self.labelText ~= "" then
        local textH = getTextManager():MeasureStringY(self.font, self.labelText)
        local textY = math.floor((self:getHeight() - textH) / 2)
        self:drawText(self.labelText, boxSize + 8, textY, self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a * self.alpha, self.font)
    end
end

--- Saves the current checkbox state into the provided data table.
---@param data table Table used to store the checkbox state.
function PMUI.Checkbox:SaveState(data)
    data.checked = self.checked
end

--- Restores the checkbox state from the provided data table.
--- Invokes the change callback if a saved state is available.
---@param data table Table containing the previously saved checkbox state.
function PMUI.Checkbox:LoadState(data)
    if data.checked ~= nil then
        self:SetChecked(data.checked, true)
    end
end

return PMUI.Checkbox