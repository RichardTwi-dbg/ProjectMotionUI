require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.Button = PMUI.BaseElement:derive("PMUI_Button")

--- Creates a new button element with default appearance and behavior.
---@param text string|nil Text displayed inside the button.
---@return PMUI.Button
function PMUI.Button:new(text)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.text = text or "Button"
    o.font = UIFont.Medium
    o.passThroughClicks = false
    o.onClickCallback = nil
    o.isPressed = false

    -- Default button colors for different interaction states.
    o.colorNormal  = { r = 0.22, g = 0.25, b = 0.30, a = 1.0 }
    o.colorHover   = { r = 0.30, g = 0.35, b = 0.42, a = 1.0 }
    o.colorPressed = { r = 0.16, g = 0.18, b = 0.22, a = 1.0 }
    o.borderColor  = { r = 0.45, g = 0.50, b = 0.58, a = 1.0 }
    o.textColor    = { r = 0.95, g = 0.95, b = 0.95, a = 1.0 }
    o.soundClick   = "UIActivateButton"

    -- Optional textures for each interaction state.
    o.texNormal  = nil
    o.texHover   = nil
    o.texPressed = nil

    -- Default dimensions used by the layout system.
    o.offsetW = 140
    o.offsetH = 36

    return o
end

--- Assigns textures used to render the button in different interaction states.
--- Texture paths are automatically resolved through getTexture().
---@param normalTex string|Texture|nil Texture displayed in the default state.
---@param hoverTex string|Texture|nil Texture displayed while the mouse is hovering.
---@param pressedTex string|Texture|nil Texture displayed while the button is pressed.
---@return PMUI.Button
function PMUI.Button:SetTextures(normalTex, hoverTex, pressedTex)
    self.texNormal  = type(normalTex) == "string" and getTexture(normalTex) or normalTex
    self.texHover   = type(hoverTex) == "string" and getTexture(hoverTex) or hoverTex
    self.texPressed = type(pressedTex) == "string" and getTexture(pressedTex) or pressedTex
    return self
end

--- Sets the text displayed inside the button.
---@param text string Button label.
---@return PMUI.Button
function PMUI.Button:SetText(text)
    self.text = text
    return self
end

--- Sets the font used to render the button label.
---@param font UIFont Font assigned to the button.
---@return PMUI.Button
function PMUI.Button:SetFont(font)
    self.font = font
    return self
end

--- Overrides the button colors for its interaction states.
--- Unspecified colors retain their current values.
---@param normal table|nil Color used in the default state.
---@param hover table|nil Color used while the mouse is hovering.
---@param pressed table|nil Color used while the button is pressed.
---@return PMUI.Button
function PMUI.Button:SetColors(normal, hover, pressed)
    if normal then self.colorNormal = normal end
    if hover then self.colorHover = hover end
    if pressed then self.colorPressed = pressed end
    return self
end

--- Registers a callback executed when the button is clicked.
--- The button instance is passed as the callback argument.
---@param callback function|nil Function invoked after a successful click.
---@return PMUI.Button
function PMUI.Button:OnClick(callback)
    self.onClickCallback = callback
    return self
end

--- Handles the initial mouse press and activates the pressed visual state.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Whether the mouse event was handled.
function PMUI.Button:onMouseDown(x, y)
    self.isPressed = true
    return true
end

--- Handles mouse release and executes the click callback if released over the button.
--- Plays the configured click sound before invoking the callback.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Whether the mouse event was handled.
function PMUI.Button:onMouseUp(x, y)
    if self.isPressed then
        self.isPressed = false
        if self:isMouseOver() then
            if self.soundClick then
                PMUI.PlaySound(self.soundClick)
            end
            if self.onClickCallback then
                self.onClickCallback(self)
            end
        end
    end
    return true
end

--- Resets the pressed state when the mouse button is released outside the element.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
function PMUI.Button:onMouseUpOutside(x, y)
    self.isPressed = false
end

--- Renders the button background and label before the element's main render pass.
--- Selects the appropriate texture or color based on the current interaction state.
--- Textures take priority over solid-color backgrounds.
function PMUI.Button:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local h = self:getHeight()
    local isHover = self:isMouseOver()

    if self.texNormal then
        local tex = self.texNormal
        local tint = 1.0

        if self.isPressed then
            if self.texPressed then
                tex = self.texPressed
            else
                tint = 0.75
            end
        elseif isHover then
            if self.texHover then
                tex = self.texHover
            else
                tint = 1.15
            end
        end

        self:drawTextureScaled(tex, 0, 0, w, h, self.alpha, tint, tint, tint)
    else
        local currentColor = self.colorNormal
        if self.isPressed then
            currentColor = self.colorPressed
        elseif isHover then
            currentColor = self.colorHover
        end

        self:drawRect(0, 0, w, h, currentColor.a * self.alpha, currentColor.r, currentColor.g, currentColor.b)
        self:drawRectBorder(0, 0, w, h, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    end

    -- Center the label horizontally and vertically within the button.
    if self.text and self.text ~= "" then
        local textW = getTextManager():MeasureStringX(self.font, self.text)
        local textH = getTextManager():MeasureStringY(self.font, self.text)
        local textX = (w - textW) / 2
        local textY = (h - textH) / 2

        self:drawText(self.text, textX, textY, self.textColor.r, self.textColor.g, self.textColor.b, self.textColor.a * self.alpha, self.font)
    end
end

return PMUI.Button