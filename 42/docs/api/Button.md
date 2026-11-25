# Button
**Require path:** `require "ProjectMotionUI/Components/Button"`

---
## Class `PMUI.Button`
*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Button:new(text)`

Creates a new button element with default appearance and behavior.
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['text', 'string|nil', 'Text displayed inside the button.']` | `['text', 'string|nil', 'Text displayed inside the button.']` | ['text', 'string|nil', 'Text displayed inside the button.'] |

### `PMUI.Button:SetTextures(normalTex, hoverTex, pressedTex)`

Assigns textures used to render the button in different interaction states.
Texture paths are automatically resolved through getTexture().
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['normalTex', 'string|Texture|nil', 'Texture displayed in the default state.']` | `['normalTex', 'string|Texture|nil', 'Texture displayed in the default state.']` | ['normalTex', 'string|Texture|nil', 'Texture displayed in the default state.'] |
| `['hoverTex', 'string|Texture|nil', 'Texture displayed while the mouse is hovering.']` | `['hoverTex', 'string|Texture|nil', 'Texture displayed while the mouse is hovering.']` | ['hoverTex', 'string|Texture|nil', 'Texture displayed while the mouse is hovering.'] |
| `['pressedTex', 'string|Texture|nil', 'Texture displayed while the button is pressed.']` | `['pressedTex', 'string|Texture|nil', 'Texture displayed while the button is pressed.']` | ['pressedTex', 'string|Texture|nil', 'Texture displayed while the button is pressed.'] |

### `PMUI.Button:SetText(text)`

Sets the text displayed inside the button.
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['text', 'string', 'Button label.']` | `['text', 'string', 'Button label.']` | ['text', 'string', 'Button label.'] |

### `PMUI.Button:SetFont(font)`

Sets the font used to render the button label.
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['font', 'UIFont', 'Font assigned to the button.']` | `['font', 'UIFont', 'Font assigned to the button.']` | ['font', 'UIFont', 'Font assigned to the button.'] |

### `PMUI.Button:SetColors(normal, hover, pressed)`

Overrides the button colors for its interaction states.
Unspecified colors retain their current values.
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['normal', 'table|nil', 'Color used in the default state.']` | `['normal', 'table|nil', 'Color used in the default state.']` | ['normal', 'table|nil', 'Color used in the default state.'] |
| `['hover', 'table|nil', 'Color used while the mouse is hovering.']` | `['hover', 'table|nil', 'Color used while the mouse is hovering.']` | ['hover', 'table|nil', 'Color used while the mouse is hovering.'] |
| `['pressed', 'table|nil', 'Color used while the button is pressed.']` | `['pressed', 'table|nil', 'Color used while the button is pressed.']` | ['pressed', 'table|nil', 'Color used while the button is pressed.'] |

### `PMUI.Button:OnClick(callback)`

Registers a callback executed when the button is clicked.
The button instance is passed as the callback argument.
@return PMUI.Button

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['callback', 'function|nil', 'Function invoked after a successful click.']` | `['callback', 'function|nil', 'Function invoked after a successful click.']` | ['callback', 'function|nil', 'Function invoked after a successful click.'] |

### `PMUI.Button:onMouseDown(x, y)`

Handles the initial mouse press and activates the pressed visual state.
@return boolean Whether the mouse event was handled.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.Button:onMouseUp(x, y)`

Handles mouse release and executes the click callback if released over the button.
Plays the configured click sound before invoking the callback.
@return boolean Whether the mouse event was handled.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.Button:onMouseUpOutside(x, y)`

Resets the pressed state when the mouse button is released outside the element.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.Button:prerender()`

Renders the button background and label before the element's main render pass.
Selects the appropriate texture or color based on the current interaction state.
Textures take priority over solid-color backgrounds.

