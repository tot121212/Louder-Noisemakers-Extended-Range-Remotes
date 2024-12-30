local Main = require "LSMRR/Main"
local StarlitEvents = require "LSMRR/StarlitEvents"

-- Add func and listener
---@type Starlit.Events.Callback_OnItemLoaded
local OnItemLoaded = function(item)
    Main.SetItemPropertiesFromModData(item)
end

StarlitEvents.OnItemLoaded:addListener(OnItemLoaded)
