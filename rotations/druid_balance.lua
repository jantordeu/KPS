--[[[
@module Druid Balance Rotation
@author Kirk24788
@version Hekili
]]--

local spells = kps.spells.druid
local env = kps.env.druid

--[[
Suggested Talents:
Level 15: Starlord
Level 30: Displacer Beast
Level 45: Restoration Affinity
Level 60: Mass Entanglement
Level 75: Incarnation: Chosen of Elune
Level 90: Blessing of the Ancients
Level 100: Nature's Balance
]]--

kps.rotations.register("DRUID","BALANCE",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    {spells.rejuvenation, 'not player.hasMyBuff(spells.rejuvenation)' , "player" },
    {spells.renewal, 'player.hp < 0.30' , "player" },
    {spells.moonfire, 'target.isAttackable and target.myDebuffDuration(spells.moonfire) < 2 and not spells.moonfire.isRecastAt("target")' , "target" },
    {spells.sunfire, 'target.isAttackable and target.myDebuffDuration(spells.sunfire) < 2 and not spells.sunfire.isRecastAt("target")' , "target" }, 
    
	{kps.hekili({
		spells.moonfire,
		spells.sunfire
	}), 'kps.multiTarget'},

}
,"Hekili")