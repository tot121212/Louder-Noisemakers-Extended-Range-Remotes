local starlitEvents = require "Starlit/Events"
if starlitEvents == nil then print("LSMRR: Failed to load Starlit Events") return end

LSMRREvents = {}

LSMRREvents.onItemLoaded = starlitEvents.new()

-- Initialize tables to store event listeners and functions
LSMRREvents.Listeners = {}
LSMRREvents.Functions = {}

-- Checks an individual item and processes its containers if it is an InventoryContainer
function LSMRREvents.Functions.checkItem(item)
    if item == nil then return end
    if instanceof(item, "InventoryContainer") then
        if item:getInventory() then
            LSMRREvents.Functions.checkFromContainer(item:getInventory())
        end
        if item:getItemContainer() then
            LSMRREvents.Functions.checkFromContainer(item:getItemContainer())
        end
    end
    if instanceof(item, "InventoryItem") then
        print("LSMRR: Remodifying item")
        LSMRREvents.onItemLoaded:trigger(item)
    end
end

function LSMRREvents.Functions.checkFromContainer(container)
    if container == nil then return end
    local containerItems = container:getItems()
    if containerItems then
        for i=0, containerItems:size()-1 do
            local item = containerItems:get(i)
            LSMRREvents.Functions.checkItem(item)
        end
    end
end

-- Handles checking multiple containers in an object or a single container
function LSMRREvents.Functions.checkAllPossibleContainers(containerObj)
    if containerObj:getContainerCount() and containerObj:getContainerCount() > 1 then
        -- Process multiple containers
        for containerindex = 0, containerObj:getContainerCount() do
            LSMRREvents.Functions.checkFromContainer(containerObj:getContainerByIndex(containerindex))
        end
    else
        -- Process single container
        if containerObj:getItemContainer() then
            LSMRREvents.Functions.checkFromContainer(containerObj:getItemContainer())
        else
            LSMRREvents.Functions.checkFromContainer(containerObj:getContainer())
        end
    end
end

-- Processes all inventories in an inventory page, including backpacks and vehicle parts
function LSMRREvents.Functions.checkAllInventories(isInventoryPage)
    local containerObj
    for i,v in ipairs(isInventoryPage.backpacks) do
        -- Check parent inventory containers
        if v.inventory:getParent() then
            containerObj = v.inventory:getParent()
            if instanceof(containerObj, "IsoObject")
            and (containerObj:getContainer() or containerObj:getItemContainer()) then
                LSMRREvents.Functions.checkAllPossibleContainers(containerObj)
            end
        end
        -- Check vehicle part containers
        if v.inventory:getVehiclePart() then
            containerObj = v.inventory:getVehiclePart()
            if instanceof(containerObj, "IsoObject")
            and containerObj:getItemContainer() then
                LSMRREvents.Functions.checkFromContainer(containerObj:getItemContainer(), containerObj)
            end
        end
    end
end

-- Checks a game world grid square for LSMRR items
function LSMRREvents.Listeners.checkGridsquareForLSMRRItems(square)
    if square == nil then return end
    local worldObjects = square:getWorldObjects()
    if worldObjects:size() == 0 then return end
    for i = 0, worldObjects:size() - 1 do
        local object = worldObjects:get(i)
        if object and instanceof(object, "IsoWorldInventoryObject") then
            local item = object:getItem()
            LSMRREvents.onItemLoaded:trigger(item)
        end
    end
end

-- Event listener for inventory window refresh
function LSMRREvents.Listeners.checkForLSMRRItemsOnRefreshEnd(isInventoryPage, state)
    if state == "end" then
        LSMRREvents.Functions.checkAllInventories(isInventoryPage)
    end
end

-- Register event listeners
Events.LoadGridsquare.Add(LSMRREvents.Listeners.checkGridsquareForLSMRRItems)
Events.ReuseGridsquare.Add(LSMRREvents.Listeners.checkGridsquareForLSMRRItems)
Events.OnRefreshInventoryWindowContainers.Add(LSMRREvents.Listeners.checkForLSMRRItemsOnRefreshEnd)
Events.OnFillContainer.Add(LSMRREvents.Listeners.checkForLSMRRItemsOnFillContainer)

return LSMRREvents