require 'Items/ProceduralDistributions'
require 'Items/SuburbsDistributions'
require 'Items/Distributions'

function loot_register(item, chance, allocation)
    table.insert(ProceduralDistributions.list[allocation].items, item);
    table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local item_name = "";

-- Base.4X_Range_Remotes_Mag_LOUDER_Tot
item_name = "Base.4X_Range_Remotes_Mag_LOUDER_Tot";
loot_register(item_name, 2 , "BookstoreMisc");
loot_register(item_name, 1 , "CrateMagazines");
loot_register(item_name, 8 , "ElectronicStoreMagazines");
loot_register(item_name, 2 , "EngineerTools");
loot_register(item_name, 1 , "LibraryBooks");
loot_register(item_name, 0.1 , "LivingRoomShelf");
loot_register(item_name, 0.1 , "LivingRoomShelfNoTapes");
loot_register(item_name, 0.1 , "LivingRoomSideTable");
loot_register(item_name, 0.1 , "LivingRoomSideTableNoRemote");
loot_register(item_name, 1 , "MagazineRackMixed");
loot_register(item_name, 1 , "PostOfficeMagazines");
loot_register(item_name, 0.1 , "ShelfGeneric");
loot_register(item_name, 2 , "ToolStoreBooks");

-- Base.NoiseTrap_Mag_LOUDER_Tot
item_name = "Base.NoiseTrap_Mag_LOUDER_Tot";
loot_register(item_name, 2 , "BookstoreMisc");
loot_register(item_name, 1 , "CrateMagazines");
loot_register(item_name, 8 , "ElectronicStoreMagazines");
loot_register(item_name, 2 , "EngineerTools");
loot_register(item_name, 1 , "LibraryBooks");
loot_register(item_name, 0.1 , "LivingRoomShelf");
loot_register(item_name, 0.1 , "LivingRoomShelfNoTapes");
loot_register(item_name, 0.1 , "LivingRoomSideTable");
loot_register(item_name, 0.1 , "LivingRoomSideTableNoRemote");
loot_register(item_name, 1 , "MagazineRackMixed");
loot_register(item_name, 1 , "PostOfficeMagazines");
loot_register(item_name, 0.1 , "ShelfGeneric");
loot_register(item_name, 2 , "ToolStoreBooks");
