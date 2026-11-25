# Tooltip
**Require path:** `require "ProjectMotionUI/Core/Tooltip"`

---
## Methods & Functions

### `PMUI.TooltipManager.UpdateForElement(el)`

Updates the global tooltip for the specified UI element.
Displays the tooltip when the element is hovered and hides it when
the mouse leaves the active target.

Tooltip content is read from the element's `_tooltipData` field:
`title` is optional, while `text` contains the description.
The tooltip is positioned near the mouse cursor and adjusted
to remain within the screen boundaries.


| Parameter | Type | Description |
| :--- | :--- | :--- |
| `el` | `ISUIElement` | UI element whose tooltip should be updated. |

