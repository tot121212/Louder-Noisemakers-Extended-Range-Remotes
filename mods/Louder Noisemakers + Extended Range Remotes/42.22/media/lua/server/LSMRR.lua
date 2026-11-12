--- Item properties are removed during crafting, so how can we modify them in a way that my modified properties are kept?
--- When a louder item is used in crafting, convert new item into its louder counterpart, if applicable.

--- It may be that when you have an item favorited it saves the modData, meaning it would save the louder sound range, will have to test

local SoundRange = {
    DigitalWatch = 25,
    AlarmClock = 50,
    NoiseMaker = 150,
}

local RemoteRange = {
    V1 = 50,
    V2 = 75,
    V3 = 100,
}

local function SetSoundRadius(item)
    local itemName = item:getName();
    if string.find(itemName, "Digital") and string.find(itemName, "Watch") then
        item:setSoundRadius(SoundRange.DigitalWatch);
        return true;
    elseif string.find(itemName, "Alarm") and string.find(itemName, "Clock") then
        item:setSoundRadius(SoundRange.AlarmClock);
        return true;
    elseif string.find(itemName, "Noise") and (string.find(itemName, "Maker") or string.find(itemName, "Generator")) then
        item:setNoiseRange(SoundRange.NoiseMaker);
        return true;
    end
    return false;
end

local function SetRemoteRadius(item)
    local itemName = item:getName();
    if string.find(itemName, "Remote") and string.find(itemName, "Controller") then
        if string.find(itemName, "V1") then
            item:setRemoteRange(RemoteRange.V1);
            return true;
        elseif string.find(itemName, "V2") then
            item:setRemoteRange(RemoteRange.V2);
            return true;
        elseif string.find(itemName, "V3") then
            item:setRemoteRange(RemoteRange.V3);
            return true;
        end
    end
    return false;
end

--- dont need to test for modData bc the func for it already has a case for that

local Recipe = Recipe or {};
Recipe.OnCreate = Recipe.OnCreate or {};

local louderStr = "(Louder)";

Recipe.OnCreate.LSMRR_MakeLouder = function(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);

    SetSoundRadius(inventoryItem);

    inventoryItem:setCustomName(true);

    local itemName = inventoryItem:getName();
    if string.find(itemName, louderStr) == nil then
        inventoryItem:setName(inventoryItem:getName() .. " " .. louderStr);
    end
end

local erStr = "Extended Range";

Recipe.OnCreate.LSMRR_MakeRangeHigher = function(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);

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