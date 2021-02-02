--[[[
@module Demonhunter Havoc Rotation
@author Kirk24788
@version 8.0.1
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter




kps.rotations.register("DEMONHUNTER","HAVOC",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.blur, 'player.hp < 0.5'},
        {spells.darkness, 'player.hp < 0.7'},
    }},

    {kps.hekili({}), 'keys.shift'},
    {kps.hekili({
        spells.elysianDecree.id,
        spells.metamorphosis.id
    })}
}
,"Hekili")
