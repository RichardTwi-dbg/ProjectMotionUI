require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Label"

PMUI = PMUI or {}
PMUI.Toasts = PMUI.Toasts or {}
PMUI.ActiveToasts = PMUI.ActiveToasts or {}

--- Color palette used to identify notification types.
local TOAST_TYPES = {
    info    = { r = 0.28, g = 0.62, b = 0.92 },
    success = { r = 0.30, g = 0.78, b = 0.45 },
    warning = { r = 0.92, g = 0.65, b = 0.18 },
    error   = { r = 0.88, g = 0.28, b = 0.28 }
}

--- Repositions all active notifications, stacking them from the bottom-right corner.
--- Notifications that are currently closing are skipped.
local function RepositionToasts()
    local bottomMargin = 24
    local gap = 10
    local currentOffsetY = -bottomMargin

    for i = #PMUI.ActiveToasts, 1, -1 do
        local toast = PMUI.ActiveToasts[i]
        if toast and not toast._closing then
            toast.anim:Spring({ offsetY = currentOffsetY }, 180, 16)
            currentOffsetY = currentOffsetY - toast:getHeight() - gap
        end
    end
end

--- Creates and displays a toast notification.
--- Notifications are stacked in the bottom-right corner and automatically
--- close after the specified duration. Clicking a notification closes it immediately.
---
--- @param title string|nil Notification title. Defaults to "Notification".
--- @param message string|nil Notification message displayed below the title.
--- @param toastType string|nil Notification type: "info", "success", "warning" or "error".
--- @param duration number|nil Time in seconds before the notification closes. Defaults to 3.5.
--- @return PMUI_Frame toast The created notification frame.
function PMUI.Notify(title, message, toastType, duration)
    local theme = PMUI.GetTheme()
    local stripeColor = TOAST_TYPES[toastType or "info"] or TOAST_TYPES.info
    duration = duration or 3.5

    local id = "PMUI_Toast_" .. tostring(ZombRand(1000000))
    local toastW = 320
    local toastH = 66

    local toast = PMUI.Frame:new()
        :SetSize(toastW, toastH)
        :SetPositionPercent(1.0, 1.0)
        :SetPosition(-20, -24)
        :SetAnchor(1.0, 1.0)
        :SetBackgroundColor(theme.windowBg.r, theme.windowBg.g, theme.windowBg.b, 0.96)
        :SetBorderColor(theme.windowBorder.r, theme.windowBorder.g, theme.windowBorder.b, 0.9)
        :SetPassThroughClicks(false)

    local stripe = PMUI.Frame:new()
        :SetSize(5, toastH)
        :SetPosition(0, 0)
        :SetBackgroundColor(stripeColor.r, stripeColor.g, stripeColor.b, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    toast:AddChild(stripe)

    toast:AddChild(
        PMUI.Label:new(title or "Notification", UIFont.Medium)
            :SetPosition(14, 10)
            :SetColor(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 1.0)
    )
    toast:AddChild(
        PMUI.Label:new(message or "", UIFont.Small)
            :SetPosition(14, 34)
            :SetColor(theme.textSecondary.r, theme.textSecondary.g, theme.textSecondary.b, 1.0)
    )

    local timerBar = PMUI.Frame:new()
        :SetSize(toastW - 5, 3)
        :SetPosition(5, toastH - 3)
        :SetBackgroundColor(stripeColor.r, stripeColor.g, stripeColor.b, 0.85)
        :SetBorderColor(0, 0, 0, 0)
    toast:AddChild(timerBar)

    --- Closes the notification and removes it from the active list.
    --- Repositions remaining notifications and plays the exit animation.
    local function CloseToast()
        if toast._closing then return end
        toast._closing = true

        for idx, t in ipairs(PMUI.ActiveToasts) do
            if t == toast then
                table.remove(PMUI.ActiveToasts, idx)
                break
            end
        end
        RepositionToasts()

        toast.anim:Tween("toast_exit", { animOffsetX = 60, alpha = 0 }, 0.22, PMUI.Easing.QuadOut, function()
            PMUI.CloseInstance(id)
        end)
    end

    --- Handles clicks on the notification frame.
    --- @return boolean True to consume the mouse event.
    toast.onMouseDown = function()
        CloseToast()
        return true
    end

    table.insert(PMUI.ActiveToasts, toast)
    PMUI.CreateInstance(id, toast)
    RepositionToasts()

    if getSoundManager() then
        getSoundManager():playUISound("UIToggleTick")
    end
    toast.anim:FadeIn(0.2)
    toast.anim:SlideIn("right", 50, 0.28)

    timerBar.anim:Tween("toast_timer", { offsetW = 0 }, duration, PMUI.Easing.Linear, function()
        CloseToast()
    end)

    return toast
end

return PMUI.Notify