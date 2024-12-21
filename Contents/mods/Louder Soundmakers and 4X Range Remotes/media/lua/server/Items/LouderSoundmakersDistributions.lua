-- require 'Items/ProceduralDistributions'
-- require 'Items/SuburbsDistributions'
-- require 'Items/Distributions'

local default_table = "ProceduralDistributions";

local default_literature_chances = {
    --- ["DistributionName"] = DistributionChance
    ["BookstoreMisc"]               = 2,
    ["CrateMagazines"]              = 2,
    ["ElectronicStoreMagazines"]    = 8,
    ["EngineerTools"]               = 2,
    ["LibraryBooks"]                = 1,
    ["LivingRoomShelf"]             = 0.1,
    ["LivingRoomShelfNoTapes"]      = 0.1,
    ["LivingRoomSideTable"]         = 0.1,
    ["LivingRoomSideTableNoRemote"] = 0.1,
    ["MagazineRackMixed"]           = 1,
    ["PostOfficeMagazines"]         = 1,
    ["ShelfGeneric"]                = 0.1,
    ["ToolStoreBooks"]              = 2
}

local literature_names_with_chances = {
    ["4X_Range_Remotes_Mag_LOUDER_Tot"] = default_literature_chances,
    ["NoiseTrap_Mag_LOUDER_Tot"] = default_literature_chances
}

local literature_module_name = "LouderSoundmakers_Items_Literature";

--- Iterate items and item_names and add to _table with module_name prepended
--- Should make a seperate list with the distributions but... :D
local function iterate_items_into_table(items, module_name, _table)
    for item_name, _ in pairs(items) do
        for distribution, chance_for_distribution in pairs(items[item_name]) do
            table.insert(_table.list[distribution].items, module_name .. item_name);
            table.insert(_table.list[distribution].items, chance_for_distribution);
        end
    end
end

--- Add literature to default_table
iterate_items_into_table(literature_names_with_chances, literature_module_name, default_table);