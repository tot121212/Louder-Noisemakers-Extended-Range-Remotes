local InventoryUI = require("lua/shared/Starlit/client/ui/InventoryUI")
if InventoryUI == nil then print("InventoryUI is nil") return end

local LSMRRInventoryUIListeners = {}

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

function LSMRRInventoryUIListeners.getModDataSoundTypes() return modDataSoundTypes end

--LSMRRInventoryUIListeners.shouldBeProgressBar = true

-- store old callbacks, replace, run, then run old, then replace back to way it was
--[[ local callback_drawItemDetails = ISInventoryPane.drawItemDetails
local callback_render = ISToolTipInv.render ]]

--- Adds tooltips to LSMRR_hasModifiedSoundRadius items
--- @type Starlit.InventoryUI.Callback_OnFillItemTooltip
function LSMRRInventoryUIListeners.CheckForModifiedRadiusItems(tooltip, layout, item)
    local modData = item:getModData()
    if modData == nil then return end
    if modData.LSMRR == nil then return end
    if modData.LSMRR.hasModifiedVolume ~= true then return end -- quick check
    print("CheckForModifiedRadiusItems Proc")
    local hasValidSoundType = false
    for k, v in pairs(modDataSoundTypes) do
        if modData.LSMRR[k] then -- if has one of the sound types modData identifier
            hasValidSoundType = true

            -- modify item properties in case of game reload

            -- local volume = modData[k]
            local layoutItem = layout:addItem()
            if layoutItem == nil then return end
            layoutItem:setLabel(getText("Tooltip_LSMRR_ItemVolume"), 1, 0.8, 0.8, 1)
            --if LSMRRInventoryUIListeners.shouldBeProgressBar == true then
                --LSMRRInventoryUIListeners.MakeProgressBar(volume, layoutItem, tooltip, layout)
            --else
            local soundTypeVolume
            local soundTypeFunc = soundTypeFuncs[v]
            if soundTypeFunc == nil then print("soundTypeFunc not valid")return end
            soundTypeVolume = soundTypeFunc(item)
            if soundTypeVolume == nil then print("soundType not valid on item") return end
            layoutItem:setValue(tostring(soundTypeVolume), 1, 1, 1, 1)
            --layoutItem:setValueRightNoPlus(tostring(soundTypeVolumeFromItemDirectly))
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

