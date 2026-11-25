# Tabs
**Путь подключения:** `require "ProjectMotionUI/Components/Tabs"`

---
## Класс `PMUI.Tabs`
*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.Tabs:new()`

Creates a tab container with a tab bar and a content area.
@return PMUI.Tabs

### `PMUI.Tabs:AddTab(title)`

Adds a new tab and returns its content container.
The first tab added is automatically selected.
@return PMUI.Frame Content container associated with the new tab.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['title', 'string', 'Text displayed on the tab button.']` | `['title', 'string', 'Text displayed on the tab button.']` | ['title', 'string', 'Text displayed on the tab button.'] |

### `PMUI.Tabs:UpdateTabButtonsLayout()`

Recalculates tab button positions and widths.
All buttons share the available tab bar width equally.

### `PMUI.Tabs:SelectTab(index, instant)`

Activates the specified tab and updates the visibility and appearance of all tabs.
The selected tab can optionally skip its fade-in animation.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['index', 'number', 'Index of the tab to activate.']` | `['index', 'number', 'Index of the tab to activate.']` | ['index', 'number', 'Index of the tab to activate.'] |
| `['instant', 'boolean|nil', 'If true, switches without playing the fade-in animation.']` | `['instant', 'boolean|nil', 'If true, switches without playing the fade-in animation.']` | ['instant', 'boolean|nil', 'If true, switches without playing the fade-in animation.'] |

### `PMUI.Tabs:OnTabChange(callback)`

Registers a callback invoked whenever the active tab changes.
The callback receives the selected tab index and its tab data.
@return PMUI.Tabs

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['callback', 'function|nil', 'Tab change callback.']` | `['callback', 'function|nil', 'Tab change callback.']` | ['callback', 'function|nil', 'Tab change callback.'] |

### `PMUI.Tabs:SaveState(data)`

Saves the currently active tab index into the provided state table.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['data', 'table', 'State table to populate.']` | `['data', 'table', 'State table to populate.']` | ['data', 'table', 'State table to populate.'] |

### `PMUI.Tabs:LoadState(data)`

Restores the active tab from a previously saved state.
Invalid or out-of-range indices are ignored.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `['data', 'table', 'State table containing the saved active index.']` | `['data', 'table', 'State table containing the saved active index.']` | ['data', 'table', 'State table containing the saved active index.'] |

