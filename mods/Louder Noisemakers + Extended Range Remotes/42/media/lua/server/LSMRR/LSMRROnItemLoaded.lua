local LSMRRMain = require "lua/server/LSMRR/LSMRRMain"
local LSMRREvents = require "lua/server/LSMRR/LSMRREvents"

local onItemLoaded = function (item)
    LSMRRMain.SetItemPropertiesFromModData(item)
end

LSMRREvents.onItemLoaded:addListener(onItemLoaded)