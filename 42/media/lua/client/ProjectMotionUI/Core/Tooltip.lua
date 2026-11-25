require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Label"

PMUI = PMUI or {}
PMUI.TooltipManager = PMUI.TooltipManager or {}

--- Unique instance identifier for the global tooltip.
local TOOLTIP_ID = "PMUI_Global_Tooltip"

--- Element currently displaying a tooltip.
local activeTarget = nil

--- Root frame of the global tooltip.
local tooltipBox = nil

--- Label displaying the tooltip title.
local titleLbl = nil

--- Label displaying the tooltip description.
local descLbl = nil

--- Creates the global tooltip instance if it does not already exist.
--- Initializes its frame, labels, theme colors and visibility.
local function EnsureTooltipCreated()
    if tooltipBox and PMUI.GetInstance(TOOLTIP_ID) then
        return
    end

    local theme = PMUI.GetTheme()
    tooltipBox = PMUI.Frame:new()
        :SetSize(200, 50)
        :SetBackgroundColor(0.06, 0.07, 0.09, 0.96)
        :SetBorderColor(theme.accent.r, theme.accent.g, theme.accent.b, 0.95)
        :SetPassThroughClicks(true)

    titleLbl = PMUI.Label:new("", UIFont.Small)
        :SetPosition(10, 6)
        :SetColor(theme.accent.r, theme.accent.g, theme.accent.b, 1.0)
    tooltipBox:AddChild(titleLbl)

    descLbl = PMUI.Label:new("", UIFont.Small)
        :SetPosition(10, 24)
        :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 0.92)
    tooltipBox:AddChild(descLbl)

    PMUI.CreateInstance(TOOLTIP_ID, tooltipBox)
    tooltipBox:setVisible(false)
end

--- Updates the global tooltip for the specified UI element.
--- Displays the tooltip when the element is hovered and hides it when
--- the mouse leaves the active target.
---
--- Tooltip content is read from the element's `_tooltipData` field:
--- `title` is optional, while `text` contains the description.
--- The tooltip is positioned near the mouse cursor and adjusted
--- to remain within the screen boundaries.
---
--- @param el ISUIElement UI element whose tooltip should be updated.
function PMUI.TooltipManager.UpdateForElement(el)
    if not el._tooltipData or not el:isVisible() or el.alpha <= 0.1 then return end

    if el:isMouseOver() then
        EnsureTooltipCreated()

        if activeTarget ~= el then
            activeTarget = el
            local data = el._tooltipData
            local hasTitle = (data.title and data.title ~= "")
            local hasDesc  = (data.text and data.text ~= "")

            titleLbl:setVisible(hasTitle)
            descLbl:setVisible(hasDesc)

            local maxW = 60
            local totalH = 10

            if hasTitle then
                titleLbl:SetText(data.title)
                maxW = math.max(maxW, titleLbl:getWidth() + 20)
                totalH = totalH + titleLbl:getHeight() + 4
            end

            if hasDesc then
                descLbl:SetText(data.text)
                descLbl:SetPosition(10, hasTitle and (titleLbl:getHeight() + 10) or 7)
                maxW = math.max(maxW, descLbl:getWidth() + 20)
                totalH = totalH + descLbl:getHeight() + 4
            end

            tooltipBox:SetSize(maxW, totalH)
            tooltipBox:setVisible(true)
            if tooltipBox.javaObject then
                tooltipBox:bringToTop()
            end
            tooltipBox.anim:FadeIn(0.12)
        end

        local mx = getMouseX()
        local my = getMouseY()
        local screenW = getCore():getScreenWidth()
        local screenH = getCore():getScreenHeight()
        local boxW = tooltipBox:getWidth()
        local boxH = tooltipBox:getHeight()

        local targetX = mx + 14
        local targetY = my + 16

        if targetX + boxW > screenW - 8 then
            targetX = mx - boxW - 10
        end
        if targetY + boxH > screenH - 8 then
            targetY = my - boxH - 10
        end

        tooltipBox:SetPosition(targetX, targetY)
    elseif activeTarget == el then
        activeTarget = nil
        if tooltipBox then
            tooltipBox:setVisible(false)
        end
    end
end

return PMUI.TooltipManager