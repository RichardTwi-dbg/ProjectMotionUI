# BaseElement
**Путь подключения:** `require "ProjectMotionUI/Core/BaseElement"`

---
## Класс `PMUI.BaseElement`
*Наследуется от:* `ISUIElement`

## Методы и функции

### `PMUI.BaseElement:new()`

Creates a base PMUI element with hierarchy, layout, animation, and interaction support.
@return PMUI.BaseElement

### `PMUI.BaseElement:GetHierarchyParent()`

Returns the element's parent in the PMUI hierarchy.
@return PMUI.BaseElement|nil

### `PMUI.BaseElement:GetHierarchyRoot()`

Returns the top-level element in the current hierarchy.
@return PMUI.BaseElement

### `PMUI.BaseElement:SetPersistState(enabled, key)`

Enables or disables persistent state for this element.
The state key is used to identify the element when saving and restoring its data.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['enabled', 'boolean', 'Whether state persistence is enabled.']` | `['enabled', 'boolean', 'Whether state persistence is enabled.']` | ['enabled', 'boolean', 'Whether state persistence is enabled.'] |
| `['key', 'string|nil', 'Optional unique state key. Defaults to the element type.']` | `['key', 'string|nil', 'Optional unique state key. Defaults to the element type.']` | ['key', 'string|nil', 'Optional unique state key. Defaults to the element type.'] |

### `PMUI.BaseElement:SaveState(data)`

Saves the element's position, scale, and gravity state into the provided table.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['data', 'table', 'State table to populate.']` | `['data', 'table', 'State table to populate.']` | ['data', 'table', 'State table to populate.'] |

### `PMUI.BaseElement:LoadState(data)`

Restores the element's position, scale, and gravity state.
Position offsets are reset if the restored coordinates place the element outside the screen.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['data', 'table', 'Previously saved element state.']` | `['data', 'table', 'Previously saved element state.']` | ['data', 'table', 'Previously saved element state.'] |

### `PMUI.BaseElement:ApplyStyle(styleNameOrList, params)`

Applies one or more registered styles to the element.
A table can be supplied to apply multiple styles in sequence.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['styleNameOrList', 'string|string[]', 'Style name or an ordered list of style names.']` | `['styleNameOrList', 'string|string[]', 'Style name or an ordered list of style names.']` | ['styleNameOrList', 'string|string[]', 'Style name or an ordered list of style names.'] |
| `['params', 'table|nil', 'Optional parameters passed to each style function.']` | `['params', 'table|nil', 'Optional parameters passed to each style function.']` | ['params', 'table|nil', 'Optional parameters passed to each style function.'] |

### `PMUI.BaseElement:instantiate()`

Initializes the element and all children registered in its PMUI hierarchy.
Each child is initialized, instantiated, attached to the native UI hierarchy, and laid out.

### `PMUI.BaseElement:AddChild(child)`

Adds a child element to the PMUI hierarchy.
If the parent is already instantiated, the child is also initialized and attached immediately.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['child', 'PMUI.BaseElement', 'Child element to add.']` | `['child', 'PMUI.BaseElement', 'Child element to add.']` | ['child', 'PMUI.BaseElement', 'Child element to add.'] |

### `PMUI.BaseElement:SetHoverSound(soundName)`

Sets the sound played when the mouse enters the element.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['soundName', 'string|nil', 'UI sound name.']` | `['soundName', 'string|nil', 'UI sound name.']` | ['soundName', 'string|nil', 'UI sound name.'] |

### `PMUI.BaseElement:SetClickSound(soundName)`

Sets the sound played when the element is clicked.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['soundName', 'string|nil', 'UI sound name.']` | `['soundName', 'string|nil', 'UI sound name.']` | ['soundName', 'string|nil', 'UI sound name.'] |

### `PMUI.BaseElement:OnRender(fn)`

Registers a callback executed during the element's render phase.
The callback receives the element instance.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['fn', 'function', 'Render callback.']` | `['fn', 'function', 'Render callback.']` | ['fn', 'function', 'Render callback.'] |

### `PMUI.BaseElement:OnPreRender(fn)`

Registers a callback executed during the element's pre-render phase.
The callback receives the element instance and frame delta time in seconds.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['fn', 'function', 'Pre-render callback.']` | `['fn', 'function', 'Pre-render callback.']` | ['fn', 'function', 'Pre-render callback.'] |

### `PMUI.BaseElement:OnHover(fn)`

Registers a callback invoked when the element's hover state changes.
The callback receives the element instance and the new hover state.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['fn', 'function', 'Hover callback.']` | `['fn', 'function', 'Hover callback.']` | ['fn', 'function', 'Hover callback.'] |

### `PMUI.BaseElement:SetDraggable(enabled, targetElement)`

Enables or disables dragging for this element.
An optional target element can be specified to move a parent or another element instead.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['enabled', 'boolean', 'Whether dragging is enabled.']` | `['enabled', 'boolean', 'Whether dragging is enabled.']` | ['enabled', 'boolean', 'Whether dragging is enabled.'] |
| `['targetElement', 'PMUI.BaseElement|nil', 'Element to move. Defaults to this element.']` | `['targetElement', 'PMUI.BaseElement|nil', 'Element to move. Defaults to this element.']` | ['targetElement', 'PMUI.BaseElement|nil', 'Element to move. Defaults to this element.'] |

### `PMUI.BaseElement:SetGravity(enabled)`

Enables or disables the falling physics effect.
Enabling gravity starts a fall animation; disabling it restores the element's position.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['enabled', 'boolean', 'Whether gravity is enabled.']` | `['enabled', 'boolean', 'Whether gravity is enabled.']` | ['enabled', 'boolean', 'Whether gravity is enabled.'] |

### `PMUI.BaseElement:SetTooltip(titleOrText, text)`

Sets the tooltip content displayed for this element.
When only one argument is provided, it is treated as the tooltip text without a title.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['titleOrText', 'string', 'Tooltip title or body text.']` | `['titleOrText', 'string', 'Tooltip title or body text.']` | ['titleOrText', 'string', 'Tooltip title or body text.'] |
| `['text', 'string|nil', 'Optional tooltip body text.']` | `['text', 'string|nil', 'Optional tooltip body text.']` | ['text', 'string|nil', 'Optional tooltip body text.'] |

### `PMUI.BaseElement:SetSize(offsetW, offsetH)`

Sets the element's fixed width and height offsets.
The final dimensions also include any parent-relative scale values.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['offsetW', 'number|nil', 'Width offset in pixels.']` | `['offsetW', 'number|nil', 'Width offset in pixels.']` | ['offsetW', 'number|nil', 'Width offset in pixels.'] |
| `['offsetH', 'number|nil', 'Height offset in pixels.']` | `['offsetH', 'number|nil', 'Height offset in pixels.']` | ['offsetH', 'number|nil', 'Height offset in pixels.'] |

### `PMUI.BaseElement:SetSizePercent(scaleW, scaleH)`

Sets the element's width and height as proportions of its parent.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['scaleW', 'number|nil', 'Width scale relative to the parent.']` | `['scaleW', 'number|nil', 'Width scale relative to the parent.']` | ['scaleW', 'number|nil', 'Width scale relative to the parent.'] |
| `['scaleH', 'number|nil', 'Height scale relative to the parent.']` | `['scaleH', 'number|nil', 'Height scale relative to the parent.']` | ['scaleH', 'number|nil', 'Height scale relative to the parent.'] |

### `PMUI.BaseElement:SetPosition(offsetX, offsetY)`

Sets the element's position using pixel offsets relative to its parent.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['offsetX', 'number|nil', 'Horizontal position offset.']` | `['offsetX', 'number|nil', 'Horizontal position offset.']` | ['offsetX', 'number|nil', 'Horizontal position offset.'] |
| `['offsetY', 'number|nil', 'Vertical position offset.']` | `['offsetY', 'number|nil', 'Vertical position offset.']` | ['offsetY', 'number|nil', 'Vertical position offset.'] |

### `PMUI.BaseElement:SetPositionPercent(scaleX, scaleY)`

Sets the element's position using proportions of its parent dimensions.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['scaleX', 'number|nil', 'Horizontal position scale.']` | `['scaleX', 'number|nil', 'Horizontal position scale.']` | ['scaleX', 'number|nil', 'Horizontal position scale.'] |
| `['scaleY', 'number|nil', 'Vertical position scale.']` | `['scaleY', 'number|nil', 'Vertical position scale.']` | ['scaleY', 'number|nil', 'Vertical position scale.'] |

### `PMUI.BaseElement:SetAnchor(anchorX, anchorY)`

Sets the element's anchor point.
Anchor values are normalized: 0.0 represents the leading edge, 0.5 the center, and 1.0 the trailing edge.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['anchorX', 'number|nil', 'Horizontal anchor value.']` | `['anchorX', 'number|nil', 'Horizontal anchor value.']` | ['anchorX', 'number|nil', 'Horizontal anchor value.'] |
| `['anchorY', 'number|nil', 'Vertical anchor value.']` | `['anchorY', 'number|nil', 'Vertical anchor value.']` | ['anchorY', 'number|nil', 'Vertical anchor value.'] |

### `PMUI.BaseElement:SetPassThroughClicks(pass)`

Controls whether mouse clicks pass through this element to elements behind it.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['pass', 'boolean', 'Whether mouse clicks should pass through.']` | `['pass', 'boolean', 'Whether mouse clicks should pass through.']` | ['pass', 'boolean', 'Whether mouse clicks should pass through.'] |

### `PMUI.BaseElement:SetAlpha(alpha)`

Sets the element's opacity.
@return PMUI.BaseElement

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['alpha', 'number', 'Opacity value, typically between 0.0 and 1.0.']` | `['alpha', 'number', 'Opacity value, typically between 0.0 and 1.0.']` | ['alpha', 'number', 'Opacity value, typically between 0.0 and 1.0.'] |

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
@return boolean|nil Whether the mouse event was handled.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.BaseElement:onMouseMove(dx, dy)`

Updates the dragged element's position while the mouse moves.
Keeps a short history of mouse positions for calculating the release velocity.
@return boolean|nil True when the element is being dragged.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['dx', 'number', 'Horizontal mouse movement delta.']` | `['dx', 'number', 'Horizontal mouse movement delta.']` | ['dx', 'number', 'Horizontal mouse movement delta.'] |
| `['dy', 'number', 'Vertical mouse movement delta.']` | `['dy', 'number', 'Vertical mouse movement delta.']` | ['dy', 'number', 'Vertical mouse movement delta.'] |

### `PMUI.BaseElement:onMouseMoveOutside(dx, dy)`

Continues drag handling when the mouse moves outside the element's bounds.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['dx', 'number', 'Horizontal mouse movement delta.']` | `['dx', 'number', 'Horizontal mouse movement delta.']` | ['dx', 'number', 'Horizontal mouse movement delta.'] |
| `['dy', 'number', 'Vertical mouse movement delta.']` | `['dy', 'number', 'Vertical mouse movement delta.']` | ['dy', 'number', 'Vertical mouse movement delta.'] |

### `PMUI.BaseElement:onMouseUp(x, y)`

Handles mouse button release.
Stops dragging and, if the element was falling before the drag, applies the release velocity to its fall animation.
@return boolean|nil Whether the mouse event was handled.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.BaseElement:onMouseUpOutside(x, y)`

Handles mouse button release outside the element's bounds.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

### `PMUI.BaseElement:onRightMouseDown(x, y)`

Handles right mouse button presses according to the click pass-through setting.
@return boolean Whether the mouse event was handled.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['x', 'number', 'Mouse X coordinate relative to the element.']` | `['x', 'number', 'Mouse X coordinate relative to the element.']` | ['x', 'number', 'Mouse X coordinate relative to the element.'] |
| `['y', 'number', 'Mouse Y coordinate relative to the element.']` | `['y', 'number', 'Mouse Y coordinate relative to the element.']` | ['y', 'number', 'Mouse Y coordinate relative to the element.'] |

