# Shape

**Путь подключения:** `require "ProjectMotionUI/Components/Shape"`

---

## Класс `PMUI.Shape`

*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.Shape:new(presetOrParts)`

Creates a shape from a preset or a custom collection of rectangular parts.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `presetOrParts` | `string\|table\|nil` | Preset name or an array of normalized shape parts. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:SetPreset(presetName)`

Replaces the current shape parts with the specified preset.
Unknown preset names result in an empty shape.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `presetName` | `string` | Name of a preset from PMUI.ShapePresets. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:SetColor(r, g, b, a)`

Sets the default fill color used by shape parts without an individual color.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:AddPart(nx, ny, nw, nh, customColor)`

Adds a rectangular part to the shape.
Coordinates and dimensions are normalized relative to the element size.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `nx` | `number` | Horizontal position (0.0-1.0). |
| `ny` | `number` | Vertical position (0.0-1.0). |
| `nw` | `number` | Relative width (0.0-1.0). |
| `nh` | `number` | Relative height (0.0-1.0). |
| `customColor` | `table\|nil` | Optional color override for this part. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:ClearParts()`

Removes all parts from the shape.

**Returns:** `PMUI.Shape`

### `PMUI.Shape:prerender()`

Renders all shape parts as scaled rectangles.
Each part can use its own color or inherit the shape's default fill color.

