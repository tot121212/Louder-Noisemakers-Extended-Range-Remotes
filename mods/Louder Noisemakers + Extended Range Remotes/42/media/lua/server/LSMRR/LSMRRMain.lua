-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

LSMRRMain = {}
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
    if newVolumeOfItem ~= nil then return newVolumeOfItem end
    -- if input item for recipe has volume
    newVolumeOfItem = recipeTableData["items"][inputItemName]
    if newVolumeOfItem ~= nil then return newVolumeOfItem end
end

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    local recipeVolume = LSMRRMain.getRecipeVolume(recipeName, inputItemName)
    if recipeVolume == nil then return nil end

    if soundType == "Radius" then
        inputItem:setSoundRadius(recipeVolume)
        inputItemModData["LSMRR_increasedSoundRadius"] = recipeVolume
    elseif soundType == "Noise" then
        inputItem:setNoiseRange(recipeVolume)
        inputItemModData["LSMRR_increasedNoiseRange"] = recipeVolume
    elseif soundType == "Remote" then
        inputItem:setRemoteRange(recipeVolume)
        inputItemModData["LSMRR_increasedRemoteRange"] = recipeVolume
    else return nil end

    -- fast bool tag for checking during render
    inputItemModData["LSMRR_hasModifiedVolume"] = true
    inputItemModData["LSMRR_recipeUsedToModify"] = recipeName
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
    local inputItem = craftRecipeData:getAllInputItems():get(0)
    local inputItemName = inputItem:getName()
    local inputItemModData = inputItem:getModData()
    local newVolumeOfItem = LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    if newVolumeOfItem == nil then print("\tRecipe/Item volume not found : fail") end
end

