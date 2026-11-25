require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.GridLayout = PMUI.BaseElement:derive("PMUI_GridLayout")

--- Creates a new grid layout container with the specified column count and cell dimensions.
---@param columns number|nil Number of columns in the grid. Defaults to 4.
---@param cellW number|nil Width of each grid cell. Defaults to 48.
---@param cellH number|nil Height of each grid cell. Defaults to 48.
---@return PMUI.GridLayout
function PMUI.GridLayout:new(columns, cellW, cellH)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.columns = math.max(1, columns or 4)
    o.cellWidth = cellW or 48
    o.cellHeight = cellH or 48
    o.gapX = 6
    o.gapY = 6
    o.padding = 8
    o.autoSize = true

    return o
end

--- Sets the number of columns used to arrange child elements.
--- Triggers a layout recalculation after updating the value.
---@param cols number Number of grid columns. Minimum value is 1.
---@return PMUI.GridLayout
function PMUI.GridLayout:SetColumns(cols)
    self.columns = math.max(1, cols or 1)
    self:RecalculateLayout()
    return self
end

--- Sets the dimensions of each grid cell.
--- All child elements are resized to match the specified cell dimensions.
---@param w number|nil Cell width.
---@param h number|nil Cell height.
---@return PMUI.GridLayout
function PMUI.GridLayout:SetCellSize(w, h)
    self.cellWidth = w or self.cellWidth
    self.cellHeight = h or self.cellHeight
    self:RecalculateLayout()
    return self
end

--- Sets the horizontal and vertical spacing between grid cells.
--- If the vertical gap is omitted, the horizontal gap is used for both axes.
---@param gapX number|nil Horizontal spacing between cells.
---@param gapY number|nil Vertical spacing between cells.
---@return PMUI.GridLayout
function PMUI.GridLayout:SetGap(gapX, gapY)
    self.gapX = gapX or 0
    self.gapY = gapY or gapX or 0
    self:RecalculateLayout()
    return self
end

--- Sets the inner spacing between the grid content and its container boundaries.
---@param pad number|nil Padding applied to all sides of the grid.
---@return PMUI.GridLayout
function PMUI.GridLayout:SetPadding(pad)
    self.padding = pad or 0
    self:RecalculateLayout()
    return self
end

--- Enables or disables automatic container resizing based on its contents.
--- When enabled, the container dimensions are calculated from the cell count,
--- column count, cell dimensions, gaps, and padding.
---@param enabled boolean Whether automatic resizing should be enabled.
---@return PMUI.GridLayout
function PMUI.GridLayout:SetAutoSize(enabled)
    self.autoSize = enabled
    self:RecalculateLayout()
    return self
end

--- Recalculates the positions and dimensions of all child elements.
--- Arranges children sequentially from left to right and top to bottom.
--- Resets child scaling and anchors to ensure consistent cell positioning.
--- Automatically updates the container dimensions when auto sizing is enabled.
function PMUI.GridLayout:RecalculateLayout()
    PMUI.BaseElement.RecalculateLayout(self)

    local count = #self._hierarchyChildren
    for i, child in ipairs(self._hierarchyChildren) do
        -- Convert the child index into its corresponding grid coordinates.
        local idx = i - 1
        local col = idx % self.columns
        local row = math.floor(idx / self.columns)

        -- Calculate the child's position using cell dimensions, spacing, and padding.
        local posX = self.padding + col * (self.cellWidth + self.gapX)
        local posY = self.padding + row * (self.cellHeight + self.gapY)

        -- Reset scaling and anchors so the child uses fixed cell dimensions.
        child.scaleX = 0
        child.scaleY = 0
        child.scaleW = 0
        child.scaleH = 0
        child.anchorX = 0
        child.anchorY = 0

        -- Assign the calculated cell dimensions and position.
        child.offsetW = self.cellWidth
        child.offsetH = self.cellHeight
        child.offsetX = posX
        child.offsetY = posY

        child:RecalculateLayout()
    end

    if self.autoSize then
        -- Calculate the number of rows required to accommodate all children.
        local rows = math.max(1, math.ceil(count / self.columns))

        -- Calculate the total container dimensions, including gaps and padding.
        local totalW = self.padding * 2 + self.columns * self.cellWidth + (self.columns - 1) * self.gapX
        local totalH = self.padding * 2 + rows * self.cellHeight + (rows - 1) * self.gapY

        -- Update the logical and Java UI dimensions.
        self:setWidth(math.max(1, totalW))
        self:setHeight(math.max(1, totalH))
        if self.javaObject then
            self.javaObject:setWidth(self:getWidth())
            self.javaObject:setHeight(self:getHeight())
        end

        -- Apply the updated position after resizing the container.
        self:ApplyPositionOnly()
    end
end

return PMUI.GridLayout