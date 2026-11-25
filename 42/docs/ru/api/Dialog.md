# Dialog

**Путь подключения:** `require "ProjectMotionUI/Components/Dialog"`

---

## Класс `PMUI.Dialog`

*Наследуется от:* `PMUI.Frame`

## Методы и функции

### `PMUI.Dialog:new(title, message)`

Creates a new modal dialog with a title, message, and centered content panel.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `title` | `string\|nil` | Dialog title displayed in the header. |
| `message` | `string\|nil` | Message displayed inside the dialog. |

**Returns:** `PMUI.Dialog`

### `PMUI.Dialog:AddButton(text, callback)`

Creates and adds a button to the dialog.
Buttons are automatically distributed horizontally across the bottom of the panel.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `text` | `string` | Button label. |
| `callback` | `function\|nil` | Function invoked when the button is clicked. |

**Returns:** `PMUI.Dialog`

