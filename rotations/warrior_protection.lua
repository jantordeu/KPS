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

-- kps.defensive for charge
-- kps.interrupt for interrupts
-- kps.multiTarget for multiTarget
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
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.intercept, 'kps.defensive and target.isAttackable and target.distance > 10' },

    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.victoryRush, 'player.hp < 0.90'},
    {spells.stoneform, 'player.isDispellable("Disease")' , "player" },
    {spells.stoneform, 'player.isDispellable("Poison")' , "player" },
    {spells.stoneform, 'player.isDispellable("Magic")' , "player" },
    {spells.stoneform, 'player.isDispellable("Curse")' , "player" },
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
    {spells.thunderClap, 'player.plateCount > 2 and target.distance <= 10'},
    {spells.revenge, 'spells.revenge.cost == 0' , "target", "revenge_free" },
    {spells.revenge, 'player.rage > 90' , "target", "revenge_rage" },
    {spells.devastate, 'target.distance <= 10' , "target" , "devastate" }, 

    {{"nested"}, 'player.hasTalent(6,2)', {
        {spells.ignorePain, 'player.buffValue(spells.ignorePain) < player.incomingDamage and player.myBuffDuration(spells.ignorePain) < 9' , "target", "ignorePain" },
        {spells.ignorePain, 'player.myBuffDuration(spells.ignorePain) < 12 and player.buffValue(spells.ignorePain) < player.hpMax * 0.50' , "target", "ignorePain_buffvalue" },
        {spells.ignorePain, 'player.hasTalent(6,2) and player.myBuffDuration(spells.ignorePain) < 3' , "target", "ignorePain_duration" },
        {spells.revenge, 'player.hasTalent(6,2) and player.myBuffDuration(spells.ignorePain) < 9' , "target", "revenge_buff" },
    }},

    {{"macro"}, 'true' , "/startattack" },

}
,"warrior_protection_bfa")