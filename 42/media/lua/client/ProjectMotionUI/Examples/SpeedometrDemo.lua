require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Core/Tooltip"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/ProgressBar"
require "ProjectMotionUI/Components/Slider"
require "ProjectMotionUI/Components/Checkbox"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Layouts/StackLayout"
require "ProjectMotionUI/Layouts/GridLayout"

local SPEEDO_ID = "PMUI_Demo_Speedometer"

local function SpawnFireParticle(parentContainer, intensityRatio)
    local pw = parentContainer:getWidth()
    local ph = parentContainer:getHeight()
    if pw <= 10 or ph <= 10 then return end

    local size = 8 + ZombRand(12)
    local startX = ZombRand(math.max(1, pw - size))
    local startY = ph - size - ZombRand(10)

    local r = 1.0
    local g = 0.25 + (ZombRand(60) / 100.0)
    local b = 0.05

    local flame = PMUI.Frame:new()
        :SetSize(size, size)
        :SetPosition(startX, startY)
        :SetBackgroundColor(r, g, b, 0.85)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    parentContainer:AddChild(flame)

    local riseSpeed = 55 + ZombRand(65) + (intensityRatio * 40)
    local driftX = (ZombRand(40) - 20)
    local lifeTime = 0.45 + (ZombRand(30) / 100.0)

    flame.anim.effects["fire_rise"] = {
        elapsed = 0,
        duration = lifeTime,
        customUpdate = function(p, dt)
            local progress = p.anim.effects["fire_rise"].elapsed / lifeTime
            p.animOffsetY = p.animOffsetY - riseSpeed * dt
            p.animOffsetX = p.animOffsetX + driftX * dt
            p.alpha = math.max(0, 0.85 * (1.0 - progress))
            return false
        end,
        finish = function(p)
            p:setVisible(false)
            parentContainer:removeChild(p)
        end
    }
end

function PMUI.OpenSpeedometerDemo()
    if PMUI.GetInstance(SPEEDO_ID) then
        PMUI.CloseInstance(SPEEDO_ID)
        return
    end

    local theme = PMUI.GetTheme()
    local speedoWin = PMUI.Window:new("VEHICLE TELEMETRY & SPEEDO", 360, 325)
        :SetPositionPercent(0.5, 0.72)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.08, 0.09, 0.11, 0.96)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 1.0)

    local fireLayer = PMUI.Frame:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    speedoWin.content:AddChild(fireLayer)

    local body = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(16)
        :SetGap(8)
    speedoWin.content:AddChild(body)

    local topRow = PMUI.HBox:new():SetGap(10):SetAutoSize(true)
    body:AddChild(topRow)

    local speedDigits = PMUI.Label:new("0 KM/H", UIFont.Large)
        :SetColor(0.30, 0.85, 0.55, 1.0)
    topRow:AddChild(speedDigits)

    local statusLabel = PMUI.Label:new("[SAFE]", UIFont.Small)
        :SetColor(0.65, 0.75, 0.80, 1.0)
    topRow:AddChild(statusLabel)

    local speedBar = PMUI.ProgressBar:new(0, 120)
        :SetSize(328, 24)
        :SetValue(0, true)
        :SetShowText(true, "0 / 120 KM/H")
        :SetTooltip("Speedometer Gauge", ">60: Vibration | >100: Fire | >115 (5s): Glitch | 120 (100s): BOOM!")
    body:AddChild(speedBar)

    local overheatLabel = PMUI.Label:new("Engine Stress (120 km/h): 0.0 / 100.0s", UIFont.Small)
        :SetColor(0.75, 0.78, 0.82, 1.0)
    body:AddChild(overheatLabel)

    local currentSpeed = 0
    local syncWithCar = false
    local highSpeedTimer = 0
    local criticalTimer = 0
    local glitchCooldown = 0
    local fireSpawnTimer = 0
    local isExploded = false

    local speedSlider = PMUI.Slider:new(0, 120, 1)
        :SetSize(328, 22)
        :SetValue(0, false)
        :SetTooltip("Manual Throttle", "Drag to test speed thresholds (60, 100, 115, 120)")
        :OnChange(function(val)
            syncWithCar = false
            currentSpeed = val
        end)
    body:AddChild(speedSlider)

    body:AddChild(
        PMUI.Checkbox:new("Sync with Player Vehicle", false)
            :SetTooltip("Vehicle Sync", "Reads real speed from your current car in Project Zomboid")
            :OnChange(function(checked)
                syncWithCar = checked
            end)
    )

    local btnGrid = PMUI.GridLayout:new(2, 160, 30)
        :SetPadding(0)
        :SetGap(8, 6)
    body:AddChild(btnGrid)

    btnGrid:AddChild(
        PMUI.Button:new("Cruise (55)")
            :SetTooltip("Safe Speed", "No vibration, engine cools down")
            :OnClick(function() syncWithCar = false; speedSlider:SetValue(55, true) end)
    )
    btnGrid:AddChild(
        PMUI.Button:new("Fire Zone (108)")
            :SetTooltip("Fire Threshold (>100)", "Spawns fire particles & strong shake")
            :OnClick(function() syncWithCar = false; speedSlider:SetValue(108, true) end)
    )
    btnGrid:AddChild(
        PMUI.Button:new("Max 120 (Glitch)")
            :SetTooltip("Critical Speed (120)", "Triggers Glitch after 5s, explodes at 100s")
            :OnClick(function() syncWithCar = false; speedSlider:SetValue(120, true) end)
    )
    btnGrid:AddChild(
        PMUI.Button:new("Fast-Forward 96s")
            :SetTooltip("Debug Overheat", "Sets 120 km/h timer to 96/100s so you can see the explosion in 4 seconds!")
            :SetColors(
                { r = 0.52, g = 0.20, b = 0.20, a = 1.0 },
                { r = 0.68, g = 0.25, b = 0.25, a = 1.0 },
                { r = 0.38, g = 0.14, b = 0.14, a = 1.0 }
            )
            :OnClick(function()
                syncWithCar = false
                speedSlider:SetValue(120, true)
                highSpeedTimer = 6.0
                criticalTimer = 96.0
                PMUI.Notify("CRITICAL WARNING", "4 seconds until speedometer detonation!", "error", 3.0)
            end)
    )

    local oldPrerender = speedoWin.prerender
    speedoWin.prerender = function(selfWin)
        if isExploded then
            oldPrerender(selfWin)
            return
        end

        local dt = UIManager.getMillisSinceLastRender() / 1000.0
        if dt > 0.1 then dt = 0.1 end

        if syncWithCar then
            local player = getSpecificPlayer(0)
            local vehicle = player and player:getVehicle()
            if vehicle then
                currentSpeed = math.min(120, math.floor(math.abs(vehicle:getCurrentSpeedKmHour())))
                speedSlider:SetValue(currentSpeed, false)
            else
                currentSpeed = 0
            end
        end

        speedDigits:SetText(tostring(currentSpeed) .. " KM/H")
        speedBar:SetValue(currentSpeed, true)
        speedBar:SetShowText(true, tostring(currentSpeed) .. " / 120 KM/H")

        if currentSpeed > 60 then
            local intensityRatio = math.min(1.0, (currentSpeed - 60) / 60.0)
            local maxShakePx = 11.0 * intensityRatio

            selfWin.animOffsetX = (ZombRand(200) / 100.0 - 1.0) * maxShakePx
            selfWin.animOffsetY = (ZombRand(200) / 100.0 - 1.0) * (maxShakePx * 0.75)
            selfWin:ApplyPositionOnly()

            local r = 1.0
            local g = math.max(0.15, 0.85 * (1.0 - intensityRatio))
            local b = 0.15
            speedDigits:SetColor(r, g, b, 1.0)
            speedBar:SetFillColor(r, g, b, 1.0)
            statusLabel:SetText(currentSpeed > 100 and "[ON FIRE!]" or "[VIBRATING]")
            statusLabel:SetColor(r, g, b, 1.0)
        else
            if selfWin.animOffsetX ~= 0 or selfWin.animOffsetY ~= 0 then
                selfWin.animOffsetX = 0
                selfWin.animOffsetY = 0
                selfWin:ApplyPositionOnly()
            end
            speedDigits:SetColor(0.30, 0.85, 0.55, 1.0)
            speedBar:SetFillColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
            statusLabel:SetText("[SAFE]")
            statusLabel:SetColor(0.65, 0.75, 0.80, 1.0)
        end

        if currentSpeed > 100 then
            local fireRatio = (currentSpeed - 100) / 20.0 -- 0.0 .. 1.0
            fireSpawnTimer = fireSpawnTimer + dt
            local spawnRate = math.max(0.025, 0.08 - fireRatio * 0.055)
            if fireSpawnTimer >= spawnRate then
                fireSpawnTimer = 0
                SpawnFireParticle(fireLayer, fireRatio)
                if fireRatio > 0.6 then
                    SpawnFireParticle(fireLayer, fireRatio)
                end
            end
        end

        if currentSpeed > 115 then
            highSpeedTimer = highSpeedTimer + dt
            if highSpeedTimer > 5.0 then
                statusLabel:SetText("[SYSTEM GLITCH!]")
                glitchCooldown = glitchCooldown - dt
                if glitchCooldown <= 0 then
                    glitchCooldown = 0.65
                    selfWin.anim:PlayEffect("Glitch", 0.35, { intensity = 14 })
                end
            end
        else
            highSpeedTimer = math.max(0, highSpeedTimer - dt * 2.0)
        end

        if currentSpeed >= 120 then
            criticalTimer = criticalTimer + dt
        else
            criticalTimer = math.max(0, criticalTimer - dt * 3.0)
        end
        
        overheatLabel:SetText(string.format("Engine Stress (120 km/h): %.1f / 100.0s", criticalTimer))

        if criticalTimer > 70 then
            overheatLabel:SetColor(1.0, 0.25, 0.25, 1.0)
        elseif criticalTimer > 0 then
            overheatLabel:SetColor(1.0, 0.70, 0.25, 1.0)
        else
            overheatLabel:SetColor(0.75, 0.78, 0.82, 1.0)
        end

        if criticalTimer >= 1.0 and not isExploded then
            isExploded = true
            PMUI.Notify("BOOM!", "Speedometer exploded from extreme over-speed!", "error", 4.5)
            if getSoundManager() then
                getSoundManager():playUISound("UIActivateButton")
            end
            selfWin.anim:Shatter(6, 4, 750, function()
                PMUI.CloseInstance(SPEEDO_ID)
            end)
        end
        oldPrerender(selfWin)
    end

    PMUI.CreateInstance(SPEEDO_ID, speedoWin, true)
    speedoWin.anim:FadeIn(0.25)
    speedoWin.anim:SlideIn("bottom", 30, 0.3)
end