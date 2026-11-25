# Slider

**Путь подключения:** `require "ProjectMotionUI/Components/Slider"`

---

## Класс `PMUI.Slider`

*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.Slider:new(minVal, maxVal, step)`

Creates a slider with the specified value range and step.
@return PMUI.Slider

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `minVal` | `number|nil` | Minimum slider value. Defaults to 0. |
| `maxVal` | `number|nil` | Maximum slider value. Defaults to 100. |
| `step` | `number|nil` | Value increment. Defaults to 1. |

### `PMUI.Slider:SetValue(val, triggerCallback)`

Sets the slider value, clamping it to the configured range.
The value is rounded to the nearest step when step is greater than zero.
@return PMUI.Slider

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `val` | `number` | Target slider value. |
| `triggerCallback` | `boolean|nil` | Whether to invoke the change callback if the value changes. |

### `PMUI.Slider:GetValue()`

Returns the current slider value.
@return number

### `PMUI.Slider:OnChange(callback)`

Registers a callback invoked when the slider value changes.
The callback receives the new value and the slider instance.
@return PMUI.Slider

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `callback` | `function|nil` | Change callback. |

### `PMUI.Slider:UpdateFromMouse()`

Updates the slider value based on the current mouse position.
Converts the horizontal mouse coordinate into a normalized range ratio.

### `PMUI.Slider:onMouseDown(x, y)`

Starts dragging the slider thumb and immediately updates the value.
@return boolean Always returns true to indicate that the input was handled.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.Slider:onMouseMove(dx, dy)`

Updates the slider value while the mouse is being dragged.
@return boolean|nil True when the slider is actively being dragged.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `dx` | `number` | Horizontal mouse movement delta. |
| `dy` | `number` | Vertical mouse movement delta. |

### `PMUI.Slider:onMouseMoveOutside(dx, dy)`

Continues updating the slider while the mouse is dragged outside its bounds.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `dx` | `number` | Horizontal mouse movement delta. |
| `dy` | `number` | Vertical mouse movement delta. |

### `PMUI.Slider:onMouseUp(x, y)`

Stops dragging the slider and plays the UI confirmation sound.
@return boolean|nil True when an active drag was completed.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.Slider:onMouseUpOutside(x, y)`

Stops dragging when the mouse button is released outside the slider.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.Slider:prerender()`

Renders the slider track, filled portion, and draggable thumb.

### `PMUI.Slider:SaveState(data)`

Saves the current slider value into the provided state table.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `data` | `table` | State table to populate. |

### `PMUI.Slider:LoadState(data)`

Restores the slider value from a previously saved state.
The change callback is triggered when the restored value differs from the current value.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `data` | `table` | State table containing the saved value. |

