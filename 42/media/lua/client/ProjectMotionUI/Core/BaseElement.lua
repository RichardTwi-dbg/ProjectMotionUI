require "ISUI/ISUIElement"
require "ProjectMotionUI/Core/Animation"
require "ProjectMotionUI/Core/Style"

PMUI = PMUI or {}
PMUI.BaseElement = ISUIElement:derive("PMUI_BaseElement")

--- Creates a base PMUI element with hierarchy, layout, animation, and interaction support.
---@return PMUI.BaseElement
function PMUI.BaseElement:new()
    local o = ISUIElement:new(0, 0, 0, 0)
    setmetatable(o, self)
    self.__index = self

    o._hierarchyParent = nil
    o._hierarchyChildren = {}

    o._persistState = false
    o._stateKey = nil
    o._tooltipData = nil

    o.soundHover = nil
    o.soundClick = nil
    o._wasHovered = false

    o._onPreRenderHooks = {}
    o._onRenderHooks = {}
    o._onHoverHooks = {}

    o.isDraggable = false
    o.dragTarget = nil
    o.isDragging = false
    o.gravityEnabled = false
    o.dragStartMouseX = 0
    o.dragStartMouseY = 0
    o.dragStartOffsetX = 0
    o.dragStartOffsetY = 0
    o.lastMouseX = 0
    o.lastMouseY = 0
    o.dragVelX = 0
    o.dragVelY = 0

    o.scaleX = 0
    o.scaleY = 0
    o.offsetX = 0
    o.offsetY = 0

    o.scaleW = 0
    o.scaleH = 0
    o.offsetW = 100
    o.offsetH = 100

    o.anchorX = 0
    o.anchorY = 0

    o.animOffsetX = 0
    o.animOffsetY = 0

    o.alpha = 1.0
    o.passThroughClicks = true

    o.anim = PMUI.AnimationController:new(o)

    return o
end

--- Returns the element's parent in the PMUI hierarchy.
---@return PMUI.BaseElement|nil
function PMUI.BaseElement:GetHierarchyParent()
    return self._hierarchyParent
end

--- Returns the top-level element in the current hierarchy.
---@return PMUI.BaseElement
function PMUI.BaseElement:GetHierarchyRoot()
    local current = self
    while current._hierarchyParent do
        current = current._hierarchyParent
    end
    return current
end

--- Enables or disables persistent state for this element.
--- The state key is used to identify the element when saving and restoring its data.
---@param enabled boolean Whether state persistence is enabled.
---@param key string|nil Optional unique state key. Defaults to the element type.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetPersistState(enabled, key)
    self._persistState = enabled and true or false
    self._stateKey = key or self._stateKey or tostring(self.Type)
    return self
end

--- Saves the element's position, scale, and gravity state into the provided table.
---@param data table State table to populate.
function PMUI.BaseElement:SaveState(data)
    data.offsetX = self.offsetX + (self.animOffsetX or 0)
    data.offsetY = self.offsetY + (self.animOffsetY or 0)
    data.scaleX  = self.scaleX
    data.scaleY  = self.scaleY
    data.gravityEnabled = self.gravityEnabled
end

--- Restores the element's position, scale, and gravity state.
--- Position offsets are reset if the restored coordinates place the element outside the screen.
---@param data table Previously saved element state.
function PMUI.BaseElement:LoadState(data)
    if data.offsetX ~= nil then self.offsetX = data.offsetX end
    if data.offsetY ~= nil then self.offsetY = data.offsetY end
    if data.scaleX  ~= nil then self.scaleX  = data.scaleX  end
    if data.scaleY  ~= nil then self.scaleY  = data.scaleY  end

    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()
    local absX = (screenW * self.scaleX) + self.offsetX
    local absY = (screenH * self.scaleY) + self.offsetY
    if absX < 0 or absX > screenW - 40 then self.offsetX = 0 end
    if absY < 0 or absY > screenH - 40 then self.offsetY = 0 end

    self:RecalculateLayout()

    if data.gravityEnabled then
        self:SetGravity(true)
    end
end

--- Applies one or more registered styles to the element.
--- A table can be supplied to apply multiple styles in sequence.
---@param styleNameOrList string|string[] Style name or an ordered list of style names.
---@param params table|nil Optional parameters passed to each style function.
---@return PMUI.BaseElement
function PMUI.BaseElement:ApplyStyle(styleNameOrList, params)
    if type(styleNameOrList) == "table" then
        for _, name in ipairs(styleNameOrList) do
            self:ApplyStyle(name, params)
        end
        return self
    end

    local styleFn = PMUI.GetStyle(styleNameOrList)
    if styleFn then
        styleFn(self, params)
    else
        print("[PMUI] Warning: Style '" .. tostring(styleNameOrList) .. "' not found!")
    end
    return self
end

--- Initializes the element and all children registered in its PMUI hierarchy.
--- Each child is initialized, instantiated, attached to the native UI hierarchy, and laid out.
function PMUI.BaseElement:instantiate()
    ISUIElement.instantiate(self)

    for i, child in ipairs(self._hierarchyChildren) do
        child:initialise()
        child:instantiate()
        self:addChild(child)
        child:RecalculateLayout()
    end
end

--- Adds a child element to the PMUI hierarchy.
--- If the parent is already instantiated, the child is also initialized and attached immediately.
---@param child PMUI.BaseElement Child element to add.
---@return PMUI.BaseElement
function PMUI.BaseElement:AddChild(child)
    if not child then return self end

    child._hierarchyParent = self
    table.insert(self._hierarchyChildren, child)

    if self.javaObject then
        child:initialise()
        child:instantiate()
        self:addChild(child)
    end

    child:RecalculateLayout()
    return self
end

--- Plays a UI sound by its game sound identifier.
---@param soundName string Sound name registered in the game.
function PMUI.PlaySound(soundName)
    if soundName and soundName ~= "" and getSoundManager() then
        getSoundManager():playUISound(soundName)
    end
end

--- Sets the sound played when the mouse enters the element.
---@param soundName string|nil UI sound name.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetHoverSound(soundName)
    self.soundHover = soundName
    return self
end

--- Sets the sound played when the element is clicked.
---@param soundName string|nil UI sound name.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetClickSound(soundName)
    self.soundClick = soundName
    return self
end

--- Registers a callback executed during the element's render phase.
--- The callback receives the element instance.
---@param fn function Render callback.
---@return PMUI.BaseElement
function PMUI.BaseElement:OnRender(fn)
    if type(fn) == "function" then
        table.insert(self._onRenderHooks, fn)
    end
    return self
end

--- Registers a callback executed during the element's pre-render phase.
--- The callback receives the element instance and frame delta time in seconds.
---@param fn function Pre-render callback.
---@return PMUI.BaseElement
function PMUI.BaseElement:OnPreRender(fn)
    if type(fn) == "function" then
        table.insert(self._onPreRenderHooks, fn)
    end
    return self
end

--- Registers a callback invoked when the element's hover state changes.
--- The callback receives the element instance and the new hover state.
---@param fn function Hover callback.
---@return PMUI.BaseElement
function PMUI.BaseElement:OnHover(fn)
    if type(fn) == "function" then
        table.insert(self._onHoverHooks, fn)
    end
    return self
end

--- Enables or disables dragging for this element.
--- An optional target element can be specified to move a parent or another element instead.
---@param enabled boolean Whether dragging is enabled.
---@param targetElement PMUI.BaseElement|nil Element to move. Defaults to this element.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetDraggable(enabled, targetElement)
    self.isDraggable = enabled
    self.dragTarget = targetElement or self
    if enabled then
        self.passThroughClicks = false
    end
    return self
end

--- Enables or disables the falling physics effect.
--- Enabling gravity starts a fall animation; disabling it restores the element's position.
---@param enabled boolean Whether gravity is enabled.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetGravity(enabled)
    self.gravityEnabled = enabled
    if enabled and self.anim then
        self.anim:FallDown(0.52, 2300)
    elseif not enabled and self.anim then
        self.anim:RestoreFromFall(false)
    end
    return self
end

--- Sets the tooltip content displayed for this element.
--- When only one argument is provided, it is treated as the tooltip text without a title.
---@param titleOrText string Tooltip title or body text.
---@param text string|nil Optional tooltip body text.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetTooltip(titleOrText, text)
    if text == nil then
        self._tooltipData = { title = nil, text = titleOrText }
    else
        self._tooltipData = { title = titleOrText, text = text }
    end
    return self
end

--- Sets the element's fixed width and height offsets.
--- The final dimensions also include any parent-relative scale values.
---@param offsetW number|nil Width offset in pixels.
---@param offsetH number|nil Height offset in pixels.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetSize(offsetW, offsetH)
    self.offsetW = offsetW or self.offsetW
    self.offsetH = offsetH or self.offsetH
    self:RecalculateLayout()
    return self
end

--- Sets the element's width and height as proportions of its parent.
---@param scaleW number|nil Width scale relative to the parent.
---@param scaleH number|nil Height scale relative to the parent.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetSizePercent(scaleW, scaleH)
    self.scaleW = scaleW or self.scaleW
    self.scaleH = scaleH or self.scaleH
    self:RecalculateLayout()
    return self
end

--- Sets the element's position using pixel offsets relative to its parent.
---@param offsetX number|nil Horizontal position offset.
---@param offsetY number|nil Vertical position offset.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetPosition(offsetX, offsetY)
    self.offsetX = offsetX or self.offsetX
    self.offsetY = offsetY or self.offsetY
    self:RecalculateLayout()
    return self
end

--- Sets the element's position using proportions of its parent dimensions.
---@param scaleX number|nil Horizontal position scale.
---@param scaleY number|nil Vertical position scale.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetPositionPercent(scaleX, scaleY)
    self.scaleX = scaleX or self.scaleX
    self.scaleY = scaleY or self.scaleY
    self:RecalculateLayout()
    return self
end

--- Sets the element's anchor point.
--- Anchor values are normalized: 0.0 represents the leading edge, 0.5 the center, and 1.0 the trailing edge.
---@param anchorX number|nil Horizontal anchor value.
---@param anchorY number|nil Vertical anchor value.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetAnchor(anchorX, anchorY)
    self.anchorX = anchorX or self.anchorX
    self.anchorY = anchorY or self.anchorY
    self:RecalculateLayout()
    return self
end

--- Controls whether mouse clicks pass through this element to elements behind it.
---@param pass boolean Whether mouse clicks should pass through.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetPassThroughClicks(pass)
    self.passThroughClicks = pass
    return self
end

--- Sets the element's opacity.
---@param alpha number Opacity value, typically between 0.0 and 1.0.
---@return PMUI.BaseElement
function PMUI.BaseElement:SetAlpha(alpha)
    self.alpha = alpha
    return self
end

--- Recalculates and applies the element's position without changing its dimensions.
--- Position is calculated from parent-relative scale, pixel offsets, anchor, and animation offsets.
function PMUI.BaseElement:ApplyPositionOnly()
    local parentW, parentH
    if self._hierarchyParent then
        parentW = self._hierarchyParent:getWidth()
        parentH = self._hierarchyParent:getHeight()
    else
        parentW = getCore():getScreenWidth()
        parentH = getCore():getScreenHeight()
    end

    local w = self:getWidth()
    local h = self:getHeight()

    local finalX = math.floor((parentW * self.scaleX) + self.offsetX - (w * self.anchorX) + self.animOffsetX)
    local finalY = math.floor((parentH * self.scaleY) + self.offsetY - (h * self.anchorY) + self.animOffsetY)

    self:setX(finalX)
    self:setY(finalY)
    if self.javaObject then
        self.javaObject:setX(finalX)
        self.javaObject:setY(finalY)
    end
end

--- Recalculates the element's dimensions and position.
--- Also updates the layout of all child elements in the PMUI hierarchy.
function PMUI.BaseElement:RecalculateLayout()
    local parentW, parentH
    if self._hierarchyParent then
        parentW = self._hierarchyParent:getWidth()
        parentH = self._hierarchyParent:getHeight()
    else
        parentW = getCore():getScreenWidth()
        parentH = getCore():getScreenHeight()
    end

    local finalW = math.floor((parentW * self.scaleW) + self.offsetW)
    local finalH = math.floor((parentH * self.scaleH) + self.offsetH)

    self:setWidth(finalW)
    self:setHeight(finalH)
    if self.javaObject then
        self.javaObject:setWidth(finalW)
        self.javaObject:setHeight(finalH)
    end

    self:ApplyPositionOnly()

    for _, child in ipairs(self._hierarchyChildren) do
        child:RecalculateLayout()
    end
end

--- Performs per-frame element updates before rendering.
--- Updates animations, hover state, registered pre-render callbacks, and tooltip positioning.
function PMUI.BaseElement:prerender()
    local dt = UIManager.getMillisSinceLastRender() / 1000.0
    if dt > 0.1 then dt = 0.1 end

    if self.anim then
        self.anim:Update(dt)
    end

    local hovered = self:isVisible() and self:isMouseOver()
    if hovered ~= self._wasHovered then
        self._wasHovered = hovered
        if hovered and self.soundHover then
            PMUI.PlaySound(self.soundHover)
        end
        for _, fn in ipairs(self._onHoverHooks) do
            fn(self, hovered)
        end
    end

    for _, fn in ipairs(self._onPreRenderHooks) do
        fn(self, dt)
    end

    if self._tooltipData and PMUI.TooltipManager then
        PMUI.TooltipManager.UpdateForElement(self)
    end
end

--- Executes registered render callbacks and draws the debug overlay when enabled.
function PMUI.BaseElement:render()
    for _, fn in ipairs(self._onRenderHooks) do
        fn(self)
    end

    if PMUI.Debug and PMUI.Debug.Enabled then
        PMUI.Debug.DrawElementOverlay(self)
    end
end

--- Handles mouse button presses.
--- Starts dragging when the element is draggable; otherwise respects click pass-through settings.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean|nil Whether the mouse event was handled.
function PMUI.BaseElement:onMouseDown(x, y)
    if self.isDraggable then
        local target = self.dragTarget or self
        local root = target:GetHierarchyRoot()
        if root and root.javaObject then
            root:bringToTop()
        end

        target._wasFallingBeforeDrag = (target.anim and target.anim.effects["fall_down"] ~= nil) or target.gravityEnabled

        if target.anim then
            target.anim.effects["fall_down"] = nil
            target.anim.springs["animOffsetX"] = nil
            target.anim.springs["animOffsetY"] = nil
        end

        target.offsetX = target.offsetX + target.animOffsetX
        target.offsetY = target.offsetY + target.animOffsetY
        target.animOffsetX = 0
        target.animOffsetY = 0

        self.isDragging = true
        self.dragStartMouseX = getMouseX()
        self.dragStartMouseY = getMouseY()
        self.dragStartOffsetX = target.offsetX
        self.dragStartOffsetY = target.offsetY

        self._dragHistory = {
            { x = self.dragStartMouseX, y = self.dragStartMouseY, t = getTimestampMs() }
        }
        return true
    end

    if self.passThroughClicks then
        return false
    end
    return true
end

--- Updates the dragged element's position while the mouse moves.
--- Keeps a short history of mouse positions for calculating the release velocity.
---@param dx number Horizontal mouse movement delta.
---@param dy number Vertical mouse movement delta.
---@return boolean|nil True when the element is being dragged.
function PMUI.BaseElement:onMouseMove(dx, dy)
    if self.isDragging then
        local target = self.dragTarget or self
        local mx = getMouseX()
        local my = getMouseY()

        target.offsetX = self.dragStartOffsetX + (mx - self.dragStartMouseX)
        target.offsetY = self.dragStartOffsetY + (my - self.dragStartMouseY)
        target:ApplyPositionOnly()

        if self._dragHistory then
            table.insert(self._dragHistory, { x = mx, y = my, t = getTimestampMs() })
            if #self._dragHistory > 5 then
                table.remove(self._dragHistory, 1)
            end
        end
        return true
    end
end

--- Continues drag handling when the mouse moves outside the element's bounds.
---@param dx number Horizontal mouse movement delta.
---@param dy number Vertical mouse movement delta.
function PMUI.BaseElement:onMouseMoveOutside(dx, dy)
    self:onMouseMove(dx, dy)
end

--- Handles mouse button release.
--- Stops dragging and, if the element was falling before the drag, applies the release velocity to its fall animation.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean|nil Whether the mouse event was handled.
function PMUI.BaseElement:onMouseUp(x, y)
    if self.isDragging then
        self.isDragging = false
        local target = self.dragTarget or self

        if target._wasFallingBeforeDrag and target.anim then
            local throwVx, throwVy = 0, 0
            local now = getTimestampMs()

            if self._dragHistory and #self._dragHistory >= 2 then
                local oldest = self._dragHistory[1] -- Keep the oldest sample to calculate release velocity.
                local dtSec = (now - oldest.t) / 1000.0
                if dtSec > 0.005 and dtSec < 0.15 then
                    local mx = getMouseX()
                    local my = getMouseY()
                    throwVx = ((mx - oldest.x) / dtSec) * 0.85
                    throwVy = ((my - oldest.y) / dtSec) * 0.85
                end
            end

            throwVx = math.max(-2200, math.min(2200, throwVx))
            throwVy = math.max(-2200, math.min(2200, throwVy))
            target.anim:FallDown(0.58, 2200, nil, throwVx, throwVy)
        end
        return true
    end

    if self.passThroughClicks then
        return false
    end
    return true
end

--- Handles mouse button release outside the element's bounds.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
function PMUI.BaseElement:onMouseUpOutside(x, y)
    if self.isDragging then
        self:onMouseUp(x, y)
    end
end

--- Handles right mouse button presses according to the click pass-through setting.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Whether the mouse event was handled.
function PMUI.BaseElement:onRightMouseDown(x, y)
    if self.passThroughClicks then
        return false
    end
    return true
end

return PMUI.BaseElement