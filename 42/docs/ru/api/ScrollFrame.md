# ScrollFrame

**Путь подключения:** `require "ProjectMotionUI/Components/ScrollFrame"`

---

## Класс `PMUI.ScrollFrame`

*Наследуется от:* `PMUI.Frame`

## Методы и функции

### `PMUI.ScrollFrame:new()`

Creates a scrollable frame that clips its children to the visible area.

**Returns:** `PMUI.ScrollFrame`

### `PMUI.ScrollFrame:onMouseWheel(del)`

Handles mouse wheel input and updates the vertical scroll position.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `del` | `number` | Mouse wheel delta. |

**Returns:** `boolean Always returns true to indicate that the input was handled.`

### `PMUI.ScrollFrame:ClampScroll()`

Keeps the scroll position within the valid content boundaries.
Prevents scrolling above the beginning or below the end of the content.

### `PMUI.ScrollFrame:ApplyScrollOffset()`

Applies the current scroll offset to all direct child elements.
Child positions are updated without recalculating their layout.

### `PMUI.ScrollFrame:RecalculateLayout()`

Recalculates the frame layout and determines the maximum scroll distance.
The scrollable content height is based on the lowest child boundary.

### `PMUI.ScrollFrame:prerender()`

Sets the stencil clipping area to the frame's visible bounds.
Child elements rendered afterward are clipped to this rectangle.

### `PMUI.ScrollFrame:render()`

Renders the frame contents and its custom vertical scrollbar.
The scrollbar thumb size and position reflect the current scroll state.

