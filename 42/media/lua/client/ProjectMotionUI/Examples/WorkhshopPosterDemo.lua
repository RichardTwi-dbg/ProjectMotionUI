require "ProjectMotionUI/ProjectMotionUI"
require "ProjectMotionUI/Core/Theme"
require "ProjectMotionUI/Core/Toast"
require "ProjectMotionUI/Core/Style"
require "ProjectMotionUI/Components/Window"
require "ProjectMotionUI/Components/Frame"
require "ProjectMotionUI/Components/Button"
require "ProjectMotionUI/Components/Label"
require "ProjectMotionUI/Components/ProgressBar"
require "ProjectMotionUI/Components/Slider"
require "ProjectMotionUI/Components/Checkbox"
require "ProjectMotionUI/Components/Dropdown"
require "ProjectMotionUI/Components/Shape"
require "ProjectMotionUI/Components/Image"
require "ProjectMotionUI/Layouts/StackLayout"
require "ProjectMotionUI/Layouts/GridLayout"

local POSTER_ID = "PMUI_Workshop_Poster_Showcase"
local ICON_ID = "PMUI_Workshop_Icon_256"

function PMUI.OpenWorkshopIcon()
    if PMUI.GetInstance(ICON_ID) then
        PMUI.CloseInstance(ICON_ID)
        return
    end

    local iconBox = PMUI.Frame:new()
        :SetSize(256, 256)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.07, 0.08, 0.11, 1.0)
        :SetBorderColor(0.28, 0.68, 0.98, 1.0)
        :SetCornerRadius(24)
        :SetDraggable(true)

    local aura = PMUI.Shape:new("diamond")
        :SetSize(236, 236)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetColor(0.20, 0.58, 0.95, 0.14)
    iconBox:AddChild(aura)

    local gem = PMUI.Shape:new()
        :SetSize(210, 210)
        :SetPositionPercent(0.5, 0.52)
        :SetAnchor(0.5, 0.5)

    local cTopHighlight = { r = 0.72, g = 0.92, b = 1.00, a = 1.0 }
    local cLeftLight    = { r = 0.35, g = 0.78, b = 1.00, a = 1.0 }
    local cCenterMain   = { r = 0.22, g = 0.62, b = 0.96, a = 1.0 }
    local cRightMid     = { r = 0.14, g = 0.46, b = 0.82, a = 1.0 }
    local cDeepShadow   = { r = 0.09, g = 0.30, b = 0.60, a = 1.0 }

    local crownSteps = 12
    for i = 0, crownSteps - 1 do
        local t = i / (crownSteps - 1)
        local y = 0.08 + t * 0.28
        local h = (0.28 / crownSteps) + 0.006
        local totalW = 0.52 + t * 0.44
        local startX = (1.0 - totalW) / 2.0

        local wLeft  = totalW * 0.28
        local wMid   = totalW * 0.44
        local wRight = totalW * 0.28

        gem:AddPart(startX, y, wLeft, h, cLeftLight)
        gem:AddPart(startX + wLeft, y, wMid, h, (i < 4) and cTopHighlight or cCenterMain)
        gem:AddPart(startX + wLeft + wMid, y, wRight, h, cRightMid)
    end

    local pavSteps = 24
    for i = 0, pavSteps - 1 do
        local t = i / (pavSteps - 1)
        local y = 0.36 + t * 0.58
        local h = (0.58 / pavSteps) + 0.006
        local totalW = math.max(0.02, 0.96 * (1.0 - t))
        local startX = (1.0 - totalW) / 2.0

        local wLeft  = totalW * 0.30
        local wMid   = totalW * 0.40
        local wRight = totalW * 0.30

        gem:AddPart(startX, y, wLeft, h, cCenterMain)
        gem:AddPart(startX + wLeft, y, wMid, h, cLeftLight)
        gem:AddPart(startX + wLeft + wMid, y, wRight, h, (t > 0.45) and cDeepShadow or cRightMid)
    end

    gem:AddPart(0.24, 0.16, 0.10, 0.05, { r = 1.0, g = 1.0, b = 1.0, a = 0.95 })
    gem:AddPart(0.21, 0.22, 0.06, 0.06, { r = 1.0, g = 1.0, b = 1.0, a = 0.75 })

    iconBox:AddChild(gem)

    iconBox.onMouseDown = function()
        gem.anim:Bounce(10, 0.35)
        gem.anim:PlayEffect("Pulse", 0.5, { minAlpha = 0.75 })
        return true
    end

    PMUI.CreateInstance(ICON_ID, iconBox)
    iconBox.anim:FadeIn(0.25)
end

Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_F9 then
        PMUI.OpenWorkshopIcon()
    end
end)


function PMUI.OpenWorkshopPoster()
    if PMUI.GetInstance(POSTER_ID) then
        PMUI.CloseInstance(POSTER_ID)
        return
    end

    local card = PMUI.Frame:new()
        :SetSize(512, 512)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.09, 0.10, 0.13, 0.98)
        :SetBorderColor(0.28, 0.62, 0.92, 1.0)
        :SetCornerRadius(14)
        :SetDraggable(true)

    local header = PMUI.Frame:new()
        :SetSizePercent(1.0, 0):SetSize(0, 44)
        :SetBackgroundColor(0.13, 0.16, 0.22, 1.0)
        :SetBorderColor(0.28, 0.62, 0.92, 0.8)
        :SetCornerRadius(14, true)
    card:AddChild(header)

    header:AddChild(
        PMUI.Label:new("PROJECT MOTION UI", UIFont.Medium)
            :SetPosition(16, 12)
            :SetColor(0.96, 0.98, 1.0, 1.0)
    )

    local badge = PMUI.Frame:new()
        :SetSize(84, 24)
        :SetPositionPercent(1.0, 0.5)
        :SetPosition(-14, 0)
        :SetAnchor(1.0, 0.5)
        :SetBackgroundColor(0.28, 0.62, 0.92, 0.22)
        :SetBorderColor(0.28, 0.62, 0.92, 0.9)
        :SetCornerRadius(6)
    header:AddChild(badge)

    badge:AddChild(
        PMUI.Label:new("LUA | B42", UIFont.Small)
            :SetPosition(14, 4)
            :SetColor(0.55, 0.85, 1.0, 1.0)
    )

    local mainVBox = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, -44)
        :SetPosition(0, 44)
        :SetPadding(18)
        :SetGap(12)
    card:AddChild(mainVBox)

    local heroBox = PMUI.Frame:new()
        :SetSize(484, 114)
        :SetBackgroundColor(0.12, 0.14, 0.19, 0.95)
        :SetBorderColor(0.25, 0.30, 0.40, 0.9)
        :SetCornerRadius(10)
    mainVBox:AddChild(heroBox)

    heroBox:AddChild(
        PMUI.Label:new("PMUI FRAMEWORK", UIFont.Large)
            :SetPosition(16, 12)
            :SetColor(0.28, 0.68, 0.98, 1.0)
    )

    heroBox:AddChild(
        PMUI.Label:new("Adaptive Layouts  |  Spring Physics  |  Fluent API", UIFont.Small)
            :SetPosition(16, 46)
            :SetColor(0.82, 0.86, 0.94, 1.0)
    )

    local shapesRow = PMUI.HBox:new()
        :SetPosition(16, 72)
        :SetGap(14)
        :SetAutoSize(true)
    heroBox:AddChild(shapesRow)

    shapesRow:AddChild(PMUI.Shape:new("diamond"):SetSize(26, 26):SetColor(0.28, 0.82, 0.98, 1.0))
    shapesRow:AddChild(PMUI.Shape:new("circle"):SetSize(26, 26):SetColor(0.95, 0.65, 0.20, 1.0))
    shapesRow:AddChild(PMUI.Shape:new("crosshair"):SetSize(26, 26):SetColor(0.35, 0.90, 0.50, 1.0))
    shapesRow:AddChild(PMUI.Shape:new("triangle"):SetSize(26, 26):SetColor(0.92, 0.32, 0.42, 1.0))
    shapesRow:AddChild(PMUI.Image:new("media/ui/Heart_On.png"):SetSize(26, 26):SetTint(1.0, 0.35, 0.40, 1.0))

    local columns = PMUI.HBox:new():SetGap(12):SetAutoSize(true)
    mainVBox:AddChild(columns)

    local leftCard = PMUI.Frame:new()
        :SetSize(236, 224)
        :SetBackgroundColor(0.12, 0.14, 0.18, 0.95)
        :SetBorderColor(0.25, 0.30, 0.40, 0.85)
        :SetCornerRadius(10)
    columns:AddChild(leftCard)

    local leftVBox = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(12)
        :SetGap(9)
    leftCard:AddChild(leftVBox)

    leftVBox:AddChild(
        PMUI.Label:new("UI COMPONENTS", UIFont.Small)
            :SetColor(0.55, 0.85, 1.0, 1.0)
    )

    local bar = PMUI.ProgressBar:new(0, 100)
        :SetSize(212, 22)
        :SetValue(78, true)
    leftVBox:AddChild(bar)

    local slider = PMUI.Slider:new(0, 100, 1)
        :SetSize(212, 20)
        :SetValue(78, false)
        :OnChange(function(v)
            bar:SetValue(v, false)
        end)
    leftVBox:AddChild(slider)

    leftVBox:AddChild(
        PMUI.Checkbox:new("Spring Physics Enabled", true)
    )

    leftVBox:AddChild(
        PMUI.Checkbox:new("Persist Window State", true)
    )

    leftVBox:AddChild(
        PMUI.Dropdown:new({ "Theme: Cyber Dark", "Theme: Zomboid", "Theme: Military" }, 1)
            :SetSize(212, 30)
    )

    local rightCard = PMUI.Frame:new()
        :SetSize(236, 224)
        :SetBackgroundColor(0.12, 0.14, 0.18, 0.95)
        :SetBorderColor(0.25, 0.30, 0.40, 0.85)
        :SetCornerRadius(10)
    columns:AddChild(rightCard)

    local rightVBox = PMUI.VBox:new()
        :SetSizePercent(1.0, 1.0):SetSize(0, 0)
        :SetPadding(12)
        :SetGap(9)
    rightCard:AddChild(rightVBox)

    rightVBox:AddChild(
        PMUI.Label:new("MOTION & STYLES", UIFont.Small)
            :SetColor(0.95, 0.68, 0.25, 1.0)
    )

    rightVBox:AddChild(
        PMUI.Button:new("Primary Action")
            :SetSize(212, 34)
            :ApplyStyle("PrimaryButton")
            :OnClick(function(btn)
                btn.anim:Impulse(300, -180, 220, 9)
            end)
    )

    rightVBox:AddChild(
        PMUI.Button:new("Danger Shatter FX")
            :SetSize(212, 34)
            :ApplyStyle("DangerButton")
            :OnClick(function(btn)
                btn.anim:Shake(8, 0.35)
            end)
    )

    local toastPreview = PMUI.Frame:new()
        :SetSize(212, 58)
        :SetBackgroundColor(0.08, 0.10, 0.13, 0.98)
        :SetBorderColor(0.30, 0.78, 0.45, 0.95)
        :SetCornerRadius(6)
    rightVBox:AddChild(toastPreview)

    local stripe = PMUI.Frame:new()
        :SetSize(4, 58)
        :SetPosition(0, 0)
        :SetBackgroundColor(0.30, 0.78, 0.45, 1.0)
        :SetBorderColor(0, 0, 0, 0)
    toastPreview:AddChild(stripe)

    toastPreview:AddChild(
        PMUI.Label:new("Toast Notification", UIFont.Small)
            :SetPosition(12, 8)
            :SetColor(0.35, 0.88, 0.52, 1.0)
    )
    toastPreview:AddChild(
        PMUI.Label:new("Zero FPS impact in Kahlua!", UIFont.Small)
            :SetPosition(12, 28)
            :SetColor(0.80, 0.84, 0.90, 1.0)
    )

    local footer = PMUI.Frame:new()
        :SetSize(484, 34)
        :SetBackgroundColor(0.13, 0.16, 0.22, 0.9)
        :SetBorderColor(0.25, 0.30, 0.40, 0.7)
        :SetCornerRadius(8)
    mainVBox:AddChild(footer)

    footer:AddChild(
        PMUI.Label:new("docs.pmui.blacklist-vpn.ru   |   Open-Source Modding Library", UIFont.Small)
            :SetPosition(16, 9)
            :SetColor(0.65, 0.75, 0.88, 1.0)
    )

    PMUI.CreateInstance(POSTER_ID, card)
    card.anim:FadeIn(0.25)
    card.anim:SlideIn("top", 25, 0.3)
end

Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_F9 then
        PMUI.OpenWorkshopPoster()
    end
end)

local CONCEPT_ID = "PMUI_Workshop_Concept_512"

local function CreateFacetedGem(size)
    local gem = PMUI.Shape:new():SetSize(size, size)

    local cTopHighlight = { r = 0.75, g = 0.94, b = 1.00, a = 1.0 }
    local cLeftLight    = { r = 0.35, g = 0.78, b = 1.00, a = 1.0 }
    local cCenterMain   = { r = 0.22, g = 0.62, b = 0.96, a = 1.0 }
    local cRightMid     = { r = 0.14, g = 0.46, b = 0.82, a = 1.0 }
    local cDeepShadow   = { r = 0.09, g = 0.30, b = 0.60, a = 1.0 }

    local crownSteps = 10
    for i = 0, crownSteps - 1 do
        local t = i / (crownSteps - 1)
        local y = 0.08 + t * 0.28
        local h = (0.28 / crownSteps) + 0.008
        local totalW = 0.52 + t * 0.44
        local startX = (1.0 - totalW) / 2.0

        local wLeft  = totalW * 0.28
        local wMid   = totalW * 0.44
        local wRight = totalW * 0.28

        gem:AddPart(startX, y, wLeft, h, cLeftLight)
        gem:AddPart(startX + wLeft, y, wMid, h, (i < 3) and cTopHighlight or cCenterMain)
        gem:AddPart(startX + wLeft + wMid, y, wRight, h, cRightMid)
    end

    local pavSteps = 20
    for i = 0, pavSteps - 1 do
        local t = i / (pavSteps - 1)
        local y = 0.36 + t * 0.58
        local h = (0.58 / pavSteps) + 0.008
        local totalW = math.max(0.02, 0.96 * (1.0 - t))
        local startX = (1.0 - totalW) / 2.0

        local wLeft  = totalW * 0.30
        local wMid   = totalW * 0.40
        local wRight = totalW * 0.30

        gem:AddPart(startX, y, wLeft, h, cCenterMain)
        gem:AddPart(startX + wLeft, y, wMid, h, cLeftLight)
        gem:AddPart(startX + wLeft + wMid, y, wRight, h, (t > 0.45) and cDeepShadow or cRightMid)
    end

    gem:AddPart(0.24, 0.16, 0.10, 0.05, { r = 1.0, g = 1.0, b = 1.0, a = 0.95 })
    return gem
end

function PMUI.OpenWorkshopConcept512()
    if PMUI.GetInstance(CONCEPT_ID) then
        PMUI.CloseInstance(CONCEPT_ID)
        return
    end

    local canvas = PMUI.Frame:new()
        :SetSize(512, 512)
        :SetPositionPercent(0.5, 0.5)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.07, 0.08, 0.11, 1.0)
        :SetBorderColor(0.28, 0.65, 0.98, 1.0)
        :SetCornerRadius(18)
        :SetDraggable(true)

    for gx = 64, 448, 64 do
        canvas:AddChild(
            PMUI.Frame:new()
                :SetSize(1, 480):SetPosition(gx, 16)
                :SetBackgroundColor(0.28, 0.65, 0.98, 0.07)
                :SetBorderColor(0, 0, 0, 0)
        )
    end
    for gy = 64, 448, 64 do
        canvas:AddChild(
            PMUI.Frame:new()
                :SetSize(480, 1):SetPosition(16, gy)
                :SetBackgroundColor(0.28, 0.65, 0.98, 0.07)
                :SetBorderColor(0, 0, 0, 0)
        )
    end

    local titleLbl = PMUI.Label:new("PROJECT MOTION UI", UIFont.Large)
        :SetPositionPercent(0.5, 0.09)
        :SetAnchor(0.5, 0.5)
        :SetColor(0.96, 0.98, 1.0, 1.0)
    canvas:AddChild(titleLbl)

    local subTitle = PMUI.Label:new("NEXT-GEN UI & PHYSICS ENGINE FOR PROJECT ZOMBOID", UIFont.Small)
        :SetPositionPercent(0.5, 0.15)
        :SetAnchor(0.5, 0.5)
        :SetColor(0.35, 0.78, 1.0, 1.0)
    canvas:AddChild(subTitle)

    local outerRing = PMUI.Frame:new()
        :SetSize(190, 190)
        :SetPositionPercent(0.5, 0.42)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.28, 0.65, 0.98, 0.06)
        :SetBorderColor(0.28, 0.65, 0.98, 0.35)
        :SetCornerRadius(95)
    canvas:AddChild(outerRing)

    local innerRing = PMUI.Frame:new()
        :SetSize(142, 142)
        :SetPositionPercent(0.5, 0.42)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.28, 0.65, 0.98, 0.10)
        :SetBorderColor(0.45, 0.85, 1.0, 0.55)
        :SetCornerRadius(71)
    canvas:AddChild(innerRing)

    canvas:AddChild(PMUI.Frame:new():SetSize(70, 2):SetPosition(85, 214):SetBackgroundColor(0.28, 0.68, 0.98, 0.5):SetBorderColor(0,0,0,0))
    canvas:AddChild(PMUI.Frame:new():SetSize(70, 2):SetPosition(357, 214):SetBackgroundColor(0.95, 0.65, 0.22, 0.5):SetBorderColor(0,0,0,0))

    local centerGem = CreateFacetedGem(112)
        :SetPositionPercent(0.5, 0.42)
        :SetAnchor(0.5, 0.5)
    canvas:AddChild(centerGem)

    local leftNode = PMUI.Shape:new("crosshair")
        :SetSize(28, 28)
        :SetPosition(68, 201)
        :SetColor(0.35, 0.85, 1.0, 0.95)
    canvas:AddChild(leftNode)

    local rightNode = PMUI.Shape:new("circle")
        :SetSize(24, 24)
        :SetPosition(420, 203)
        :SetColor(0.98, 0.65, 0.22, 0.95)
    canvas:AddChild(rightNode)

    local pillarsGrid = PMUI.GridLayout:new(2, 224, 72)
        :SetPositionPercent(0.5, 0.75)
        :SetAnchor(0.5, 0.5)
        :SetPadding(0)
        :SetGap(12, 12)
    canvas:AddChild(pillarsGrid)

    local function CreatePillarCard(title, desc, accentCol, iconShape)
        local card = PMUI.Frame:new()
            :SetBackgroundColor(0.11, 0.13, 0.18, 0.96)
            :SetBorderColor(accentCol.r, accentCol.g, accentCol.b, 0.75)
            :SetCornerRadius(10)

        card:AddChild(
            PMUI.Frame:new()
                :SetSize(4, 72):SetPosition(0, 0)
                :SetBackgroundColor(accentCol.r, accentCol.g, accentCol.b, 1.0)
                :SetBorderColor(0, 0, 0, 0)
        )

        iconShape:SetPosition(16, 22):SetColor(accentCol.r, accentCol.g, accentCol.b, 1.0)
        card:AddChild(iconShape)

        card:AddChild(
            PMUI.Label:new(title, UIFont.Medium)
                :SetPosition(52, 14)
                :SetColor(0.96, 0.98, 1.0, 1.0)
        )
        card:AddChild(
            PMUI.Label:new(desc, UIFont.Small)
                :SetPosition(52, 38)
                :SetColor(0.72, 0.78, 0.88, 1.0)
        )
        return card
    end

    pillarsGrid:AddChild(
        CreatePillarCard(
            "ADAPTIVE LAYOUT",
            "Scale + Offset + VBox/Grid",
            { r = 0.28, g = 0.75, b = 0.98 },
            PMUI.Shape:new("crosshair"):SetSize(26, 26)
        )
    )

    pillarsGrid:AddChild(
        CreatePillarCard(
            "SPRING PHYSICS",
            "Tweens, Throw, Shatter FX",
            { r = 0.98, g = 0.62, b = 0.20 },
            PMUI.Shape:new("triangle"):SetSize(26, 26)
        )
    )

    pillarsGrid:AddChild(
        CreatePillarCard(
            "FULL STYLING",
            "Themes, Textures & Sounds",
            { r = 0.72, g = 0.45, b = 0.98 },
            PMUI.Shape:new("diamond"):SetSize(26, 26)
        )
    )

    pillarsGrid:AddChild(
        CreatePillarCard(
            "ZERO FPS DROP",
            "Event-driven Kahlua Core",
            { r = 0.30, g = 0.88, b = 0.52 },
            PMUI.Shape:new("circle"):SetSize(26, 26)
        )
    )

    local footer = PMUI.Frame:new()
        :SetSize(460, 28)
        :SetPositionPercent(0.5, 0.94)
        :SetAnchor(0.5, 0.5)
        :SetBackgroundColor(0.12, 0.15, 0.20, 0.9)
        :SetBorderColor(0.28, 0.65, 0.98, 0.4)
        :SetCornerRadius(6)
    canvas:AddChild(footer)

    footer:AddChild(
        PMUI.Label:new("           BUILD 42   |   docs.pmui.blacklist-vpn.ru", UIFont.Small)
            :SetPositionPercent(0.5, 0.5)
            :SetAnchor(0.5, 0.5)
            :SetColor(0.75, 0.85, 0.96, 1.0)
    )

    canvas.onMouseDown = function()
        centerGem.anim:Bounce(10, 0.35)
        leftNode.anim:Impulse(-120, 0, 180, 10)
        rightNode.anim:Impulse(120, 0, 180, 10)
        return true
    end

    PMUI.CreateInstance(CONCEPT_ID, canvas)
    canvas.anim:FadeIn(0.25)
end

Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_F10 then
        PMUI.OpenWorkshopConcept512()
    end
end)

