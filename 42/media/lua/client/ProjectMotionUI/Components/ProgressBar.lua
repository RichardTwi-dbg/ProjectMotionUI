require "ProjectMotionUI/Core/BaseElement"
require "ProjectMotionUI/Core/Theme"

PMUI = PMUI or {}
PMUI.ProgressBar = PMUI.BaseElement:derive("PMUI_ProgressBar")

--- Creates a progress bar with the specified value range.
---@param minVal number|nil Minimum progress value. Defaults to 0.
---@param maxVal number|nil Maximum progress value. Defaults to 100.
---@return PMUI.ProgressBar
function PMUI.ProgressBar:new(minVal, maxVal)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    local theme = PMUI.GetTheme()
    o.minVal = minVal or 0
    o.maxVal = maxVal or 100
    o.value = o.minVal
    o.displayValue = o.minVal

    o.bgColor = { r = theme.inputBg.r, g = theme.inputBg.g, b = theme.inputBg.b, a = 0.95 }
    o.fillColor = { r = theme.accent.r, g = theme.accent.g, b = theme.accent.b, a = 1.0 }
    o.borderColor = { r = theme.windowBorder.r, g = theme.windowBorder.g, b = theme.windowBorder.b, a = 1.0 }
    o.textColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }

    o.showText = true
    o.customText = nil
    o.font = UIFont.Small

    o.offsetW = 220
    o.offsetH = 24
    return o
end

--- Sets the minimum and maximum values of the progress range.
---@param minVal number Minimum progress value.
---@param maxVal number Maximum progress value.
---@return PMUI.ProgressBar
function PMUI.ProgressBar:SetRange(minVal, maxVal)
    self.minVal = minVal or 0
    self.maxVal = maxVal or 100
    return self
end

--- Updates the progress value.
--- The value is clamped to the configured range.
--- When instant is false, the displayed value is animated using QuadOut easing.
---@param val number Target progress value.
---@param instant boolean|nil If true, updates the displayed value immediately.
---@return PMUI.ProgressBar
function PMUI.ProgressBar:SetValue(val, instant)
    val = math.max(self.minVal, math.min(self.maxVal, val))
    self.value = val

    if instant then
        self.displayValue = val
    else
        self.anim:Tween("bar_fill", { displayValue = val }, 0.30, PMUI.Easing.QuadOut)
    end
    return self
end

--- Sets the progress fill color.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.ProgressBar
function PMUI.ProgressBar:SetFillColor(r, g, b, a)
    self.fillColor = { r = r, g = g, b = b, a = a or 1.0 }
    return self
end

--- Controls whether progress text is displayed.
--- An optional custom string can be used instead of the automatically calculated percentage.
---@param show boolean Whether to display text.
---@param customText string|nil Custom text to display instead of the percentage.
---@return PMUI.ProgressBar
function PMUI.ProgressBar:SetShowText(show, customText)
    self.showText = show
    self.customText = customText
    return self
end

--- Renders the progress bar, including its background, fill, border, and optional text.
--- The fill width is calculated from the current animated display value.
function PMUI.ProgressBar:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local h = self:getHeight()

    self:drawRect(0, 0, w, h, self.bgColor.a * self.alpha, self.bgColor.r, self.bgColor.g, self.bgColor.b)

    -- Normalize the displayed value to a 0-1 ratio before calculating the fill width.
    local span = math.max(self.maxVal - self.minVal, 0.0001)
    local ratio = math.max(0, math.min(1, (self.displayValue - self.minVal) / span))
    local fillW = math.floor((w - 2) * ratio)

    if fillW > 0 then
        self:drawRect(1, 1, fillW, h - 2, self.fillColor.a * self.alpha, self.fillColor.r, self.fillColor.g, self.fillColor.b)
    end

    self:drawRectBorder(0, 0, w, h, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    if self.showText then
        local txt = self.customText or string.format("%d%%", math.floor(ratio * 100 + 0.5))
        local tw = getTextManager():MeasureStringX(self.font, txt)
        local th = getTextManager():MeasureStringY(self.font, txt)

        -- Center the text both horizontally and vertically inside the progress bar.
        self:drawText(txt, (w - tw) / 2, (h - th) / 2, self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a * self.alpha, self.font)
    end
end

return PMUI.ProgressBar