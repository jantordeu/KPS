--[[[
@module Monk Windwalker Rotation
@generated_from monk_windwalker.simc
@version 6.2.2
]]--
local spells = kps.spells.monk
local env = kps.env.monk

--GENERATED FROM SIMCRAFT PROFILE 'monk_windwalker.simc'
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
    {spells.fleshcraft, 'not player.isMoving' , "player" },
    {spells.fallenOrder, 'kps.multiTarget'},
    {spells.bonedustBrew, 'kps.multiTarget'},
    
    
    {spells.invokeXuenTheWhiteTiger},
    {spells.touchOfDeath },
	{spells.fistOfTheWhiteTiger, 'player.hasTalent(3,2) and player.chi < 3 and player.energy > 80' },
	{spells.expelHarm, 'player.chi < 5 and player.energy > 80' },
	{spells.tigerPalm , 'player.chi < 4 and player.energy > 80'},
	{spells.whirlingDragonPunch }, -- Only usable while both Fists of Fury and Rising Sun Kick are on cooldown.
	{spells.spinningCraneKick , 'player.hasBuff(spells.DanceOfChiJi)' },
	{spells.risingSunKick },
	{spells.fistsOfFury  },
	{spells.fistOfTheWhiteTiger },
	{spells.expelHarm, 'player.chi < player.chiMax' },
	{spells.chiBurst, 'player.chi < player.chiMax' },
	{spells.blackoutKick },
	{spells.chiWave , 'player.hasTalent(1,2)' },
	{spells.tigerPalm },   
    --{spells.stormEarthAndFire, 'kps.multiTarget'},
	{spells.vivify, 'heal.defaultTarget.hp < 0.70' , kps.heal.defaultTarget},
 

    
}
,"monk_windwalker")


--{spells.serenity, 'player.hasTalent(7,3)' },



        
 


 
