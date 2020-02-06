--[[[
@module Warrior Fury Rotation
@author htordeux
@version 8.0.1
]]--

local spells = kps.spells.warrior
local env = kps.env.warrior

local HeroicLeap = spells.heroicLeap.name

-- kps.defensive for charge
-- kps.interrupt for interrupts
-- kps.multiTarget for multiTarget
kps.rotations.register("WARRIOR","FURY",
{

    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HeroicLeap },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --{{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    {spells.berserkerRage, 'target.isAttackable and target.isCasting' },
    {spells.berserkerRage, 'focus.isAttackable and focus.isCasting' },
    -- Charge enemy
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance >= 10' },
    {spells.charge, 'kps.defensive and target.isAttackable and target.distance >= 10' },
    {spells.battleShout, 'not player.hasBuff(spells.battleShout)' },

    -- interrupts
    {spells.pummel, 'kps.interrupt and target.distance <= 10 and target.isInterruptable and target.castTimeLeft < 1' , "target" },
    {spells.pummel, 'kps.interrupt and focus.distance <= 10 and focus.isInterruptable and focus.castTimeLeft < 1' , "focus" },

    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.90', "/use item:5512" },
    {spells.victoryRush, 'player.hp < 0.80' },
    {spells.victoryRush, 'player.myBuffDuration(spells.victoryRush) < 4' },
    {spells.bloodthirst, 'player.hasBuff(spells.enragedRegeneration)' },
    {spells.enragedRegeneration, 'spells.bloodthirst.cooldown < player.gcd and player.hp < 0.70' },
    {spells.rallyingCry, 'player.hp < 0.60' },
    {spells.stoneform, 'player.isDispellable("Disease")' , "player" },
    {spells.stoneform, 'player.isDispellable("Poison")' , "player" },
    {spells.stoneform, 'player.isDispellable("Magic")' , "player" },
    {spells.stoneform, 'player.isDispellable("Curse")' , "player" },
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.intimidatingShout, 'not player.isInGroup and player.plateCount > 3 and not player.hasBuff(spells.recklessness) and spells.recklessness.cooldown > 0' },
    {spells.intimidatingShout, 'not player.isInGroup and player.incomingDamage > player.hpMax * 0.10 and not player.hasBuff(spells.recklessness) and spells.recklessness.cooldown > 0' },
    
    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden" 144259
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(0)' , "/use 13" },
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(1)' , "/use 14" },

    -- "Reckless Abandon" talent Recklessness generates 100 Rage and lasts 4 sec longer.
    {spells.recklessness, 'kps.cooldowns and player.hasTalent(7,1) and player.rage <= 25 and target.isAttackable and target.distance <= 10' },
    {spells.recklessness, 'kps.cooldowns and not player.hasTalent(7,1) and player.rage >= 75 and target.isAttackable and target.distance <= 10' },
    
    {spells.rampage, 'player.myBuffDuration(spells.enrage) < player.gcd' , "target" , "rampage_enrage" },
    {spells.rampage, 'player.rage >= 90' , "target" , "rampage_dumprage" },
    
    -- "Mort subite" -- "Sudden Death" -- Execute can be used on any target, regardless of their health.
    {spells.execute, 'target.hp <= 0.20 and player.hasBuff(spells.enrage)' , "target" , "execute_hp" },
    {spells.execute, 'spells.execute.isUsable and player.hasTalent(3,2)' , "target" , "execute_usable" },

    {{"nested"}, 'kps.multiTarget and target.distance <= 10 and target.isAttackable', {
        {spells.whirlwind, 'player.buffStacks(spells.whirlwind) < 2 ' , "target" , "whirlwind_multiTarget_stacks" },
        {spells.recklessness, 'target.isAttackable and target.distance <= 10' , "target" },
        {spells.siegebreaker, 'player.hasTalent(6,2)' },
        {spells.rampage, 'player.hasBuff(spells.whirlwind)' , "target" },
        {spells.bladestorm, 'player.hasBuff(spells.enrage)' , "target" },
        {spells.execute, 'spells.execute.isUsable and player.hasBuff(spells.enrage)' , "target" , "execute_usable" },
        {spells.dragonRoar, 'not player.hasTalent(7,3) and player.hasBuff(spells.enrage)' , "target" },
        {spells.dragonRoar, 'player.hasTalent(7,3) and target.hasDebuff(spells.siegebreaker)' , "target" },
        {spells.bloodthirst, 'target.isAttackable and target.distance <= 10' , "target" , "bloodthirst_multiTarget" },
        {spells.ragingBlow, 'target.isAttackable and target.distance <= 10' , "target" , "ragingBlow_multiTarget" },
        {spells.whirlwind, 'true' , "target" , "whirlwind_multiTarget" },
    }},

    {{"nested"}, 'player.hasBuff(spells.recklessness) and target.distance <= 10 and target.isAttackable' , {
        {spells.dragonRoar, 'true' , "target" , "dragonRoar" },
        {spells.siegebreaker, 'player.hasTalent(6,2)' },
    }},

    -- "Siegebreaker" -- "Briseur de siège" -- increasing your damage done to the target by 15% for 10 sec.
    -- "Dragon Roar" -- Physical damage to all enemies within 12 yds and reducing their movement speed by 50% for 6 sec.
    {{"nested"}, 'spells.recklessness.cooldown >= 30 and target.distance <= 10 and target.isAttackable', {
        {spells.dragonRoar, 'player.hasTalent(7,3) and target.hasDebuff(spells.siegebreaker)' , "target" , "dragonRoar_siegebreaker" },
        {spells.dragonRoar, 'not player.hasTalent(7,3) and player.hasBuff(spells.enrage)' , "target" , "dragonRoar" },
        {spells.siegebreaker, 'player.hasTalent(6,2)' },
    }},

    {spells.bloodthirst, 'not player.hasBuff(spells.enrage) and target.isAttackable and target.distance <= 10' , "target" },
    {spells.ragingBlow, 'spells.ragingBlow.charges == 2 and target.isAttackable and target.distance <= 10' , "target" , "ragingBlow_charges" },
    {spells.bloodthirst, 'target.isAttackable and target.distance <= 10' , "target" },
    {spells.ragingBlow, 'target.isAttackable and target.distance <= 10' , "target" , "ragingBlow_charges"},
    {spells.furiousSlash, 'player.hasTalent(3,3) and player.myBuffDuration(spells.furiousSlash) < 4 and target.isAttackable and target.distance <= 10' , "target" , "furiousSlash_buff"},
    {spells.furiousSlash, 'player.hasTalent(3,3) and player.buffStacks(spells.furiousSlash) < 3 and target.isAttackable and target.distance <= 10' , "target" , "furiousSlash_stacks"},
    {spells.whirlwind, 'target.isAttackable and target.distance <= 10' , "target" },

    {{"macro"}, 'true' , "/startattack" },

}
,"Warrior_Fury_bfa")
