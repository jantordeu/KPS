--[[[
@module Warrior Protection Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior

local HeroicLeap = spells.heroicLeap.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("WARRIOR","PROTECTION", "taunt", "Interface\\Icons\\spell_nature_reincarnation", "taunt")
end)

kps.rotations.register("WARRIOR","PROTECTION",
{
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    
    {spells.taunt, 'kps.taunt and not player.isTarget' , "target" , "taunt" },
    {spells.berserkerRage, 'target.isCasting' },
    
    -- Interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.pummel, 'target.isInterruptable and target.castTimeLeft < 1' , "target" },
        {spells.pummel, 'focus.isInterruptable and focus.castTimeLeft < 1' , "focus" },
    }},
    {spells.spellReflection, 'target.isCasting' , "target" },
    {spells.shockwave, 'target.isCasting' , "target" },
    
    -- Charge enemy
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HeroicLeap },
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distanceMax  > 10' },
    {spells.intercept, 'kps.defensive and target.isAttackable and target.distanceMax  > 10' },

    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.victoryRush, 'player.hp < 0.90'},
    {spells.shieldWall, 'player.hp < 0.60' },
    {spells.lastStand, 'player.hp < 0.40' },

    -- TRINKETS
    {{"macro"}, 'player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.isElite' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.hp > player.hp' , "/use 14" },

    {spells.demoralizingShout, 'player.incomingDamage > 0' },    
    {spells.avatar},

    {spells.shieldBlock, 'player.incomingDamage > 0 and player.myBuffDuration(spells.shieldBlock) < 2' , "target" , "shieldBlock" },
    {spells.shieldSlam},
    {spells.thunderClap, 'player.plateCount > 2 and target.distanceMax  <= 10'},
    {spells.revenge, 'spells.revenge.cost == 0' , "target", "revenge_free" },
    {spells.revenge, 'player.rage > 90' , "target", "revenge_rage" },
    {spells.devastate, 'target.distanceMax  <= 10' , "target" , "devastate" }, 

    {{"macro"}, 'true' , "/startattack" },

}
,"warrior_protection_bfa")