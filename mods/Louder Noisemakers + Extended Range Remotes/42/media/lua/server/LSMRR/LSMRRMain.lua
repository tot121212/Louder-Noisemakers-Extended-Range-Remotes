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
    if not recipeTableData then return end
    -- if recipe has volume
    newVolumeOfItem = recipeTableData["volume"]
    if newVolumeOfItem then return newVolumeOfItem end
    -- if input item for recipe has volume
    newVolumeOfItem = recipeTableData["items"][inputItemName]
    if newVolumeOfItem then return newVolumeOfItem end
end

function LSMRRMain.SetItemPropertiesFromModData(inventoryItem)
    local modData = inventoryItem:getModData()
    if modData.LSMRR then return end
    if modData.LSMRR.hasModifiedVolume then
        if modData.LSMRR.increasedSoundRadius then
            inventoryItem:setSoundRadius(modData.LSMRR.increasedSoundRadius)
        elseif modData.LSMRR.increasedNoiseRange then
            inventoryItem:setNoiseRange(modData.LSMRR.increasedNoiseRange)
        elseif modData.LSMRR.increasedRemoteRange then
            inventoryItem:setRemoteRange(modData.LSMRR.increasedRemoteRange)
        end
    end
end

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    local recipeVolume = LSMRRMain.getRecipeVolume(recipeName, inputItemName)
    if not recipeVolume then return end
    if not inputItemModData.LSMRR then inputItemModData.LSMRR = {} end
    -- initialize soundType
    if soundType == "Radius" then
        inputItemModData.LSMRR.increasedSoundRadius = recipeVolume
    elseif soundType == "Noise" then
        inputItemModData.LSMRR.increasedNoiseRange = recipeVolume
    elseif soundType == "Remote" then
        inputItemModData.LSMRR.increasedRemoteRange = recipeVolume
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
    local inputItem = craftRecipeData:getAllKeepInputItems():get(0)
    local inputItemName = inputItem:getName()
    local inputItemModData = inputItem:getModData()
    local newVolumeOfItem = LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    if not newVolumeOfItem then print("\tRecipe/Item volume not found : fail") end
end

return LSMRRMain