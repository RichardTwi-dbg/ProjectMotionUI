require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Button"

PMUI = PMUI or {}
PMUI.Dialog = PMUI.Frame:derive("PMUI_Dialog")

--- Creates a new modal dialog with a title, message, and centered content panel.
---@param title string|nil Dialog title displayed in the header.
---@param message string|nil Message displayed inside the dialog.
---@return PMUI.Dialog
function PMUI.Dialog:new(title, message)
    local o = PMUI.Frame:new()
    setmetatable(o, self)
    self.__index = self

    -- Configure the full-screen overlay behind the dialog.
    o:SetSizePercent(1.0, 1.0):SetSize(0, 0)
    o:SetBackgroundColor(0.0, 0.0, 0.0, 0.65)
    o:SetBorderColor(0, 0, 0, 0)
    o:SetPassThroughClicks(false)

    -- Create the centered dialog panel.
    o.panel = PMUI.Frame:new()
        :SetSize(420, 200)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.12, 0.13, 0.16, 0.96)
        :SetBorderColor(0.35, 0.40, 0.48, 1.0)
    o:AddChild(o.panel)

    -- Create the header area at the top of the dialog.
    o.header = PMUI.Frame:new()
        :SetSizePercent(1.0, 0)
        :SetSize(0, 36)
        :SetBackgroundColor(0.18, 0.20, 0.25, 1.0)
        :SetBorderColor(0.35, 0.40, 0.48, 1.0)
    o.panel:AddChild(o.header)

    o.titleText = title or "Уведомление"
    o.messageText = message or ""

    -- Extend the panel's prerender method to draw the dialog title and message.
    -- The text opacity follows the alpha of the dialog hierarchy.
    local oldPanelPrerender = o.panel.prerender
    o.panel.prerender = function(selfPanel)
        oldPanelPrerender(selfPanel)
        local a = selfPanel:GetHierarchyRoot().alpha
        if a <= 0.01 then return end

        selfPanel:drawText(o.titleText, 14, 8, 1.0, 1.0, 1.0, a, UIFont.Medium)
        selfPanel:drawText(o.messageText, 16, 52, 0.85, 0.88, 0.92, a, UIFont.Small)
    end

    o.buttons = {}
    return o
end

--- Creates and adds a button to the dialog.
--- Buttons are automatically distributed horizontally across the bottom of the panel.
---@param text string Button label.
---@param callback function|nil Function invoked when the button is clicked.
---@return PMUI.Dialog
function PMUI.Dialog:AddButton(text, callback)
    local btn = PMUI.Button:new(text)
        :SetSize(120, 32)
        :SetPositionPercent(0, 1.0)
        :SetPosition(0, -14)
        :SetAnchor(0.5, 1.0)
        :OnClick(callback)

    table.insert(self.buttons, btn)
    self.panel:AddChild(btn)

    -- Recalculate button positions to distribute all buttons evenly.
    local count = #self.buttons
    for i, b in ipairs(self.buttons) do
        local fraction = i / (count + 1)
        b:SetPositionPercent(fraction, 1.0)
    end

    return self
end

return PMUI.Dialog