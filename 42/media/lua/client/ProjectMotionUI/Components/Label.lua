require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.Label = PMUI.BaseElement:derive("PMUI_Label")

--- Creates a new text label with the specified content and font.
---@param text string|nil Initial text content.
---@param font UIFont|nil Font used to render the text. Defaults to UIFont.Small.
---@return PMUI.Label
function PMUI.Label:new(text, font)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.text = text or ""
    o.font = font or UIFont.Small
    o.textColor = { r = 0.92, g = 0.94, b = 0.96, a = 1.0 }
    o.align = "left"
    o.autoSize = true

    o:UpdateSizeFromText()
    return o
end

--- Updates the label text and recalculates its dimensions when auto sizing is enabled.
---@param text string|nil New text content.
---@return PMUI.Label
function PMUI.Label:SetText(text)
    self.text = text or ""
    if self.autoSize then
        self:UpdateSizeFromText()
    end
    return self
end

--- Sets the font used to render the label.
--- Recalculates the element dimensions when auto sizing is enabled.
---@param font UIFont Font assigned to the label.
---@return PMUI.Label
function PMUI.Label:SetFont(font)
    self.font = font
    if self.autoSize then
        self:UpdateSizeFromText()
    end
    return self
end

--- Sets the label text color.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.Label
function PMUI.Label:SetColor(r, g, b, a)
    self.textColor = { r = r, g = g, b = b, a = a or 1.0 }
    return self
end

--- Sets the horizontal text alignment.
--- Disables automatic sizing to preserve the manually assigned element dimensions.
---@param align string Alignment mode: "left", "center", or "right".
---@return PMUI.Label
function PMUI.Label:SetAlign(align)
    self.align = align or "left"
    self.autoSize = false
    return self
end

--- Calculates and updates the element dimensions based on the current text and font.
--- Uses the text manager to measure the required width and height.
function PMUI.Label:UpdateSizeFromText()
    local w = getTextManager():MeasureStringX(self.font, self.text)
    local h = getTextManager():MeasureStringY(self.font, self.text)
    self.offsetW = math.max(w, 1)
    self.offsetH = math.max(h, 1)
    self:RecalculateLayout()
end

--- Renders the label text using the configured font, color, and alignment.
--- Text is positioned horizontally according to the selected alignment mode.
function PMUI.Label:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 or self.text == "" then return end

    local w = self:getWidth()
    local textW = getTextManager():MeasureStringX(self.font, self.text)
    local drawX = 0

    -- Calculate the horizontal text offset based on the alignment mode.
    if self.align == "center" then
        drawX = (w - textW) / 2
    elseif self.align == "right" then
        drawX = w - textW
    end

    self:drawText(self.text, drawX, 0, self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a * self.alpha, self.font)
end

return PMUI.Label