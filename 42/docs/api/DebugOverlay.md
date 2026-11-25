# DebugOverlay

**Require path:** `require "ProjectMotionUI/Core/DebugOverlay"`

---

## Methods & Functions

### `PMUI.Debug.Toggle()`

Toggles the debug overlay state.

**Returns:** `boolean enabled The updated debug state.`

### `PMUI.Debug.SetEnabled(state)`

Sets the debug overlay state.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `state` | `boolean` | Whether debug rendering should be enabled. |

### `PMUI.Debug.DrawElementOverlay(el)`

Draws a debug overlay for a UI element.
Displays the element's bounds, padding, type, dimensions and hover state.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `el` | `ISUIElement` | The UI element to draw the overlay for. |

