require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Label"

PMUI = PMUI or {}
PMUI.Window = PMUI.Frame:derive("PMUI_Window")

--- Creates a window with a draggable header, title, close button, and content area.
---@param title string|nil Window title. Defaults to "Window".
---@param width number|nil Initial window width. Defaults to 360.
---@param height number|nil Initial window height. Defaults to 280.
---@return PMUI.Window
function PMUI.Window:new(title, width, height)
    local defaultRadius = PMUI.DefaultCornerRadius or 8
    local o = PMUI.Frame:new()
    setmetatable(o, self)
    self.__index = self

    o:SetSize(width or 360, height or 280)
    o:SetBackgroundColor(0.11, 0.12, 0.15, 0.96)
    o:SetBorderColor(0.32, 0.38, 0.48, 1.0)
    o:SetPassThroughClicks(false)
    o:SetCornerRadius(defaultRadius)

    o.headerHeight = 36
    o.header = PMUI.Frame:new()
        :SetSizePercent(1.0, 0):SetSize(0, o.headerHeight)
        :SetBackgroundColor(0.17, 0.20, 0.26, 1.0)
        :SetBorderColor(0.32, 0.38, 0.48, 1.0)
        :SetDraggable(true, o)
    o:AddChild(o.header)

    -- Match the header's top corners to the window's rounded outline.
    o.header:SetCornerRadius(defaultRadius, true)

    o.titleLabel = PMUI.Label:new(title or "Window", UIFont.Medium)
        :SetPosition(12, 8)
        :SetColor(0.95, 0.97, 1.0, 1.0)
    o.header:AddChild(o.titleLabel)

    -- The close button is anchored to the right side of the header.
    o.closeButton = PMUI.Button:new("X")
        :SetSize(26, 26)
        :SetPositionPercent(1.0, 0.5)
        :SetPosition(-6, 0)
        :SetAnchor(1.0, 0.5)
        :SetColors(
            { r = 0.45, g = 0.16, b = 0.18, a = 0.9 },
            { r = 0.72, g = 0.22, b = 0.24, a = 1.0 },
            { r = 0.35, g = 0.12, b = 0.14, a = 1.0 }
        )
        :OnClick(function()
            o:Close()
        end)
    o.header:AddChild(o.closeButton)

    -- Content occupies the area below the header.
    o.content = PMUI.Frame:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, -o.headerHeight)
        :SetPosition(0, o.headerHeight)
        :SetBackgroundColor(0, 0, 0, 0)
        :SetBorderColor(0, 0, 0, 0)
        :SetPassThroughClicks(true)
    o:AddChild(o.content)

    o.onCloseCallback = nil
    return o
end

--- Sets the window background texture.
--- When a texture is assigned, the header background and border are made transparent.
---@param textureOrPath string|Texture|nil Texture object or path to a texture.
---@return PMUI.Window
function PMUI.Window:SetTexture(textureOrPath)
    PMUI.Frame.SetTexture(self, textureOrPath)
    if self.bgTexture and self.header then
        self.header:SetBackgroundColor(0, 0, 0, 0)
        self.header:SetBorderColor(0, 0, 0, 0)
    end
    return self
end

--- Sets the sound played when the window is opened.
---@param soundName string|nil UI sound name.
---@return PMUI.Window
function PMUI.Window:SetOpenSound(soundName)
    self.openSound = soundName
    return self
end

--- Sets the sound played when the window is closed.
---@param soundName string|nil UI sound name.
---@return PMUI.Window
function PMUI.Window:SetCloseSound(soundName)
    self.closeSound = soundName
    return self
end

--- Sets the corner radius of the window and its header.
--- The header uses the top-corners-only mode to preserve the window shape.
---@param radius number Corner radius in pixels.
---@return PMUI.Window
function PMUI.Window:SetCornerRadius(radius)
    PMUI.Frame.SetCornerRadius(self, radius, false)
    if self.header then
        self.header:SetCornerRadius(radius, true)
    end
    return self
end

--- Sets the background color of the window header.
---@param r number Red component (0.0-1.0).
---@param g number Green component (0.0-1.0).
---@param b number Blue component (0.0-1.0).
---@param a number|nil Alpha component (0.0-1.0).
---@return PMUI.Window
function PMUI.Window:SetHeaderColor(r, g, b, a)
    self.header:SetBackgroundColor(r, g, b, a)
    return self
end

--- Registers a callback invoked when the window is closed.
--- The callback receives the window instance.
---@param callback function|nil Close callback.
---@return PMUI.Window
function PMUI.Window:OnClose(callback)
    self.onCloseCallback = callback
    return self
end

--- Closes the window.
--- Invokes the close callback, plays the configured sound, and fades out the window.
--- Registered instances are removed through PMUI.CloseInstance after the fade-out completes.
function PMUI.Window:Close()
    if self.onCloseCallback then
        self.onCloseCallback(self)
    end

    if self.closeSound then
        PMUI.PlaySound(self.closeSound)
    end

    if self._instanceId then
        local id = self._instanceId
        self.anim:FadeOut(0.18, function()
            PMUI.CloseInstance(id)
        end)
    else
        self:setVisible(false)
    end
end

return PMUI.Window