# Label

**Require path:** `require "ProjectMotionUI/Components/Label"`

---

## Class `PMUI.Label`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Label:new(text, font)`

Creates a new text label with the specified content and font.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `text` | `string\|nil` | Initial text content. |
| `font` | `UIFont\|nil` | Font used to render the text. Defaults to UIFont.Small. |

**Returns:** `PMUI.Label`

### `PMUI.Label:SetText(text)`

Updates the label text and recalculates its dimensions when auto sizing is enabled.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `text` | `string\|nil` | New text content. |

**Returns:** `PMUI.Label`

### `PMUI.Label:SetFont(font)`

Sets the font used to render the label.
Recalculates the element dimensions when auto sizing is enabled.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `font` | `UIFont` | Font assigned to the label. |

**Returns:** `PMUI.Label`

### `PMUI.Label:SetColor(r, g, b, a)`

Sets the label text color.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Label`

### `PMUI.Label:SetAlign(align)`

Sets the horizontal text alignment.
Disables automatic sizing to preserve the manually assigned element dimensions.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `align` | `string` | Alignment mode: "left", "center", or "right". |

**Returns:** `PMUI.Label`

### `PMUI.Label:UpdateSizeFromText()`

Calculates and updates the element dimensions based on the current text and font.
Uses the text manager to measure the required width and height.

### `PMUI.Label:prerender()`

Renders the label text using the configured font, color, and alignment.
Text is positioned horizontally according to the selected alignment mode.

