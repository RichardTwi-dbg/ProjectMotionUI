require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.Shape = PMUI.BaseElement:derive("PMUI_Shape")

--- Collection of predefined shapes represented as normalized rectangles.
--- Each rectangle uses relative coordinates and dimensions in the 0.0-1.0 range.
PMUI.ShapePresets = {

    -- Two intersecting rectangles forming a cross.
    cross = {
        { x = 0.38, y = 0.0,  w = 0.24, h = 1.0 },
        { x = 0.0,  y = 0.38, w = 1.0,  h = 0.24 }
    },

    -- Four corner markers and a center point forming a crosshair.
    crosshair = {
        { x = 0.47, y = 0.0,  w = 0.06, h = 0.32 },
        { x = 0.47, y = 0.68, w = 0.06, h = 0.32 },
        { x = 0.0,  y = 0.47, w = 0.32, h = 0.06 },
        { x = 0.68, y = 0.47, w = 0.32, h = 0.06 },
        { x = 0.45, y = 0.45, w = 0.10, h = 0.10 }
    },

    -- Triangle approximation built from horizontal rectangles of increasing width.
    triangle = (function()
        local rects = {}
        local steps = 12
        for i = 0, steps - 1 do
            local ratio = (i + 1) / steps
            local w = ratio
            local x = (1 - w) / 2
            local y = i / steps
            table.insert(rects, { x = x, y = y, w = w, h = (1 / steps) + 0.01 })
        end
        return rects
    end)(),

    -- Diamond approximation built from horizontal rectangles that widen toward the center.
    diamond = (function()
        local rects = {}
        local steps = 14
        for i = 0, steps - 1 do
            local t = i / (steps - 1) -- Normalized vertical position (0.0-1.0).
            local w = 1 - math.abs(t * 2 - 1)
            local x = (1 - w) / 2
            local y = i / steps
            table.insert(rects, { x = x, y = y, w = math.max(w, 0.08), h = (1 / steps) + 0.01 })
        end
        return rects
    end)(),

    -- Circle approximation built from horizontal slices calculated using the circle equation.
    circle = (function()
        local rects = {}
        local steps = 18
        for i = 0, steps - 1 do
            local ny = ((i + 0.5) / steps) * 2 - 1 -- Normalized vertical position (-1.0 to 1.0).
            local w = math.sqrt(math.max(0, 1 - ny * ny))
            local x = (1 - w) / 2
            local y = i / steps
            table.insert(rects, { x = x, y = y, w = w, h = (1 / steps) + 0.01 })
        end
        return rects
    end)()
}

--- Creates a shape from a preset or a custom collection of rectangular parts.
---@param presetOrParts string|table|nil Preset name or an array of normalized shape parts.
---@return PMUI.Shape
function PMUI.Shape:new(presetOrParts)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.fillColor = { r = 0.35, g = 0.75, b = 0.55, a = 1.0 }
    o.parts = {}

    if type(presetOrParts) == "string" then
        o:SetPreset(presetOrParts)
    elseif type(presetOrParts) == "table" then
        o.parts = presetOrParts
    end

    return o
end

--- Replaces the current shape parts with the specified preset.
--- Unknown preset names result in an empty shape.
---@param presetName string Name of a preset from PMUI.ShapePresets.
---@return PMUI.Shape
function PMUI.Shape:SetPreset(presetName)
    self.parts = PMUI.ShapePresets[presetName] or {}
    return self
end

--- Sets the default fill color used by shape parts without an individual color.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0), defaults to 1.0.
---@return PMUI.Shape
function PMUI.Shape:SetColor(r, g, b, a)
    self.fillColor = { r = r, g = g, b = b, a = a or 1.0 }
    return self
end

--- Adds a rectangular part to the shape.
--- Coordinates and dimensions are normalized relative to the element size.
---@param nx number Horizontal position (0.0-1.0).
---@param ny number Vertical position (0.0-1.0).
---@param nw number Relative width (0.0-1.0).
---@param nh number Relative height (0.0-1.0).
---@param customColor table|nil Optional color override for this part.
---@return PMUI.Shape
function PMUI.Shape:AddPart(nx, ny, nw, nh, customColor)
    table.insert(self.parts, {
        x = nx,
        y = ny,
        w = nw,
        h = nh,
        color = customColor
    })
    return self
end

--- Removes all parts from the shape.
---@return PMUI.Shape
function PMUI.Shape:ClearParts()
    self.parts = {}
    return self
end

--- Renders all shape parts as scaled rectangles.
--- Each part can use its own color or inherit the shape's default fill color.
function PMUI.Shape:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local totalW = self:getWidth()
    local totalH = self:getHeight()

    for _, part in ipairs(self.parts) do
        local c = part.color or self.fillColor
        local px = math.floor(part.x * totalW)
        local py = math.floor(part.y * totalH)
        local pw = math.max(1, math.ceil(part.w * totalW))
        local ph = math.max(1, math.ceil(part.h * totalH))

        self:drawRect(px, py, pw, ph, c.a * self.alpha, c.r, c.g, c.b)
    end
end

return PMUI.Shape