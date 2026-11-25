require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.Frame = PMUI.BaseElement:derive("PMUI_Frame")

--- Creates a new frame element with default background and border settings.
---@return PMUI.Frame
function PMUI.Frame:new()
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.bgTexture = nil
    o.bgColor = { r = 0.10, g = 0.11, b = 0.13, a = 0.90 }
    o.borderColor = { r = 0.30, g = 0.32, b = 0.36, a = 1.0 }
    o.drawBackground = true
    o.drawBorder = true
    o.cornerRadius = 0
    o.roundTopOnly = false

    return o
end

--- Sets the frame background texture.
--- String values are resolved through getTexture(), while texture objects are assigned directly.
---@param textureOrPath string|Texture|nil Texture object or path to a texture.
---@return PMUI.Frame
function PMUI.Frame:SetTexture(textureOrPath)
    if type(textureOrPath) == "string" then
        self.bgTexture = getTexture(textureOrPath)
    else
        self.bgTexture = textureOrPath
    end
    return self
end

--- Sets the frame background color and controls background visibility.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.Frame
function PMUI.Frame:SetBackgroundColor(r, g, b, a)
    self.bgColor = { r = r, g = g, b = b, a = a or 1.0 }
    self.drawBackground = (a or 1.0) > 0
    return self
end

--- Sets the frame border color and controls border visibility.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.Frame
function PMUI.Frame:SetBorderColor(r, g, b, a)
    self.borderColor = { r = r, g = g, b = b, a = a or 1.0 }
    self.drawBorder = (a or 1.0) > 0
    return self
end

--- Sets the corner radius used when rendering the frame.
--- Optionally limits rounded corners to the top edge.
---@param radius number Corner radius in pixels.
---@param topOnly boolean|nil Whether only the top corners should be rounded.
---@return PMUI.Frame
function PMUI.Frame:SetCornerRadius(radius, topOnly)
    self.cornerRadius = math.max(0, math.floor(radius or 0))
    self.roundTopOnly = topOnly and true or false
    return self
end

--- Draws a frame with rounded corners using individual horizontal rectangles.
--- Supports independently rounded top and bottom edges.
--- Falls back to standard rectangle rendering when the radius is too small.
---@param w number Frame width.
---@param h number Frame height.
---@param r number Requested corner radius.
---@param bgCol table Background color components.
---@param borderCol table Border color components.
---@param alphaMult number Additional alpha multiplier, usually the frame's opacity.
function PMUI.Frame:DrawRoundedBox(w, h, r, bgCol, borderCol, alphaMult)
    -- Prevent the corner radius from exceeding the frame dimensions.
    r = math.min(r, math.floor(w / 2), math.floor(h / 2))
    if r <= 1 then
        if self.drawBackground then
            self:drawRect(0, 0, w, h, bgCol.a * alphaMult, bgCol.r, bgCol.g, bgCol.b)
        end
        if self.drawBorder then
            self:drawRectBorder(0, 0, w, h, borderCol.a * alphaMult, borderCol.r, borderCol.g, borderCol.b)
        end
        return
    end

    local bgA = bgCol.a * alphaMult
    local bdA = borderCol.a * alphaMult
    local bottomR = self.roundTopOnly and 0 or r

    -- Draw the central rectangular section between the rounded edges.
    local midY = r
    local midH = h - r - bottomR
    if midH > 0 then
        if self.drawBackground then
            self:drawRect(0, midY, w, midH, bgA, bgCol.r, bgCol.g, bgCol.b)
        end
        if self.drawBorder then
            self:drawRect(0, midY, 1, midH, bdA, borderCol.r, borderCol.g, borderCol.b)
            self:drawRect(w - 1, midY, 1, midH, bdA, borderCol.r, borderCol.g, borderCol.b)
        end
    end

    -- Build the top rounded corners row by row using circle geometry.
    -- Each row calculates its horizontal inset from the corner radius.
    local prevInset = r
    for i = 0, r - 1 do
        local dy = (r - 0.5) - i
        local dx = math.sqrt(math.max(0, r * r - dy * dy))
        local inset = math.floor(r - dx + 0.5)
        local lineW = w - inset * 2

        if lineW > 0 then
            if self.drawBackground then
                self:drawRect(inset, i, lineW, 1, bgA, bgCol.r, bgCol.g, bgCol.b)
            end
            if self.drawBorder then
                if i == 0 then
                    -- Draw the horizontal top edge.
                    self:drawRect(inset, 0, lineW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                else
                    -- Draw only the newly exposed portions of the rounded side edges.
                    local edgeW = math.max(1, prevInset - inset)
                    self:drawRect(inset, i, edgeW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                    self:drawRect(w - inset - edgeW, i, edgeW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                end
            end
        end
        prevInset = inset
    end

    -- Draw the bottom rounded corners unless only the top edge is rounded.
    if bottomR > 0 then
        prevInset = bottomR
        for i = 0, bottomR - 1 do
            local dy = (bottomR - 0.5) - i
            local dx = math.sqrt(math.max(0, bottomR * bottomR - dy * dy))
            local inset = math.floor(bottomR - dx + 0.5)
            local lineW = w - inset * 2
            local yPos = h - 1 - i

            if lineW > 0 then
                if self.drawBackground then
                    self:drawRect(inset, yPos, lineW, 1, bgA, bgCol.r, bgCol.g, bgCol.b)
                end
                if self.drawBorder then
                    if i == 0 then
                        -- Draw the horizontal bottom edge.
                        self:drawRect(inset, yPos, lineW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                    else
                        -- Draw the newly exposed portions of the bottom rounded edges.
                        local edgeW = math.max(1, prevInset - inset)
                        self:drawRect(inset, yPos, edgeW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                        self:drawRect(w - inset - edgeW, yPos, edgeW, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
                    end
                end
            end
            prevInset = inset
        end
    elseif self.drawBorder then
        -- Keep the bottom edge straight when only the top corners are rounded.
        self:drawRect(0, h - 1, w, 1, bdA, borderCol.r, borderCol.g, borderCol.b)
    end
end

--- Renders the frame background, texture, and border.
--- Uses the configured texture when available, otherwise draws a solid-color background.
--- Applies rounded corner rendering when a non-zero corner radius is configured.
function PMUI.Frame:prerender()
    PMUI.BaseElement.prerender(self)

    if self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local h = self:getHeight()

    if self.bgTexture then
        -- Draw the background texture and optionally overlay the border.
        self:drawTextureScaled(self.bgTexture, 0, 0, w, h, self.bgColor.a * self.alpha, 1, 1, 1)
        if self.drawBorder then
            self:drawRectBorder(0, 0, w, h, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)
        end
        return
    end

    if self.cornerRadius and self.cornerRadius > 0 then
        self:DrawRoundedBox(w, h, self.cornerRadius, self.bgColor, self.borderColor, self.alpha)
    else
        -- Use standard rectangle rendering when rounded corners are disabled.
        if self.drawBackground then
            self:drawRect(0, 0, w, h, self.bgColor.a * self.alpha, self.bgColor.r, self.bgColor.g, self.bgColor.b)
        end
        if self.drawBorder then
            self:drawRectBorder(0, 0, w, h, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)
        end
    end
end

return PMUI.Frame