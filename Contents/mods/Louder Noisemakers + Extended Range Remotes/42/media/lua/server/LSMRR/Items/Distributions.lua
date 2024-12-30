--- ProceduralDistributions should be the only one used, generally
local defaultTable = ProceduralDistributions

--- Default distributions for electronics magazines
local defaultElectronicsLiteratureChances = {
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
--- If you wanted to make your own custom literature table, you would just copy the structure above.

--- Can ignore, just a little helper function that is used for modifying a tables values via an operation.
---@param inputLiteratureChances table
---@param resultCallable function
local function modLiteratureTable(inputLiteratureChances, resultCallable)
    local literatureTable = {}
    for item_name, chance in pairs(inputLiteratureChances) do
        literatureTable[item_name] = tonumber(string.format("%.2f", resultCallable(chance)))
    end
    return literatureTable
end

--- Each literature has its own table with the distributions and the chances for that item to spawn in said distributions.
local literatureNamesWithChances = {
    ["LSMRRExtendedRangeRemoteMag"] = defaultElectronicsLiteratureChances,
    ["LSMRRModulatedNoiseMakerMag"] = defaultElectronicsLiteratureChances,
    ["LSMRRAddAmplifierSchematic"] = modLiteratureTable(defaultElectronicsLiteratureChances, function(a) return (a/2) end),
}

--- Module that the literature originates.
local literatureModuleName = "LSMRR";


--- Iterate chanceForItem and add to _table
---
---@param items table
---@param moduleName string
---@param _table DistributionsTable
local function iterateItemsIntoTable(items, moduleName, _table)
    for itemName, v in pairs(items) do
        for distribution, chanceForItem in pairs(items[itemName]) do
            --- add module.item to table
            table.insert(_table["list"][distribution].items, moduleName .. "." .. itemName)
            table.insert(_table["list"][distribution].items, chanceForItem)
        end
    end
end

--- Add literature to defaultTable
iterateItemsIntoTable(literatureNamesWithChances, literatureModuleName, defaultTable)