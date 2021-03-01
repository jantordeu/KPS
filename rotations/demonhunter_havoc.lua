--[[[
@module Demonhunter Havoc Rotation
@author Kirk24788
@version Hekili
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter




kps.rotations.register("DEMONHUNTER","HAVOC",
{
    {kps.hekili({
        spells.disrupt
    }), 'keys.shift'},
    {kps.hekili({
        spells.disrupt.id,
        spells.elysianDecree,
        spells.metamorphosis
    })}
}
,"Hekili")
