--[[[
@module Shaman Restoration Rotation
@author kirk24788
@version 7.0.3
]]--
local spells = kps.spells.monk
local env = kps.env.monk


kps.rotations.register("MONK","MISTWEAVER",
{

{{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
{{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
{{"macro"}, 'not focus.exists and mouseover.isHealable and mouseover.isRaidTank' , "/focus mouseover" },



{spells.lifeCocoon, 'heal.defaultTank.hp < 0.40' , kps.heal.defaultTank},
-- EnvelopingMist lasts for 6 seconds by default, each RisingSunKick is a 66% increase to that duration
{spells.risingSunKick, 'true' , kps.heal.defaultTarget},
{spells.thunderFocusTea, 'true' , kps.heal.defaultTarget},
{spells.revival, 'heal.countLossInRange(0.80) == heal.countInRange' , kps.heal.defaultTarget},
-- ChijiTheRedCrane giving you a 25 second window in which you are spending no Mana, 3 min cd
-- DPS and get your Crane stacks to 3, before casting your instant EnvelopingMist 
{spells.invokeChijiTheRedCrane, 'heal.countLossInRange(0.85) > 3' , kps.heal.defaultTarget},
-- YulonTheJadeSerpent giving you a 25 second window Yu'lon will heal injured allies with Soothing Breath, healing the target and up to 2 allies 
{spells.invokeYulonTheJadeSerpent, 'heal.countLossInRange(0.85) > 3' , kps.heal.defaultTarget},
-- During Invoke Yulon, Invoke ChiJi, you should replace casts of EssenceFont with EnvelopingMist to apply EnvelopingBreath to the majority of the group
-- you will need to weave in casts of EnvelopingMist in order to trigger your EnvelopingBreath passive

{spells.soothingMist, 'heal.defaultTank.hp < 0.85' , kps.heal.defaultTank},
{spells.envelopingMist, 'heal.defaultTank.hp < 0.70' , kps.heal.defaultTank},
{spells.envelopingMist, 'heal.defaultTarget.hp < 0.70' , kps.heal.defaultTarget},

{spells.essenceFont, 'heal.countLossInRange(0.85) > 3' , kps.heal.defaultTarget},

{spells.mysticTouch, 'heal.defaultTarget.hp < 0.85' , kps.heal.defaultTarget},
{spells.vivify, 'heal.defaultTarget.hp < 0.85' , kps.heal.defaultTarget},
{spells.renewingMist, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid},





}
,"mistweaver_shadowland")


--vivify = kps.Spell.fromId(116670)
--risingSunKick = kps.Spell.fromId(107428)
--essenceFont = kps.Spell.fromId(191837)
--soothingMist = kps.Spell.fromId(115175)
--envelopingMist = kps.Spell.fromId(124682)
--mysticTouch = kps.Spell.fromId(8647)
--thunderFocusTea = kps.Spell.fromId(116680)
--renewingMist = kps.Spell.fromId(115151)
--invokeChijiTheRedCrane = kps.Spell.fromId(198664)
--invokeNiuzaoTheBlackOx = kps.Spell.fromId(132578)
--invokeXuenTheWhiteTiger = kps.Spell.fromId(123904)
--lifeCocoon = kps.Spell.fromId(116849)
--revival = kps.Spell.fromId(115310)