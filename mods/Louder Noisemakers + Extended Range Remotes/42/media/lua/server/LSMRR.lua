--- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
--- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

--- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

--- make louder and return indentifier for kind of item
function MakeLouder(item, itemName)
    if string.find(itemName, "Digital") and string.find(itemName, "Watch") then
        item:setSoundRadius(25);
        return "radius";
    elseif string.find(itemName, "Alarm") and string.find(itemName, "Clock") then
        item:setSoundRadius(50);
        return "radius";
    elseif string.find(itemName, "Noise") and (string.find(itemName, "Maker") or string.find(itemName, "Generator")) then
        item:setNoiseRange(150);
        return "noise";
    elseif string.find(itemName, "Remote") and string.find(itemName, "Controller") then
        if string.find(itemName, "V1") then
            item:setRemoteRange(50);
            return "remote";
        elseif string.find(itemName, "V2") then
            item:setRemoteRange(75);
            return "remote";
        elseif string.find(itemName, "V3") then
            item:setRemoteRange(100);
            return "remote";
        end
    end
    return false;
end

--- dont need to test for modData bc the func for it already has a case for that

local Recipe = Recipe;

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
    -- local modData = inventoryItem:getModData();
    -- if modData.LSMRR_isLouder or modData.LSMRR_hasExtendedRange then
    --     print("Recipe.OnCreate.LSMRR_MakeLouder: item is already modified");
    --     return;
    -- end

    local itemName = inventoryItem:getName();
    print("Recipe.OnCreate.LSMRR_MakeLouder itemName: " .. itemName);
    local itemCustomType = MakeLouder(inventoryItem, itemName);
    print("Recipe.OnCreate.LSMRR_MakeLouder itemCustomType: " .. itemCustomType);

    local newItemName = "";
    
    --- check if item is valud and modify accordingly
    if itemCustomType == "radius" or itemCustomType == "noise" then
        modData.LSMRR_isLouder = true;
        if not string.find(itemName, louderStr) then
            newItemName = itemName .. " " .. louderStr;
        end
    elseif itemCustomType == "remote" then
        modData.LSMRR_hasExtendedRange = true;
        if not string.find(itemName, erStr) then
            newItemName =  erStr .. " " .. itemName;
        end
    else
        print("LSMRR Recipe.OnCreate: itemCustomType is not valid");
        return;
    end
    print("Recipe.OnCreate.LSMRR_MakeLouder newItemName: " .. newItemName);

    --- set names
    if not inventoryItem:isCustomName() then
        inventoryItem:setCustomName(true);
    end
    inventoryItem:setName(newItemName);
    print("Recipe.OnCreate.LSMRR_MakeLouder inventoryItem:getName(): " .. inventoryItem:getName());
    inventoryItem:setDisplayName(newItemName);
    print("Recipe.OnCreate.LSMRR_MakeLouder inventoryItem:getDisplayName(): " .. inventoryItem:getDisplayName());
end

---if item is being crafted, and item is related to this mod
---timer_for_recipe = recipe_craft_time * 10
    ---when timer ends, stop checking for signals
---hook into signals
    ---new craft (recipe)
        ---store ref to recipe
    ---ingredient being deleted (itembeingdeleted)
        ---save itembeingdeleted modData filtered to only my stuff
    ---signal for new item being created (newitem)
        ---if newitem is my item, apply modData to it and stop listening for signals