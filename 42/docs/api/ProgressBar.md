# ProgressBar
**Require path:** `require "ProjectMotionUI/Components/ProgressBar"`

---
## Class `PMUI.ProgressBar`
*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.ProgressBar:new(minVal, maxVal)`

Creates a progress bar with the specified value range.
@return PMUI.ProgressBar

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['minVal', 'number|nil', 'Minimum progress value. Defaults to 0.']` | `['minVal', 'number|nil', 'Minimum progress value. Defaults to 0.']` | ['minVal', 'number|nil', 'Minimum progress value. Defaults to 0.'] |
| `['maxVal', 'number|nil', 'Maximum progress value. Defaults to 100.']` | `['maxVal', 'number|nil', 'Maximum progress value. Defaults to 100.']` | ['maxVal', 'number|nil', 'Maximum progress value. Defaults to 100.'] |

### `PMUI.ProgressBar:SetRange(minVal, maxVal)`

Sets the minimum and maximum values of the progress range.
@return PMUI.ProgressBar

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['minVal', 'number', 'Minimum progress value.']` | `['minVal', 'number', 'Minimum progress value.']` | ['minVal', 'number', 'Minimum progress value.'] |
| `['maxVal', 'number', 'Maximum progress value.']` | `['maxVal', 'number', 'Maximum progress value.']` | ['maxVal', 'number', 'Maximum progress value.'] |

### `PMUI.ProgressBar:SetValue(val, instant)`

Updates the progress value.
The value is clamped to the configured range.
When instant is false, the displayed value is animated using QuadOut easing.
@return PMUI.ProgressBar

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['val', 'number', 'Target progress value.']` | `['val', 'number', 'Target progress value.']` | ['val', 'number', 'Target progress value.'] |
| `['instant', 'boolean|nil', 'If true, updates the displayed value immediately.']` | `['instant', 'boolean|nil', 'If true, updates the displayed value immediately.']` | ['instant', 'boolean|nil', 'If true, updates the displayed value immediately.'] |

### `PMUI.ProgressBar:SetFillColor(r, g, b, a)`

Sets the progress fill color.
@return PMUI.ProgressBar

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['r', 'number', 'Red component (0.0-1.0).']` | `['r', 'number', 'Red component (0.0-1.0).']` | ['r', 'number', 'Red component (0.0-1.0).'] |
| `['g', 'number', 'Green component (0.0-1.0).']` | `['g', 'number', 'Green component (0.0-1.0).']` | ['g', 'number', 'Green component (0.0-1.0).'] |
| `['b', 'number', 'Blue component (0.0-1.0).']` | `['b', 'number', 'Blue component (0.0-1.0).']` | ['b', 'number', 'Blue component (0.0-1.0).'] |
| `['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.']` | `['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.']` | ['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.'] |

### `PMUI.ProgressBar:SetShowText(show, customText)`

Controls whether progress text is displayed.
An optional custom string can be used instead of the automatically calculated percentage.
@return PMUI.ProgressBar

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['show', 'boolean', 'Whether to display text.']` | `['show', 'boolean', 'Whether to display text.']` | ['show', 'boolean', 'Whether to display text.'] |
| `['customText', 'string|nil', 'Custom text to display instead of the percentage.']` | `['customText', 'string|nil', 'Custom text to display instead of the percentage.']` | ['customText', 'string|nil', 'Custom text to display instead of the percentage.'] |

### `PMUI.ProgressBar:prerender()`

Renders the progress bar, including its background, fill, border, and optional text.
The fill width is calculated from the current animated display value.

