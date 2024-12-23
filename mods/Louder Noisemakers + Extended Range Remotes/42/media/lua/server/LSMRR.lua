-- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
-- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

-- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

-- make louder and return indentifier for kind of item

local Recipe = Recipe;

function MakeLouder(item, scriptItemName)
    if string.find(scriptItemName, "Watch") and string.find(scriptItemName, "Digital") then
        item:setSoundRadius(25);
        return "radius";
    elseif string.find(scriptItemName, "AlarmClock2") then
        item:setSoundRadius(50);
        return "radius";
    elseif string.find(scriptItemName, "NoiseTrap") then
        item:setNoiseRange(150);
        return "noise";
    elseif string.find(scriptItemName, "RemoteCrafted") then
        if string.find(scriptItemName, "V1") then
            item:setRemoteRange(50);
            return "remote";
        elseif string.find(scriptItemName, "V2") then
            item:setRemoteRange(75);
            return "remote";
        elseif string.find(scriptItemName, "V3") then
            item:setRemoteRange(100);
            return "remote";
        end
    end
    return false;
end

local louderStr = "(Louder)";
local erStr = "Extended Range";

function Recipe.OnCreate.LSMRR_MakeLouder(craftRecipeData, _)
    
    local inputItems = craftRecipeData:getAllInputItems();
    print("Recipe.OnCreate.LSMRR_MakeLouder inputItems: " .. tostring(inputItems));

    local inventoryItem = inputItems:get(0);
    if inventoryItem == nil then
        print("Recipe.OnCreate.LSMRR_MakeLouder: inventoryItem is nil");
        return;
    end

    --- Check if item is already modified before anything
    local modData = inventoryItem:getModData();
    -- if modData.LSMRR_isLouder or modData.LSMRR_hasExtendedRange then
    --     print("Recipe.OnCreate.LSMRR_MakeLouder: item is already modified");
    --     return;
    -- end

    local itemName = inventoryItem:getName();
    if itemName == nil then
        print("Recipe.OnCreate.LSMRR_MakeLouder: itemName is nil");
        return;
    end
    print("Recipe.OnCreate.LSMRR_MakeLouder itemName: " .. itemName);
    local scriptItem = inventoryItem:getScriptItem() --- script template for item
    print("Recipe.OnCreate.LSMRR_MakeLouder scriptItem: " .. tostring(scriptItem));
    local scriptItemName = scriptItem:getName();
    
    local itemCustomType = MakeLouder(inventoryItem, scriptItemName);
    print("Recipe.OnCreate.LSMRR_MakeLouder itemCustomType: " .. itemCustomType);
   
    print("Recipe.OnCreate.LSMRR_MakeLouder modData: " .. tostring(modData));
    local newItemName = "";
    
    --- check if item is valid and modify accordingly
    if itemCustomType == "radius" then
        modData.LSMRR_isLouder = true;
        if not string.find(itemName, louderStr) then
            newItemName = itemName .. " " .. louderStr;
        end
        print("Recipe.OnCreate.LSMRR_MakeLouder soundRadius: " .. tostring(inventoryItem:getSoundRadius()));
    elseif itemCustomType == "noise" then
        modData.LSMRR_isNoisier = true;
        if not string.find(itemName, louderStr) then
            newItemName = itemName .. " " .. louderStr;
        end
        print("Recipe.OnCreate.LSMRR_MakeLouder noiseRange: " .. tostring(inventoryItem:getNoiseRange()));
    elseif itemCustomType == "remote" then
        modData.LSMRR_hasExtendedRange = true;
        if not string.find(itemName, erStr) then
            newItemName =  erStr .. " " .. itemName;
        end
        --print("Recipe.OnCreate.LSMRR_MakeLouder remoteRange: " .. tostring(inventoryItem:getRemoteRange()));
    else
        --print("LSMRR Recipe.OnCreate: itemCustomType is not valid");
        return;
    end
    --- make sure newItemName isnt an empty string
    if newItemName == "" then
        newItemName = itemName;
    end
    --print("Recipe.OnCreate.LSMRR_MakeLouder newItemName: " .. newItemName);

    --- set names
    if not inventoryItem:isCustomName() then
        inventoryItem:setCustomName(true);
    end
    if newItemName ~= nil then
        inventoryItem:setName(newItemName);
        --print("Recipe.OnCreate.LSMRR_MakeLouder inventoryItem:getName(): " .. inventoryItem:getName());
    end
    --inventoryItem:setDisplayName(newItemName);
    --print("Recipe.OnCreate.LSMRR_MakeLouder inventoryItem:getDisplayName(): " .. inventoryItem:getDisplayName());
end