# ProgressBar

**Require path:** `require "ProjectMotionUI/Components/ProgressBar"`

---

## Class `PMUI.ProgressBar`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.ProgressBar:new(minVal, maxVal)`

Creates a progress bar with the specified value range.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `minVal` | `number\|nil` | Minimum progress value. Defaults to 0. |
| `maxVal` | `number\|nil` | Maximum progress value. Defaults to 100. |

**Returns:** `PMUI.ProgressBar`

### `PMUI.ProgressBar:SetRange(minVal, maxVal)`

Sets the minimum and maximum values of the progress range.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `minVal` | `number` | Minimum progress value. |
| `maxVal` | `number` | Maximum progress value. |

**Returns:** `PMUI.ProgressBar`

### `PMUI.ProgressBar:SetValue(val, instant)`

Updates the progress value.
The value is clamped to the configured range.
When instant is false, the displayed value is animated using QuadOut easing.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `val` | `number` | Target progress value. |
| `instant` | `boolean\|nil` | If true, updates the displayed value immediately. |

**Returns:** `PMUI.ProgressBar`

### `PMUI.ProgressBar:SetFillColor(r, g, b, a)`

Sets the progress fill color.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.ProgressBar`

### `PMUI.ProgressBar:SetShowText(show, customText)`

Controls whether progress text is displayed.
An optional custom string can be used instead of the automatically calculated percentage.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `show` | `boolean` | Whether to display text. |
| `customText` | `string\|nil` | Custom text to display instead of the percentage. |

**Returns:** `PMUI.ProgressBar`

### `PMUI.ProgressBar:prerender()`

Renders the progress bar, including its background, fill, border, and optional text.
The fill width is calculated from the current animated display value.

