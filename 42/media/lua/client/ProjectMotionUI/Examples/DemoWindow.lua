require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Core/DebugOverlay"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/ProgressBar"
require "ProjectMotionUI/Components/Slider"
require "ProjectMotionUI/Components/Checkbox"
require "ProjectMotionUI/Components/Dropdown"
require "ProjectMotionUI/Components/Tabs"
require "ProjectMotionUI/Components/Shape"
require "ProjectMotionUI/Layouts/StackLayout"

local CONTROL_ID = "PMUI_Demo_Controls"
local TARGET_ID  = "PMUI_Demo_Target"

local function SpawnTargetWindow()
    local theme = PMUI.GetTheme()

    local targetWin = PMUI.Window:new("PMUI PLAYGROUND & PING-PONG", 420, 390)
        :SetPositionPercent(0.66, 0.48)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, theme.windowBg.a)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 1.0)
        :SetHeaderColor(theme.headerBg.r, theme.headerBg.g, theme.headerBg.b, 1.0)

    local tabs = PMUI.Tabs:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
    targetWin.content:AddChild(tabs)

    local controlsTab = tabs:AddTab("Controls & Physics")
    local pongTab     = tabs:AddTab("Play Ping-Pong!")

    local body = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(16)
        :SetGap(10)
    controlsTab:AddChild(body)

    local gravityCheck = PMUI.Checkbox:new("Enable Gravity (Grab header & THROW me!)", false)
        :OnChange(function(checked)
            targetWin:SetGravity(checked)
            PMUI.Notify(
                "Physics Mode",
                checked and "Flick the window header with your mouse!" or "Gravity disabled.",
                checked and "warning" or "info",
                2.5
            )
        end)
    body:AddChild(gravityCheck)

    local progressLabel = PMUI.Label:new("Shield Charge: 60%", UIFont.Small)
        :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
    body:AddChild(progressLabel)

    local progressBar = PMUI.ProgressBar:new(0, 100)
        :SetSize(388, 22)
        :SetValue(60, true)
    body:AddChild(progressBar)

    local slider = PMUI.Slider:new(0, 100, 5)
        :SetSize(388, 22)
        :SetValue(60, false)
        :OnChange(function(val)
            progressLabel:SetText("Shield Charge: " .. tostring(val) .. "%")
            progressBar:SetValue(val, false)
        end)
    body:AddChild(slider)

    body:AddChild(
        PMUI.Label:new("Ping-Pong Ball Speed (Dropdown):", UIFont.Small)
            :SetColor(theme.textSecondary.r, theme.textSecondary.g, theme.textSecondary.b, 1.0)
    )

    local ballSpeedMultiplier = 1.0
    local speedDropdown = PMUI.Dropdown:new({ "Casual (1.0x)", "Fast (1.4x)", "Insane (1.9x)" }, 1)
        :SetSize(388, 32)
        :OnSelect(function(opt, idx)
            if idx == 1 then ballSpeedMultiplier = 1.0
            elseif idx == 2 then ballSpeedMultiplier = 1.4
            else ballSpeedMultiplier = 1.9 end
            PMUI.Notify("Difficulty Set", "Selected: " .. opt, "info", 2.0)
        end)
    body:AddChild(speedDropdown)

    body:AddChild(
        PMUI.Button:new("Shatter This Window!")
            :SetSize(388, 36)
            :SetColors(
                { r = 0.52, g = 0.20, b = 0.20, a = 1.0 },
                { r = 0.68, g = 0.25, b = 0.25, a = 1.0 },
                { r = 0.38, g = 0.14, b = 0.14, a = 1.0 }
            )
            :OnClick(function()
                targetWin.anim:Shatter(5, 4, 520, function()
                    PMUI.CloseInstance(TARGET_ID)
                end)
            end)
    )

    local arenaW, arenaH = 388, 250
    local arena = PMUI.Frame:new()
        :SetSize(arenaW, arenaH)
        :SetPosition(16, 44)
        :SetBackgroundColor(0.06, 0.07, 0.09, 1.0)
        :SetBorderColor(theme.accent.r, theme.accent.g, theme.accent.b, 0.8)
        :SetPassThroughClicks(false)
    pongTab:AddChild(arena)

    local net = PMUI.Frame:new()
        :SetSize(2, arenaH - 16)
        :SetPosition(arenaW / 2 - 1, 8)
        :SetBackgroundColor(1, 1, 1, 0.15)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(net)

    local playerScore, aiScore = 0, 0
    local scoreLabel = PMUI.Label:new("PLAYER: 0   |   CPU: 0", UIFont.Medium)
        :SetPosition(16, 12)
        :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    pongTab:AddChild(scoreLabel)

    local paddleW, paddleH = 10, 56
    local playerY = (arenaH - paddleH) / 2
    local aiY     = (arenaH - paddleH) / 2

    local playerPaddle = PMUI.Frame:new()
        :SetSize(paddleW, paddleH)
        :SetPosition(12, playerY)
        :SetBackgroundColor(0.30, 0.85, 0.50, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(playerPaddle)

    local aiPaddle = PMUI.Frame:new()
        :SetSize(paddleW, paddleH)
        :SetPosition(arenaW - 12 - paddleW, aiY)
        :SetBackgroundColor(0.90, 0.35, 0.35, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(aiPaddle)

    local ballSize = 14
    local ballX = arenaW / 2 - ballSize / 2
    local ballY = arenaH / 2 - ballSize / 2
    local ballVx = 210
    local ballVy = 140

    local ball = PMUI.Shape:new("circle")
        :SetSize(ballSize, ballSize)
        :SetPosition(ballX, ballY)
        :SetColor(1.0, 0.90, 0.30, 1.0)
    arena:AddChild(ball)

    local function ResetBall(dirX)
        ballX = arenaW / 2 - ballSize / 2
        ballY = arenaH / 2 - ballSize / 2
        local speed = 210 * ballSpeedMultiplier
        ballVx = dirX * speed
        ballVy = (ZombRand(2) == 0 and -1 or 1) * (110 + ZombRand(80)) * ballSpeedMultiplier
    end

    local oldArenaPrerender = arena.prerender
    arena.prerender = function(selfArena)
        oldArenaPrerender(selfArena)
        if not pongTab:isVisible() then return end

        local dt = UIManager.getMillisSinceLastRender() / 1000.0
        if dt > 0.05 then dt = 0.05 end

        local mouseLocalY = getMouseY() - selfArena:getAbsoluteY()
        if selfArena:isMouseOver() then
            playerY = math.max(4, math.min(arenaH - paddleH - 4, mouseLocalY - paddleH / 2))
            playerPaddle:SetPosition(12, playerY)
        end

        local aiCenter = aiY + paddleH / 2
        local ballCenter = ballY + ballSize / 2
        local aiSpeed = 165 * ballSpeedMultiplier
        if aiCenter < ballCenter - 6 then
            aiY = aiY + aiSpeed * dt
        elseif aiCenter > ballCenter + 6 then
            aiY = aiY - aiSpeed * dt
        end
        aiY = math.max(4, math.min(arenaH - paddleH - 4, aiY))
        aiPaddle:SetPosition(arenaW - 12 - paddleW, aiY)

        ballX = ballX + ballVx * dt
        ballY = ballY + ballVy * dt

        if ballY <= 2 then
            ballY = 2
            ballVy = math.abs(ballVy)
            if getSoundManager() then getSoundManager():playUISound("UIToggleTick") end
        elseif ballY + ballSize >= arenaH - 2 then
            ballY = arenaH - 2 - ballSize
            ballVy = -math.abs(ballVy)
            if getSoundManager() then getSoundManager():playUISound("UIToggleTick") end
        end

        if ballVx < 0 and ballX <= 12 + paddleW and ballX + ballSize >= 12 then
            if ballY + ballSize >= playerY and ballY <= playerY + paddleH then
                ballX = 12 + paddleW
                ballVx = math.abs(ballVx) * 1.05
                local hitOffset = ((ballY + ballSize / 2) - (playerY + paddleH / 2)) / (paddleH / 2)
                ballVy = ballVy + hitOffset * 140
                playerPaddle.anim:Bounce(4, 0.15)
                if getSoundManager() then getSoundManager():playUISound("UIActivateButton") end
            end
        end

        local aiLeft = arenaW - 12 - paddleW
        if ballVx > 0 and ballX + ballSize >= aiLeft and ballX <= aiLeft + paddleW then
            if ballY + ballSize >= aiY and ballY <= aiY + paddleH then
                ballX = aiLeft - ballSize
                ballVx = -math.abs(ballVx) * 1.05
                aiPaddle.anim:Bounce(4, 0.15)
                if getSoundManager() then getSoundManager():playUISound("UIActivateButton") end
            end
        end

        if ballX < -ballSize then
            aiScore = aiScore + 1
            scoreLabel:SetText("PLAYER: " .. playerScore .. "   |   CPU: " .. aiScore)
            targetWin.anim:Shake(8, 0.3)
            ResetBall(1)
        elseif ballX > arenaW then
            playerScore = playerScore + 1
            scoreLabel:SetText("PLAYER: " .. playerScore .. "   |   CPU: " .. aiScore)
            targetWin.anim:Bounce(8, 0.25)
            PMUI.Notify("GOAL!", "You scored! Score: " .. playerScore .. " - " .. aiScore, "success", 2.0)
            ResetBall(-1)
        end
        ball:SetPosition(ballX, ballY)
    end

    PMUI.CreateInstance(TARGET_ID, targetWin)
    targetWin.anim:FadeIn(0.25)
    targetWin.anim:SlideIn("right", 40, 0.3)
end

local function OpenPhysicsSandbox()
    if PMUI.GetInstance(CONTROL_ID) or PMUI.GetInstance(TARGET_ID) then
        PMUI.CloseInstance(CONTROL_ID)
        PMUI.CloseInstance(TARGET_ID)
        return
    end

    SpawnTargetWindow()

    local theme = PMUI.GetTheme()
    local controlWin = PMUI.Window:new("PMUI CONTROLLER", 320, 260)
        :SetPositionPercent(0.24, 0.48)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, theme.windowBg.a)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 1.0)
        :SetHeaderColor(theme.headerBg.r, theme.headerBg.g, theme.headerBg.b, 1.0)

    local controlsBox = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(16)
        :SetGap(10)

    controlWin.content:AddChild(controlsBox)
    controlsBox:AddChild(
        PMUI.Button:new("Respawn Playground Window")
            :SetSize(288, 38)
            :OnClick(function()
                SpawnTargetWindow()
            end)
        )

    controlsBox:AddChild(
        PMUI.Button:new("Spawn Toast Notification")
            :SetSize(288, 38)
            :OnClick(function()
                local types = { "info", "success", "warning", "error" }
                local t = types[ZombRand(#types) + 1]
                PMUI.Notify("PMUI Toast (" .. t .. ")", "Click to dismiss early!", t, 3.5)
            end)
        )

    local debugBtn = PMUI.Button:new(PMUI.Debug.Enabled and "Layout Debug: ON (F8)" or "Layout Debug: OFF (F8)")
        :SetSize(288, 38)
        :OnClick(function(btn)
            local state = PMUI.Debug.Toggle()
            btn:SetText(state and "Layout Debug: ON (F8)" or "Layout Debug: OFF (F8)")
        end)

    controlsBox:AddChild(debugBtn)
    PMUI.CreateInstance(CONTROL_ID, controlWin)
    controlWin.anim:FadeIn(0.25)
    controlWin.anim:SlideIn("left", 40, 0.3)
end

Events.OnKeyPressed.Add(onKeyPressed)