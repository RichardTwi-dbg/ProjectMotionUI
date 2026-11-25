# Shape

**Require path:** `require "ProjectMotionUI/Components/Shape"`

---

## Class `PMUI.Shape`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Shape:new(presetOrParts)`

Creates a shape from a preset or a custom collection of rectangular parts.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `presetOrParts` | `string\|table\|nil` | Preset name or an array of normalized shape parts. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:SetPreset(presetName)`

Replaces the current shape parts with the specified preset.
Unknown preset names result in an empty shape.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `presetName` | `string` | Name of a preset from PMUI.ShapePresets. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:SetColor(r, g, b, a)`

Sets the default fill color used by shape parts without an individual color.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Shape`

### `PMUI.Shape:AddPart(nx, ny, nw, nh, customColor)`

Adds a rectangular part to the shape.
Coordinates and dimensions are normalized relative to the element size.

| Parameter | Type | Description |
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

