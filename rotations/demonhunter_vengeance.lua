--[[[
@module Demonhunter Vengeance Rotation
@author Kirk24788
@version 8.0.1
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter

kps.rotations.register("DEMONHUNTER","VENGEANCE",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.demonSpikes, 'player.hp < 0.8 and not player.hasBuff(spells.demonSpikes)'},
        {spells.metamorphosis, 'player.hp < 0.6'},
        {spells.fieryBrand, 'player.hp < 0.7'},
    }},

    {spells.infernalStrike, 'keys.shift and not spells.infernalStrike.isRecastAt("target")'},

    {kps.hekili({
        spells.infernalStrike.id
    })}
}
,"Hekili")
