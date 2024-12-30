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
    ["RemoteCraftedV1"] = SandboxVars['LSMRR']['RemoteCraftedV1Range'],
    ["RemoteCraftedV2"] = SandboxVars['LSMRR']['RemoteCraftedV2Range'],
    ["RemoteCraftedV3"] = SandboxVars['LSMRR']['RemoteCraftedV3Range'],
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
function Main.getRecipeVolumeTable() return RecipeVolumeTable end

function Main.getRecipeVolume(recipeName, inputItemName)
    local newVolumeOfItem;
    -- ensure recipe is valid
    local recipeTableData = RecipeVolumeTable[recipeName]
    if not recipeTableData then return end
    -- if recipe has volume
    newVolumeOfItem = recipeTableData["volume"]
    if newVolumeOfItem then return newVolumeOfItem end
    -- if input item for recipe has volume
    newVolumeOfItem = recipeTableData["items"][inputItemName]
    if newVolumeOfItem then return newVolumeOfItem end
end

Main.SetItemPropertiesFromModData = function(inventoryItem, object)
    if not inventoryItem:hasModData() then return end
    local modData = inventoryItem:getModData()
    if not modData["LSMRR"] then return end
    print("LSMRR.SetItemPropertiesFromModData")
    local wasModified = false
    if modData["LSMRR"]["hasModifiedVolume"] then
        if modData["LSMRR"]["increasedSoundRadius"] then
            inventoryItem:setSoundRadius(modData["LSMRR"]["increasedSoundRadius"])
            print("Updated sound radius: " .. inventoryItem:getSoundRadius())
            wasModified = true
        elseif modData["LSMRR"]["increasedNoiseRange"] then
            inventoryItem:setNoiseRange(modData["LSMRR"]["increasedNoiseRange"])
            print("Updated noise range: " .. inventoryItem:getNoiseRange())
            wasModified = true
        elseif modData["LSMRR"]["increasedRemoteRange"] then
            inventoryItem:setRemoteRange(modData["LSMRR"]["increasedRemoteRange"])
            print("Updated remote range: " .. inventoryItem:getRemoteRange())
            wasModified = true
        end
    end
    if wasModified then inventoryItem:setCustomName(wasModified) end
end

--- add set item properties to OnLoadItem event
Events.OnLoadExistingItem:addListener(Main.SetItemPropertiesFromModData)

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function Main.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    print("LSMRR.MakeLouder")
    local recipeVolume = Main.getRecipeVolume(recipeName, inputItemName)
    if not recipeVolume then return end
    if not inputItemModData then inputItemModData = {} end
    if not inputItemModData["LSMRR"] then inputItemModData["LSMRR"] = {} end
    -- initialize soundType
    if soundType == "Radius" then
        inputItemModData["LSMRR"]["increasedSoundRadius"] = recipeVolume
        --print("Sound radius modData: " .. recipeVolume)
    elseif soundType == "Noise" then
        inputItemModData["LSMRR"]["increasedNoiseRange"] = recipeVolume
        --print("Noise range modData: " .. recipeVolume)
    elseif soundType == "Remote" then
        inputItemModData["LSMRR"]["increasedRemoteRange"] = recipeVolume
        --print("Remote range modData: " .. recipeVolume)
    else return end

    -- fast bool tag for checking during render
    inputItemModData["LSMRR"]["hasModifiedVolume"] = true
    inputItemModData["LSMRR"]["recipeUsedToModify"] = recipeName
    Main.SetItemPropertiesFromModData(inputItem)
    --inputItemModData["LSMRR_nameToPrepend"] = RecipeVolumeTable[recipeName]["nameModPrep  end"]
    if not recipeVolume then print("Recipe/Item volume not found : fail") return end
    return recipeVolume
end

--- Modifies item "Volume" and modData
---@param craftRecipeData craftRecipeData
---@param character character
---@param soundType string
function Main.OnMakeLouder(craftRecipeData, character, soundType)
    print("LSMRR.OnMakeLouder")
    local recipeName = craftRecipeData:getRecipe():getName()
    if not recipeName then print("Recipe name not found : fail") end
    local inputItem = craftRecipeData:getAllInputItems():get(0)
    if not inputItem then print("Input item not found : fail") end
    local inputItemName = inputItem:getName()
    if not inputItemName then print("Input item name not found : fail") end
    local inputItemModData = inputItem:getModData()
    if not inputItemModData then print("Input item modData not found : fail") end
    local newVolumeOfItem = Main.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    return newVolumeOfItem
end

return Main