require "ProjectMotionUI/Core/BaseElement"
require "ProjectMotionUI/Core/Theme"

PMUI = PMUI or {}
PMUI.Dropdown = PMUI.BaseElement:derive("PMUI_Dropdown")

--- Creates a new dropdown element with the provided options and initial selection.
---@param options table|nil List of available dropdown options.
---@param defaultIndex number|nil Index of the initially selected option.
---@return PMUI.Dropdown
function PMUI.Dropdown:new(options, defaultIndex)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    local theme = PMUI.GetTheme()
    o.passThroughClicks = false
    o.options = options or { "Option 1", "Option 2" }
    o.selectedIndex = defaultIndex or 1
    o.isOpen = false
    o.itemHeight = 28
    o.onSelectCallback = nil

    -- Initialize dropdown colors from the active UI theme.
    o.bgColor     = { r = theme.btnNormal.r, g = theme.btnNormal.g, b = theme.btnNormal.b, a = 1.0 }
    o.hoverColor  = { r = theme.btnHover.r, g = theme.btnHover.g, b = theme.btnHover.b, a = 1.0 }
    o.accentColor = { r = theme.accent.r, g = theme.accent.g, b = theme.accent.b, a = 1.0 }
    o.borderColor = { r = theme.windowBorder.r, g = theme.windowBorder.g, b = theme.windowBorder.b, a = 1.0 }
    o.textColor   = { r = theme.textPrimary.r, g = theme.textPrimary.g, b = theme.textPrimary.b, a = 1.0 }

    o.font = UIFont.Small
    o.baseHeight = 32
    o.offsetW = 200
    o.offsetH = o.baseHeight

    return o
end

--- Replaces the available options and resets the selected index.
---@param options table|nil List of options to display.
---@param defaultIndex number|nil Index of the option to select after updating the list.
---@return PMUI.Dropdown
function PMUI.Dropdown:SetOptions(options, defaultIndex)
    self.options = options or {}
    self.selectedIndex = defaultIndex or 1
    return self
end

--- Returns the currently selected option and its index.
---@return any selectedOption Currently selected option, or nil if unavailable.
---@return number selectedIndex Index of the selected option.
function PMUI.Dropdown:GetSelected()
    return self.options[self.selectedIndex], self.selectedIndex
end

--- Registers a callback invoked whenever an option is selected.
--- The callback receives the selected value, its index, and the dropdown instance.
---@param callback function|nil Function invoked after an option is selected.
---@return PMUI.Dropdown
function PMUI.Dropdown:OnSelect(callback)
    self.onSelectCallback = callback
    return self
end

--- Toggles the dropdown between expanded and collapsed states.
--- Updates the element height to accommodate the option list.
--- Brings the dropdown to the top of the UI hierarchy when expanded.
function PMUI.Dropdown:Toggle()
    self.isOpen = not self.isOpen
    if self.isOpen then
        self.offsetH = self.baseHeight + (#self.options * self.itemHeight)
        if self.javaObject then
            self:bringToTop()
        end
    else
        self.offsetH = self.baseHeight
    end
    self:RecalculateLayout()
end

--- Handles mouse input for expanding the dropdown or selecting an option.
--- Clicking the header toggles the dropdown, while clicking an item updates the selection.
--- Plays the corresponding UI sound and invokes the selection callback when applicable.
---@param x number Mouse X coordinate relative to the element.
---@param y number Mouse Y coordinate relative to the element.
---@return boolean Whether the mouse event was handled.
function PMUI.Dropdown:onMouseDown(x, y)
    if not self.isOpen then
        self:Toggle()
        if getSoundManager() then getSoundManager():playUISound("UIToggleTick") end
        return true
    end

    if y <= self.baseHeight then
        self:Toggle()
        return true
    end

    local clickedIdx = math.floor((y - self.baseHeight) / self.itemHeight) + 1
    if clickedIdx >= 1 and clickedIdx <= #self.options then
        self.selectedIndex = clickedIdx
        self:Toggle()
        if getSoundManager() then getSoundManager():playUISound("UIActivateButton") end
        if self.onSelectCallback then
            self.onSelectCallback(self.options[clickedIdx], clickedIdx, self)
        end
    else
        self:Toggle()
    end
    return true
end

--- Renders the dropdown header and, when expanded, the available option list.
--- Highlights the header and individual options when hovered.
--- Marks the currently selected option with an accent indicator.
function PMUI.Dropdown:prerender()
    PMUI.BaseElement.prerender(self)
    if self.alpha <= 0.01 then return end

    local w = self:getWidth()
    local bh = self.baseHeight

    local isHeaderHover = self:isMouseOver() and (getMouseY() - self:getAbsoluteY() <= bh)
    local hCol = isHeaderHover and self.hoverColor or self.bgColor

    -- Draw the dropdown header and its current selection.
    self:drawRect(0, 0, w, bh, hCol.a * self.alpha, hCol.r, hCol.g, hCol.b)
    self:drawRectBorder(0, 0, w, bh, self.borderColor.a * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    local currentText = tostring(self.options[self.selectedIndex] or "Select...")
    local th = getTextManager():MeasureStringY(self.font, currentText)
    self:drawText(currentText, 10, (bh - th) / 2, self.textColor.r, self.textColor.g, self.textColor.b, self.alpha, self.font)

    -- Display an arrow indicating the current expansion state.
    local arrow = self.isOpen and "^" or "v"
    self:drawText(arrow, w - 18, (bh - th) / 2, self.accentColor.r, self.accentColor.g, self.accentColor.b, self.alpha, self.font)

    if self.isOpen then
        local mouseLocalY = getMouseY() - self:getAbsoluteY()
        local isOver = self:isMouseOver()

        -- Render each option with hover and selection highlighting.
        for i, opt in ipairs(self.options) do
            local itemY = bh + (i - 1) * self.itemHeight
            local isItemHovered = isOver and (mouseLocalY >= itemY and mouseLocalY < itemY + self.itemHeight)
            local isSelected = (i == self.selectedIndex)

            local bg = isItemHovered and self.hoverColor or self.bgColor
            self:drawRect(0, itemY, w, self.itemHeight, 0.98 * self.alpha, bg.r * 0.85, bg.g * 0.85, bg.b * 0.85)
            self:drawRectBorder(0, itemY, w, self.itemHeight, 0.6 * self.alpha, self.borderColor.r, self.borderColor.g, self.borderColor.b)

            if isSelected then
                self:drawRect(2, itemY + 2, 3, self.itemHeight - 4, self.alpha, self.accentColor.r, self.accentColor.g, self.accentColor.b)
            end

            self:drawText(tostring(opt), 12, itemY + (self.itemHeight - th) / 2, self.textColor.r, self.textColor.g, self.textColor.b, self.alpha, self.font)
        end
    end
end

--- Saves the currently selected option index into the provided data table.
---@param data table Table used to store the dropdown state.
function PMUI.Dropdown:SaveState(data)
    data.selectedIndex = self.selectedIndex
end

--- Restores the selected option from the provided data table.
--- Invokes the selection callback if the saved index matches an available option.
---@param data table Table containing the previously saved dropdown state.
function PMUI.Dropdown:LoadState(data)
    if data.selectedIndex and self.options[data.selectedIndex] then
        self.selectedIndex = data.selectedIndex
        if self.onSelectCallback then
            self.onSelectCallback(self.options[self.selectedIndex], self.selectedIndex, self)
        end
    end
end

return PMUI.Dropdown