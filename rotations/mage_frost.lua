--[[[
@module Mage Frost Rotation
@author htordeux
@version 8.3
]]--

local spells = kps.spells.mage
local env = kps.env.mage

local Blizzard = spells.blizzard.name
local RingOfFrost  = spells.ringOfFrost.name
local IceBlock = spells.iceBlock.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("MAGE","FROST", "polymorph", "Interface\\Icons\\spell_nature_polymorph", "polymorph")
end)

kps.rotations.register("MAGE","FROST",
{
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

    {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},
    {{"macro"}, 'player.hasBuff(spells.iceBlock) and player.hp > 0.90' , "/cancelaura "..IceBlock },
    {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
    {spells.iceBarrier, 'not player.hasBuff(spells.iceBarrier)'},
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.65', "player" },
    {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
    {spells.invisibility, 'target.isRaidBoss and targettarget.isUnit("player")'},
    {spells.invisibility, 'player.isTarget and player.hp < 0.40'},
    {spells.polymorph, 'kps.polymorph and focus.isAttackable and not focus.hasDebuff(spells.polymorph)' , "focus" },
    --{spells.spellsteal, 'target.isStealable' , "target" },

    {{"nested"},'kps.cooldowns', {
        {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
        {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
        {spells.removeCurse, 'heal.lowestTankInRaid.isDispellable("Curse")' , kps.heal.lowestTankInRaid },
        {spells.removeCurse, 'heal.lowestInRaid.isDispellable("Curse")' , kps.heal.lowestInRaid },
        {spells.removeCurse, 'heal.isCurseDispellable' , kps.heal.isMagicDispellable },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.counterspell, 'target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.counterspell, 'focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
        {spells.counterspell, 'mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
    }},
    
    -- TRINKETS
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'kps.multitarget and target.isAttackable' , env.damageTarget },
    {spells.azerite.guardianOfAzeroth, 'kps.multitarget and target.isAttackable' , env.damageTarget },
    {spells.azerite.focusedazeriteBeam, 'kps.multitarget and target.isAttackable' , env.damageTarget },

    {spells.icyVeins },
    {spells.frozenOrb, 'target.isAttackable' , "target" },
    {spells.cometStorm, 'player.hasTalent(6,3)' },

    {spells.glacialSpike, 'not player.isMoving and player.hasTalent(7,3) and player.hasBuff(spells.brainFreeze)' , "target" , "glacialSpike" },
    -- if you do have Glacial Spike enabled you will always save Ebonbolt to generate a Brain Freeze proc for Glacial Spike
    {spells.ebonbolt, 'not player.isMoving and player.hasTalent(4,3) and not player.hasBuff(spells.brainFreeze) and player.buffStacks(spells.icicles) == 5' , "target" , "ebonbolt_5" },
    -- flurry consomme gel mental -- between 0-3 Icicles use Flurry -- Only use Flurry with Brain Freeze
    {spells.flurry, 'player.hasBuff(spells.brainFreeze) and player.buffStacks(spells.icicles) < 4' , "target" , "flurry" },
    {spells.iceLance, 'player.hasBuff(spells.fingersOfFrost)' , "target" }, 

    {{"macro"}, 'keys.shift and spells.blizzard.cooldown == 0' , "/cast [@cursor] "..Blizzard },
    {{"macro"}, 'spells.blizzard.cooldown == 0 and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Blizzard },
    {{"macro"}, 'spells.blizzard.cooldown == 0 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Blizzard },

    {spells.iceFloes, 'player.hasTalent(2,3) and player.isMoving and not player.hasBuff(spells.iceFloes)' },
    {spells.mirrorImage, 'player.hasTalent(3,2)' },
    {spells.runeOfPower, 'not player.isMoving and player.hasTalent(3,3)' },

    {spells.frostNova, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova) and not spells.frostNova.isRecastAt("target")' , "target" },
    {spells.coneOfCold, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova)' , "target" },
    {spells.iceNova, 'player.hasTalent(1,3) and target.distanceMax <= 10 and target.isAttackable' , "target" },

    {spells.frostbolt, 'not player.isMoving' },
    {spells.iceLance },

}
,"mage_frost_basic")