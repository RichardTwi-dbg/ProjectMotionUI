PMUI = PMUI or {}
PMUI.AnimationController = {}
PMUI.AnimationController.__index = PMUI.AnimationController
PMUI.CustomEffects = PMUI.CustomEffects or {}

--- Collection of easing functions used by animations.
---@class PMUI.Easing
PMUI.Easing = {
    --- Linear interpolation without easing.
    ---@param t number Normalized progress (0.0-1.0).
    ---@return number
    Linear = function(t) return t end,

    --- Quadratic easing that starts quickly and slows down towards the end.
    ---@param t number Normalized progress (0.0-1.0).
    ---@return number
    QuadOut = function(t) return 1 - (1 - t) * (1 - t) end,

    --- Quadratic easing that accelerates and then decelerates.
    ---@param t number Normalized progress (0.0-1.0).
    ---@return number
    QuadInOut = function(t)
        return t < 0.5 and 2 * t * t or 1 - ((-2 * t + 2) ^ 2) / 2
    end,

    --- Easing that overshoots the target before settling.
    ---@param t number Normalized progress (0.0-1.0).
    ---@return number
    BackOut = function(t)
        local c1 = 1.70158
        local c3 = c1 + 1
        return 1 + c3 * ((t - 1) ^ 3) + c1 * ((t - 1) ^ 2)
    end
}

--- Registers a custom animation effect.
--- The effect must provide an update function and may optionally define start and finish callbacks.
---@param name string Unique effect identifier.
---@param config table Effect definition containing update, start, and/or finish callbacks.
function PMUI.RegisterEffect(name, config)
    if not name or type(config) ~= "table" or type(config.update) ~= "function" then
        print("[PMUI] Error: RegisterEffect requires name and { update = fn }")
        return
    end
    PMUI.CustomEffects[name] = config
end

--- Starts a registered custom effect on the controlled element.
---@param name string Registered effect identifier.
---@param duration number|nil Effect duration in seconds. Defaults to 0.5.
---@param params table|nil Parameters passed to the effect callbacks.
---@param onComplete function|nil Callback invoked when the effect finishes.
function PMUI.AnimationController:PlayEffect(name, duration, params, onComplete)
    local effectDef = PMUI.CustomEffects[name]
    if not effectDef then
        print("[PMUI] Warning: Custom effect '" .. tostring(name) .. "' not found!")
        return
    end

    duration = math.max(duration or 0.5, 0.001)
    params = params or {}

    if effectDef.start then
        effectDef.start(self.element, params)
    end

    self.effects["custom_" .. name] = {
        elapsed = 0,
        duration = duration,
        customUpdate = function(el, dt)
            local effData = self.effects["custom_" .. name]
            local progress = math.min(effData.elapsed / duration, 1.0)
            effectDef.update(el, progress, params, dt)
            return progress >= 1.0
        end,
        finish = function(el)
            if effectDef.finish then
                effectDef.finish(el, params)
            end
            if onComplete then
                onComplete(el)
            end
        end
    }
end

--- Creates an animation controller for a UI element.
---@param element PMUI.BaseElement Element controlled by this animation controller.
---@return PMUI.AnimationController
function PMUI.AnimationController:new(element)
    local o = setmetatable({}, self)
    o.element = element
    o.tweens = {}
    o.effects = {}
    o.springs = {}
    return o
end

--- Animates one or more element properties towards their target values.
--- Starting a tween with an existing tag replaces the previous tween using that tag.
---@param tag string|nil Unique tween identifier. Defaults to "default_tween".
---@param props table Property names mapped to their target values.
---@param duration number|nil Animation duration in seconds. Defaults to 0.25.
---@param easing function|nil Easing function used to interpolate values.
---@param onComplete function|nil Callback invoked when the tween finishes.
function PMUI.AnimationController:Tween(tag, props, duration, easing, onComplete)
    tag = tag or "default_tween"
    easing = easing or PMUI.Easing.QuadOut
    duration = math.max(duration or 0.25, 0.001)

    local startValues = {}
    for propName, _ in pairs(props) do
        startValues[propName] = self.element[propName] or 0
    end

    self.tweens[tag] = {
        elapsed = 0,
        duration = duration,
        startValues = startValues,
        targetValues = props,
        easing = easing,
        onComplete = onComplete
    }
end

--- Creates or updates spring animations for the specified element properties.
--- Existing spring velocity is preserved when a property already has an active spring.
---@param props table Property names mapped to their target values.
---@param stiffness number|nil Spring stiffness. Defaults to 180.
---@param damping number|nil Spring damping. Defaults to 12.
function PMUI.AnimationController:Spring(props, stiffness, damping)
    stiffness = stiffness or 180
    damping = damping or 12

    for propName, targetVal in pairs(props) do
        local currentVal = self.element[propName] or 0
        local existing = self.springs[propName]

        self.springs[propName] = {
            current = currentVal,
            target = targetVal,
            velocity = existing and existing.velocity or 0,
            stiffness = stiffness,
            damping = damping
        }
    end
end

--- Applies an impulse to the element's animation offsets.
--- Both offsets are animated back to zero using spring physics.
---@param vx number|nil Initial horizontal velocity.
---@param vy number|nil Initial vertical velocity.
---@param stiffness number|nil Spring stiffness. Defaults to 220.
---@param damping number|nil Spring damping. Defaults to 10.
function PMUI.AnimationController:Impulse(vx, vy, stiffness, damping)
    stiffness = stiffness or 220
    damping = damping or 10

    self:Spring({ animOffsetX = 0, animOffsetY = 0 }, stiffness, damping)

    self.springs["animOffsetX"].velocity = self.springs["animOffsetX"].velocity + (vx or 0)
    self.springs["animOffsetY"].velocity = self.springs["animOffsetY"].velocity + (vy or 0)
end

--- Simulates the element falling under gravity with horizontal movement and bouncing.
--- The element remains within its parent or screen boundaries.
---@param bounciness number|nil Bounce strength, clamped between 0.1 and 0.85. Defaults to 0.5.
---@param gravity number|nil Downward acceleration. Defaults to 2200.
---@param onComplete function|nil Callback invoked when the element settles.
---@param initVx number|nil Initial horizontal velocity.
---@param initVy number|nil Initial vertical velocity.
function PMUI.AnimationController:FallDown(bounciness, gravity, onComplete, initVx, initVy)
    bounciness = math.min(math.max(bounciness or 0.5, 0.1), 0.85)
    gravity = gravity or 2200

    self.springs["animOffsetY"] = nil
    self.tweens["slide"] = nil

    local velY = initVy or 0
    local velX = initVx or ((ZombRand(2) == 0 and -1 or 1) * (30 + ZombRand(50)))

    self.effects["fall_down"] = {
        elapsed = 0,
        duration = 8.0,
        customUpdate = function(targetEl, dt)
            local parentH = targetEl._hierarchyParent and targetEl._hierarchyParent:getHeight() or getCore():getScreenHeight()
            local parentW = targetEl._hierarchyParent and targetEl._hierarchyParent:getWidth() or getCore():getScreenWidth()
            local baseBottomY = (targetEl:getY() - targetEl.animOffsetY) + targetEl:getHeight()
            local baseLeftX = targetEl:getX() - targetEl.animOffsetX
            local floorOffset = math.max(0, parentH - baseBottomY)
            local minOffsetX = -baseLeftX
            local maxOffsetX = parentW - (baseLeftX + targetEl:getWidth())

            velY = velY + gravity * dt
            targetEl.animOffsetY = targetEl.animOffsetY + velY * dt
            targetEl.animOffsetX = targetEl.animOffsetX + velX * dt

            velX = velX * (1 - 1.5 * dt)

            if targetEl.animOffsetX <= minOffsetX then
                targetEl.animOffsetX = minOffsetX
                velX = -velX * bounciness
            elseif targetEl.animOffsetX >= maxOffsetX then
                targetEl.animOffsetX = maxOffsetX
                velX = -velX * bounciness
            end

            if targetEl.animOffsetY >= floorOffset then
                targetEl.animOffsetY = floorOffset
                velX = velX * 0.65

                if math.abs(velY) < 60 then
                    targetEl.animOffsetY = floorOffset
                    if onComplete then onComplete(targetEl) end
                    return true
                end

                velY = -velY * bounciness
            end

            return false
        end
    }
end

--- Stops the falling effect and restores the element to its original position.
---@param instant boolean|nil If true, resets offsets immediately; otherwise uses spring animation.
function PMUI.AnimationController:RestoreFromFall(instant)
    self.effects["fall_down"] = nil
    if instant then
        self.element.animOffsetX = 0
        self.element.animOffsetY = 0
        self.element:ApplyPositionOnly()
    else
        self:Spring({ animOffsetX = 0, animOffsetY = 0 }, 160, 14)
    end
end

--- Breaks the element into animated fragments that scatter and fade out.
--- A temporary effect layer is created to render the fragments independently.
---@param cols number|nil Number of fragment columns. Defaults to 4.
---@param rows number|nil Number of fragment rows. Defaults to 3.
---@param force number|nil Fragment scattering force. Defaults to 450.
---@param onComplete function|nil Callback invoked after all fragments disappear.
function PMUI.AnimationController:Shatter(cols, rows, force, onComplete)
    cols = cols or 4
    rows = rows or 3
    force = force or 450

    if getSoundManager() then
        getSoundManager():playUISound("UIActivateButton")
    end

    local el = self.element
    if el._isShattered then return end
    el._isShattered = true

    local totalW = el:getWidth()
    local totalH = el:getHeight()

    if totalW <= 2 or totalH <= 2 then
        el:setVisible(false)
        if onComplete then onComplete(el) end
        return
    end

    local startX = el:getAbsoluteX()
    local startY = el:getAbsoluteY()

    local fxLayerId = "PMUI_ShatterFX_" .. tostring(ZombRand(1000000))
    local fxLayer = PMUI.Frame:new()
        :SetSize(1, 1)
        :SetPosition(0, 0)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    PMUI.CreateInstance(fxLayerId, fxLayer)

    local shardW = math.ceil(totalW / cols)
    local shardH = math.ceil(totalH / rows)

    local bg = el.bgColor or el.colorNormal or { r = 0.25, g = 0.28, b = 0.34, a = 1.0 }
    local border = el.borderColor or { r = 0.5, g = 0.55, b = 0.65, a = 1.0 }

    el:setVisible(false)

    local centerX = totalW / 2
    local centerY = totalH / 2
    local activeShards = 0

    for r = 0, rows - 1 do
        for c = 0, cols - 1 do
            local localX = c * shardW
            local localY = r * shardH
            local w = math.min(shardW, totalW - localX)
            local h = math.min(shardH, totalH - localY)

            if w > 0 and h > 0 then
                activeShards = activeShards + 1

                local shard = PMUI.Frame:new()
                    :SetSize(w, h)
                    :SetPosition(startX + localX, startY + localY)
                    :SetBackgroundColor(bg.r, bg.g, bg.b, bg.a)
                    :SetBorderColor(border.r, border.g, border.b, border.a)
                    :SetPassThroughClicks(true)

                fxLayer:AddChild(shard)

                local shardCenterX = localX + w / 2
                local shardCenterY = localY + h / 2
                local dirX = (shardCenterX - centerX) / math.max(centerX, 1)
                local dirY = (shardCenterY - centerY) / math.max(centerY, 1)

                local vx = dirX * force + (ZombRand(160) - 80)
                local vy = dirY * (force * 0.7) - (120 + ZombRand(160))
                local gravity = 1600
                local lifeTime = 0.75 + (ZombRand(30) / 100.0)

                shard.anim.effects["shard_physics"] = {
                    elapsed = 0,
                    duration = lifeTime,
                    customUpdate = function(s, dt)
                        vy = vy + gravity * dt
                        s.animOffsetX = s.animOffsetX + vx * dt
                        s.animOffsetY = s.animOffsetY + vy * dt

                        local progress = s.anim.effects["shard_physics"].elapsed / lifeTime
                        if progress > 0.45 then
                            s.alpha = math.max(0, 1 - ((progress - 0.45) / 0.55))
                        end
                        return false
                    end,
                    finish = function(s)
                        s:setVisible(false)
                        fxLayer:removeChild(s)
                        activeShards = activeShards - 1
                        if activeShards <= 0 then
                            PMUI.CloseInstance(fxLayerId)
                            if onComplete then
                                onComplete(el)
                            end
                        end
                    end
                }
            end
        end
    end
end

--- Applies a horizontal shake animation that gradually decreases in intensity.
---@param intensity number|nil Maximum horizontal displacement. Defaults to 6.
---@param duration number|nil Animation duration in seconds. Defaults to 0.35.
function PMUI.AnimationController:Shake(intensity, duration)
    intensity = intensity or 6
    duration = duration or 0.35

    self.effects["shake"] = {
        elapsed = 0,
        duration = duration,
        update = function(el, progress)
            local decay = 1 - progress
            el.animOffsetX = math.sin(progress * math.pi * 10) * intensity * decay
        end,
        finish = function(el)
            el.animOffsetX = 0
        end
    }
end

--- Moves the element vertically in a short bouncing motion.
---@param height number|nil Maximum vertical displacement. Defaults to 8.
---@param duration number|nil Animation duration in seconds. Defaults to 0.3.
function PMUI.AnimationController:Bounce(height, duration)
    height = height or 8
    duration = duration or 0.3

    self.effects["bounce"] = {
        elapsed = 0,
        duration = duration,
        update = function(el, progress)
            el.animOffsetY = -math.sin(progress * math.pi) * height
        end,
        finish = function(el)
            el.animOffsetY = 0
        end
    }
end

--- Fades the element in by animating its alpha from zero to one.
---@param duration number|nil Fade duration in seconds. Defaults to 0.25.
---@param onComplete function|nil Callback invoked when the fade finishes.
function PMUI.AnimationController:FadeIn(duration, onComplete)
    self.element.alpha = 0
    self:Tween("fade", { alpha = 1 }, duration or 0.25, PMUI.Easing.QuadOut, onComplete)
end

--- Fades the element out by animating its alpha to zero.
---@param duration number|nil Fade duration in seconds. Defaults to 0.25.
---@param onComplete function|nil Callback invoked when the fade finishes.
function PMUI.AnimationController:FadeOut(duration, onComplete)
    self:Tween("fade", { alpha = 0 }, duration or 0.25, PMUI.Easing.QuadOut, onComplete)
end

--- Slides the element into its original position from the specified direction.
---@param direction string Entry direction: "left", "right", "top", or "bottom".
---@param distance number|nil Initial displacement in pixels. Defaults to 40.
---@param duration number|nil Animation duration in seconds. Defaults to 0.3.
---@param onComplete function|nil Callback invoked when the animation finishes.
function PMUI.AnimationController:SlideIn(direction, distance, duration, onComplete)
    distance = distance or 40
    duration = duration or 0.3

    if direction == "left" then
        self.element.animOffsetX = -distance
    elseif direction == "right" then
        self.element.animOffsetX = distance
    elseif direction == "top" then
        self.element.animOffsetY = -distance
    elseif direction == "bottom" then
        self.element.animOffsetY = distance
    end

    self:Tween("slide", { animOffsetX = 0, animOffsetY = 0 }, duration, PMUI.Easing.BackOut, onComplete)
end

--- Updates all active tweens, springs, and effects.
--- Applies the resulting position changes after all animation calculations are complete.
---@param dt number Time elapsed since the previous update, in seconds.
function PMUI.AnimationController:Update(dt)
    local needsLayout = false
    for tag, tw in pairs(self.tweens) do

        tw.elapsed = tw.elapsed + dt
        local progress = math.min(tw.elapsed / tw.duration, 1.0)
        local eased = tw.easing(progress)

        for prop, targetVal in pairs(tw.targetValues) do
            local startVal = tw.startValues[prop]
            self.element[prop] = startVal + (targetVal - startVal) * eased

            if prop == "offsetX" or prop == "offsetY" or prop == "scaleX" or prop == "scaleY"
                or prop == "animOffsetX" or prop == "animOffsetY" then
                    needsLayout = true
            end
        end

        if progress >= 1.0 then
            self.tweens[tag] = nil
            if tw.onComplete then
                tw.onComplete(self.element)
            end
        end
    end

    for prop, sp in pairs(self.springs) do
        local displacement = sp.current - sp.target
        local springForce = -sp.stiffness * displacement
        local dampingForce = -sp.damping * sp.velocity
        local acceleration = springForce + dampingForce

        sp.velocity = sp.velocity + acceleration * dt
        sp.current = sp.current + sp.velocity * dt
        self.element[prop] = sp.current

        if prop == "offsetX" or prop == "offsetY" or prop == "scaleX" or prop == "scaleY"
            or prop == "animOffsetX" or prop == "animOffsetY" then
            needsLayout = true
        end

        if math.abs(sp.velocity) < 0.5 and math.abs(sp.current - sp.target) < 0.1 then
            self.element[prop] = sp.target
            self.springs[prop] = nil
        end
    end

    for tag, eff in pairs(self.effects) do
        eff.elapsed = eff.elapsed + dt
        local isDone = false

        if eff.customUpdate then
            isDone = eff.customUpdate(self.element, dt)
        else
            local progress = math.min(eff.elapsed / eff.duration, 1.0)
            eff.update(self.element, progress)
            isDone = (progress >= 1.0)
        end
            needsLayout = true

            if isDone or eff.elapsed >= eff.duration then
            if eff.finish then
                eff.finish(self.element)
            end
            self.effects[tag] = nil
        end
    end
    if needsLayout then
        self.element:ApplyPositionOnly()
    end
end

-- Example custom effects registered during module initialization.

PMUI.RegisterEffect("Glitch", {
    update = function(el, progress, params)
        local intensity = params.intensity or 12
        if progress < 0.92 then
            el.animOffsetX = (ZombRand(intensity * 2 + 1) - intensity)
            el.animOffsetY = (ZombRand(intensity + 1) - (intensity / 2))
            el.alpha = (ZombRand(10) > 2) and 1.0 or 0.35
        end
    end,
    finish = function(el)
        el.animOffsetX = 0
        el.animOffsetY = 0
        el.alpha = 1.0
    end
})

PMUI.RegisterEffect("Pulse", {
    update = function(el, progress, params)
        local minAlpha = params.minAlpha or 0.45
        local wave = (math.sin(progress * math.pi * 2) + 1) * 0.5
        el.alpha = minAlpha + (1.0 - minAlpha) * wave
    end,
    finish = function(el)
        el.alpha = 1.0
    end
})

PMUI.RegisterEffect("Flash", {
    update = function(el, progress, params)
        local lift = params.height or 12
        el.animOffsetY = -math.sin(progress * math.pi) * lift
        el.alpha = 0.5 + 0.5 * math.cos(progress * math.pi * 2)
    end,
    finish = function(el)
        el.animOffsetY = 0
        el.alpha = 1.0
    end
})

return PMUI.AnimationController