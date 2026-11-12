local SoundRange = {
    DigitalWatch = 25,
    AlarmClock = 50,
    NoiseMaker = 150,
}

local SoundItemTypes = {}

local function RegisterSoundItemType(baseType, louderType, radius, modDataKey, tooltip)
    local settings = {
        louderType = louderType,
        radius = radius,
        modDataKey = modDataKey,
        tooltip = tooltip,
    }
    SoundItemTypes[baseType] = settings
    SoundItemTypes[louderType] = settings
end

for _, watch in ipairs({"Black", "Red", "Dress"}) do
    for _, side in ipairs({"Right", "Left"}) do
        local itemType = "WristWatch_" .. side .. "_Digital" .. watch
        RegisterSoundItemType(
            "Base." .. itemType,
            "LouderSoundmakers_Items." .. itemType .. "_LOUDER_Tot",
            SoundRange.DigitalWatch,
            "LSMRR_SoundRadius",
            "Tooltip_LSMRR_SoundRadius"
        )
    end
end

RegisterSoundItemType(
    "Base.AlarmClock2",
    "LouderSoundmakers_Items.AlarmClock2_LOUDER_Tot",
    SoundRange.AlarmClock,
    "LSMRR_SoundRadius",
    "Tooltip_LSMRR_SoundRadius"
)

for _, itemType in ipairs({
    "NoiseTrap",
    "NoiseTrapRemote",
    "NoiseTrapSensorV1",
    "NoiseTrapSensorV2",
    "NoiseTrapSensorV3",
    "NoiseTrapTriggered",
}) do
    RegisterSoundItemType(
        "Base." .. itemType,
        "LouderSoundmakers_Items." .. itemType .. "_LOUDER_Tot",
        SoundRange.NoiseMaker,
        "LSMRR_NoiseRange",
        "Tooltip_LSMRR_NoiseRange"
    )
end

local RemoteRange = {
    V1 = 50,
    V2 = 75,
    V3 = 100,
}

local louderStr = "(Louder)";

local function ApplySoundItemSettings(item, settings)
    if item:getFullType() ~= settings.louderType then
        local scriptItem = ScriptManager.instance:FindItem(settings.louderType)
        if not scriptItem then
            error("LSMRR item type is not defined: " .. settings.louderType)
        end
        item:setModule(scriptItem:getModuleName())
        item:setType(scriptItem:getName())
        item:setScriptItem(scriptItem)
        item:setRegistry_id(scriptItem)
    end

    item:getModData()[settings.modDataKey] = settings.radius
    if settings.modDataKey == "LSMRR_SoundRadius" then
        item:setSoundRadius(settings.radius)
        item:setTooltip(getText(settings.tooltip, tostring(item:getSoundRadius())))
    else
        item:setNoiseRange(settings.radius)
        item:setTooltip(getText(settings.tooltip, tostring(item:getNoiseRange())))
    end
end

local function SetSoundRadius(item)
    local settings = SoundItemTypes[item:getFullType()]
    if not settings then
        return false
    end
    ApplySoundItemSettings(item, settings)
    return true
end

local RestoreItemRadii

local function RestoreContainerRadii(container)
    if not container then
        return
    end
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        RestoreItemRadii(items:get(i))
    end
end

RestoreItemRadii = function(item)
    if not item then
        return
    end
    local fullType = item:getFullType()
    local settings = SoundItemTypes[fullType]
    if settings and fullType ~= settings.louderType then
        local wasCustomized = item:getModData()[settings.modDataKey]
            or string.find(item:getName(), louderStr, 1, true)
        if wasCustomized then
            ApplySoundItemSettings(item, settings)
        end
    end

    if instanceof(item, "InventoryContainer") then
        RestoreContainerRadii(item:getInventory())
    end
end

local function RestoreCharacterRadii(player)
    RestoreContainerRadii(player:getInventory())
    local wornItems = player:getWornItems()
    for i = 0, wornItems:size() - 1 do
        RestoreItemRadii(wornItems:getItemByIndex(i))
    end
end

local restoredPlayers = setmetatable({}, {__mode = "k"})

local function RestorePlayerRadii(player)
    if player then
        if restoredPlayers[player] then
            return
        end
        restoredPlayers[player] = true
        RestoreCharacterRadii(player)
        return
    end

    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        RestorePlayerRadii(players:get(i))
    end
end

local function RestoreWornItemRadii(character)
    local wornItems = character:getWornItems()
    for i = 0, wornItems:size() - 1 do
        RestoreItemRadii(wornItems:getItemByIndex(i))
    end
end

local function RestoreSquareRadii(square)
    if not square then
        return
    end

    local worldItems = square:getWorldObjects()
    for i = 0, worldItems:size() - 1 do
        RestoreItemRadii(worldItems:get(i):getItem())
    end

    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if instanceof(object, "IsoTrap") then
            RestoreItemRadii(object:getItem())
        end
        RestoreContainerRadii(object:getContainer())
        if instanceof(object, "IsoMannequin") then
            RestoreWornItemRadii(object)
        end
    end

    local vehicle = square:getVehicleContainer()
    if vehicle then
        for i = 0, vehicle:getPartCount() - 1 do
            local part = vehicle:getPartByIndex(i)
            if part then
                RestoreContainerRadii(part:getItemContainer())
            end
        end
    end

    local movingObjects = square:getMovingObjects()
    for i = 0, movingObjects:size() - 1 do
        local movingObject = movingObjects:get(i)
        if instanceof(movingObject, "IsoGameCharacter") then
            RestorePlayerRadii(movingObject)
        elseif instanceof(movingObject, "IsoDeadBody") then
            RestoreWornItemRadii(movingObject)
        end
    end
end

local function RestoreNewPlayerRadii(player)
    if player and not restoredPlayers[player] then
        RestorePlayerRadii(player)
    end
end

local function SetRemoteRadius(item)
    local itemName = item:getName();
    if string.find(itemName, "Remote") and string.find(itemName, "Controller") then
        if string.find(itemName, "V1") then
            item:setRemoteRange(RemoteRange.V1);
            item:setTooltip(getText("Tooltip_LSMRR_RemoteRange", tostring(item:getRemoteRange())));
            return true;
        elseif string.find(itemName, "V2") then
            item:setRemoteRange(RemoteRange.V2);
            item:setTooltip(getText("Tooltip_LSMRR_RemoteRange", tostring(item:getRemoteRange())));
            return true;
        elseif string.find(itemName, "V3") then
            item:setRemoteRange(RemoteRange.V3);
            item:setTooltip(getText("Tooltip_LSMRR_RemoteRange", tostring(item:getRemoteRange())));
            return true;
        end
    end
    return false;
end

LSMRR = LSMRR or {};
LSMRR.OnCreate = LSMRR.OnCreate or {};

Events.OnLoad.Add(RestorePlayerRadii);
Events.OnPlayerMove.Add(RestoreNewPlayerRadii);
Events.LoadGridsquare.Add(RestoreSquareRadii);

LSMRR.OnCreate.LSMRR_MakeLouder = function(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);
    local itemName = inventoryItem:getName();

    SetSoundRadius(inventoryItem);

    inventoryItem:setCustomName(true);

    if string.find(itemName, louderStr) == nil then
        inventoryItem:setName(itemName .. " " .. louderStr);
    end
end

local erStr = "Extended Range";

LSMRR.OnCreate.LSMRR_MakeRangeHigher = function(craftRecipeData, _)
    local inventoryItem = craftRecipeData:getAllKeepInputItems():get(0);

    SetRemoteRadius(inventoryItem);

    inventoryItem:setCustomName(true);

    local itemName = inventoryItem:getName();
    if string.find(itemName, erStr) == nil then
        inventoryItem:setName(erStr .. " " .. inventoryItem:getName());
    end
end