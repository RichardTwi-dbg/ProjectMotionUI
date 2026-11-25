require "ProjectMotionUI/Components/Frame"

PMUI = PMUI or {}
PMUI.ScrollFrame = PMUI.Frame:derive("PMUI_ScrollFrame")

--- Creates a scrollable frame that clips its children to the visible area.
---@return PMUI.ScrollFrame
function PMUI.ScrollFrame:new()
    local o = PMUI.Frame:new()
    setmetatable(o, self)
    self.__index = self

    o.passThroughClicks = false
    o.scrollY = 0
    o.maxScrollY = 0
    o.scrollSpeed = 28

    return o
end

--- Handles mouse wheel input and updates the vertical scroll position.
---@param del number Mouse wheel delta.
---@return boolean Always returns true to indicate that the input was handled.
function PMUI.ScrollFrame:onMouseWheel(del)
    self.scrollY = self.scrollY + (del * self.scrollSpeed)
    self:ClampScroll()
    self:ApplyScrollOffset()
    return true
end

--- Keeps the scroll position within the valid content boundaries.
--- Prevents scrolling above the beginning or below the end of the content.
function PMUI.ScrollFrame:ClampScroll()
    if self.scrollY < 0 then self.scrollY = 0 end
    if self.scrollY > self.maxScrollY then self.scrollY = self.maxScrollY end
end

--- Applies the current scroll offset to all direct child elements.
--- Child positions are updated without recalculating their layout.
function PMUI.ScrollFrame:ApplyScrollOffset()
    for _, child in ipairs(self._hierarchyChildren) do
        child.animOffsetY = -self.scrollY
        child:ApplyPositionOnly()
    end
end

--- Recalculates the frame layout and determines the maximum scroll distance.
--- The scrollable content height is based on the lowest child boundary.
function PMUI.ScrollFrame:RecalculateLayout()
    PMUI.Frame.RecalculateLayout(self)

    local contentBottom = 0
    for _, child in ipairs(self._hierarchyChildren) do
        local bottom = child.offsetY + child:getHeight()
        if bottom > contentBottom then
            contentBottom = bottom
        end
    end

    self.maxScrollY = math.max(0, contentBottom - self:getHeight())
    self:ClampScroll()
    self:ApplyScrollOffset()
end

--- Sets the stencil clipping area to the frame's visible bounds.
--- Child elements rendered afterward are clipped to this rectangle.
function PMUI.ScrollFrame:prerender()
    PMUI.Frame.prerender(self)

    self:setStencilRect(0, 0, self:getWidth(), self:getHeight())
end

--- Renders the frame contents and its custom vertical scrollbar.
--- The scrollbar thumb size and position reflect the current scroll state.
function PMUI.ScrollFrame:render()
    PMUI.Frame.render(self)

    self:clearStencilRect()

    if self.maxScrollY > 0 and self.alpha > 0.01 then
        local w = self:getWidth()
        local h = self:getHeight()
        local totalH = h + self.maxScrollY
        local barH = math.max(20, (h / totalH) * h)
        local barY = (self.scrollY / self.maxScrollY) * (h - barH)

        self:drawRect(w - 6, barY, 4, barH, 0.5 * self.alpha, 0.7, 0.75, 0.85)
    end
end

return PMUI.ScrollFrame