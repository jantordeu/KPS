--[[[
@module Deathknight Blood Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.vampiricBlood, 'player.hp < 0.5'},
        {spells.dancingRuneWeapon, 'player.hp < 0.6'},
    }},

    {kps.hekili({
        spells.mindFreeze
    }), 'keys.shift'},
    {kps.hekili({
        spells.mindFreeze,
        spells.deathAndDecay
    })}
}
,"Icy Veins", {2,2,2,1,0,2,-1})
