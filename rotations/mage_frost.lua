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
   kps.gui.addCustomToggle("MAGE","FROST", "control", "Interface\\Icons\\spell_nature_polymorph", "control")
end)

kps.rotations.register("MAGE","FROST",
{

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    
    {spells.polymorph, 'kps.control and focus.isAttackable and not focus.hasMyDebuff(spells.polymorph) and focus.myDebuffDuration(spells.polymorph) < 2' , "focus" },

    {spells.iceBlock, 'player.hp <= 0.20' },
    {spells.iceBarrier, 'not player.hasBuff(spells.iceBarrier)' },
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Blizzard },
    
    {spells.spellsteal, 'target.isStealable' , "target" },
   -- interrupts
    {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
    {{"nested"}, 'kps.interrupt',{
        {spells.counterspell, 'target.isInterruptable' , "target" },
        {spells.counterspell, 'focus.isInterruptable' , "focus" },
    }},
    
    -- TRINKETS
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(0)' , "/use 13" },
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(1)' , "/use 14" },
    
    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'player.hasBuff(spells.voidForm)' , env.damageTarget },

    -- "Slow Fall"
    {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
    {spells.iceFloes, 'player.hasTalent(2,3) and player.isMoving and not player.hasBuff(spells.iceFloes)' },
    {spells.mirrorImage, 'player.hasTalent(3,2)' },
    {spells.runeOfPower, 'player.hasTalent(3,3)' },
    {spells.icyVeins },
    
    {spells.frostNova, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova) and not spells.frostNova.isRecastAt("target")' , "target" },
    {spells.frostNova, 'focus.isAttackable and focus.distanceMax <= 10 and not target.hasDebuff(spells.frostNova) and not spells.frostNova.isRecastAt("focus")' , "focus" },
    {spells.coneOfCold, 'target.isAttackable and target.distanceMax <= 10 and not target.hasDebuff(spells.frostNova)' , "target" },
    {spells.coneOfCold, 'focus.isAttackable and focus.distanceMax <= 10 and not focus.hasDebuff(spells.frostNova)' , "focus" },
    {{"nested"}, 'kps.multiTarget and target.distance <= 10 and target.isAttackable', {
        {spells.frozenOrb },
        {spells.cometStorm, 'player.hasTalent(6,3)' },
        {spells.iceNova, 'player.hasTalent(1,3)' },
        {{"macro"}, 'not player.isMoving and target.distanceMax <= 10 and spells.blizzard.cooldown == 0', "/cast [@player] "..Blizzard },
    }},
    {{"macro"}, 'not player.isMoving and spells.ringOfFrost.cooldown == 0 and not target.hasMyDebuff(spells.frostNova) and target.isAttackable and target.distanceMax <= 10', "/cast [@player] "..RingOfFrost },
    
    -- Cast Flurry If you have 5 stacks of Mastery: Icicles after casting Glacial Spike
    {{spells.glacialSpike,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasTalent(7,3) and player.buffStacks(spells.icicles) == 5 and player.hasBuff(spells.brainFreeze)' , "target" , "glacialSpike_flurry_iceLance" },
    -- if you have have 5 Mastery: Icicles then you cast Glacial Spike, followed by the Flurry -- if you do have Glacial Spike enabled you will always save Ebonbolt to generate a Brain Freeze proc for Glacial Spike
    {spells.ebonbolt, 'not player.isMoving and player.hasTalent(7,3) and player.buffStacks(spells.icicles) == 5 and not player.hasBuff(spells.brainFreeze)' , "target" , "ebonbolt_glacialSpike_flurry_iceLance" },

    {spells.iceLance, 'player.hasBuff(spells.fingersOfFrost)' , "target" , "fingersOfFrost" },
     -- "Blizzard" -- "Freezing Rain"  Blizzard is instant cast and deals 50% increased damage
    {spells.blizzard, 'player.hasBuff(spells.freezingRain)' },

    {spells.frozenOrb, 'target.hasMyDebuff(spells.frostNova)' , "target" },    
    {spells.rayOfFrost, 'player.hasTalent(7,2)' },
    {spells.cometStorm, 'player.hasTalent(6,3)' },

    {spells.iceNova, 'player.hasTalent(1,3)' },
    {spells.frostbolt, 'not player.isMoving' },
    {spells.iceLance },

}
,"mage_frost_basic")