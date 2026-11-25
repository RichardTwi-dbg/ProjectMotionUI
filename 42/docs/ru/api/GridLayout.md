# GridLayout

**Путь подключения:** `require "ProjectMotionUI/Components/GridLayout"`

---

## Класс `PMUI.GridLayout`

*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.GridLayout:new(columns, cellW, cellH)`

Creates a new grid layout container with the specified column count and cell dimensions.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `columns` | `number\|nil` | Number of columns in the grid. Defaults to 4. |
| `cellW` | `number\|nil` | Width of each grid cell. Defaults to 48. |
| `cellH` | `number\|nil` | Height of each grid cell. Defaults to 48. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:SetColumns(cols)`

Sets the number of columns used to arrange child elements.
Triggers a layout recalculation after updating the value.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `cols` | `number` | Number of grid columns. Minimum value is 1. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:SetCellSize(w, h)`

Sets the dimensions of each grid cell.
All child elements are resized to match the specified cell dimensions.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `w` | `number\|nil` | Cell width. |
| `h` | `number\|nil` | Cell height. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:SetGap(gapX, gapY)`

Sets the horizontal and vertical spacing between grid cells.
If the vertical gap is omitted, the horizontal gap is used for both axes.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `gapX` | `number\|nil` | Horizontal spacing between cells. |
| `gapY` | `number\|nil` | Vertical spacing between cells. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:SetPadding(pad)`

Sets the inner spacing between the grid content and its container boundaries.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `pad` | `number\|nil` | Padding applied to all sides of the grid. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:SetAutoSize(enabled)`

Enables or disables automatic container resizing based on its contents.
When enabled, the container dimensions are calculated from the cell count,
column count, cell dimensions, gaps, and padding.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `enabled` | `boolean` | Whether automatic resizing should be enabled. |

**Returns:** `PMUI.GridLayout`

### `PMUI.GridLayout:RecalculateLayout()`

Recalculates the positions and dimensions of all child elements.
Arranges children sequentially from left to right and top to bottom.
Resets child scaling and anchors to ensure consistent cell positioning.
Automatically updates the container dimensions when auto sizing is enabled.

