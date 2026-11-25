PMUI = PMUI or {}

--- Available UI theme palettes.
--- Each theme defines colors for windows, buttons, text, inputs and accents.
PMUI.Themes = {
    Dark = {
        windowBg      = { r = 0.11, g = 0.12, b = 0.15, a = 0.96 },
        windowBorder  = { r = 0.32, g = 0.38, b = 0.48, a = 1.0 },
        headerBg      = { r = 0.17, g = 0.20, b = 0.26, a = 1.0 },
        btnNormal     = { r = 0.22, g = 0.25, b = 0.31, a = 1.0 },
        btnHover      = { r = 0.30, g = 0.35, b = 0.44, a = 1.0 },
        btnPressed    = { r = 0.15, g = 0.17, b = 0.22, a = 1.0 },
        accent        = { r = 0.28, g = 0.62, b = 0.92, a = 1.0 },
        textPrimary   = { r = 0.95, g = 0.96, b = 0.98, a = 1.0 },
        textSecondary = { r = 0.72, g = 0.76, b = 0.84, a = 1.0 },
        inputBg       = { r = 0.08, g = 0.09, b = 0.11, a = 0.95 }
    },
    Zomboid = {
        windowBg      = { r = 0.09, g = 0.09, b = 0.09, a = 0.96 },
        windowBorder  = { r = 0.85, g = 0.45, b = 0.12, a = 1.0 },
        headerBg      = { r = 0.16, g = 0.12, b = 0.09, a = 1.0 },
        btnNormal     = { r = 0.20, g = 0.16, b = 0.13, a = 1.0 },
        btnHover      = { r = 0.85, g = 0.45, b = 0.12, a = 0.90 },
        btnPressed    = { r = 0.60, g = 0.30, b = 0.08, a = 1.0 },
        accent        = { r = 0.92, g = 0.48, b = 0.12, a = 1.0 },
        textPrimary   = { r = 0.96, g = 0.94, b = 0.90, a = 1.0 },
        textSecondary = { r = 0.78, g = 0.74, b = 0.68, a = 1.0 },
        inputBg       = { r = 0.05, g = 0.05, b = 0.05, a = 0.95 }
    },
    Military = {
        windowBg      = { r = 0.10, g = 0.12, b = 0.10, a = 0.96 },
        windowBorder  = { r = 0.36, g = 0.48, b = 0.34, a = 1.0 },
        headerBg      = { r = 0.16, g = 0.22, b = 0.16, a = 1.0 },
        btnNormal     = { r = 0.20, g = 0.27, b = 0.20, a = 1.0 },
        btnHover      = { r = 0.28, g = 0.38, b = 0.27, a = 1.0 },
        btnPressed    = { r = 0.14, g = 0.19, b = 0.14, a = 1.0 },
        accent        = { r = 0.42, g = 0.76, b = 0.38, a = 1.0 },
        textPrimary   = { r = 0.92, g = 0.96, b = 0.91, a = 1.0 },
        textSecondary = { r = 0.70, g = 0.78, b = 0.69, a = 1.0 },
        inputBg       = { r = 0.07, g = 0.08, b = 0.07, a = 0.95 }
    }
}

--- Name of the currently active theme.
PMUI.CurrentThemeName = "Dark"

--- Sets the active theme if the specified theme exists.
---
--- @param themeName string Name of the theme to activate.
function PMUI.SetTheme(themeName)
    if PMUI.Themes[themeName] then
        PMUI.CurrentThemeName = themeName
    end
end

--- Returns the palette of the currently active theme.
--- Falls back to the Dark theme if the active theme is unavailable.
---
--- @return table theme The active theme color palette.
function PMUI.GetTheme()
    return PMUI.Themes[PMUI.CurrentThemeName] or PMUI.Themes.Dark
end

--- Registers a custom theme palette.
---
--- @param name string Name used to identify the theme.
--- @param palette table Theme palette containing the required color definitions.
function PMUI.RegisterTheme(name, palette)
    PMUI.Themes[name] = palette
end

return PMUI.Themes