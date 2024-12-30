local globalEvents = Events
local Events = {}

local StarlitEvents = require "LSMRR/StarlitEvents"
local StarlitAddListeners = require "LSMRR/StarlitAddListeners"

-- Initialize tables to store event listeners and functions
Events.Listeners = {}
Events.Functions = {}

-- Checks an individual item and processes its containers if it is an InventoryContainer
function Events.Functions.checkItem(item)
    if not item then return end
    if instanceof(item, "InventoryContainer") then
        if item:getInventory() then
            Events.Functions.checkFromContainer(item:getInventory())
        elseif item:getItemContainer() then
            Events.Functions.checkFromContainer(item:getItemContainer())
        end
    elseif instanceof(item, "InventoryItem") then
        StarlitEvents.OnItemLoaded.trigger(item)
    end
end

function Events.Functions.checkFromContainer(container)
    if not container then return end
    local containerItems = container:getItems()
    if not containerItems then return end
    for i=0, containerItems:size()-1 do
        local item = containerItems:get(i)
        Events.Functions.checkItem(item)
    end
end

-- Handles checking multiple containers in an object or a single container
function Events.Functions.checkAllPossibleContainers(containerObj)
    if not containerObj then return end
    if containerObj:getContainerCount() and containerObj:getContainerCount() > 1 then
        -- Process multiple containers
        for containerIndex = 0, containerObj:getContainerCount() do
            Events.Functions.checkFromContainer(containerObj:getContainerByIndex(containerIndex))
        end
    else
        -- Process single container
        if containerObj:getItemContainer() then
            Events.Functions.checkFromContainer(containerObj:getItemContainer())
        else
            Events.Functions.checkFromContainer(containerObj:getContainer())
        end
    end
end

-- Processes all inventories in an inventory page, including backpacks and vehicle parts
function Events.Functions.checkAllInventories(isInventoryPage)
    if not isInventoryPage then return end
    local containerObj
    for i,v in ipairs(isInventoryPage.backpacks) do
        -- Check parent inventory containers
        if v.inventory:getParent() then
            containerObj = v.inventory:getParent()
            if not containerObj then return end
            if instanceof(containerObj, "IsoObject") and
            (containerObj:getContainer() or containerObj:getItemContainer()) then
                Events.Functions.checkAllPossibleContainers(containerObj)
            end
        end
        -- Check vehicle part containers
        if v.inventory:getVehiclePart() then
            containerObj = v.inventory:getVehiclePart()
            if not containerObj then return end
            if not instanceof(containerObj, "IsoObject")
            and containerObj:getItemContainer() then
                Events.Functions.checkFromContainer(containerObj:getItemContainer())
            end
        end
    end
end

local objectTypesToCheck = {
    "IsoWorldInventoryObject",
    "IsoTrap",
}

local function hasGetItemMethod(obj)
    for i, objectType in ipairs(objectTypesToCheck) do
        if instanceof(obj, objectType) then return true end
    end
    return false
end

-- Checks a game world grid square for LSMRR items
function Events.Listeners.checkGridsquareForLSMRRItems(gridSquare)
    print("Checking square for LSMRR items")
    if not gridSquare then return end
    local worldObjects = gridSquare:getWorldObjects()
    if not worldObjects then return end
    if worldObjects:size() == 0 then return end
    for i = 0, worldObjects:size() - 1 do
        local object = worldObjects:get(i)
        if not object then return end
        if not hasGetItemMethod(object) then return end
        local item = object:getItem()
        if not item then return end
        Events.Functions.checkItem(item)
    end
end

-- Event listener for inventory window refresh
function Events.Listeners.checkForLSMRRItemsOnRefreshEnd(isInventoryPage, state)
    if not isInventoryPage or state then return end
    if not state == "end" then return end
    print("Checking for LSMRR items on refresh end")
    Events.Functions.checkAllInventories(isInventoryPage)
end

function Events.Listener.checkForLSMRRItemsOnFillContainer(roomType, containerType, itemContainer)
    if not roomType or not containerType or not itemContainer then return end
    if itemContainer:isExplored() or itemContainer:isHasBeenLooted() then return end
    Events.checkFromContainer(itemContainer)
end

function Events.Listeners.onConnectedCheckPlayerForLSMRRItems(player)
    if not player then return end
    local inventory = player:getInventory()
    if not inventory then return end
    Events.Functions.checkFromContainer(inventory)
end

-- Register event listeners
globalEvents.LoadGridsquare.Add(Events.Listeners.checkGridsquareForLSMRRItems)
globalEvents.ReuseGridsquare.Add(Events.Listeners.checkGridsquareForLSMRRItems)
globalEvents.OnRefreshInventoryWindowContainers.Add(Events.Listeners.checkForLSMRRItemsOnRefreshEnd)
globalEvents.OnFillContainer.Add(Events.Listeners.checkForLSMRRItemsOnFillContainer)
globalEvents.OnConnected.Add(Events.Listeners.onConnectedCheckPlayerForLSMRRItems)

return Events