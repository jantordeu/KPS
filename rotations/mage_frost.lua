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
    env.FocusMouseover,
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

    -- "Slow Fall"
    {spells.slowFall, 'player.isFallingFor(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
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
        {{"macro"}, 'not player.isMoving and target.distanceMax <= 10 and focus.exists and focus.distanceMax <= 10', "/cast [@player] "..Blizzard },
    }},
    {{"macro"}, 'not player.isMoving and spells.frostNova.cooldown > kps.gcd and not target.hasMyDebuff(spells.frostNova) and target.isAttackable and target.distanceMax <= 10', "/cast [@player] "..RingOfFrost },
    
    -- cast Glacial Spike when available and only when you have a Brain Freeze 
    {spells.glacialSpike, 'player.hasTalent(7,3) and spells.glacialSpike.isUsable and player.hasBuff(spells.brainFreeze)' , "target" , "glacialSpike" },
    -- if you have Splitting Ice talented and there is more than 1 target you should cast Glacial Spike when available, even without a Brain Freeze
    {spells.glacialSpike, 'player.hasTalent(7,3) and spells.glacialSpike.isUsable and player.hasTalent(6,2) and player.plateCount > 1 ' , "target" , "glacialSpike_splittingIce" },

    -- if you have have 5 Mastery: Icicles then you cast Glacial Spike, followed by the Flurry -- if you do have Glacial Spike enabled you will always save Ebonbolt to generate a Brain Freeze proc for Glacial Spike
    {{spells.ebonbolt,spells.glacialSpike,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasTalent(7,3) and spells.glacialSpike.isUsable and not player.hasBuff(spells.brainFreeze)' , "target" , "ebonbolt_glacialSpike_flurry_iceLance" },
    -- Cast Flurry If you have 5 stacks of Mastery: Icicles after casting Glacial Spike
    {{spells.glacialSpike,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasTalent(7,3) and spells.glacialSpike.isUsable' , "target" , "glacialSpike_flurry_iceLance" },

    -- vous avez un proc Gel mental et moins de 4 stacks de Glaçons -- if you do not have Glacial Spike talented
    {{spells.frostbolt,spells.flurry,spells.iceLance}, 'not player.isMoving and not player.hasTalent(7,3) and player.buffStacks(spells.icicles) <= 4 and player.hasBuff(spells.brainFreeze)' , "target" , "frostbolt_flurry_iceLance" },
    -- Cast Ebonbolt followed by Flurry and then Ice Lance if you do not have Glacial Spike enabled
    {{spells.ebonbolt,spells.flurry,spells.iceLance}, 'not player.isMoving and player.hasTalent(7,3) and not spells.glacialSpike.isUsable and player.buffStacks(spells.icicles) < 4' , "target" , "ebonbolt_flurry_iceLance" },

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