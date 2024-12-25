local Recipe = Recipe;

function Recipe.OnCreate.LSMRR_BoostWatchVolume(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRR_AdjustGearsOnAlarmClock(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Radius")
end
function Recipe.OnCreate.LSMRR_ModulateNoiseMakerVolume(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Noise")
end
function Recipe.OnCreate.LSMRR_ExtendRangeOfRemoteController(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Remote")
end
function Recipe.OnCreate.LSMRR_AttachAmplifierToNoiseMaker(craftRecipeData, character)
    LSMRRMain.OnMakeLouder(craftRecipeData, character, "Noise")
end