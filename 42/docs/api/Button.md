# Button

**Require path:** `require "ProjectMotionUI/Components/Button"`

---

## Class `PMUI.Button`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Button:new(text)`

Creates a new button element with default appearance and behavior.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `text` | `string\|nil` | Text displayed inside the button. |

**Returns:** `PMUI.Button`

### `PMUI.Button:SetTextures(normalTex, hoverTex, pressedTex)`

Assigns textures used to render the button in different interaction states.
Texture paths are automatically resolved through getTexture().

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `normalTex` | `string\|Texture\|nil` | Texture displayed in the default state. |
| `hoverTex` | `string\|Texture\|nil` | Texture displayed while the mouse is hovering. |
| `pressedTex` | `string\|Texture\|nil` | Texture displayed while the button is pressed. |

**Returns:** `PMUI.Button`

### `PMUI.Button:SetText(text)`

Sets the text displayed inside the button.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `text` | `string` | Button label. |

**Returns:** `PMUI.Button`

### `PMUI.Button:SetFont(font)`

Sets the font used to render the button label.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `font` | `UIFont` | Font assigned to the button. |

**Returns:** `PMUI.Button`

### `PMUI.Button:SetColors(normal, hover, pressed)`

Overrides the button colors for its interaction states.
Unspecified colors retain their current values.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `normal` | `table\|nil` | Color used in the default state. |
| `hover` | `table\|nil` | Color used while the mouse is hovering. |
| `pressed` | `table\|nil` | Color used while the button is pressed. |

**Returns:** `PMUI.Button`

### `PMUI.Button:OnClick(callback)`

Registers a callback executed when the button is clicked.
The button instance is passed as the callback argument.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `callback` | `function\|nil` | Function invoked after a successful click. |

**Returns:** `PMUI.Button`

### `PMUI.Button:onMouseDown(x, y)`

Handles the initial mouse press and activates the pressed visual state.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean Whether the mouse event was handled.`

### `PMUI.Button:onMouseUp(x, y)`

Handles mouse release and executes the click callback if released over the button.
Plays the configured click sound before invoking the callback.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean Whether the mouse event was handled.`

### `PMUI.Button:onMouseUpOutside(x, y)`

Resets the pressed state when the mouse button is released outside the element.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.Button:prerender()`

Renders the button background and label before the element's main render pass.
Selects the appropriate texture or color based on the current interaction state.
Textures take priority over solid-color backgrounds.

