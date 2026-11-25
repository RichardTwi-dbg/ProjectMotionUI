require "ISUI/ISTextEntryBox"
require "ProjectMotionUI/Core/BaseElement"

PMUI = PMUI or {}
PMUI.TextInput = PMUI.BaseElement:derive("PMUI_TextInput")

--- Creates a text input field with an optional placeholder.
---@param placeholder string|nil Text displayed when the input is empty and unfocused.
---@return PMUI.TextInput
function PMUI.TextInput:new(placeholder)
    local o = PMUI.BaseElement:new()
    setmetatable(o, self)
    self.__index = self

    o.passThroughClicks = false
    o.offsetW = 200
    o.offsetH = 30
    o.placeholder = placeholder or ""
    o.onTextChangeCallback = nil

    o.entry = ISTextEntryBox:new("", 0, 0, o.offsetW, o.offsetH)
    o.entry.font = UIFont.Small
    o.entry.backgroundColor = { r = 0.08, g = 0.09, b = 0.11, a = 0.95 }
    o.entry.borderColor = { r = 0.35, g = 0.40, b = 0.48, a = 1.0 }

    -- Forward text changes from the native input control to the PMUI callback.
    o.entry.onTextChange = function()
        if o.onTextChangeCallback then
            o.onTextChangeCallback(o:GetText(), o)
        end
    end

    return o
end

--- Initializes the base element and its native text entry control.
--- Adds the input control as a child and synchronizes its dimensions.
function PMUI.TextInput:instantiate()
    PMUI.BaseElement.instantiate(self)
    self.entry:initialise()
    self.entry:instantiate()
    self:addChild(self.entry)
    self:SyncEntrySize()
end

--- Synchronizes the native text entry dimensions with the parent element.
--- Updates both the Lua control and its Java UI object when available.
function PMUI.TextInput:SyncEntrySize()
    if self.entry then
        self.entry:setWidth(self:getWidth())
        self.entry:setHeight(self:getHeight())
        if self.entry.javaObject then
            self.entry.javaObject:setWidth(self:getWidth())
            self.entry.javaObject:setHeight(self:getHeight())
        end
    end
end

--- Recalculates the element layout and updates the native input dimensions.
function PMUI.TextInput:RecalculateLayout()
    PMUI.BaseElement.RecalculateLayout(self)
    self:SyncEntrySize()
end

--- Returns the current text entered by the user.
---@return string
function PMUI.TextInput:GetText()
    return self.entry:getText() or ""
end

--- Sets the text displayed in the input field.
---@param text string|nil Text to assign. Nil is treated as an empty string.
---@return PMUI.TextInput
function PMUI.TextInput:SetText(text)
    self.entry:setText(text or "")
    return self
end

--- Registers a callback invoked whenever the input text changes.
--- The callback receives the current text and the TextInput instance.
---@param callback function|nil Text change callback.
---@return PMUI.TextInput
function PMUI.TextInput:OnChange(callback)
    self.onTextChangeCallback = callback
    return self
end

--- Renders the native input control and its placeholder when applicable.
--- The placeholder is hidden while the field is focused or contains text.
function PMUI.TextInput:render()
    PMUI.BaseElement.render(self)
    if self:GetText() == "" and self.placeholder ~= "" and not self.entry:isFocused() then
        local textH = getTextManager():MeasureStringY(self.entry.font, self.placeholder)
        local y = (self:getHeight() - textH) / 2
        self:drawText(self.placeholder, 8, y, 0.5, 0.55, 0.6, 0.8 * self.alpha, self.entry.font)
    end
end

--- Saves the current input text into the provided state table.
---@param data table State table to populate.
function PMUI.TextInput:SaveState(data)
    data.text = self:GetText()
end

--- Restores the input text from a previously saved state.
---@param data table State table containing the saved text.
function PMUI.TextInput:LoadState(data)
    if data.text ~= nil then
        self:SetText(data.text)
    end
end

return PMUI.TextInput