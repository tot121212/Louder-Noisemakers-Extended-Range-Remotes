local defaultTable = ProceduralDistributions

--- The pass by ref data for default literature chance
local defaultLiteratureChances = {
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

---@param inputLiteratureChances table
---@param resultCallable function
local function modLiteratureTable(inputLiteratureChances, resultCallable)
    local literatureTable = {}
    for item_name, chance in pairs(inputLiteratureChances) do
        literatureTable[item_name] = tonumber(string.format("%.2f", resultCallable(chance)))
    end
    return literatureTable
end

local literatureNamesWithChances = {
    ["LSMRRExtendedRangeRemoteMag"] = defaultLiteratureChances,
    ["LSMRRModulatedNoiseMakerMag"] = defaultLiteratureChances,
    ["LSMRRAddAmplifierSchematic"] = modLiteratureTable(defaultLiteratureChances, function(a) return (a/2) end),
}

local literatureModuleName = "LSMRR";

--- Iterate items and item_names and add to _table with module_name prepended
--- Should make a seperate list with the distributions but... :D
--- 
---@param items table
---@param moduleName string
---@param _table DistributionsTable
local function iterateItemsIntoTable(items, moduleName, _table)
    for itemName, v in pairs(items) do
        for distribution, chanceForItem in pairs(items[itemName]) do
            table.insert(_table["list"][distribution].items, moduleName .. "." .. itemName)
            table.insert(_table["list"][distribution].items, chanceForItem)
        end
    end
end

--- Add literature to default_table
iterateItemsIntoTable(literatureNamesWithChances, literatureModuleName, defaultTable)