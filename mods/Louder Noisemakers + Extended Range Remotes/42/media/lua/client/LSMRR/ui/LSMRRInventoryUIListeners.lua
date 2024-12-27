local InventoryUI = require("Starlit/client/ui/InventoryUI");

local LSMRRInventoryUIListeners = {}

local modDataSoundTypes = {
    ["LSMRR_increasedSoundRadius"] = true,
    ["LSMRR_increasedNoiseRange"] = true,
    ["LSMRR_increasedRemoteRange"] = true,
}
function LSMRRInventoryUIListeners.getModDataSoundTypes() return modDataSoundTypes end

LSMRRInventoryUIListeners.shouldBeProgressBar = true

-- store old callbacks, replace, run, then run old, then replace back to way it was
--[[ local callback_drawItemDetails = ISInventoryPane.drawItemDetails
local callback_render = ISToolTipInv.render ]]

--- Adds tooltips to LSMRR_hasModifiedSoundRadius items
--- @type Starlit.InventoryUI.Callback_OnFillItemTooltip
function LSMRRInventoryUIListeners.CheckForModifiedRadiusItems(tooltip, layout, item)
    local modData = item:getModData()
    if modData["LSMRR_hasModifiedVolume"] == nil then return end -- quick check
    print("CheckForModifiedRadiusItems Proc")
    
    local hasValidSoundType = false
    for k, _ in pairs(modDataSoundTypes) do
        if modData[k] ~= nil then -- if has one of the sound types modData identifier
            hasValidSoundType = true
            local volume = modData[k]
            local layoutItem = layout:addItem()
            layoutItem:setLabel(getText("Tooltip_LSMRR_ItemVolume"), 1, 0.8, 0.8, 1)
            --if LSMRRInventoryUIListeners.shouldBeProgressBar == true then
                --LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem, tooltip, layout)
            --else
            layoutItem:setValue(tostring(volume), 1, 1, 1, 1)
            --end
        end
    end
    if hasValidSoundType ~= true then
        print("\tItem did not have any valid sound type")
        return
    end
end

--- not implemented correctly
--[[ function LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem)
    local max = LSMRRMain.getProgressBarMax()
    if max < volume then
        max = volume
    end
    local progressValue = tonumber(string.format("%.2f", tostring(volume / max)))
    if math.abs(progressValue or 1.0) > 1.0 then
        progressValue = 1.0
    end
    progressValue = 1
    layoutItem:setProgress(progressValue, color:getR(), color:getG(), color:getB(), 1.0)
end ]]

InventoryUI.onFillItemTooltip:addListener(LSMRRInventoryUIListeners.CheckForModifiedRadiusItems)

return LSMRRInventoryUIListeners

