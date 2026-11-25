require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.Image = PMUI.BaseElement:derive("PMUI_Image")

--- Creates a new image element using the specified texture.
---@param textureOrPath string|Texture|nil Texture object or path to a texture.
---@return PMUI.Image
function PMUI.Image:new(textureOrPath)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.tintColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
    o:SetTexture(textureOrPath)

    return o
end

--- Sets the image texture.
--- String values are resolved through getTexture(), while texture objects are assigned directly.
--- Automatically adopts the texture dimensions when the element still uses its default size.
---@param textureOrPath string|Texture|nil Texture object or path to a texture.
---@return PMUI.Image
function PMUI.Image:SetTexture(textureOrPath)
    if type(textureOrPath) == "string" then
        self.texture = getTexture(textureOrPath)
    else
        self.texture = textureOrPath
    end

    -- Use the original texture dimensions when the element has not been resized manually.
    if self.texture and self.offsetW == 100 and self.offsetH == 100 then
        self.offsetW = self.texture:getWidth()
        self.offsetH = self.texture:getHeight()
        self:RecalculateLayout()
    end
    return self
end

--- Sets the color tint applied to the image texture.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.Image
function PMUI.Image:SetTint(r, g, b, a)
    self.tintColor = { r = r, g = g, b = b, a = a or 1.0 }
    return self
end

--- Renders the image texture scaled to the element's current dimensions.
--- Applies the configured tint color and combines its alpha with the element opacity.
function PMUI.Image:prerender()
    PMUI.BaseElement.prerender(self)
    if not self.texture or self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local h = self:getHeight()
    local c = self.tintColor

    self:drawTextureScaled(self.texture, 0, 0, w, h, c.a * self.alpha, c.r, c.g, c.b)
end

return PMUI.Image