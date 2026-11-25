require "ProjectMotionUI/Core/BaseElement"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Button"

PMUI = PMUI or {}
PMUI.Tabs = PMUI.BaseElement:derive("PMUI_Tabs")

--- Creates a tab container with a tab bar and a content area.
---@return PMUI.Tabs
function PMUI.Tabs:new()
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    local theme = PMUI.GetTheme()
    o.tabBarHeight = 34
    o.tabs = {} -- Each tab stores its title, button, and content container.
    o.activeIndex = 0
    o.onTabChangeCallback = nil

    o.accentColor = theme.accent
    o.normalColor = theme.btnNormal
    o.hoverColor  = theme.btnHover

    -- The tab bar occupies the top portion of the component.
    o.tabBar = PMUI.Frame:new()
        :SetSizePercent(1.0, 0):SetSize(0, o.tabBarHeight)
        :SetBackgroundColor(0.08, 0.09, 0.11, 0.9)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 0.8)
    o:AddChild(o.tabBar)

    -- The body area fills the remaining space below the tab bar.
    o.bodyArea = PMUI.Frame:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, -o.tabBarHeight)
        :SetPosition(0, o.tabBarHeight)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    o:AddChild(o.bodyArea)

    return o
end

--- Adds a new tab and returns its content container.
--- The first tab added is automatically selected.
---@param title string Text displayed on the tab button.
---@return PMUI.Frame Content container associated with the new tab.
function PMUI.Tabs:AddTab(title)
    local index = #self.tabs + 1

    local btn = PMUI.Button:new(title)
        :SetFont(UIFont.Small)
        :OnClick(function()
            self:SelectTab(index)
        end)
    self.tabBar:AddChild(btn)

    local container = PMUI.Frame:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    container:setVisible(false)
    self.bodyArea:AddChild(container)

    table.insert(self.tabs, {
        title = title,
        button = btn,
        container = container
    })

    self:UpdateTabButtonsLayout()

    if self.activeIndex == 0 then
        self:SelectTab(1, true)
    end

    return container
end

--- Recalculates tab button positions and widths.
--- All buttons share the available tab bar width equally.
function PMUI.Tabs:UpdateTabButtonsLayout()
    local count = #self.tabs
    if count == 0 then return end

    local share = 1.0 / count
    for i, tab in ipairs(self.tabs) do
        tab.button
            :SetPositionPercent((i - 1) * share, 0)
            :SetSizePercent(share, 1.0)
            :SetSize(0, 0)
    end
end

--- Activates the specified tab and updates the visibility and appearance of all tabs.
--- The selected tab can optionally skip its fade-in animation.
---@param index number Index of the tab to activate.
---@param instant boolean|nil If true, switches without playing the fade-in animation.
function PMUI.Tabs:SelectTab(index, instant)
    if index < 1 or index > #self.tabs or index == self.activeIndex then return end
    self.activeIndex = index

    for i, tab in ipairs(self.tabs) do
        local isSelected = (i == index)
        tab.container:setVisible(isSelected)

        if isSelected then
            tab.button:SetColors(self.accentColor, self.accentColor, self.accentColor)
            if not instant then
                tab.container.anim:FadeIn(0.18)
            end
        else
            tab.button:SetColors(self.normalColor, self.hoverColor, self.accentColor)
        end
    end

    if self.onTabChangeCallback then
        self.onTabChangeCallback(index, self.tabs[index])
    end
end

--- Registers a callback invoked whenever the active tab changes.
--- The callback receives the selected tab index and its tab data.
---@param callback function|nil Tab change callback.
---@return PMUI.Tabs
function PMUI.Tabs:OnTabChange(callback)
    self.onTabChangeCallback = callback
    return self
end

--- Saves the currently active tab index into the provided state table.
---@param data table State table to populate.
function PMUI.Tabs:SaveState(data)
    data.activeIndex = self.activeIndex
end

--- Restores the active tab from a previously saved state.
--- Invalid or out-of-range indices are ignored.
---@param data table State table containing the saved active index.
function PMUI.Tabs:LoadState(data)
    if data.activeIndex and data.activeIndex >= 1 and data.activeIndex <= #self.tabs then
        self:SelectTab(data.activeIndex, true)
    end
end

return PMUI.Tabs