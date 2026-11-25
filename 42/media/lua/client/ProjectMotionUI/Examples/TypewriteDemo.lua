require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Image"
require "ProjectMotionUI/Layouts/StackLayout"

local TYPEWRITER_ID = "PMUI_Demo_Typewriter"

local STORY_LINES = {
    {
        speaker = "RADIO OPERATOR",
        text = "Survivor, do you copy? Sector 4 perimeter is failing...",
        triggers = {}
    },
    {
        speaker = "RADIO OPERATOR",
        text = "WARNING! Horde detected near the main gate! Hold the line!",
        triggers = {
            ["WARNING!"] = function(win, lbl)
                win.anim:Shake(12, 0.45)
                lbl:SetColor(1.0, 0.35, 0.35, 1.0)
                PMUI.Notify("ALERT", "Horde proximity warning triggered!", "error", 2.5)
            end
        }
    },
    {
        speaker = "SYSTEM DIAGNOSTIC",
        text = "Signal interference... GLITCH detected in receiver module...",
        triggers = {
            ["GLITCH"] = function(win)
                win.anim:PlayEffect("Glitch", 0.5, { intensity = 16 })
            end
        }
    },
    {
        speaker = "RADIO OPERATOR",
        text = "Reinforcements arriving! Brace for IMPACT in 3... 2... 1!",
        triggers = {
            ["1"] = function(win)
                win.anim:Impulse(0, -450, 200, 8)
                if getSoundManager() then
                    getSoundManager():playUISound("UIActivateButton")
                end
            end
        }
    }
}

function PMUI.OpenTypewriterDemo()
    if PMUI.GetInstance(TYPEWRITER_ID) then
        PMUI.CloseInstance(TYPEWRITER_ID)
        return
    end

    local theme = PMUI.GetTheme()
    local win = PMUI.Window:new("EMERGENCY TRANSMISSION", 480, 220)
        :SetPositionPercent(0.5, 0.78)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, 0.96)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 1.0)

    local body = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(16)
        :SetGap(10)
    win.content:AddChild(body)

    local speakerLabel = PMUI.Label:new("", UIFont.Medium)
        :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    body:AddChild(speakerLabel)

    local textLabel = PMUI.Label:new("", UIFont.Small)
        :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
    body:AddChild(textLabel)

    local footer = PMUI.HBox:new()
        :SetPositionPercent(0, 1.0):SetPosition(16, -46)
        :SetGap(10)
        :SetAutoSize(true)
    win.content:AddChild(footer)

    local lineIndex = 1
    local charIndex = 0
    local charTimer = 0
    local charInterval = 0.035
    local isTyping = false
    local firedTriggers = {}

    local function StartLine(idx)
        lineIndex = idx
        local lineData = STORY_LINES[lineIndex]
        if not lineData then
            win:Close()
            return
        end

        speakerLabel:SetText("[" .. lineData.speaker .. "]")
        textLabel:SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
        textLabel:SetText("")
        charIndex = 0
        charTimer = 0
        isTyping = true
        firedTriggers = {}
    end

    local nextBtn = PMUI.Button:new("Next / Skip >>")
        :SetSize(140, 32)
        :OnClick(function()
            local lineData = STORY_LINES[lineIndex]
            if isTyping and lineData then
                charIndex = #lineData.text
                textLabel:SetText(lineData.text)
                isTyping = false
                for word, fn in pairs(lineData.triggers) do
                    if not firedTriggers[word] then
                        firedTriggers[word] = true
                        fn(win, textLabel)
                    end
                end
            else
                StartLine(lineIndex + 1)
            end
        end)
    footer:AddChild(nextBtn)

    local restartBtn = PMUI.Button:new("Restart")
        :SetSize(100, 32)
        :OnClick(function()
            StartLine(1)
        end)
    footer:AddChild(restartBtn)

    local oldPrerender = win.prerender
    win.prerender = function(selfWin)
        oldPrerender(selfWin)
        if not isTyping then return end

        local dt = UIManager.getMillisSinceLastRender() / 1000.0
        if dt > 0.1 then dt = 0.1 end

        charTimer = charTimer + dt
        local lineData = STORY_LINES[lineIndex]

        while charTimer >= charInterval and isTyping do
            charTimer = charTimer - charInterval
            charIndex = charIndex + 1

            if charIndex <= #lineData.text then
                local currentSubstr = string.sub(lineData.text, 1, charIndex)
                textLabel:SetText(currentSubstr)

                local lastChar = string.sub(currentSubstr, -1)
                if lastChar ~= " " and (charIndex % 2 == 0) and getSoundManager() then
                    getSoundManager():playUISound("UIToggleTick")
                end

                for triggerWord, triggerFn in pairs(lineData.triggers) do
                    if not firedTriggers[triggerWord] and string.find(currentSubstr, triggerWord, 1, true) then
                        firedTriggers[triggerWord] = true
                        triggerFn(win, textLabel)
                    end
                end
            else
                isTyping = false
            end
        end
    end

    PMUI.CreateInstance(TYPEWRITER_ID, win, true)
    win.anim:FadeIn(0.25)
    win.anim:SlideIn("bottom", 30, 0.3)
    StartLine(1)
end
