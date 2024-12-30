local Main = {}

local Events = require "LSMRR/Events"

-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

local baseProgressBarMax = 100
local progressBarMax = baseProgressBarMax
function Main.getProgressBarMax() return progressBarMax end

-- Remote Controller ranges
local RemoteItemData = {
    ["Base.RemoteCraftedV1"] = SandboxVars['LSMRR']['RemoteCraftedV1Range'],
    ["Base.RemoteCraftedV2"] = SandboxVars['LSMRR']['RemoteCraftedV2Range'],
    ["Base.RemoteCraftedV3"] = SandboxVars['LSMRR']['RemoteCraftedV3Range'],
}

-- Maps recipe to volume and allows higher specificity with item tables
local RecipeVolumeTable = {
    ["LSMRRBoostWatchVolume"] = {
        ["nameModPrepend"] = "Bass Boosted",
        ["volume"] = SandboxVars['LSMRR']['DigitalWatchVolume'],
    },
    ["LSMRRAdjustGearsOnAlarmClock"] = {
        ["nameModPrepend"] = "Tuned",
        ["volume"] = SandboxVars['LSMRR']['AlarmClockVolume'],
    },
    ["LSMRRModulateNoiseMakerVolume"] = {
        ["nameModPrepend"] = "Hacked",
        ["volume"] = SandboxVars['LSMRR']['NoiseMakerVolume'],
    },
    ["LSMRRAttachAmplifierToNoiseMaker"] = {
        ["nameModPrepend"] = "Amplified",
        ["volume"] = SandboxVars['LSMRR']['AmplifiedNoiseMakerVolume'],
    },
    ["LSMRRExtendRangeOfRemoteController"] = {
        ["nameModPrepend"] = "Extended",
        ["volume"] = nil,
        ["items"] = RemoteItemData,  -- Reference to the external items table
    },
}

function Main.getRecipeVolume(recipeName, scriptItemName)
    --print("Recipe name: " .. recipeName)
    --print("Script item name: " .. scriptItemName)
    local newVolumeOfItem;
    -- ensure recipe is valid
    local recipeTableData = RecipeVolumeTable[recipeName]
    if not recipeTableData then return end
    -- if recipe has volume
    newVolumeOfItem = recipeTableData["volume"]
    if newVolumeOfItem then return newVolumeOfItem end
    -- if input item for recipe has volume
    
    newVolumeOfItem = recipeTableData["items"][scriptItemName]
    if newVolumeOfItem then return newVolumeOfItem end
end

---@type LSMRR.Events.Callback_OnLoadExistingItem
Main.SetItemPropertiesFromModData = function(inventoryItem, isoObject)
    if not inventoryItem:hasModData() then return end
    local modData = inventoryItem:getModData()
    if not modData["LSMRR"] then return end
    
    if modData["LSMRR"]["hasModifiedVolume"] then
        --print("LSMRR: Setting modified volume")
        local recipeToCraftItem = modData["LSMRR"]["recipeUsedToCraft"]
        if not recipeToCraftItem then return end
        local scriptItemName =  inventoryItem:getScriptItem():getFullName()
        if not scriptItemName then return end
        local newVolume = Main.getRecipeVolume(recipeToCraftItem, scriptItemName)
        if not newVolume then return end
        if modData["LSMRR"]["hasIncreasedSoundRadius"] then
            inventoryItem:setSoundRadius(newVolume)
            --print("Updated sound radius: " .. inventoryItem:getSoundRadius())
        elseif modData["LSMRR"]["hasIncreasedNoiseRange"] then
            inventoryItem:setNoiseRange(newVolume)
            --print("Updated noise range: " .. inventoryItem:getNoiseRange())
        elseif modData["LSMRR"]["hasIncreasedRemoteRange"] then
            inventoryItem:setRemoteRange(newVolume)
            --print("Updated remote range: " .. inventoryItem:getRemoteRange())
        end
    end
end

--- add set item properties to OnLoadItem event
Events.OnLoadExistingItem:addListener(Main.SetItemPropertiesFromModData)

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function Main.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    print("LSMRR.MakeLouder")
    if not inputItemModData then inputItemModData = {} end
    if not inputItemModData["LSMRR"] then inputItemModData["LSMRR"] = {} end
    -- initialize soundType
    if soundType == "Radius" then
        inputItemModData["LSMRR"]["hasIncreasedSoundRadius"] = true
        --print("Sound radius modData: " .. recipeVolume)
    elseif soundType == "Noise" then
        inputItemModData["LSMRR"]["hasIncreasedNoiseRange"] = true
        --print("Noise range modData: " .. recipeVolume)
    elseif soundType == "Remote" then
        inputItemModData["LSMRR"]["hasIncreasedRemoteRange"] = true
        --print("Remote range modData: " .. recipeVolume)
    else return end

    -- fast bool tag for checking during render
    inputItemModData["LSMRR"]["hasModifiedVolume"] = true
    inputItemModData["LSMRR"]["recipeUsedToCraft"] = recipeName
    Main.SetItemPropertiesFromModData(inputItem, nil)
    --inputItemModData["LSMRR_nameToPrepend"] = RecipeVolumeTable[recipeName]["nameModPrepend"]
end

--- Modifies item "Volume" and modData
---@param craftRecipeData craftRecipeData
---@param character character
---@param soundType string
function Main.OnMakeLouder(craftRecipeData, character, soundType)
    print("LSMRR.OnMakeLouder")
    local recipeName = craftRecipeData:getRecipe():getName()
    if not recipeName then print("ERROR: Recipe name not found") end
    local inputItem = craftRecipeData:getAllInputItems():get(0)
    if not inputItem then print("ERROR: Input item not found") end
    local inputItemName = inputItem:getName()
    if not inputItemName then print("ERROR: Input item name not found") end
    local inputItemModData = inputItem:getModData()
    if not inputItemModData then print("ERROR: Input item modData not found") end
    Main.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
end

return Main