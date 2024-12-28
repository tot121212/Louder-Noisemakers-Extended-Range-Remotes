local LSMRRMain = require "LSMRR/LSMRRMain"

local onItemLoaded = function (item)
    LSMRRMain.SetItemPropertiesFromModData(item)
end

LSMRREvents.onItemLoaded:addListener(onItemLoaded)
return LSMRRMain