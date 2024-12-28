-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

local LSMRRMain = {}
local sandboxVars = SandboxVars.LSMRR

local baseProgressBarMax = 100
local progressBarMax = baseProgressBarMax
function LSMRRMain.getProgressBarMax() return progressBarMax end

-- Remote Controller ranges
local RemoteItemData = {
    ["RemoteCraftedV1"] = sandboxVars.RemoteCraftedV1Range,
    ["RemoteCraftedV2"] = sandboxVars.RemoteCraftedV2Range,
    ["RemoteCraftedV3"] = sandboxVars.RemoteCraftedV3Range,
}

-- Maps recipe to volume and allows higher specificity with item tables
local RecipeVolumeTable = {
    ["LSMRRBoostWatchVolume"] = {
        ["nameModPrepend"] = "Bass Boosted",
        ["volume"] = sandboxVars.DigitalWatchVolume,
    },
    ["LSMRRAdjustGearsOnAlarmClock"] = {
        ["nameModPrepend"] = "Tuned",
        ["volume"] = sandboxVars.AlarmClockVolume,
    },
    ["LSMRRModulateNoiseMakerVolume"] = {
        ["nameModPrepend"] = "Hacked",
        ["volume"] = sandboxVars.NoiseMakerVolume,
    },
    ["LSMRRAttachAmplifierToNoiseMaker"] = {
        ["nameModPrepend"] = "Amplified",
        ["volume"] = sandboxVars.AmplifiedNoiseMakerVolume,
    },
    ["LSMRRExtendRangeOfRemoteController"] = {
        ["nameModPrepend"] = "Extended",
        ["volume"] = nil,
        ["items"] = RemoteItemData,  -- Reference to the external items table
    },
}
function LSMRRMain.getRecipeVolumeTable() return RecipeVolumeTable end

function LSMRRMain.getRecipeVolume(recipeName, inputItemName)
    local newVolumeOfItem;
    -- ensure recipe is valid
    local recipeTableData = RecipeVolumeTable[recipeName]
    if recipeTableData == nil then return end
    -- if recipe has volume
    newVolumeOfItem = recipeTableData["volume"]
    if newVolumeOfItem then return newVolumeOfItem end
    -- if input item for recipe has volume
    newVolumeOfItem = recipeTableData["items"][inputItemName]
    if newVolumeOfItem then return newVolumeOfItem end
end

function LSMRRMain.SetItemPropertiesFromModData(inventoryItem)
    local modData = inventoryItem:getModData()
    if modData.LSMRR == nil then return end
    if modData.LSMRR.hasModifiedVolume ~= true then
        print("LSMRR.SetItemPropertiesFromModData")
        if modData.LSMRR.increasedSoundRadius then
            inventoryItem:setSoundRadius(modData.LSMRR.increasedSoundRadius)
            print("\tSound radius: " .. inventoryItem:getSoundRadius())
        elseif modData.LSMRR.increasedNoiseRange then
            inventoryItem:setNoiseRange(modData.LSMRR.increasedNoiseRange)
            print("\tNoise range: " .. inventoryItem:getNoiseRange())
        elseif modData.LSMRR.increasedRemoteRange then
            inventoryItem:setRemoteRange(modData.LSMRR.increasedRemoteRange)
            print("\tRemote range: " .. inventoryItem:getRemoteRange())
        end
    end
    
end

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    print("LSMRR.MakeLouder")
    local recipeVolume = LSMRRMain.getRecipeVolume(recipeName, inputItemName)
    if recipeVolume == nil then return end
    if inputItemModData == nil then inputItemModData = {} end
    if inputItemModData.LSMRR == nil then inputItemModData.LSMRR = {} end
    -- initialize soundType
    if soundType == "Radius" then
        inputItemModData.LSMRR.increasedSoundRadius = recipeVolume
        print("\tSound radius modData: " .. recipeVolume)
    elseif soundType == "Noise" then
        inputItemModData.LSMRR.increasedNoiseRange = recipeVolume
        print("\tNoise range modData: " .. recipeVolume)
    elseif soundType == "Remote" then
        inputItemModData.LSMRR.increasedRemoteRange = recipeVolume
        print("\tRemote range modData: " .. recipeVolume)
    else return end

    -- fast bool tag for checking during render
    inputItemModData.LSMRR.hasModifiedVolume = true
    inputItemModData.LSMRR.recipeUsedToModify = recipeName
    LSMRRMain.SetItemPropertiesFromModData(inputItem)
    --inputItemModData["LSMRR_nameToPrepend"] = RecipeVolumeTable[recipeName]["nameModPrep  end"]
    return recipeVolume
end

--- Modifies item "Volume" and modData
---@param craftRecipeData craftRecipeData
---@param character character
---@param soundType string
function LSMRRMain.OnMakeLouder(craftRecipeData, character, soundType)
    print("LSMRR.OnMakeLouder")
    local recipeName = craftRecipeData:getRecipe():getName()
    if recipeName == nil then print("\tRecipe name not found : fail") end
    local inputItem = craftRecipeData:getAllInputItems():get(0)
    if inputItem == nil then print("\tInput item not found : fail") end
    print(inputItem)
    local inputItemName = inputItem:getName()
    if inputItemName == nil then print("\tInput item name not found : fail") end
    local inputItemModData = inputItem:getModData()
    if inputItemModData == nil then print("\tInput item modData not found : fail") end
    local newVolumeOfItem = LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    if newVolumeOfItem == nil then print("\tRecipe/Item volume not found : fail") end
end

return LSMRRMain