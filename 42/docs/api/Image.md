# Image

**Require path:** `require "ProjectMotionUI/Components/Image"`

---

## Class `PMUI.Image`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Image:new(textureOrPath)`

Creates a new image element using the specified texture.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `textureOrPath` | `string\|Texture\|nil` | Texture object or path to a texture. |

**Returns:** `PMUI.Image`

### `PMUI.Image:SetTexture(textureOrPath)`

Sets the image texture.
String values are resolved through getTexture(), while texture objects are assigned directly.
Automatically adopts the texture dimensions when the element still uses its default size.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `textureOrPath` | `string\|Texture\|nil` | Texture object or path to a texture. |

**Returns:** `PMUI.Image`

### `PMUI.Image:SetTint(r, g, b, a)`

Sets the color tint applied to the image texture.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `r` | `number` | Red component (0.0-1.0). |
| `g` | `number` | Green component (0.0-1.0). |
| `b` | `number` | Blue component (0.0-1.0). |
| `a` | `number\|nil` | Alpha component (0.0-1.0), defaults to 1.0. |

**Returns:** `PMUI.Image`

### `PMUI.Image:prerender()`

Renders the image texture scaled to the element's current dimensions.
Applies the configured tint color and combines its alpha with the element opacity.

