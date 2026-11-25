require "ProjectMotionUI/Utils"

PMUI = PMUI or {}
PMUI.Instances = PMUI.Instances or {}
PMUI.SavedStates = PMUI.SavedStates or {}

--- Recursively saves the state of all persistent elements in a UI hierarchy.
--- Each element's state is stored in the bucket using its `_stateKey`.
---
--- @param el PMUI_Element Root element or child element to process.
--- @param bucket table Storage table for serialized element states.
local function SaveElementTreeState(el, bucket)
    if not el then return end

    if el._persistState and el._stateKey then
        local data = {}
        if el.SaveState then
            el:SaveState(data)
        end
        bucket[el._stateKey] = data
    end

    if el._hierarchyChildren then
        for _, child in ipairs(el._hierarchyChildren) do
            SaveElementTreeState(child, bucket)
        end
    end
end

--- Recursively restores the state of persistent elements in a UI hierarchy.
--- Element states are retrieved from the bucket using each element's `_stateKey`.
---
--- @param el PMUI_Element Root element or child element to process.
--- @param bucket table|nil Storage table containing previously saved element states.
local function RestoreElementTreeState(el, bucket)
    if not el or not bucket then return end

    if el._persistState and el._stateKey and bucket[el._stateKey] then
        if el.LoadState then
            el:LoadState(bucket[el._stateKey])
        end
    end

    if el._hierarchyChildren then
        for _, child in ipairs(el._hierarchyChildren) do
            RestoreElementTreeState(child, bucket)
        end
    end
end

--- Creates and registers a UI instance.
--- Initializes the root element, adds it to the UI manager,
--- restores previously saved state if available and recalculates its layout.
---
--- If an instance with the same ID already exists, it is closed first.
---
--- @param id string Unique identifier of the UI instance.
--- @param rootElement PMUI_Element Root element of the UI hierarchy.
--- @param rememberState boolean|nil Whether to persist the root element's state. Defaults to the element's existing setting.
--- @return PMUI_Element|nil instance The created root element, or nil if the required arguments are missing.
function PMUI.CreateInstance(id, rootElement, rememberState)
    if not id or not rootElement then
        PLog("CreateInstance requires id and rootElement!", "error")
        return nil
    end

    if PMUI.Instances[id] then
        PMUI.CloseInstance(id)
    end

    rootElement._instanceId = id

    if rememberState ~= nil then
        rootElement:SetPersistState(rememberState, "root")
    end

    PMUI.Instances[id] = rootElement

    rootElement:initialise()
    rootElement:instantiate()
    rootElement:addToUIManager()

    if PMUI.SavedStates[id] then
        RestoreElementTreeState(rootElement, PMUI.SavedStates[id])
    end

    rootElement:RecalculateLayout()
    return rootElement
end

--- Retrieves an active UI instance by its identifier.
---
--- @param id string Unique identifier of the UI instance.
--- @return PMUI_Element|nil instance The registered root element, or nil if not found.
function PMUI.GetInstance(id)
    return PMUI.Instances[id]
end

--- Closes an active UI instance.
--- Saves the state of persistent elements before hiding the instance,
--- removing it from the UI manager and unregistering it.
---
--- @param id string Unique identifier of the UI instance to close.
function PMUI.CloseInstance(id)
    local instance = PMUI.Instances[id]
    if instance then
        local bucket = PMUI.SavedStates[id] or {}
        SaveElementTreeState(instance, bucket)
        PMUI.SavedStates[id] = bucket

        instance:setVisible(false)
        instance:removeFromUIManager()
        PMUI.Instances[id] = nil
    end
end

--- Clears saved state for a specific instance or all instances.
--- Does not close active UI instances.
---
--- @param id string|nil Instance identifier. If omitted, all saved states are cleared.
function PMUI.ResetSavedState(id)
    if id then
        PMUI.SavedStates[id] = nil
    else
        PMUI.SavedStates = {}
    end
end

--- Closes all currently registered UI instances.
--- Persistent element states are saved during the closing process.
function PMUI.CloseAll()
    for id, _ in pairs(PMUI.Instances) do
        PMUI.CloseInstance(id)
    end
end

--- Recalculates the layout of all active UI instances.
--- Registered as a callback for the game's screen resolution change event.
local function onResolutionChange()
    for _, instance in pairs(PMUI.Instances) do
        if instance and instance.RecalculateLayout then
            instance:RecalculateLayout()
        end
    end
end

--- Registers the resolution change handler when the event is available.
if Events.OnResolutionChange then
    Events.OnResolutionChange.Add(onResolutionChange)
end

return PMUI