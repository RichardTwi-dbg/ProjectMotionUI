# Window

**Путь подключения:** `require "ProjectMotionUI/Components/Window"`

---

## Класс `PMUI.Window`

*Наследуется от:* `PMUI.Frame`

## Методы и функции

### `PMUI.Window:new(title, width, height)`

Creates a window with a draggable header, title, close button, and content area.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `title` | `string\|nil` | Window title. Defaults to "Window". |
| `width` | `number\|nil` | Initial window width. Defaults to 360. |
| `height` | `number\|nil` | Initial window height. Defaults to 280. |

**Returns:** `PMUI.Window`

### `PMUI.Window:SetTexture(textureOrPath)`

Sets the window background texture.
When a texture is assigned, the header background and border are made transparent.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `textureOrPath` | `string\|Texture\|nil` | Texture object or path to a texture. |

**Returns:** `PMUI.Window`

### `PMUI.Window:SetOpenSound(soundName)`

Sets the sound played when the window is opened.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `soundName` | `string\|nil` | UI sound name. |

**Returns:** `PMUI.Window`

### `PMUI.Window:SetCloseSound(soundName)`

Sets the sound played when the window is closed.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `soundName` | `string\|nil` | UI sound name. |

**Returns:** `PMUI.Window`

### `PMUI.Window:SetCornerRadius(radius)`

Sets the corner radius of the window and its header.
The header uses the top-corners-only mode to preserve the window shape.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `radius` | `number` | Corner radius in pixels. |

**Returns:** `PMUI.Window`

### `PMUI.Window:SetHeaderColor(r, g, b, a)`

Sets the background color of the window header.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0). |

**Returns:** `PMUI.Window`

### `PMUI.Window:OnClose(callback)`

Registers a callback invoked when the window is closed.
The callback receives the window instance.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `callback` | `function\|nil` | Close callback. |

**Returns:** `PMUI.Window`

### `PMUI.Window:Close()`

Closes the window.
Invokes the close callback, plays the configured sound, and fades out the window.
Registered instances are removed through PMUI.CloseInstance after the fade-out completes.

