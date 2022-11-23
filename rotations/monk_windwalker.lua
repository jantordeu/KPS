--[[[
@module Monk Windwalker Rotation
@author from wowhead
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
        spells.detox,
        spells.spearHandStrike
    })}

}
,"monk_windwalker")



        
 


 
