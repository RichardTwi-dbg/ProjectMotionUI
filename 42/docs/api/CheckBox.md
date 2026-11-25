# CheckBox

**Require path:** `require "ProjectMotionUI/Components/CheckBox"`

---

## Class `PMUI.Checkbox`

*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.Checkbox:new(labelText, initialState)`

Creates a new checkbox element with the specified label and initial state.
@return PMUI.Checkbox

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `labelText` | `string|nil` | Text displayed next to the checkbox. |
| `initialState` | `boolean|nil` | Whether the checkbox is initially checked. |

### `PMUI.Checkbox:SetChecked(state, triggerCallback)`

Sets the checkbox state and optionally notifies the change callback.
@return PMUI.Checkbox

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `state` | `boolean` | New checked state. |
| `triggerCallback` | `boolean|nil` | Whether to invoke the registered callback. |

### `PMUI.Checkbox:IsChecked()`

Returns whether the checkbox is currently checked.
@return boolean

### `PMUI.Checkbox:OnChange(callback)`

Registers a callback invoked whenever the checkbox state changes through a notified update.
The callback receives the new state and the checkbox instance.
@return PMUI.Checkbox

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `callback` | `function|nil` | Function invoked after a state change. |

### `PMUI.Checkbox:onMouseUp(x, y)`

Handles mouse release and toggles the checkbox if the pointer is over the element.
Triggers the change callback, plays the toggle sound, and applies a bounce animation.
@return boolean Whether the mouse event was handled.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

### `PMUI.Checkbox:prerender()`

Renders the checkbox background, border, check indicator, and optional label.
The check indicator is displayed only when the checkbox is checked.

### `PMUI.Checkbox:SaveState(data)`

Saves the current checkbox state into the provided data table.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `data` | `table` | Table used to store the checkbox state. |

### `PMUI.Checkbox:LoadState(data)`

Restores the checkbox state from the provided data table.
Invokes the change callback if a saved state is available.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `data` | `table` | Table containing the previously saved checkbox state. |

