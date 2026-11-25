# Window
**Require path:** `require "ProjectMotionUI/Components/Window"`

---
## Class `PMUI.Window`
*Inherits from:* `PMUI.Frame`

## Methods & Functions

### `PMUI.Window:new(title, width, height)`

Creates a window with a draggable header, title, close button, and content area.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['title', 'string|nil', 'Window title. Defaults to "Window".']` | `['title', 'string|nil', 'Window title. Defaults to "Window".']` | ['title', 'string|nil', 'Window title. Defaults to "Window".'] |
| `['width', 'number|nil', 'Initial window width. Defaults to 360.']` | `['width', 'number|nil', 'Initial window width. Defaults to 360.']` | ['width', 'number|nil', 'Initial window width. Defaults to 360.'] |
| `['height', 'number|nil', 'Initial window height. Defaults to 280.']` | `['height', 'number|nil', 'Initial window height. Defaults to 280.']` | ['height', 'number|nil', 'Initial window height. Defaults to 280.'] |

### `PMUI.Window:SetTexture(textureOrPath)`

Sets the window background texture.
When a texture is assigned, the header background and border are made transparent.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | ['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.'] |

### `PMUI.Window:SetOpenSound(soundName)`

Sets the sound played when the window is opened.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['soundName', 'string|nil', 'UI sound name.']` | `['soundName', 'string|nil', 'UI sound name.']` | ['soundName', 'string|nil', 'UI sound name.'] |

### `PMUI.Window:SetCloseSound(soundName)`

Sets the sound played when the window is closed.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['soundName', 'string|nil', 'UI sound name.']` | `['soundName', 'string|nil', 'UI sound name.']` | ['soundName', 'string|nil', 'UI sound name.'] |

### `PMUI.Window:SetCornerRadius(radius)`

Sets the corner radius of the window and its header.
The header uses the top-corners-only mode to preserve the window shape.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['radius', 'number', 'Corner radius in pixels.']` | `['radius', 'number', 'Corner radius in pixels.']` | ['radius', 'number', 'Corner radius in pixels.'] |

### `PMUI.Window:SetHeaderColor(r, g, b, a)`

Sets the background color of the window header.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['r', 'number', 'Red component (0.0-1.0).']` | `['r', 'number', 'Red component (0.0-1.0).']` | ['r', 'number', 'Red component (0.0-1.0).'] |
| `['g', 'number', 'Green component (0.0-1.0).']` | `['g', 'number', 'Green component (0.0-1.0).']` | ['g', 'number', 'Green component (0.0-1.0).'] |
| `['b', 'number', 'Blue component (0.0-1.0).']` | `['b', 'number', 'Blue component (0.0-1.0).']` | ['b', 'number', 'Blue component (0.0-1.0).'] |
| `['a', 'number|nil', 'Alpha component (0.0-1.0).']` | `['a', 'number|nil', 'Alpha component (0.0-1.0).']` | ['a', 'number|nil', 'Alpha component (0.0-1.0).'] |

### `PMUI.Window:OnClose(callback)`

Registers a callback invoked when the window is closed.
The callback receives the window instance.
@return PMUI.Window

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['callback', 'function|nil', 'Close callback.']` | `['callback', 'function|nil', 'Close callback.']` | ['callback', 'function|nil', 'Close callback.'] |

### `PMUI.Window:Close()`

Closes the window.
Invokes the close callback, plays the configured sound, and fades out the window.
Registered instances are removed through PMUI.CloseInstance after the fade-out completes.

