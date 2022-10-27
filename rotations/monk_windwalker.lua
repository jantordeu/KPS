--[[[
@module Monk Windwalker Rotation
@generated_from monk_windwalker.simc
@version 6.2.2
]]--
local spells = kps.spells.monk
local env = kps.env.monk

kps.rotations.register("MONK","WINDWALKER",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },

    {{"nested"}, 'kps.interrupt',{
        {spells.spearHandStrike, 'target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.spearHandStrike, 'mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.diffuseMagic , 'target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.legSweep, 'target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    {{"nested"},'kps.cooldowns', {
        {spells.detox, 'player.isDispellable("Poison")' , "player" },
        {spells.detox, 'player.isDispellable("Disease")' , "player" },
    }},
    -- NECROLORD
    {spells.fleshcraft, 'not player.isMoving' , "player" },

    {kps.hekili({
        spells.detox
    }), 'keys.shift'},
    
    
    {kps.hekili({
        spells.detox,
        spells.spearHandStrike
    })}
    
--    {spells.fleshcraft, 'not player.isMoving' , "player" },
--    {spells.fallenOrder, 'kps.multiTarget'},
--    {spells.bonedustBrew, 'kps.multiTarget'}, -- Spinning Crane Kick refunds 1 Chi when striking enemies with your Bonedust Brew active
--    {spells.stormEarthAndFire, 'kps.multiTarget'},
--    {spells.touchOfKarma, 'player.hasBuff(spells.fortifyingBrew)'  }, -- Absorbs all damage taken for 10 sec, up to 50% of your maximum health, and redirects 70% of that amount to the enemy target 1,5 min cd
--    {spells.fortifyingBrew, 'player.hp < 0.70'  }, -- Maximum health increased by 15%. Damage taken reduced by 15%. 3 min cd
--    {spells.invokeXuenTheWhiteTiger},
--    {spells.touchOfDeath },
--  {spells.fistOfTheWhiteTiger, 'player.hasTalent(3,2) and player.chi < 3 and player.energy > 80' },
--  {spells.expelHarm, 'player.chi < player.chiMax' },
--  {spells.chiBurst, 'player.hasTalent(1,3) and player.chi < player.chiMax' },
--  {spells.tigerPalm , 'player.chi < 4 and player.energy > 80'},
--  {spells.whirlingDragonPunch }, -- Only usable while both Fists of Fury and Rising Sun Kick are on cooldown.
--  {spells.spinningCraneKick , 'player.hasBuff(spells.DanceOfChiJi)' },
--  {spells.fistsOfFury  },
--  {spells.risingSunKick },
--  {spells.spinningCraneKick },
--  {spells.fistOfTheWhiteTiger },
--  {spells.chiWave , 'player.hasTalent(1,2)' },
--  {spells.blackoutKick },
--  {spells.tigerPalm },   
--  {spells.vivify, 'player.hp < 0.70' , "player"},

}
,"monk_windwalker")



        
 


 
