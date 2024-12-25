local InventoryUI = require("Starlit/client/ui/InventoryUI");

local LSMRRInventoryUIListeners = {}

local modDataSoundTypes = {
    ["LSMRR_increasedSoundRadius"] = true,
    ["LSMRR_increasedNoiseRange"] = true,
    ["LSMRR_increasedRemoteRange"] = true,
}

--- Adds tooltips to LSMRR_hasModifiedSoundRadius items
--- @type Starlit.InventoryUI.Callback_OnFillItemTooltip
function LSMRRInventoryUIListeners.CheckForModifiedRadiusItems(tooltip, layout, item)
    local modData = item:getModData()
    if item:getModData()["LSMRR_hasModifiedVolume"] == nil then return end -- quick check
    print("CheckForModifiedRadiusItems Proc")
    local layoutItem = LayoutItem.new()
    layout.items:add(layoutItem)
    local hasValidSoundType = false
    for k, _ in pairs(modDataSoundTypes) do
        if modData[k] ~= nil then -- it has a sound type, which means it has a custom name
            layoutItem:setLabel((getText("Tooltip_LSMRR_ItemVolume") .. ":"), 1, 0.8, 0.8, 1)
            layoutItem:setValue(tostring(modData[k]), 1, 1, 1, 1)
            layoutItem.rightJustify = true
            -- prepend to name
            local LSMRRRecipe = modData["LSMRR_recipeUsedToModify"]
            local recipeTable = LSMRRMain.RecipeVolumeTable[LSMRRRecipe]
            local nameToPrepend = recipeTable["nameModPrepend"]
            if LSMRRRecipe ~= nil and nameToPrepend ~= nil then
                item:setCustomName(true)
                item:setName(tostring(nameToPrepend) .. item:getName())
            end
            hasValidSoundType = true
        end
    end
    if hasValidSoundType == nil then
        print("\tItem did not have any valid sound type")
    end
end

InventoryUI.onFillItemTooltip:addListener(LSMRRInventoryUIListeners.CheckForModifiedRadiusItems)

return LSMRRInventoryUIListeners