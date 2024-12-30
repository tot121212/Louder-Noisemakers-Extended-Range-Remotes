local Events = require "Starlit/Events"
--- init starlit events

local StarlitEvents = {}

StarlitEvents.OnItemLoaded = Events.new()
---@alias Starlit.Events.Callback_OnItemLoaded fun(item:InventoryItem)

return StarlitEvents
