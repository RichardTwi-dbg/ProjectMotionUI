# Frame

**Require path:** `require "ProjectMotionUI/Components/Frame"`

---

## Class `PMUI.Frame`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Frame:new()`

Creates a new frame element with default background and border settings.

**Returns:** `PMUI.Frame`

### `PMUI.Frame:SetTexture(textureOrPath)`

Sets the frame background texture.
String values are resolved through getTexture(), while texture objects are assigned directly.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `textureOrPath` | `string\|Texture\|nil` | Texture object or path to a texture. |

**Returns:** `PMUI.Frame`

### `PMUI.Frame:SetBackgroundColor(r, g, b, a)`

Sets the frame background color and controls background visibility.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Frame`

### `PMUI.Frame:SetBorderColor(r, g, b, a)`

Sets the frame border color and controls border visibility.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Frame`

### `PMUI.Frame:SetCornerRadius(radius, topOnly)`

Sets the corner radius used when rendering the frame.
Optionally limits rounded corners to the top edge.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `radius` | `number` | Corner radius in pixels. |
| `topOnly` | `boolean\|nil` | Whether only the top corners should be rounded. |

**Returns:** `PMUI.Frame`

### `PMUI.Frame:DrawRoundedBox(w, h, r, bgCol, borderCol, alphaMult)`

Draws a frame with rounded corners using individual horizontal rectangles.
Supports independently rounded top and bottom edges.
Falls back to standard rectangle rendering when the radius is too small.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `w` | `number` | Frame width. |
| `h` | `number` | Frame height. |
| `r` | `number` | Requested corner radius. |
| `bgCol` | `table` | Background color components. |
| `borderCol` | `table` | Border color components. |
| `alphaMult` | `number` | Additional alpha multiplier, usually the frame's opacity. |

### `PMUI.Frame:prerender()`

Renders the frame background, texture, and border.
Uses the configured texture when available, otherwise draws a solid-color background.
Applies rounded corner rendering when a non-zero corner radius is configured.

