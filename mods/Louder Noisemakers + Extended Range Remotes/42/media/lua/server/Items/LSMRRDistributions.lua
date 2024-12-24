require 'Items/ProceduralDistributions';

local default_table = ProceduralDistributions;

--- The pass by ref data for default literature chance
local default_literature_chances = {
--- ["DistributionName"] = ItemDistributionChance
    ["ArmyStorageElectronics"]      = 1,
    ["BookstoreMisc"]               = 2,
    ["CrateMagazines"]              = 1,
    ["ElectronicStoreMagazines"]    = 8,
    ["EngineerTools"]               = 2,
    ["ElectricianOutfit"]           = 2,
    ["ElectricianTools"]            = 2,
    ["LibraryMagazines"]            = 1,
    ["LivingRoomShelf"]             = 0.1,
    ["LivingRoomShelfClassy"]       = 0.1,
    ["LivingRoomShelfRedneck"]      = 0.1,
    ["LivingRoomSideTable"]         = 0.1,
    ["LivingRoomSideTableClassy"]   = 0.1,
    ["LivingRoomSideTableRedneck"]  = 0.1,
    ["LivingRoomWardrobe"]          = 0.1,
    ["MagazineRackMixed"]           = 1,
    ["PostOfficeMagazines"]         = 1,
    ["RecRoomShelf"]                = 0.1,
    ["SafehouseBookShelf"]          = 0.5,
    ["SafehouseFireplace"]          = 0.1,
    ["SafehouseFireplace_Late"]     = 0.1,
    ["ShelfGeneric"]                = 0.1,
    ["ToolStoreBooks"]              = 2,
    ["UniversityLibraryMagazines"]  = 1,
}

---@param input_lit_chances table
---@param resultCallable function
local function mod_literature_table(input_lit_chances, resultCallable)
    local literature_table = {}
    for item_name, chance in pairs(input_lit_chances) do
        literature_table[item_name] = tonumber(string.format("%.2f", resultCallable(chance)))
    end
    return literature_table;
end

local literature_names_with_chances = {
    ["LSMRR_ExtendedRangeRemoteMag"] = default_literature_chances,
    ["LSMRR_ModulatedNoiseMakerMag"] = default_literature_chances,
    ["LSMRR_AddAmplifierSchematic"] = mod_literature_table(default_literature_chances, function(a) return (a/2) end),
}

local literature_module_name = "LSMRR_Items_Literature";

--- Iterate items and item_names and add to _table with module_name prepended
--- Should make a seperate list with the distributions but... :D
--- 
---@param items table
---@param module_name string
---@param _table Java:DistributionsTable
local function iterate_items_into_table(items, module_name, _table)
    for item_name, _ in pairs(items) do
        for distribution, chance_for_item in pairs(items[item_name]) do
            table.insert(_table["list"][distribution].items, module_name .. "." .. item_name);
            table.insert(_table["list"][distribution].items, chance_for_item);
        end
    end
end

--- Add literature to default_table
iterate_items_into_table(literature_names_with_chances, literature_module_name, default_table);