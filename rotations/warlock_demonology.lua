--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version Hekili
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock


kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    {"/cancelaura " .. spells.burningRush, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)"},

    {kps.hekili({
    })}
}
,"Hekili", {3,3,0,3,0,3,3})

