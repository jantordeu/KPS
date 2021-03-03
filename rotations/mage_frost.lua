--[[[
@module Mage Frost Rotation
@author Kirk24788
@version Hekili
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","FROST",
{
    {kps.hekili({
        spells.counterspell
    }), 'keys.shift'},
    {kps.hekili({
        spells.counterspell,
        spells.blizzard
    })}
}
,"Hekili")
