local InventoryUI = require("Starlit/client/ui/InventoryUI")

local modDataSoundTypes = {
    ["hasIncreasedSoundRadius"] = function(item) return item:getSoundRadius() end,
    ["hasIncreasedNoiseRange"] = function(item) return item:getNoiseRange() end,
    ["hasIncreasedRemoteRange"]= function(item) return item:getRemoteRange() end,
}

--LSMRRInventoryUIListeners.shouldBeProgressBar = true

-- store old callbacks, replace, run, then run old, then replace back to way it was
--[[ local callback_drawItemDetails = ISInventoryPane.drawItemDetails
local callback_render = ISToolTipInv.render ]]

--- Adds tooltips to LSMRR_hasModifiedSoundRadius items
---@type Starlit.InventoryUI.Callback_OnFillItemTooltip
local function checkForModifiedRadiusItems(tooltip, layout, item)
    local modData = item:getModData()
    if not modData or
    not modData['LSMRR'] or
    not modData['LSMRR']['hasModifiedVolume'] then
    return end
    for k, v in pairs(modDataSoundTypes) do
        local soundTypeFunction = modData['LSMRR'][k]
        if soundTypeFunction then
            local layoutItem = layout:addItem()
            if not layoutItem then print("ERROR: No layoutItem") return end
            layoutItem:setLabel(getText("Tooltip_LSMRR_ItemVolume"), 1, 0.8, 0.8, 1)
            --if LSMRRInventoryUIListeners.shouldBeProgressBar == true then
                --LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem, tooltip, layout)
            --else
            local soundTypeVolume
            soundTypeVolume = soundTypeFunction(item)
            if not soundTypeVolume then print("ERROR: No soundTypeVolume found") return end
            layoutItem:setValue(tostring(soundTypeVolume), 1, 1, 1, 1)
            return
        end
    end
end

--- not implemented correctly
--[[ function LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem)
    local max = Main.getProgressBarMax()
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

InventoryUI.onFillItemTooltip:addListener(checkForModifiedRadiusItems)