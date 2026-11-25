# BaseElement

**Require path:** `require "ProjectMotionUI/Core/BaseElement"`

---

## Class `PMUI.BaseElement`

*Inherits from:* `ISUIElement`

## Methods & Functions

### `PMUI.BaseElement:new()`

Creates a base PMUI element with hierarchy, layout, animation, and interaction support.

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:GetHierarchyParent()`

Returns the element's parent in the PMUI hierarchy.

**Returns:** `PMUI.BaseElement\|nil`

### `PMUI.BaseElement:GetHierarchyRoot()`

Returns the top-level element in the current hierarchy.

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetPersistState(enabled, key)`

Enables or disables persistent state for this element.
The state key is used to identify the element when saving and restoring its data.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `enabled` | `boolean` | Whether state persistence is enabled. |
| `key` | `string\|nil` | Optional unique state key. Defaults to the element type. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SaveState(data)`

Saves the element's position, scale, and gravity state into the provided table.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `data` | `table` | State table to populate. |

### `PMUI.BaseElement:LoadState(data)`

Restores the element's position, scale, and gravity state.
Position offsets are reset if the restored coordinates place the element outside the screen.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `data` | `table` | Previously saved element state. |

### `PMUI.BaseElement:ApplyStyle(styleNameOrList, params)`

Applies one or more registered styles to the element.
A table can be supplied to apply multiple styles in sequence.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `styleNameOrList` | `string\|string[]` | Style name or an ordered list of style names. |
| `params` | `table\|nil` | Optional parameters passed to each style function. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:instantiate()`

Initializes the element and all children registered in its PMUI hierarchy.
Each child is initialized, instantiated, attached to the native UI hierarchy, and laid out.

### `PMUI.BaseElement:AddChild(child)`

Adds a child element to the PMUI hierarchy.
If the parent is already instantiated, the child is also initialized and attached immediately.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `child` | `PMUI.BaseElement` | Child element to add. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetHoverSound(soundName)`

Sets the sound played when the mouse enters the element.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `soundName` | `string\|nil` | UI sound name. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetClickSound(soundName)`

Sets the sound played when the element is clicked.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `soundName` | `string\|nil` | UI sound name. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:OnRender(fn)`

Registers a callback executed during the element's render phase.
The callback receives the element instance.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `fn` | `function` | Render callback. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:OnPreRender(fn)`

Registers a callback executed during the element's pre-render phase.
The callback receives the element instance and frame delta time in seconds.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `fn` | `function` | Pre-render callback. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:OnHover(fn)`

Registers a callback invoked when the element's hover state changes.
The callback receives the element instance and the new hover state.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `fn` | `function` | Hover callback. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetDraggable(enabled, targetElement)`

Enables or disables dragging for this element.
An optional target element can be specified to move a parent or another element instead.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `enabled` | `boolean` | Whether dragging is enabled. |
| `targetElement` | `PMUI.BaseElement\|nil` | Element to move. Defaults to this element. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetGravity(enabled)`

Enables or disables the falling physics effect.
Enabling gravity starts a fall animation; disabling it restores the element's position.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `enabled` | `boolean` | Whether gravity is enabled. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetTooltip(titleOrText, text)`

Sets the tooltip content displayed for this element.
When only one argument is provided, it is treated as the tooltip text without a title.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `titleOrText` | `string` | Tooltip title or body text. |
| `text` | `string\|nil` | Optional tooltip body text. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetSize(offsetW, offsetH)`

Sets the element's fixed width and height offsets.
The final dimensions also include any parent-relative scale values.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `offsetW` | `number\|nil` | Width offset in pixels. |
| `offsetH` | `number\|nil` | Height offset in pixels. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetSizePercent(scaleW, scaleH)`

Sets the element's width and height as proportions of its parent.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `scaleW` | `number\|nil` | Width scale relative to the parent. |
| `scaleH` | `number\|nil` | Height scale relative to the parent. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetPosition(offsetX, offsetY)`

Sets the element's position using pixel offsets relative to its parent.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `offsetX` | `number\|nil` | Horizontal position offset. |
| `offsetY` | `number\|nil` | Vertical position offset. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetPositionPercent(scaleX, scaleY)`

Sets the element's position using proportions of its parent dimensions.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `scaleX` | `number\|nil` | Horizontal position scale. |
| `scaleY` | `number\|nil` | Vertical position scale. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetAnchor(anchorX, anchorY)`

Sets the element's anchor point.
Anchor values are normalized: 0.0 represents the leading edge, 0.5 the center, and 1.0 the trailing edge.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `anchorX` | `number\|nil` | Horizontal anchor value. |
| `anchorY` | `number\|nil` | Vertical anchor value. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetPassThroughClicks(pass)`

Controls whether mouse clicks pass through this element to elements behind it.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `pass` | `boolean` | Whether mouse clicks should pass through. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:SetAlpha(alpha)`

Sets the element's opacity.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `alpha` | `number` | Opacity value, typically between 0.0 and 1.0. |

**Returns:** `PMUI.BaseElement`

### `PMUI.BaseElement:ApplyPositionOnly()`

Recalculates and applies the element's position without changing its dimensions.
Position is calculated from parent-relative scale, pixel offsets, anchor, and animation offsets.

### `PMUI.BaseElement:RecalculateLayout()`

Recalculates the element's dimensions and position.
Also updates the layout of all child elements in the PMUI hierarchy.

### `PMUI.BaseElement:prerender()`

Performs per-frame element updates before rendering.
Updates animations, hover state, registered pre-render callbacks, and tooltip positioning.

### `PMUI.BaseElement:render()`

Executes registered render callbacks and draws the debug overlay when enabled.

### `PMUI.BaseElement:onMouseDown(x, y)`

Handles mouse button presses.
Starts dragging when the element is draggable; otherwise respects click pass-through settings.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean\|nil Whether the mouse event was handled.`

### `PMUI.BaseElement:onMouseMove(dx, dy)`

Updates the dragged element's position while the mouse moves.
Keeps a short history of mouse positions for calculating the release velocity.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `dx` | `number` | Horizontal mouse movement delta. |
| `dy` | `number` | Vertical mouse movement delta. |

**Returns:** `boolean\|nil True when the element is being dragged.`

### `PMUI.BaseElement:onMouseMoveOutside(dx, dy)`

Continues drag handling when the mouse moves outside the element's bounds.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `dx` | `number` | Horizontal mouse movement delta. |
| `dy` | `number` | Vertical mouse movement delta. |

### `PMUI.BaseElement:onMouseUp(x, y)`

Handles mouse button release.
Stops dragging and, if the element was falling before the drag, applies the release velocity to its fall animation.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean\|nil Whether the mouse event was handled.`

### `PMUI.BaseElement:onMouseUpOutside(x, y)`

Handles mouse button release outside the element's bounds.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.BaseElement:onRightMouseDown(x, y)`

Handles right mouse button presses according to the click pass-through setting.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean Whether the mouse event was handled.`

