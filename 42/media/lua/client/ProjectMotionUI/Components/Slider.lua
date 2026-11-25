require "ProjectMotionUI/Core/BaseElement"
require "ProjectMotionUI/Core/Theme"

PMUI = PMUI or {}
PMUI.Slider = PMUI.BaseElement:derive("PMUI_Slider")

--- Creates a slider with the specified value range and step.
---@param minVal number|nil Minimum slider value. Defaults to 0.
---@param maxVal number|nil Maximum slider value. Defaults to 100.
---@param step number|nil Value increment. Defaults to 1.
---@return PMUI.Slider
function PMUI.Slider:new(minVal, maxVal, step)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    local theme = PMUI.GetTheme()
    o.passThroughClicks = false
    o.minVal = minVal or 0
    o.maxVal = maxVal or 100
    o.step = step or 1
    o.value = o.minVal
    o.isSliding = false
    o.onChangeCallback = nil

    o.trackColor = { r = theme.inputBg.r, g = theme.inputBg.g, b = theme.inputBg.b, a = 1.0 }
    o.fillColor  = { r = theme.accent.r, g = theme.accent.g, b = theme.accent.b, a = 1.0 }
    o.thumbColor = { r = 0.95, g = 0.96, b = 0.98, a = 1.0 }

    o.offsetW = 220
    o.offsetH = 24
    return o
end

--- Sets the slider value, clamping it to the configured range.
--- The value is rounded to the nearest step when step is greater than zero.
---@param val number Target slider value.
---@param triggerCallback boolean|nil Whether to invoke the change callback if the value changes.
---@return PMUI.Slider
function PMUI.Slider:SetValue(val, triggerCallback)
    val = math.max(self.minVal, math.min(self.maxVal, val))
    if self.step and self.step > 0 then
        val = math.floor((val / self.step) + 0.5) * self.step
    end

    local changed = (self.value ~= val)
    self.value = val

    if changed and triggerCallback and self.onChangeCallback then
        self.onChangeCallback(self.value, self)
    end
    return self
end

--- Returns the current slider value.
---@return number
function PMUI.Slider:GetValue()
    return self.value
end

--- Registers a callback invoked when the slider value changes.
--- The callback receives the new value and the slider instance.
---@param callback function|nil Change callback.
---@return PMUI.Slider
function PMUI.Slider:OnChange(callback)
    self.onChangeCallback = callback
    return self
end

--- Updates the slider value based on the current mouse position.
--- Converts the horizontal mouse coordinate into a normalized range ratio.
function PMUI.Slider:UpdateFromMouse()
    local w = math.max(self:getWidth(), 1)
    local localX = getMouseX() - self:getAbsoluteX()
    local ratio = math.max(0, math.min(1, localX / w))
    local rawVal = self.minVal + ratio * (self.maxVal - self.minVal)
    self:SetValue(rawVal, true)
end

--- Starts dragging the slider thumb and immediately updates the value.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Always returns true to indicate that the input was handled.
function PMUI.Slider:onMouseDown(x, y)
    self.isSliding = true
    self:UpdateFromMouse()
    return true
end

--- Updates the slider value while the mouse is being dragged.
---@param dx number Horizontal mouse movement delta.
---@param dy number Vertical mouse movement delta.
---@return boolean|nil True when the slider is actively being dragged.
function PMUI.Slider:onMouseMove(dx, dy)
    if self.isSliding then
        self:UpdateFromMouse()
        return true
    end
end

--- Continues updating the slider while the mouse is dragged outside its bounds.
---@param dx number Horizontal mouse movement delta.
---@param dy number Vertical mouse movement delta.
function PMUI.Slider:onMouseMoveOutside(dx, dy)
    self:onMouseMove(dx, dy)
end

--- Stops dragging the slider and plays the UI confirmation sound.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean|nil True when an active drag was completed.
function PMUI.Slider:onMouseUp(x, y)
    if self.isSliding then
        self.isSliding = false
        if getSoundManager() then
            getSoundManager():playUISound("UIToggleTick")
        end
        return true
    end
end

--- Stops dragging when the mouse button is released outside the slider.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
function PMUI.Slider:onMouseUpOutside(x, y)
    self:onMouseUp(x, y)
end

--- Renders the slider track, filled portion, and draggable thumb.
function PMUI.Slider:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local h = self:getHeight()
    local trackH = 6
    local trackY = math.floor((h - trackH) / 2)

    self:drawRect(0, trackY, w, trackH, self.trackColor.a * self.alpha, self.trackColor.r, self.trackColor.g, self.trackColor.b)
    self:drawRectBorder(0, trackY, w, trackH, 0.5 * self.alpha, 0.4, 0.45, 0.52)

    -- Normalize the current value to determine the filled track width and thumb position.
    local span = math.max(self.maxVal - self.minVal, 0.0001)
    local ratio = (self.value - self.minVal) / span
    local fillW = math.floor(w * ratio)

    if fillW > 0 then
        self:drawRect(0, trackY, fillW, trackH, self.fillColor.a * self.alpha, self.fillColor.r, self.fillColor.g, self.fillColor.b)
    end

    local thumbW = 14
    local thumbH = 18
    local thumbX = math.max(0, math.min(w - thumbW, fillW - math.floor(thumbW / 2)))
    local thumbY = math.floor((h - thumbH) / 2)

    self:drawRect(thumbX, thumbY, thumbW, thumbH, self.thumbColor.a * self.alpha, self.thumbColor.r, self.thumbColor.g, self.thumbColor.b)
    self:drawRectBorder(thumbX, thumbY, thumbW, thumbH, 0.9 * self.alpha, 0.2, 0.22, 0.26)
end

--- Saves the current slider value into the provided state table.
---@param data table State table to populate.
function PMUI.Slider:SaveState(data)
    data.value = self.value
end

--- Restores the slider value from a previously saved state.
--- The change callback is triggered when the restored value differs from the current value.
---@param data table State table containing the saved value.
function PMUI.Slider:LoadState(data)
    if data.value ~= nil then
        self:SetValue(data.value, true)
    end
end

return PMUI.Slider