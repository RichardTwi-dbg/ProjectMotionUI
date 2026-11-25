# TextInput
**Require path:** `require "ProjectMotionUI/Components/TextInput"`

---
## Class `PMUI.TextInput`
*Inherits from:* `PMUI.BaseElement`

## Methods & Functions

### `PMUI.TextInput:new(placeholder)`

Creates a text input field with an optional placeholder.
@return PMUI.TextInput

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['placeholder', 'string|nil', 'Text displayed when the input is empty and unfocused.']` | `['placeholder', 'string|nil', 'Text displayed when the input is empty and unfocused.']` | ['placeholder', 'string|nil', 'Text displayed when the input is empty and unfocused.'] |

### `PMUI.TextInput:instantiate()`

Initializes the base element and its native text entry control.
Adds the input control as a child and synchronizes its dimensions.

### `PMUI.TextInput:SyncEntrySize()`

Synchronizes the native text entry dimensions with the parent element.
Updates both the Lua control and its Java UI object when available.

### `PMUI.TextInput:RecalculateLayout()`

Recalculates the element layout and updates the native input dimensions.

### `PMUI.TextInput:GetText()`

Returns the current text entered by the user.
@return string

### `PMUI.TextInput:SetText(text)`

Sets the text displayed in the input field.
@return PMUI.TextInput

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['text', 'string|nil', 'Text to assign. Nil is treated as an empty string.']` | `['text', 'string|nil', 'Text to assign. Nil is treated as an empty string.']` | ['text', 'string|nil', 'Text to assign. Nil is treated as an empty string.'] |

### `PMUI.TextInput:OnChange(callback)`

Registers a callback invoked whenever the input text changes.
The callback receives the current text and the TextInput instance.
@return PMUI.TextInput

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['callback', 'function|nil', 'Text change callback.']` | `['callback', 'function|nil', 'Text change callback.']` | ['callback', 'function|nil', 'Text change callback.'] |

### `PMUI.TextInput:render()`

Renders the native input control and its placeholder when applicable.
The placeholder is hidden while the field is focused or contains text.

### `PMUI.TextInput:SaveState(data)`

Saves the current input text into the provided state table.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['data', 'table', 'State table to populate.']` | `['data', 'table', 'State table to populate.']` | ['data', 'table', 'State table to populate.'] |

### `PMUI.TextInput:LoadState(data)`

Restores the input text from a previously saved state.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `['data', 'table', 'State table containing the saved text.']` | `['data', 'table', 'State table containing the saved text.']` | ['data', 'table', 'State table containing the saved text.'] |

