require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Core/Tooltip"
require "ProjectMotionUI/Core/DebugOverlay"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/Slider"
require "ProjectMotionUI/Components/Checkbox"
require "ProjectMotionUI/Components/Dropdown"
require "ProjectMotionUI/Layouts/StackLayout"
require "ProjectMotionUI/Layouts/GridLayout"

local LAUNCHER_ID = "PMUI_Studio_Launcher"
PMUI.DefaultCornerRadius = PMUI.DefaultCornerRadius or 8

local THEMES = { "Dark", "Zomboid", "Military" }

local function IsDebugMode()
    return (getDebug and getDebug()) or (PMUI.Debug and PMUI.Debug.Enabled)
end

function PMUI.OpenLauncher()
    if PMUI.GetInstance(LAUNCHER_ID) then
        PMUI.CloseInstance(LAUNCHER_ID)
        return
    end

    local isDebug = IsDebugMode()
    local theme = PMUI.GetTheme()

    local winHeight = isDebug and 460 or 250

    local win = PMUI.Window:new(isDebug and "PMUI STUDIO [DEBUG MODE]" or "PMUI SETTINGS", 440, winHeight)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, 0.97)
        :SetBorderColor(theme.accent.r, theme.accent.g, theme.accent.b, 0.95)
        :SetHeaderColor(theme.headerBg.r, theme.headerBg.g, theme.headerBg.b, 1.0)
        :SetCornerRadius(PMUI.DefaultCornerRadius)

    local body = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(18)
        :SetGap(10)
    win.content:AddChild(body)

    body:AddChild(
        PMUI.Label:new("GLOBAL FRAMEWORK SETTINGS", UIFont.Medium)
            :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    )

    local currentThemeIdx = 1
    for i, name in ipairs(THEMES) do
        if name == PMUI.CurrentThemeName then currentThemeIdx = i break end
    end

    local themeDropdown = PMUI.Dropdown:new(THEMES, currentThemeIdx)
        :SetSize(404, 32)
        :SetTooltip("UI Theme", "Changes color palette for all newly opened windows")
        :OnSelect(function(selectedTheme)
            PMUI.SetTheme(selectedTheme)
            PMUI.Notify("Theme Applied", "Switched to " .. selectedTheme .. " theme", "success", 2.0)
            PMUI.CloseInstance(LAUNCHER_ID)
            PMUI.OpenLauncher()
        end)
    body:AddChild(themeDropdown)

    local radiusLabel = PMUI.Label:new("Window Corner Radius: " .. tostring(PMUI.DefaultCornerRadius) .. "px", UIFont.Small)
        :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
    body:AddChild(radiusLabel)

    local radiusSlider = PMUI.Slider:new(0, 16, 2)
        :SetSize(404, 22)
        :SetValue(PMUI.DefaultCornerRadius, false)
        :SetTooltip("Corner Smoothing", "Adjusts procedural corner rounding radius in pixels")
        :OnChange(function(val)
            PMUI.DefaultCornerRadius = val
            radiusLabel:SetText("Window Corner Radius: " .. tostring(val) .. "px")
            win:SetCornerRadius(val)
        end)
    body:AddChild(radiusSlider)

    if not isDebug then
        body:AddChild(
            PMUI.Button:new("Reset Window Positions")
                :SetSize(404, 34)
                :SetTooltip("Reset Positions", "Restores default window coordinates")
                :OnClick(function()
                    PMUI.ResetSavedState()
                    PMUI.Notify("Reset Complete", "Saved window positions cleared", "info", 2.5)
                end)
        )
    end

    if isDebug then
        body:AddChild(
            PMUI.Checkbox:new("Show Layout Inspector Overlay (F8)", PMUI.Debug.Enabled)
                :SetTooltip("Visual Debugger", "Highlights VBox, HBox, Grid and Button boundaries")
                :OnChange(function(checked)
                    PMUI.Debug.SetEnabled(checked)
                end)
        )

        body:AddChild(
            PMUI.Label:new("DEBUG DEMOS & SANDBOXES", UIFont.Medium)
                :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
        )

        local demoGrid = PMUI.GridLayout:new(2, 198, 36)
            :SetPadding(0)
            :SetGap(8, 8)
        body:AddChild(demoGrid)

        demoGrid:AddChild(
            PMUI.Button:new("Physics & Controls (V)")
                :SetTooltip("Sandbox", "Test gravity throw, shatter FX, sliders and dropdowns")
                :OnClick(function()
                    if OpenPhysicsSandbox then OpenPhysicsSandbox()
                    else PMUI.Notify("Demo", "Press V to toggle Physics Sandbox", "info", 2.5) end
                end)
        )

        demoGrid:AddChild(
            PMUI.Button:new("Ping-Pong Arcade (P)")
                :SetTooltip("Mini-Game", "Arcade Ping-Pong with slide-out settings drawer")
                :OnClick(function()
                    if PMUI.OpenPingPongGame then PMUI.OpenPingPongGame() end
                end)
        )

        demoGrid:AddChild(
            PMUI.Button:new("Typewriter Story (N)")
                :SetTooltip("Dialogue FX", "Character-by-character text with keyword triggers")
                :OnClick(function()
                    if PMUI.OpenTypewriterDemo then PMUI.OpenTypewriterDemo() end
                end)
        )

        demoGrid:AddChild(
            PMUI.Button:new("Vehicle Speedo (M)")
                :SetTooltip("Telemetry HUD", "Vibration >60, Fire >100, Glitch >115, Boom at 120")
                :OnClick(function()
                    if PMUI.OpenSpeedometerDemo then PMUI.OpenSpeedometerDemo() end
                end)
        )

        demoGrid:AddChild(
            PMUI.Button:new("Test Notification")
                :SetTooltip("Toast System", "Spawns stacked sliding notifications")
                :OnClick(function()
                    local types = { "info", "success", "warning", "error" }
                    local t = types[ZombRand(#types) + 1]
                    PMUI.Notify("PMUI Studio", "Notification stack test (" .. t .. ")", t, 3.0)
                end)
        )

        demoGrid:AddChild(
            PMUI.Button:new("Reset All Windows")
                :SetTooltip("Reset State", "Closes all windows and resets saved positions")
                :SetColors(
                    { r = 0.48, g = 0.18, b = 0.20, a = 1.0 },
                    { r = 0.62, g = 0.24, b = 0.26, a = 1.0 },
                    { r = 0.35, g = 0.12, b = 0.14, a = 1.0 }
                )
                :OnClick(function()
                    PMUI.CloseAll()
                    PMUI.ResetSavedState()
                    PMUI.Notify("Reset Complete", "All saved positions & states cleared", "warning", 2.5)
                end)
        )
    end

    PMUI.CreateInstance(LAUNCHER_ID, win, true)
    win.anim:FadeIn(0.22)
    win.anim:SlideIn("top", 30, 0.28)
end

local function InjectMainMenuButton()
    if not MainScreen or not MainScreen.instance then return end
    local ms = MainScreen.instance
    if ms.pmuiLauncherBtn then return end

    local btnText = IsDebugMode() and "PMUI STUDIO" or "PMUI SETTINGS"
    local btnW, btnH = 170, 32
    local x = 24
    local y = getCore():getScreenHeight() - 95

    local btn = ISButton:new(x, y, btnW, btnH, btnText, ms, function()
        PMUI.OpenLauncher()
    end)
    btn:initialise()
    btn:instantiate()
    btn.borderColor = { r = 0.32, g = 0.65, b = 0.95, a = 0.9 }
    btn.backgroundColor = { r = 0.10, g = 0.12, b = 0.16, a = 0.92 }
    btn.backgroundColorMouseOver = { r = 0.18, g = 0.24, b = 0.34, a = 0.98 }
    btn.textColor = { r = 0.95, g = 0.97, b = 1.0, a = 1.0 }

    btn:setAnchorTop(false)
    btn:setAnchorBottom(true)

    ms:addChild(btn)
    ms.pmuiLauncherBtn = btn
end

if IsDebugMode() then
    Events.OnMainMenuEnter.Add(InjectMainMenuButton)
end

Events.OnKeyPressed.Add(function(key)
    if IsDebugMode() then
        if key == Keyboard.KEY_F7 then
            PMUI.OpenLauncher()
        elseif key == Keyboard.KEY_F8 then
            PMUI.Debug.Toggle()
        end
    end
end)
