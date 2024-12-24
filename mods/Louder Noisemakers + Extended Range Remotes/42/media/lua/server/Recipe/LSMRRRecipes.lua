require 'server/LSMRR';

local LSMRR = LSMRR;
local Recipe = Recipe;

function Recipe.OnCreate.LSMRR_BoostWatchVolume(craftRecipeData, character)
    LSMRR.OnMakeLouder(craftRecipeData, character, "Radius");
end
function Recipe.OnCreate.LSMRR_AdjustGearsOnAlarmClock(craftRecipeData, character)
    LSMRR.OnMakeLouder(craftRecipeData, character, "Radius");
end
function Recipe.OnCreate.LSMRR_ModulateNoiseMakerVolume(craftRecipeData, character)
    LSMRR.OnMakeLouder(craftRecipeData, character, "Noise");
end
function Recipe.OnCreate.LSMRR_ExtendRangeOfRemoteController(craftRecipeData, character)
    LSMRR.OnMakeLouder(craftRecipeData, character, "Remote");
end
function Recipe.OnCreate.LSMRR_AttachAmplifierToNoiseMaker(craftRecipeData, character)
    LSMRR.OnMakeLouder(craftRecipeData, character, "Noise");
end