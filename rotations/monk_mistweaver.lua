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

-- Apply Mystic Touch to all enemies in combat at the start of the encounter and to all adds spawning
{spells.mysticTouch, ' target.isAttackable and not target.hasMyDebuff(spells.mysticTouch)' , "target"},
-- Life Cocoon is able to be cast through Soothing Mist without breaking the channel.
{spells.lifeCocoon, 'heal.defaultTank.hp < 0.40' , kps.heal.defaultTank},
-- renewingMist 1.8% of base mana 40 yd range Instant 9 sec recharge. healing (225% of Spell power) health over 20 sec.

{spells.refreshingJadeWind, 'not player.hasBuff(spells.refreshingJadeWind)' },

-- precast Essence Font to have a double Gusts proc on all targets with the Essence Font HoT
-- if you’re Necrolord, you always want to Cast Bonedust Brew before Revival for increased effectiveness
{spells.risingSunKick, 'player.hasTalent(7,3) and target.isAttackable and heal.hasBuffCount(spells.essenceFont) > 4' , "target"},
{spells.essenceFont, 'heal.countLossInRange(0.80) > 4' , kps.heal.lowestInRaid},
{spells.revival, 'heal.countLossInRange(0.80) > 4' , kps.heal.lowestInRaid},

-- Heals the target for (440% of Spell power) over 8 sec.  While channeling, Enveloping Mist and Vivify may be cast instantly on the target.
{spells.soothingMist, 'not heal.defaultTank.hp < 0.80 and not heal.defaultTank.hasMyBuff(spells.soothingMist)' , kps.heal.defaultTank},
-- use Enveloping Mist through the Soothing Mist channel.
{spells.envelopingMist, 'heal.defaultTank.hp < 0.80 and not heal.defaultTank.hasMyBuff(spells.envelopingMist)' , kps.heal.defaultTank},
-- Having a Renewing Mist on the target amplifies Vivify's single target healing considerably.
{spells.renewingMist, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid},
-- spamming Vivify through Soothing Mist 
{spells.vivify, 'heal.defaultTank.hasMyBuff(spells.soothingMist) and heal.defaultTank.hp < 0.80' , kps.heal.defaultTank},

-- If you have more than 5 Renewing Mists on the raid, Vivify becomes more powerful and mana efficient than Essence Font
{spells.renewingMist, 'mouseover.hp < 0.85' , "mouseover"},
{spells.vivify, 'mouseover.hp < 0.85 and mouseover.hasMyBuff(spells.renewingMist)' , "mouseover"},

-- Thunder Focus Tea -- Primarily you want to use the buff on Vivify to make it free and save mana -- Enveloping Mist immediately heals for 280% of Spell Power 
-- Renewing Mist's duration is increased by 10 sec. Vivify costs no mana. Rising Sun Kick's cooldown reduced by 0 sec
{spells.thunderFocusTea, 'heal.defaultTarget.hp < 0.70' , kps.heal.defaultTarget},

{spells.invokeChijiTheRedCrane, 'heal.countLossInRange(0.85) > 3' , kps.heal.defaultTarget},
-- YulonTheJadeSerpent giving you a 25 second window Yu'lon will heal injured allies with Soothing Breath, healing the target and up to 2 allies 
{spells.invokeYulonTheJadeSerpent, 'heal.countLossInRange(0.85) > 4' , kps.heal.defaultTarget},

-- During Invoke Yulon, Invoke ChiJi, you should replace casts of EssenceFont with EnvelopingMist to apply EnvelopingBreath to the majority of the group
-- DPS and get your Crane stacks to 3, before casting your instant EnvelopingMist 
-- you will need to weave in casts of EnvelopingMist in order to trigger your EnvelopingBreath passive


-- Soothing Mist is a channeled, 8 second long healing over time spell that is unique in that it only consumes mana whenever it ticks for healing
-- and allows casting specifically 3 other spells while also casting this one
{spells.vivify, 'player.isCastingSpell(spells.soothingMist) and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
{spells.vivify, 'player.isCastingSpell(spells.soothingMist) and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.envelopingMist)' , kps.heal.lowestInRaid},

-- EnvelopingMist 5.6% of base mana 40 yd range 2 sec cast. healing for (360% of Spell power) over 6 sec. each RisingSunKick is a 66% increase to that duration
{spells.envelopingMist, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.envelopingMist)' , kps.heal.lowestInRaid},

-- Apply Mystic Touch to all enemies in combat at the start of the encounter and to all adds spawning
{spells.mysticTouch, ' target.isAttackable and not target.hasMyDebuff(spells.mysticTouch)' , "target"},
-- vivify 3.8% of base mana / 30 Energy 40 yd range 1.5 sec cast  healing the target for (141% of Spell power)
{spells.vivify, 'not player.isMoving and heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid},

-- DAMAGE
{spells.risingSunKick, 'target.isAttackable and player.buffStacks(spells.teachingsOfTheMonastery) == 3' , "target"},
-- cast Tiger Palm to get 3 stacks of Teachings of the Monastery till RSK comes off cooldown, cast RSK and then cast Blackout Kick for extra chances of resetting you RSK.
{spells.tigerPalm, 'target.isAttackable and player.buffStacks(spells.teachingsOfTheMonastery) < 2' , "target"},
{spells.blackoutKick ,'target.isAttackable' , "target"},
{spells.risingSunKick, 'target.isAttackable' , "target"},

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