-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

LSMRRMain = {};

-- External table for common data (nameModPrepend and volume values)
local VolumeData = {
    ["Bass Boosted"] = {nameModPrepend = "Bass Boosted", volume = 20},
    ["Tuned"] = {nameModPrepend = "Tuned", volume = 40},
    ["Hacked"] = {nameModPrepend = "Hacked", volume = 100},
    ["Amplified"] = {nameModPrepend = "Amplified", volume = 400},
    ["Extended"] = {nameModPrepend = "Extended", volume = nil},  -- For cases where volume is nil
}

-- External table for items
local ItemData = {
    ["RemoteCraftedV1"] = 20,
    ["RemoteCraftedV2"] = 40,
    ["RemoteCraftedV3"] = 100,
}

-- Main Recipe Volume Table using references to the external tables
local RecipeVolumeTable = {
    ["Recipe_LSMRR_BoostWatchVolume"] = {
        ["nameModPrepend"] = VolumeData["Bass Boosted"].nameModPrepend,
        ["volume"] = VolumeData["Bass Boosted"].volume,
    },
    ["Recipe_LSMRR_AdjustGearsOnAlarmClock"] = {
        ["nameModPrepend"] = VolumeData["Tuned"].nameModPrepend,
        ["volume"] = VolumeData["Tuned"].volume,
    },
    ["Recipe_LSMRR_ModulateNoiseMakerVolume"] = {
        ["nameModPrepend"] = VolumeData["Hacked"].nameModPrepend,
        ["volume"] = VolumeData["Hacked"].volume,
    },
    ["Recipe_LSMRR_AttachAmplifierToNoiseMaker"] = {
        ["nameModPrepend"] = VolumeData["Amplified"].nameModPrepend,
        ["volume"] = VolumeData["Amplified"].volume,
    },
    ["Recipe_LSMRR_ExtendRangeOfRemoteController"] = {
        ["nameModPrepend"] = VolumeData["Extended"].nameModPrepend,
        ["volume"] = VolumeData["Extended"].volume,
        ["items"] = ItemData,  -- Reference to the external items table
    },
}

function LSMRRMain.getRecipeVolume(recipeName, inputItemName)
    local newVolumeOfItem;
    -- ensure recipe is valid query
    local recipeTableData = RecipeVolumeTable[recipeName];
    if not recipeTableData then return; end
    -- if recipe has volume
    newVolumeOfItem = recipeTableData["volume"];
    if newVolumeOfItem then return newVolumeOfItem; end
    -- if input item for recipe has volume
    newVolumeOfItem = recipeTableData["items"][inputItemName];
    if newVolumeOfItem then return newVolumeOfItem;
    else return; end
end

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData)
    local recipeVolume = LSMRRMain.getRecipeVolume(recipeName, inputItemName);
    if not recipeVolume then return end

    if soundType == "Radius" then
        inputItem:setSoundRadius(recipeVolume);
        inputItemModData["LSMRR_increasedSoundRadius"] = recipeVolume;
    elseif soundType == "Noise" then
        inputItem:setNoiseRange(recipeVolume);
        inputItemModData["LSMRR_increasedNoiseRange"] = recipeVolume;
    elseif soundType == "Remote" then
        inputItem:setRemoteRange(recipeVolume);
        inputItemModData["LSMRR_increasedRemoteRange"] = recipeVolume;
    else return; end

    -- fast bool tag for checking during render
    inputItemModData["LSMRR_hasModifiedVolume"] = true;
    inputItemModData["LSMRR_recipeUsedToModify"] = recipeName;
    return recipeVolume;
end

--- Modifies item "Volume" and modData
---@param craftRecipeData craftRecipeData
---@param character character
---@param soundType string
function LSMRRMain.OnMakeLouder(craftRecipeData, _character, soundType)
    print("LSMRR.OnMakeLouder")
    local recipe = craftRecipeData:getRecipe();
    local recipeName = recipe:getName();
    local inputItems = craftRecipeData:getAllInputItems();
    local inputItem = inputItems:get(0);
    local inputItemName = inputItem:getName();
    local inputItemModData = inputItem:getModData();
    local newVolumeOfItem = LSMRRMain.MakeLouder(inputItem, inputItemName, recipeName, soundType, inputItemModData);
    if not newVolumeOfItem then print("\tRecipe/Item volume not found : fail"); end
end

local modDataSoundTypes = {
    ["LSMRR_increasedSoundRadius"] = true,
    ["LSMRR_increasedNoiseRange"] = true,
    ["LSMRR_increasedRemoteRange"] = true,
}