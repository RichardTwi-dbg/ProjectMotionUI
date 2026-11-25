PMUI = PMUI or {}
PMUI.Debug = PMUI.Debug or {}
PMUI.Debug.Enabled = false

--- Color palette used to distinguish UI element types in debug mode.
local TYPE_COLORS = {
    PMUI_VBox        = { r = 0.2, g = 0.9, b = 0.4 },
    PMUI_HBox        = { r = 0.2, g = 0.8, b = 0.9 },
    PMUI_StackLayout = { r = 0.2, g = 0.9, b = 0.6 },
    PMUI_Frame       = { r = 0.9, g = 0.7, b = 0.2 },
    PMUI_Window      = { r = 0.9, g = 0.7, b = 0.2 },
    PMUI_Button      = { r = 1.0, g = 0.3, b = 0.4 },
    PMUI_Label       = { r = 0.7, g = 0.4, b = 1.0 }, 
}

--- Toggles the debug overlay state.
---
--- @return boolean enabled The updated debug state.
function PMUI.Debug.Toggle()
    PMUI.Debug.Enabled = not PMUI.Debug.Enabled
    return PMUI.Debug.Enabled
end

--- Sets the debug overlay state.
---
--- @param state boolean Whether debug rendering should be enabled.
function PMUI.Debug.SetEnabled(state)
    PMUI.Debug.Enabled = state
end

--- Draws a debug overlay for a UI element.
--- Displays the element's bounds, padding, type, dimensions and hover state.
---
--- @param el ISUIElement The UI element to draw the overlay for.
function PMUI.Debug.DrawElementOverlay(el)
    if not el:isVisible() or el.alpha <= 0.05 then return end

    local w = el:getWidth()
    local h = el:getHeight()
    if w <= 1 or h <= 1 then return end

    local elType = el.Type or "PMUI_Element"
    local col = TYPE_COLORS[elType] or { r = 0.8, g = 0.8, b = 0.8 }
    local isHovered = el:isMouseOver()

    local borderAlpha = isHovered and 0.95 or 0.55
    el:drawRectBorder(0, 0, w, h, borderAlpha, col.r, col.g, col.b)

    if el.paddingLeft and (el.paddingLeft > 0 or el.paddingTop > 0) then
        local px = el.paddingLeft
        local py = el.paddingTop
        local pw = w - el.paddingLeft - (el.paddingRight or 0)
        local ph = h - el.paddingTop - (el.paddingBottom or 0)
        if pw > 0 and ph > 0 then
            el:drawRectBorder(px, py, pw, ph, 0.35, col.r, col.g, col.b)
        end
    end

    local labelText = string.format("%s (%dx%d)", elType:gsub("PMUI_", ""), w, h)
    local textW = getTextManager():MeasureStringX(UIFont.Small, labelText)
    local textH = getTextManager():MeasureStringY(UIFont.Small, labelText)

    el:drawRect(0, 0, textW + 6, textH + 2, isHovered and 0.85 or 0.55, 0.05, 0.06, 0.08)
    el:drawText(labelText, 3, 1, col.r, col.g, col.b, 0.95, UIFont.Small)

    if isHovered then
        el:drawRect(0, 0, w, h, 0.12, col.r, col.g, col.b)
    end
end

return PMUI.Debug