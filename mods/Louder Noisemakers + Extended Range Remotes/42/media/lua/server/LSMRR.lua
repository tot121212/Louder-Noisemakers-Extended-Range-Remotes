-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

LSMRR = {};

--- Table for item volumes
local RecipeRangeTable = {
    ["LSMRR_BoostWatchVolume"] = {
        ["default"] = 20,
    },
    ["LSMRR_AdjustGearsOnAlarmClock"] = {
        ["default"] = 40,
    },
    ["LSMRR_ModulateNoiseMakerVolume"] = {
        ["default"] = 100,
    },
    ["LSMRR_AttachAmplifierToNoiseMaker"] = {
        ["default"] = 400,
    },
    ["LSMRR_ExtendRangeOfRemoteController"] = {
        ["default"] = nil,
        ["RemoteCraftedV1"] = 20,
        ["RemoteCraftedV2"] = 40,
        ["RemoteCraftedV3"] = 100,
    },
}

---@param inputItem inventoryItem
---@param inputItemName string
---@param recipeName string
---@param soundType string
function LSMRR.MakeLouder(inputItem, inputItemName, recipeName, soundType)
    local newRangeOfItem = nil;
    if RecipeRangeTable[recipeName][inputItemName] then
        newRangeOfItem = RecipeRangeTable[recipeName][inputItemName];
    elseif RecipeRangeTable[recipeName]["default"] then
        newRangeOfItem = RecipeRangeTable[recipeName]["default"];
    else return nil end
    if soundType == "Radius" then
        inputItem:setSoundRadius(newRangeOfItem);
    elseif soundType == "Noise" then
        inputItem:setNoiseRange(newRangeOfItem);
    elseif soundType == "Remote" then
        inputItem:setRemoteRange(newRangeOfItem);
    else
        return nil;
    end
    return newRangeOfItem;
end

--- Modifies item volume and tooltip
---@param craftRecipeData craftRecipeData
---@param character character
---@param soundType string
function LSMRR.OnMakeLouder(craftRecipeData, character, soundType)
    print("LSMRR.OnMakeLouder")
    local recipe = craftRecipeData:getRecipe();
    local recipeName = recipe:getName();
    local inputItems = craftRecipeData:getAllInputItems();
    local inputItem = inputItems:get(0);
    local inputItemName = inputItem:getName();
    local newRangeOfItem = LSMRR.MakeLouder(inputItem, inputItemName, recipeName, soundType);
    if newRangeOfItem == nil then
        print("\tItem range not valid : fail");
        return;
    else
        print("\tItem range was modifed to: " .. tostring(newRangeOfItem));
    end
    --- local newItemName = nil;

    --- make sure newItemName isnt an empty string
    ---if newItemName == "" then
    ---    newItemName = inputItemName;
    ---end

    --- set names
    ---inputItem:setCustomName(true);
    ---if newItemName ~= nil then
    ---    inputItem:setName(newItemName);
    ---end
    inputItem:setTooltip(getText("LSMRR_Tooltip_item_Volume") .. ": " .. tostring(newRangeOfItem));
    print("\tItem modified : success");
end

