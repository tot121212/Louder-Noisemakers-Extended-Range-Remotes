local Main = require "LSMRR/Main"

function Recipe.OnCreate.LSMRRBoostWatchVolume(craftRecipeData, character)
    Main.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRRAdjustGearsOnAlarmClock(craftRecipeData, character)
    Main.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRRModulateNoiseMakerVolume(craftRecipeData, character)
    Main.OnMakeLouder(craftRecipeData, character, "Noise")
end
function Recipe.OnCreate.LSMRRExtendRangeOfRemoteController(craftRecipeData, character)
    Main.OnMakeLouder(craftRecipeData, character, "Remote")
end
function Recipe.OnCreate.LSMRRAttachAmplifierToNoiseMaker(craftRecipeData, character)
    Main.OnMakeLouder(craftRecipeData, character, "Noise")
end