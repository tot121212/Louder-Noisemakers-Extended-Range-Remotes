local function addLSMRRItems()
    local playerObj = getPlayer()
    if playerObj then
        local currentLevel = playerObj:getPerkLevel(Perks.Electricity) or 0
        for i = currentLevel + 1, 10 do
            playerObj:LevelPerk(Perks.Electricity)
        end
        local knownRecipes = playerObj:getKnownRecipes()
        knownRecipes:add("Make Extended Range Remote Controller")
        knownRecipes:add("Make Alarm Clock Louder")
        knownRecipes:add("Make Noise Maker Louder")
    end

    local items = {
        -- Vanilla base-game items used by the recipes
        "Base.WristWatch_Right_DigitalBlack",
        "Base.WristWatch_Right_DigitalRed",
        "Base.WristWatch_Right_DigitalDress",
        "Base.AlarmClock2",
        "Base.NoiseTrap",
        "Base.NoiseTrapRemote",
        "Base.NoiseTrapSensorV1",
        "Base.NoiseTrapSensorV2",
        "Base.NoiseTrapSensorV3",
        "Base.NoiseTrapTriggered",
        "Base.RemoteCraftedV1",
        "Base.RemoteCraftedV2",
        "Base.RemoteCraftedV3",
        "Base.Screwdriver",
    }

    local inventory = playerObj and playerObj:getInventory()
    if inventory then
        for _, itemType in ipairs(items) do
            inventory:AddItem(itemType)
        end
    end
end

local originalSetupButtons = ISDebugMenu.setupButtons

function ISDebugMenu:setupButtons()
    originalSetupButtons(self)
    self:addButtonInfo("Add LSMRR Vanilla Test Crafting Items", addLSMRRItems, "DEV")
end
