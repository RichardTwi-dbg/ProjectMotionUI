# Image
**Путь подключения:** `require "ProjectMotionUI/Components/Image"`

---
## Класс `PMUI.Image`
*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.Image:new(textureOrPath)`

Creates a new image element using the specified texture.
@return PMUI.Image

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | ['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.'] |

### `PMUI.Image:SetTexture(textureOrPath)`

Sets the image texture.
String values are resolved through getTexture(), while texture objects are assigned directly.
Automatically adopts the texture dimensions when the element still uses its default size.
@return PMUI.Image

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | `['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.']` | ['textureOrPath', 'string|Texture|nil', 'Texture object or path to a texture.'] |

### `PMUI.Image:SetTint(r, g, b, a)`

Sets the color tint applied to the image texture.
@return PMUI.Image

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['r', 'number', 'Red component (0.0-1.0).']` | `['r', 'number', 'Red component (0.0-1.0).']` | ['r', 'number', 'Red component (0.0-1.0).'] |
| `['g', 'number', 'Green component (0.0-1.0).']` | `['g', 'number', 'Green component (0.0-1.0).']` | ['g', 'number', 'Green component (0.0-1.0).'] |
| `['b', 'number', 'Blue component (0.0-1.0).']` | `['b', 'number', 'Blue component (0.0-1.0).']` | ['b', 'number', 'Blue component (0.0-1.0).'] |
| `['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.']` | `['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.']` | ['a', 'number|nil', 'Alpha component (0.0-1.0), defaults to 1.0.'] |

### `PMUI.Image:prerender()`

Renders the image texture scaled to the element's current dimensions.
Applies the configured tint color and combines its alpha with the element opacity.

