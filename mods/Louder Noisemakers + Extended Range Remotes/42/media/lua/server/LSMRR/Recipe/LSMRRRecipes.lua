local LSMRRMain = require "lua/server/LSMRR/LSMRRMain"
if LSMRRMain == nil then print("LSMRRMain is nil") return end

local Recipe = Recipe;

function Recipe.OnCreate.LSMRRBoostWatchVolume(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRRAdjustGearsOnAlarmClock(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRRModulateNoiseMakerVolume(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Noise")
end
function Recipe.OnCreate.LSMRRExtendRangeOfRemoteController(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Remote")
end
function Recipe.OnCreate.LSMRRAttachAmplifierToNoiseMaker(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Noise")
end