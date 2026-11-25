require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.StackLayout = PMUI.BaseElement:derive("PMUI_StackLayout")

--- Creates a stack layout container.
--- Children are arranged sequentially along the specified direction.
---
--- @param direction string|nil Layout direction: "vertical" or "horizontal". Defaults to "vertical".
--- @return PMUI_StackLayout o The created layout container.
function PMUI.StackLayout:new(direction)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.direction = direction or "vertical"
    o.gap = 8
    o.paddingTop = 0
    o.paddingBottom = 0
    o.paddingLeft = 0
    o.paddingRight = 0
    o.autoSize = false

    return o
end

--- Sets the spacing between child elements.
--- Triggers an immediate layout recalculation.
---
--- @param gap number Spacing between adjacent children in pixels.
--- @return PMUI_StackLayout self
function PMUI.StackLayout:SetGap(gap)
    self.gap = gap or 0
    self:RecalculateLayout()
    return self
end

--- Sets the inner padding of the layout container.
--- Can accept either a single value for all sides or individual values.
--- Triggers an immediate layout recalculation.
---
--- @param top number Top padding, or uniform padding when used alone.
--- @param right number|nil Right padding. If omitted, the top value is used for all sides.
--- @param bottom number|nil Bottom padding.
--- @param left number|nil Left padding.
--- @return PMUI_StackLayout self
function PMUI.StackLayout:SetPadding(top, right, bottom, left)
    if right == nil then
        self.paddingTop = top or 0
        self.paddingRight = top or 0
        self.paddingBottom = top or 0
        self.paddingLeft = top or 0
    else
        self.paddingTop = top or 0
        self.paddingRight = right or 0
        self.paddingBottom = bottom or 0
        self.paddingLeft = left or 0
    end
    self:RecalculateLayout()
    return self
end

--- Enables or disables automatic container sizing.
--- When enabled, the container adjusts its dimensions to fit its children and padding.
--- Triggers an immediate layout recalculation.
---
--- @param enabled boolean Whether automatic sizing should be enabled.
--- @return PMUI_StackLayout self
function PMUI.StackLayout:SetAutoSize(enabled)
    self.autoSize = enabled
    self:RecalculateLayout()
    return self
end

--- Recalculates the positions of all child elements.
--- Children are arranged sequentially according to the layout direction,
--- with the configured gap and padding applied.
---
--- When auto sizing is enabled, the container dimensions are updated
--- to accommodate all children and their padding.
function PMUI.StackLayout:RecalculateLayout()
    PMUI.BaseElement.RecalculateLayout(self)

    local cursorX = self.paddingLeft
    local cursorY = self.paddingTop
    local maxW = 0
    local maxH = 0

    for i, child in ipairs(self._hierarchyChildren) do
        child:RecalculateLayout()

        child.scaleX = 0
        child.scaleY = 0
        child.anchorX = 0
        child.anchorY = 0
        child.offsetX = cursorX
        child.offsetY = cursorY
        child:ApplyPositionOnly()

        local cw = child:getWidth()
        local ch = child:getHeight()

        if self.direction == "vertical" then
            cursorY = cursorY + ch + self.gap
            if cw > maxW then maxW = cw end
        else
            cursorX = cursorX + cw + self.gap
            if ch > maxH then maxH = ch end
        end
    end

    if self.autoSize then
        local count = #self._hierarchyChildren
        if self.direction == "vertical" then
            local totalH = cursorY - (count > 0 and self.gap or 0) + self.paddingBottom
            local totalW = maxW + self.paddingLeft + self.paddingRight
            self:setWidth(math.max(totalW, 1))
            self:setHeight(math.max(totalH, 1))
        else
            local totalW = cursorX - (count > 0 and self.gap or 0) + self.paddingRight
            local totalH = maxH + self.paddingTop + self.paddingBottom
            self:setWidth(math.max(totalW, 1))
            self:setHeight(math.max(totalH, 1))
        end
        if self.javaObject then
            self.javaObject:setWidth(self:getWidth())
            self.javaObject:setHeight(self:getHeight())
        end
        self:ApplyPositionOnly()
    end
end

--- Creates a vertical stack layout.
--- Child elements are arranged from top to bottom.
---
--- @return PMUI_StackLayout layout The created vertical layout.
PMUI.VBox = {}
function PMUI.VBox:new()
    return PMUI.StackLayout:new("vertical")
end

--- Creates a horizontal stack layout.
--- Child elements are arranged from left to right.
---
--- @return PMUI_StackLayout layout The created horizontal layout.
PMUI.HBox = {}
function PMUI.HBox:new()
    return PMUI.StackLayout:new("horizontal")
end

return PMUI.StackLayout