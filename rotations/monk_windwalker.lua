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

    {spells.fistOfTheWhiteTiger, 'player.chi < 3' },
    {spells.expelHarm, 'player.chi < player.chiMax' },
    {spells.tigerPalm , 'player.chi < 4'},
    {spells.invokeXuenTheWhiteTiger },
    {spells.fallenOrder, 'kps.multiTarget'},
    {spells.touchOfDeath },
    {spells.vivify, 'heal.defaultTarget.hp < 0.70' , kps.heal.defaultTarget},

    {kps.hekili({
		spells.flyingSerpentKick,
		spells.fallenOrder
    })}
    
}
,"monk_windwalker")



--	{spells.fistOfTheWhiteTiger, 'player.chi < 3' },
--	{spells.expelHarm, 'player.chi < player.chiMax' },
--	{spells.tigerPalm , 'player.chi < 4'},
--	{spells.invokeXuenTheWhiteTiger },
--	{spells.fallenOrder },
--	{spells.whirlingDragonPunch },
--	{spells.spinningCraneKick , 'playerHasBuff(spells.DanceOfChiJi)' },
--	{spells.fistsOfFury  },
--	{spells.touchOfDeath },
--	{spells.chiBurst, 'player.chi < player.chiMax' },
--	{spells.blackoutKick },
--	{spells.chiWave }, 'player.hasTalent(1,2)' },
        
 


 
