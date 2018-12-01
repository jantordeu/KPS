--[[[
@module Mage Fire Rotation
@author Prescient
@version 8.0.1
]]--
local spells = kps.spells.mage
local env = kps.env.mage

local Meteor = spells.meteor.name
local Flamestrike = spells.flamestrike.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("MAGE","FIRE", "meteor", "Interface\\Icons\\spell_mage_meteor", "Meteor")
end)

kps.rotations.register("MAGE","FIRE",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'not focus.isAttackable' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.slowFall, 'player.isFallingFor(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.removeCurse, 'kps.mouseOver and mouseover.isFriend and mouseover.isDispellable("Curse")' , "mouseover" },
   {spells.spellsteal, 'target.isStealable' , "target" },

    {{"nested"}, 'kps.interrupt', {
        {spells.counterspell, 'target.isInterruptable' , "target" },
        {spells.counterspell, 'focus.isInterruptable' , "focus" },
    }},

    {{"nested"}, 'kps.defensive', {
       {spells.invisibility, 'target.isRaidBoss and player.isTarget' , "player" },
       {spells.blazingBarrier, 'player.isTarget' },
       {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
       {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25' },
     }},

    {spells.runeOfPower, 'kps.cooldowns and player.hasTalent(3,3)' , "player" },
    {{"macro"}, 'kps.cooldowns and player.timeInCombat > 1 and player.useTrinket(0)' , "/use 13" },
    {{"macro"}, 'kps.cooldowns and player.timeInCombat > 1 and player.useTrinket(1)' , "/use 14" },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and player.hasTalent(3,3) and (spells.combustion.cooldown >= 25 or player.hasBuff(spells.combustion))' , "/cast [@cursor] "..Meteor },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and not player.hasTalent(3,3) and (spells.combustion.cooldown >= 25 or player.hasBuff(spells.combustion))', "/cast [@cursor] "..Meteor },
    
    {spells.combustion, 'kps.cooldowns and not player.hasTalent(7,3) and spells.fireBlast.charges >= 1' , "player" },
    {spells.runeOfPower, 'kps.cooldowns and player.hasTalent(3,3) and not player.hasBuff(spells.runeOfPowerBuff) and spells.runeOfPower.charges >= 1.8' , "player" },
    {spells.runeOfPower, 'kps.cooldowns and player.hasTalent(3,3) and not player.hasBuff(spells.runeOfPowerBuff) and spells.combustion.cooldown >= 38 and (spells.meteor.cooldown >= 25 or spells.meteor.cooldown <= 5)' , "player" },

    {{"macro"}, 'keys.shift and player.hasBuff(spells.hotStreak)' , "/cast [@cursor] "..Flamestrike },
    {spells.phoenixFlames, 'player.hasTalent(4,3) and spells.phoenixFlames.charges >= 2' , "target" },
    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm) and (player.myBuffDuration(spells.combustion) >= 4.1 or not player.hasBuff(spells.combustion))' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.combustion) and player.hasBuff(spells.hotStreak)' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and (spells.fireball.isRecastAt("target") or spells.scorch.isRecastAt("target"))' , "target"},
    {spells.livingBomb, 'player.hasTalent(6,3) and player.plateCount >= 3 and target.timeToDie >= 8' , "target" },
    {spells.dragonsBreath, 'player.plateCount >= 3 and target.distance <= 5 and spells.fireBlast.charges == 0' , "target" },
    {spells.fireBlast, 'not spells.fireBlast.isRecastAt("target") and player.hasBuff(spells.heatingUp) and player.castTimeLeft <= 1' , "target" },
    {spells.fireBlast, 'spells.fireBlast.charges >= 1 and not spells.fireBlast.isRecastAt("target") and player.hasBuff(spells.heatingUp) and player.castTimeLeft <= 1' , "target" },
    {spells.scorch, 'not player.hasBuff(spells.hotStreak) and target.hp < 0.3' , "target" },
    {spells.scorch, 'player.hasBuff(spells.combustion) and not player.hasBuff(spells.hotStreak)' , "target" },
    {spells.scorch, 'player.isMoving' , "target" },
    {spells.fireball, 'not player.isMoving' , "target" },
    --{spells.fireball, 'not player.hasBuff(spells.heatingUp) or spells.pyroblast.isRecastAt("target") or spells.fireBlast.isRecastAt("target")' , "target" },
    
},"pre_fire_8.0.1")


kps.rotations.register("MAGE","FIRE",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'not focus.isAttackable' , "/clearfocus" },

    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Meteor },

   -- interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.counterspell, 'target.isInterruptable' , "target" },
        {spells.counterspell, 'focus.isInterruptable' , "focus" },
    }},

    {{"nested"}, 'kps.defensive', {
       {spells.invisibility, 'target.isRaidBoss and player.isTarget'},
       {spells.blazingBarrier, 'player.isTarget'},
       {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
       {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},
     }},

    {spells.runeOfPower, 'spells.runeOfPower.cooldown < spells.combustion.cooldown and not player.hasBuff(spells.combustion)'},
    {spells.runeOfPower, 'kps.cooldowns and player.hasTalent(3,3)' , "player" },
    {{"macro"}, 'kps.cooldowns and player.timeInCombat > 1 and player.useTrinket(0)' , "/use 13" },
    {{"macro"}, 'kps.cooldowns and player.timeInCombat > 1 and player.useTrinket(1)' , "/use 14" },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and player.hasTalent(3,3) and spells.combustion.cooldown >= 25 and mouseover.isAttackable' , "/cast [@cursor] "..Meteor },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and not player.hasTalent(3,3) and player.hasBuff(spells.combustion) and mouseover.isAttackable', "/cast [@cursor] "..Meteor },

    {spells.combustion, 'kps.cooldowns' },
    {spells.runeOfPower, 'kps.cooldowns and player.hasTalent(3,3) and spells.combustion.charges == 2' , "player" },
    
    {{"macro"}, 'player.plateCount > 2 and player.hasBuff(spells.hotStreak) and mouseover.isAttackable' , "/cast [@cursor] "..Flamestrike },
    {spells.phoenixFlames, 'player.hasTalent(4,3) and spells.phoenixFlames.charges >= 2' , "target" },
    
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'}, -- pyroblast,if=buff.hot_streak.up
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and player.buffDuration(spells.hotStreak) < spells.fireball.castTime'}, -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
    {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 and spells.fireBlast.charges == 0' , "target" },
    {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 and player.hasBuff(spells.combustion)' , "target" },
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'}, -- fire_blast,if=buff.heating_up.up
    {spells.fireBlast, 'not spells.fireBlast.isRecastAt("target")'}, -- fire_blast,if=!prev_off_gcd.fire_blast
    {spells.fireBlast, 'not player.hasBuff(spells.hotStreak) and player.hasBuff(spells.heatingUp)'}, -- fire_blast,if=buff.hot_streak.down&buff.heating_up.up
    {spells.flameOn, 'player.hasTalent(4,1) and spells.fireBlast.charges < 1'}, -- flame_on,if=action.fire_blast.charges<1
    {spells.scorch, 'not player.hasBuff(spells.hotStreak) and target.hp < 0.3' , "target" },
    {spells.blastWave, 'player.hasTalent(2,3) and not player.hasBuff(spells.combustion) and target.distance <= 5'}, -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1)
    {spells.blastWave, 'player.hasTalent(2,3) and player.hasBuff(spells.combustion) and spells.fireBlast.charges < 1 and target.distance <= 5'}, -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1)
    {spells.fireball, 'not player.hasBuff(spells.heatingUp)' , "target" },
    {spells.fireball, 'spells.combustion.cooldown < 6 and spells.flameOn.cooldown < 6'}, -- fireball
    {spells.scorch, 'player.isMoving' , "target" },
    {spells.fireball, 'not player.isMoving' , "target" },

}
,"mage_fire.simc")