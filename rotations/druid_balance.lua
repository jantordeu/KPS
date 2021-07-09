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
    
    {kps.hekili({
    })}
}
,"Hekili")

--[[

GetSpellCount(7, "BOOKTYPE_SPELL"))
count = GetSpellCount(194153) or 0
count = GetSpellCount(190984) or 0

spells.wrath  -- to enter Lunar Eclipse, you need to cast two Wrath 190984/wrath
spells.starfire -- to enter Solar Eclipse, you must cast two Starfire 194153-starfire
spells.eclipse 
spells.moonfire 
spells.stellarFlare 
spells.sunfire 

spells.celestialAlignment  -- oncd Les deux éclipses sont actives. Hâte augmentée de 10%. 20 secondes restantes
spells.forceOfNature -- oncd /cast [@cursor] Force of Nature
spells.furyOfElune  -- oncd in an eclipse
spells.warriorOfElune

The pandemic windows for each DoT are the following: re-DoT when you’re in between eclipse
Stellar Flare Icon Stellar Flare = 8-seconds
Moonfire Icon Moonfire = 7-seconds
Sunfire Icon Sunfire = 6-seconds

Spend your Astral Power on
spells.starsurge = kps.Spell.fromId(78674)
spells.starfall = kps.Spell.fromId(191034)

spells.convokeTheSpirits -- convoke-the-spirits when you have less than 50 Astral Power

--]]