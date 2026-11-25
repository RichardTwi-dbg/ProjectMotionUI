# Dropdown

**Путь подключения:** `require "ProjectMotionUI/Components/Dropdown"`

---

## Класс `PMUI.Dropdown`

*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.Dropdown:new(options, defaultIndex)`

Creates a new dropdown element with the provided options and initial selection.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `options` | `table\|nil` | List of available dropdown options. |
| `defaultIndex` | `number\|nil` | Index of the initially selected option. |

**Returns:** `PMUI.Dropdown`

### `PMUI.Dropdown:SetOptions(options, defaultIndex)`

Replaces the available options and resets the selected index.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `options` | `table\|nil` | List of options to display. |
| `defaultIndex` | `number\|nil` | Index of the option to select after updating the list. |

**Returns:** `PMUI.Dropdown`

### `PMUI.Dropdown:GetSelected()`

Returns the currently selected option and its index.

**Returns:** `any selectedOption Currently selected option, or nil if unavailable.`, `number selectedIndex Index of the selected option.`

### `PMUI.Dropdown:OnSelect(callback)`

Registers a callback invoked whenever an option is selected.
The callback receives the selected value, its index, and the dropdown instance.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `callback` | `function\|nil` | Function invoked after an option is selected. |

**Returns:** `PMUI.Dropdown`

### `PMUI.Dropdown:Toggle()`

Toggles the dropdown between expanded and collapsed states.
Updates the element height to accommodate the option list.
Brings the dropdown to the top of the UI hierarchy when expanded.

### `PMUI.Dropdown:onMouseDown(x, y)`

Handles mouse input for expanding the dropdown or selecting an option.
Clicking the header toggles the dropdown, while clicking an item updates the selection.
Plays the corresponding UI sound and invokes the selection callback when applicable.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `x` | `number` | Mouse X coordinate relative to the element. |
| `y` | `number` | Mouse Y coordinate relative to the element. |

**Returns:** `boolean Whether the mouse event was handled.`

### `PMUI.Dropdown:prerender()`

Renders the dropdown header and, when expanded, the available option list.
Highlights the header and individual options when hovered.
Marks the currently selected option with an accent indicator.

### `PMUI.Dropdown:SaveState(data)`

Saves the currently selected option index into the provided data table.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `data` | `table` | Table used to store the dropdown state. |

### `PMUI.Dropdown:LoadState(data)`

Restores the selected option from the provided data table.
Invokes the selection callback if the saved index matches an available option.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `data` | `table` | Table containing the previously saved dropdown state. |

