require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/Slider"
require "ProjectMotionUI/Components/Dropdown"
require "ProjectMotionUI/Components/Checkbox"
require "ProjectMotionUI/Components/Shape"
require "ProjectMotionUI/Layouts/StackLayout"

local PONG_WIN_ID = "PMUI_Pong_Main"

function PMUI.OpenPingPongGame()
    if PMUI.GetInstance(PONG_WIN_ID) then
        PMUI.CloseInstance(PONG_WIN_ID)
        return
    end

    local theme = PMUI.GetTheme()
    local mainW, mainH = 440, 340
    local drawerW = 250

    local container = PMUI.Frame:new()
        :SetSize(mainW + drawerW + 8, mainH)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)

    local gameWin = PMUI.Window:new("PMUI ARCADE: PING-PONG", mainW, mainH)
        :SetPosition(0, 0)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, 0.96)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 1.0)
        :SetHeaderColor(theme.headerBg.r, theme.headerBg.g, theme.headerBg.b, 1.0)
        :OnClose(function()
            PMUI.CloseInstance(PONG_WIN_ID)
        end)
    gameWin.header:SetDraggable(true, container)
    container:AddChild(gameWin)

    local settingsDrawer = PMUI.Frame:new()
        :SetSize(drawerW, mainH)
        :SetPosition(mainW + 8, 0)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, 0.96)
        :SetBorderColor(theme.accent.r, theme.accent.g, theme.accent.b, 0.9)
        :SetPassThroughClicks(false)
    settingsDrawer:setVisible(false)
    container:AddChild(settingsDrawer)

    local drawerHeader = PMUI.Frame:new()
        :SetSizePercent(1.0, 0):SetSize(0, 36)
        :SetBackgroundColor(theme.headerBg.r, theme.headerBg.g, theme.headerBg.b, 1.0)
        :SetBorderColor(theme.accent.r, theme.accent.g, theme.accent.b, 0.9)
    settingsDrawer:AddChild(drawerHeader)
    drawerHeader:AddChild(
        PMUI.Label:new("GAME SETTINGS", UIFont.Small)
            :SetPosition(12, 10)
            :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    )

    local drawerBody = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, -36)
        :SetPosition(0, 36)
        :SetPadding(14)
        :SetGap(10)
    settingsDrawer:AddChild(drawerBody)

    local cfg = {
        speedMult = 1.0,
        paddleHeight = 58,
        paused = false
    }

    local playerScore, aiScore = 0, 0
    local scoreLabel = PMUI.Label:new("PLAYER: 0  |  CPU: 0", UIFont.Medium)
        :SetPosition(16, 12)
        :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
    gameWin.content:AddChild(scoreLabel)

    local isDrawerOpen = false
    local settingsBtn = PMUI.Button:new("Settings >")
        :SetSize(105, 28)
        :SetPosition(mainW - 121, 8)
        :OnClick(function(btn)
            isDrawerOpen = not isDrawerOpen
            if isDrawerOpen then
                btn:SetText("< Hide")
                settingsDrawer:setVisible(true)
                settingsDrawer.anim:FadeIn(0.2)
                settingsDrawer.anim:SlideIn("left", 30, 0.25)
            else
                btn:SetText("Settings >")
                settingsDrawer.anim:FadeOut(0.18, function()
                    settingsDrawer:setVisible(false)
                end)
            end
        end)
    gameWin.content:AddChild(settingsBtn)

    local arenaW, arenaH = mainW - 32, mainH - 92
    local arena = PMUI.Frame:new()
        :SetSize(arenaW, arenaH)
        :SetPosition(16, 42)
        :SetBackgroundColor(0.05, 0.06, 0.08, 1.0)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 0.8)
    gameWin.content:AddChild(arena)

    local net = PMUI.Frame:new()
        :SetSize(2, arenaH - 12)
        :SetPosition(arenaW / 2 - 1, 6)
        :SetBackgroundColor(1, 1, 1, 0.12)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(net)

    local paddleW = 10
    local playerY = (arenaH - cfg.paddleHeight) / 2
    local aiY = (arenaH - cfg.paddleHeight) / 2

    local playerPaddle = PMUI.Frame:new()
        :SetSize(paddleW, cfg.paddleHeight)
        :SetPosition(12, playerY)
        :SetBackgroundColor(0.30, 0.85, 0.50, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(playerPaddle)

    local aiPaddle = PMUI.Frame:new()
        :SetSize(paddleW, cfg.paddleHeight)
        :SetPosition(arenaW - 12 - paddleW, aiY)
        :SetBackgroundColor(0.90, 0.35, 0.35, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    arena:AddChild(aiPaddle)

    local ballSize = 14
    local ballX, ballY = arenaW / 2, arenaH / 2
    local ballVx, ballVy = 210, 135

    local ball = PMUI.Shape:new("circle")
        :SetSize(ballSize, ballSize)
        :SetPosition(ballX, ballY)
        :SetColor(1.0, 0.88, 0.25, 1.0)
    arena:AddChild(ball)

    local function ResetBall(dirX)
        ballX = arenaW / 2 - ballSize / 2
        ballY = arenaH / 2 - ballSize / 2
        ballVx = dirX * 210 * cfg.speedMult
        ballVy = (ZombRand(2) == 0 and -1 or 1) * (120 + ZombRand(70)) * cfg.speedMult
    end

    local speedLbl = PMUI.Label:new("Ball Speed: 1.0x", UIFont.Small)
    drawerBody:AddChild(speedLbl)

    drawerBody:AddChild(
        PMUI.Slider:new(0.5, 2.5, 0.1)
            :SetSize(drawerW - 28, 22)
            :SetValue(1.0, false)
            :SetPersistState(true, "pong_speed")
            :OnChange(function(val)
                cfg.speedMult = val
                speedLbl:SetText(string.format("Ball Speed: %.1fx", val))
            end)
    )

    local sizeLbl = PMUI.Label:new("Paddle Size: 58px", UIFont.Small)
    drawerBody:AddChild(sizeLbl)

    drawerBody:AddChild(
        PMUI.Slider:new(30, 110, 4)
            :SetSize(drawerW - 28, 22)
            :SetValue(58, false)
            :SetPersistState(true, "pong_paddle")
            :OnChange(function(val)
                cfg.paddleHeight = val
                sizeLbl:SetText("Paddle Size: " .. tostring(val) .. "px")
                playerPaddle:SetSize(paddleW, val)
                aiPaddle:SetSize(paddleW, val)
            end)
    )

    drawerBody:AddChild(
        PMUI.Label:new("Ball Color:", UIFont.Small)
    )
    drawerBody:AddChild(
        PMUI.Dropdown:new({ "Gold", "Cyan Neon", "Crimson" }, 1)
            :SetSize(drawerW - 28, 30)
            :SetPersistState(true, "pong_ball_color")
            :OnSelect(function(_, idx)
                if idx == 1 then ball:SetColor(1.0, 0.88, 0.25, 1.0)
                elseif idx == 2 then ball:SetColor(0.20, 0.90, 1.0, 1.0)
                else ball:SetColor(1.0, 0.25, 0.35, 1.0) end
            end)
    )

    drawerBody:AddChild(
        PMUI.Checkbox:new("Pause Game", false)
            :OnChange(function(checked)
                cfg.paused = checked
            end)
    )

    drawerBody:AddChild(
        PMUI.Button:new("Reset Score")
            :SetSize(drawerW - 28, 32)
            :OnClick(function()
                playerScore, aiScore = 0, 0
                scoreLabel:SetText("PLAYER: 0  |  CPU: 0")
                ResetBall(1)
            end)
    )

    local oldArenaPrerender = arena.prerender
    arena.prerender = function(selfArena)
        oldArenaPrerender(selfArena)
        if cfg.paused then return end

        local dt = UIManager.getMillisSinceLastRender() / 1000.0
        if dt > 0.05 then dt = 0.05 end

        if selfArena:isMouseOver() then
            local mouseLocalY = getMouseY() - selfArena:getAbsoluteY()
            playerY = math.max(4, math.min(arenaH - cfg.paddleHeight - 4, mouseLocalY - cfg.paddleHeight / 2))
            playerPaddle:SetPosition(12, playerY)
        end

        local aiCenter = aiY + cfg.paddleHeight / 2
        local ballCenter = ballY + ballSize / 2
        local aiSpeed = 165 * cfg.speedMult
        if aiCenter < ballCenter - 6 then aiY = aiY + aiSpeed * dt
        elseif aiCenter > ballCenter + 6 then aiY = aiY - aiSpeed * dt end
        aiY = math.max(4, math.min(arenaH - cfg.paddleHeight - 4, aiY))
        aiPaddle:SetPosition(arenaW - 12 - paddleW, aiY)

        ballX = ballX + ballVx * dt
        ballY = ballY + ballVy * dt

        if ballY <= 2 then
            ballY = 2
            ballVy = math.abs(ballVy)
        elseif ballY + ballSize >= arenaH - 2 then
            ballY = arenaH - 2 - ballSize
            ballVy = -math.abs(ballVy)
        end

        if ballVx < 0 and ballX <= 12 + paddleW and ballX + ballSize >= 12 then
            if ballY + ballSize >= playerY and ballY <= playerY + cfg.paddleHeight then
                ballX = 12 + paddleW
                ballVx = math.abs(ballVx) * 1.04
                playerPaddle.anim:Bounce(4, 0.15)
                if getSoundManager() then getSoundManager():playUISound("UIActivateButton") end
            end
        end

        local aiLeft = arenaW - 12 - paddleW
        if ballVx > 0 and ballX + ballSize >= aiLeft and ballX <= aiLeft + paddleW then
            if ballY + ballSize >= aiY and ballY <= aiY + cfg.paddleHeight then
                ballX = aiLeft - ballSize
                ballVx = -math.abs(ballVx) * 1.04
                aiPaddle.anim:Bounce(4, 0.15)
                if getSoundManager() then getSoundManager():playUISound("UIActivateButton") end
            end
        end
    if ballX < -ballSize then
        aiScore = aiScore + 1
        scoreLabel:SetText("PLAYER: " .. playerScore .. "  |  CPU: " .. aiScore)
        gameWin.anim:Shake(8, 0.3)
        ResetBall(1)
        elseif ballX > arenaW then
            playerScore = playerScore + 1
            scoreLabel:SetText("PLAYER: " .. playerScore .. "  |  CPU: " .. aiScore)
            gameWin.anim:Bounce(8, 0.25)
            ResetBall(-1)
        end
        ball:SetPosition(ballX, ballY)
    end
    PMUI.CreateInstance(PONG_WIN_ID, container, true)
    gameWin.anim:FadeIn(0.25)
end