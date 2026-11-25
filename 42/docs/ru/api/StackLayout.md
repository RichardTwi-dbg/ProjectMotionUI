# StackLayout

**Путь подключения:** `require "ProjectMotionUI/Layouts/StackLayout"`

---

## Класс `PMUI.StackLayout`

*Наследуется от:* `PMUI.BaseElement`

## Методы и функции

### `PMUI.StackLayout:new(direction)`

Creates a stack layout container.
Children are arranged sequentially along the specified direction.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `direction` | `string\|nil` | Layout direction: "vertical" or "horizontal". Defaults to "vertical". |

**Returns:** `PMUI_StackLayout o The created layout container.`

### `PMUI.StackLayout:SetGap(gap)`

Sets the spacing between child elements.
Triggers an immediate layout recalculation.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `gap` | `number` | Spacing between adjacent children in pixels. |

**Returns:** `PMUI_StackLayout self`

### `PMUI.StackLayout:SetPadding(top, right, bottom, left)`

Sets the inner padding of the layout container.
Can accept either a single value for all sides or individual values.
Triggers an immediate layout recalculation.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `top` | `number` | Top padding, or uniform padding when used alone. |
| `right` | `number\|nil` | Right padding. If omitted, the top value is used for all sides. |
| `bottom` | `number\|nil` | Bottom padding. |
| `left` | `number\|nil` | Left padding. |

**Returns:** `PMUI_StackLayout self`

### `PMUI.StackLayout:SetAutoSize(enabled)`

Enables or disables automatic container sizing.
When enabled, the container adjusts its dimensions to fit its children and padding.
Triggers an immediate layout recalculation.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `enabled` | `boolean` | Whether automatic sizing should be enabled. |

**Returns:** `PMUI_StackLayout self`

### `PMUI.StackLayout:RecalculateLayout()`

Recalculates the positions of all child elements.
Children are arranged sequentially according to the layout direction,
with the configured gap and padding applied.
When auto sizing is enabled, the container dimensions are updated
to accommodate all children and their padding.

### `PMUI.VBox:new()`

### `PMUI.HBox:new()`

