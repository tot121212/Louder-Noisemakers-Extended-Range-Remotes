local function addLSMRRItems()
    local playerObj = getPlayer()
    local items = {
        -- Vanilla base-game items used by the recipes
        "Base.WristWatch_Right_DigitalBlack",
        "Base.WristWatch_Right_DigitalRed",
        "WristWatch_Right_DigitalDress",
        "Base.AlarmClock2",
        "NoiseTrap",
        "NoiseTrapRemote",
        "NoiseTrapSensorV1",
        "NoiseTrapSensorV2",
        "NoiseTrapSensorV3",
        "NoiseTrapTriggered",
        "Base.RemoteCraftedV1",
        "Base.RemoteCraftedV2",
        "Base.RemoteCraftedV3",
        "Base.Screwdriver",
    }

    local inventory = playerObj:getInventory()
    for _, itemType in ipairs(items) do
        inventory:AddItem(itemType)
    end
end

local originalSetupButtons = ISDebugMenu.setupButtons

function ISDebugMenu:setupButtons()
    originalSetupButtons(self)
    self:addButtonInfo("Add LSMRR Vanilla Test Crafting Items", addLSMRRItems, "DEV")
end
