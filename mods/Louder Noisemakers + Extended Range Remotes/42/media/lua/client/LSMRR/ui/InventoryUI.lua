local InventoryUI = require("Starlit/client/ui/InventoryUI")

local modDataSoundTypes = {
    ["increasedSoundRadius"] = "SoundRadius",
    ["increasedNoiseRange"] = "NoiseRange",
    ["increasedRemoteRange"] = "RemoteRange",
}

local soundTypeFuncs = {
    ["SoundRadius"] = function(item) return item:getSoundRadius() end,
    ["NoiseRange"] = function(item) return item:getNoiseRange() end,
    ["RemoteRange"] = function(item) return item:getRemoteRange() end,
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
    print("checkForModifiedRadiusItems Proc \n UI Item modData:")
    for index, value in pairs(modData["LSMRR"]) do
        print("Index:", index, "Value:", value)
    end
    local hasValidSoundType = false
    for k, v in pairs(modDataSoundTypes) do
        if modData['LSMRR'][k] then -- if has one of the sound types modData identifier
            hasValidSoundType = true

            -- modify item properties in case of game reload

            -- local volume = modData[k]
            local layoutItem = layout:addItem()
            if not layoutItem then return end
            layoutItem:setLabel(getText("Tooltip_LSMRR_ItemVolume"), 1, 0.8, 0.8, 1)
            --if LSMRRInventoryUIListeners.shouldBeProgressBar == true then
                --LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem, tooltip, layout)
            --else
            local soundTypeVolume
            local soundTypeFunc = soundTypeFuncs[v]
            if not soundTypeFunc then print("soundTypeFunc not valid") return end
            soundTypeVolume = soundTypeFunc(item)
            if not soundTypeVolume then print("soundType not valid on item") return end
            layoutItem:setValue(tostring(soundTypeVolume), 1, 1, 1, 1)
            
            --layoutItem:setValueRightNoPlus(tostring(soundTypeVolumeFromItemDirectly))
            --end
        end
    end
    if hasValidSoundType ~= true then
        print("Item did not have any valid sound type")
        return
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