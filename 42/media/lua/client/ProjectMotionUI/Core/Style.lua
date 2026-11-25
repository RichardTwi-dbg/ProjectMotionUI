PMUI = PMUI or {}
PMUI.Styles = PMUI.Styles or {}

--- Registers a named style callback.
--- The callback is executed when the style is applied to a UI element.
---
--- @param styleName string Unique name of the style.
--- @param applyFn function Callback receiving the target element and optional parameters.
function PMUI.RegisterStyle(styleName, applyFn)
    if not styleName or type(applyFn) ~= "function" then
        print("[PMUI] Error: RegisterStyle requires styleName and function(el, params)")
        return
    end
    PMUI.Styles[styleName] = applyFn
end

--- Retrieves a registered style callback.
---
--- @param styleName string Name of the style to retrieve.
--- @return function|nil applyFn The registered callback, or nil if the style does not exist.
function PMUI.GetStyle(styleName)
    return PMUI.Styles[styleName]
end

--- Applies the DangerButton style.
--- Uses a dark red color palette and UI interaction sounds.
PMUI.RegisterStyle("DangerButton", function(btn)
    btn:SetColors(
        { r = 0.52, g = 0.18, b = 0.20, a = 1.0 },
        { r = 0.68, g = 0.24, b = 0.26, a = 1.0 },
        { r = 0.36, g = 0.12, b = 0.14, a = 1.0 }
    )
    btn:SetHoverSound("UIToggleTick")
    btn:SetClickSound("UIActivateButton")
end)

--- Applies the PrimaryButton style.
--- Uses the current theme's accent color to generate button states.
PMUI.RegisterStyle("PrimaryButton", function(btn)
    local theme = PMUI.GetTheme and PMUI.GetTheme()
    local ac = theme and theme.accent or { r = 0.28, g = 0.62, b = 0.92, a = 1.0 }
    btn:SetColors(
        { r = ac.r * 0.85, g = ac.g * 0.85, b = ac.b * 0.85, a = 1.0 },
        { r = ac.r, g = ac.g, b = ac.b, a = 1.0 },
        { r = ac.r * 0.65, g = ac.g * 0.65, b = ac.b * 0.65, a = 1.0 }
    )
    btn:SetHoverSound("UIToggleTick")
end)

--- Applies the GlassCard style.
--- Configures a translucent background, border and optional corner radius.
---
--- @param frame ISUIElement Target frame to style.
--- @param params table|nil Optional style parameters.
--- @param params.radius number|nil Custom corner radius.
PMUI.RegisterStyle("GlassCard", function(frame, params)
    local radius = (params and params.radius) or (PMUI.DefaultCornerRadius or 8)
    frame:SetBackgroundColor(0.08, 0.09, 0.12, 0.82)
    frame:SetBorderColor(0.35, 0.42, 0.55, 0.75)
    if frame.SetCornerRadius then
        frame:SetCornerRadius(radius)
    end
end)

return PMUI.Styles