--[[[
@module Mage Frost Rotation
@author htordeux
@version 8.0.1
]]--

local spells = kps.spells.mage
local env = kps.env.mage

local Blizzard = spells.blizzard.name
local RingOfFrost  = spells.ringOfFrost.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("MAGE","FROST", "polymorph", "Interface\\Icons\\spell_nature_polymorph", "polymorph")
end)

kps.rotations.register("MAGE","FROST",
{

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.iceBarrier, 'not player.hasBuff(spells.iceBarrier)'},
   {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.spellsteal, 'target.isStealable' , "target" },

   -- interrupts
    {{"nested"},'kps.cooldowns', {
        {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
        {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
        {spells.removeCurse, 'heal.lowestTankInRaid.isDispellable("Curse")' , kps.heal.lowestTankInRaid },
        {spells.removeCurse, 'heal.lowestInRaid.isDispellable("Curse")' , kps.heal.lowestInRaid },
        {spells.removeCurse, 'heal.isCurseDispellable' , kps.heal.isMagicDispellable },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.counterspell, 'target.isInterruptable' , "target" },
        {spells.counterspell, 'focus.isInterruptable' , "focus" },
    }},

    {spells.invisibility, 'target.isRaidBoss and player.isTarget'},
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},

    {spells.polymorph, 'kps.polymorph and focus.isAttackable and focus.hasMyDebuff(spells.polymorph) and focus.myDebuffDuration(spells.polymorph) < 3' , "focus" },
    
    -- TRINKETS
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(0)' , "/use 13" },
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(1)' , "/use 14" },
    
    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'true' , env.damageTarget },
    {spells.azerite.guardianOfAzeroth, 'true' , env.damageTarget },

    {spells.icyVeins },
    {spells.frozenOrb, 'true' , "target" },

    {{"macro"}, 'keys.shift and spells.blizzard.cooldown == 0' , "/cast [@cursor] "..Blizzard },
    {{"macro"}, 'player.plateCount >= 5 and spells.blizzard.cooldown == 0 and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Blizzard },
    {{"macro"}, 'spells.blizzard.cooldown == 0 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Blizzard },
           
    {spells.iceFloes, 'player.hasTalent(2,3) and player.isMoving and not player.hasBuff(spells.iceFloes)' },
    {spells.mirrorImage, 'player.hasTalent(3,2)' },
    {spells.runeOfPower, 'not player.isMoving and player.hasTalent(3,3)' },

    {spells.frostNova, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova) and not spells.frostNova.isRecastAt("target")' , "target" },
    {spells.coneOfCold, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova)' , "target" },
 
    {{"nested"}, 'kps.multiTarget and target.distanceMax <= 10 and target.isAttackable', {
        {spells.cometStorm, 'player.hasTalent(6,3)' },
        {spells.iceNova, 'player.hasTalent(1,3)' },
    }},

    -- if you do have Glacial Spike enabled you will always save Ebonbolt to generate a Brain Freeze proc for Glacial Spike
    {spells.ebonbolt, 'not player.isMoving and player.hasTalent(4,3) not player.hasBuff(spells.brainFreeze)' , "target" },
    -- Cast Flurry If you have 5 stacks of Mastery: Icicles after casting Glacial Spike -- Only use Flurry with Brain Freeze
    {{spells.glacialSpike,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasTalent(7,3) and player.buffStacks(spells.icicles) >= 4 and player.hasBuff(spells.brainFreeze)' , "target" , "glacialSpike_flurry_iceLance" },
    {{spells.frostbolt,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasBuff(spells.brainFreeze)' , "target" , "frostbolt_flurry_iceLance" },
    {{spells.glacialSpike}, 'not player.isMoving and player.hasTalent(7,3) and player.buffStacks(spells.icicles) == 5' , "target" , "glacialSpike_flurry_iceLance" },
    
    {spells.iceLance, 'player.hasBuff(spells.fingersOfFrost)' , "target" , "fingersOfFrost" }, 
    {spells.cometStorm, 'player.hasTalent(6,3)' }, 
    
    {spells.frostbolt, 'not player.isMoving' },
    {spells.iceLance },

}
,"mage_frost_basic")