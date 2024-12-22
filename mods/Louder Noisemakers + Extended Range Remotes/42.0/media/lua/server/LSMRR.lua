--- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
--- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

--- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

function SetSoundRadius(item)
    local itemName = item:getName();
    if string.find(itemName, "Digital") and string.find(itemName, "Watch") then
        item:setSoundRadius(25);
        return true;
    elseif string.find(itemName, "Alarm") and string.find(itemName, "Clock") then
        item:setSoundRadius(50);
        return true;
    elseif string.find(itemName, "Noise") and (string.find(itemName, "Maker") or string.find(itemName, "Generator")) then
        item:setNoiseRange(150);
        return true;
    end
    return false;
end

function SetRemoteRadius(item)
    local itemName = item:getName();
    if string.find(itemName, "Remote") and string.find(itemName, "Controller") then
        if string.find(itemName, "V1") then
            item:setRemoteRange(50);
            return true;
        elseif string.find(itemName, "V2") then
            item:setRemoteRange(75);
            return true;
        elseif string.find(itemName, "V3") then
            item:setRemoteRange(100);
            return true;
        end
    end
    return false;
end

--- dont need to test for modData bc the func for it already has a case for that

local Recipe = Recipe;

local louderStr = "(Louder)";

function Recipe.OnCreate.LSMRR_MakeLouder(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);

    local modData = inventoryItem:getModData();
    modData:set("LSMRR_shouldBeLouder", true);
    SetSoundRadius(inventoryItem);

    inventoryItem:setCustomName(true);

    local itemName = inventoryItem:getName();
    if string.find(itemName, louderStr) == nil then
        inventoryItem:setName(inventoryItem:getName() .. " " .. louderStr);
    end
end

local erStr = "Extended Range";

function Recipe.OnCreate.LSMRR_MakeRangeHigher(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);

    local modData = inventoryItem:getModData();
    modData:set("LSMRR_shouldHaveExtendedRange", true);
    SetRemoteRadius(inventoryItem);

    inventoryItem:setCustomName(true);

    local itemName = inventoryItem:getName();
    if string.find(itemName, erStr) == nil then
        inventoryItem:setName(erStr .. " " .. inventoryItem:getName());
    end
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