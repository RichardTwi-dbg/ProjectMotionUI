# GridLayout
**Require path:** `require "ProjectMotionUI/Components/GridLayout"`

---
## Class `PMUI.GridLayout`
*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.GridLayout:new(columns, cellW, cellH)`

Creates a new grid layout container with the specified column count and cell dimensions.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['columns', 'number|nil', 'Number of columns in the grid. Defaults to 4.']` | `['columns', 'number|nil', 'Number of columns in the grid. Defaults to 4.']` | ['columns', 'number|nil', 'Number of columns in the grid. Defaults to 4.'] |
| `['cellW', 'number|nil', 'Width of each grid cell. Defaults to 48.']` | `['cellW', 'number|nil', 'Width of each grid cell. Defaults to 48.']` | ['cellW', 'number|nil', 'Width of each grid cell. Defaults to 48.'] |
| `['cellH', 'number|nil', 'Height of each grid cell. Defaults to 48.']` | `['cellH', 'number|nil', 'Height of each grid cell. Defaults to 48.']` | ['cellH', 'number|nil', 'Height of each grid cell. Defaults to 48.'] |

### `PMUI.GridLayout:SetColumns(cols)`

Sets the number of columns used to arrange child elements.
Triggers a layout recalculation after updating the value.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['cols', 'number', 'Number of grid columns. Minimum value is 1.']` | `['cols', 'number', 'Number of grid columns. Minimum value is 1.']` | ['cols', 'number', 'Number of grid columns. Minimum value is 1.'] |

### `PMUI.GridLayout:SetCellSize(w, h)`

Sets the dimensions of each grid cell.
All child elements are resized to match the specified cell dimensions.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['w', 'number|nil', 'Cell width.']` | `['w', 'number|nil', 'Cell width.']` | ['w', 'number|nil', 'Cell width.'] |
| `['h', 'number|nil', 'Cell height.']` | `['h', 'number|nil', 'Cell height.']` | ['h', 'number|nil', 'Cell height.'] |

### `PMUI.GridLayout:SetGap(gapX, gapY)`

Sets the horizontal and vertical spacing between grid cells.
If the vertical gap is omitted, the horizontal gap is used for both axes.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['gapX', 'number|nil', 'Horizontal spacing between cells.']` | `['gapX', 'number|nil', 'Horizontal spacing between cells.']` | ['gapX', 'number|nil', 'Horizontal spacing between cells.'] |
| `['gapY', 'number|nil', 'Vertical spacing between cells.']` | `['gapY', 'number|nil', 'Vertical spacing between cells.']` | ['gapY', 'number|nil', 'Vertical spacing between cells.'] |

### `PMUI.GridLayout:SetPadding(pad)`

Sets the inner spacing between the grid content and its container boundaries.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['pad', 'number|nil', 'Padding applied to all sides of the grid.']` | `['pad', 'number|nil', 'Padding applied to all sides of the grid.']` | ['pad', 'number|nil', 'Padding applied to all sides of the grid.'] |

### `PMUI.GridLayout:SetAutoSize(enabled)`

Enables or disables automatic container resizing based on its contents.
When enabled, the container dimensions are calculated from the cell count,
column count, cell dimensions, gaps, and padding.
@return PMUI.GridLayout

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['enabled', 'boolean', 'Whether automatic resizing should be enabled.']` | `['enabled', 'boolean', 'Whether automatic resizing should be enabled.']` | ['enabled', 'boolean', 'Whether automatic resizing should be enabled.'] |

### `PMUI.GridLayout:RecalculateLayout()`

Recalculates the positions and dimensions of all child elements.
Arranges children sequentially from left to right and top to bottom.
Resets child scaling and anchors to ensure consistent cell positioning.
Automatically updates the container dimensions when auto sizing is enabled.

