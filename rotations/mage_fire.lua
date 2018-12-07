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
   {spells.blazingBarrier, 'player.incomingDamage > 0'},
   {spells.slowFall, 'player.isFallingFor(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.removeCurse, 'kps.mouseOver and mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
   {spells.spellsteal, 'target.isStealable' , "target" },

    {{"macro"}, 'player.hasTalent(7,3) and player.hasBuff(spells.runeOfPower) and target.distance <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and player.hasBuff(spells.combustion) and target.distance <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and player.hasBuff(spells.runeOfPower)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and player.hasBuff(spells.combustion)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and player.hasBuff(spells.runeOfPower) and mouseover.isAttackable' , "/cast [@cursor] "..Meteor },
    {{"macro"}, 'kps.meteor and player.hasTalent(7,3) and player.hasBuff(spells.combustion) and mouseover.isAttackable', "/cast [@cursor] "..Meteor },

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

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14    
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },

    {spells.runeOfPower, 'player.hasTalent(3,3) and not player.hasBuff(spells.runeOfPowerBuff) and spells.runeOfPower.charges == 2' , "player" },    
    {{"nested"}, 'kps.cooldowns',{
        {{spells.runeOfPower,spells.combustion}, 'player.hasBuff(spells.hotStreak)' },
        {spells.combustion, 'player.hasBuff(spells.hotStreak) and player.hasBuff(spells.runeOfPowerBuff)' },
        {spells.runeOfPower, 'player.hasTalent(3,3) and not player.hasBuff(spells.runeOfPowerBuff) and spells.combustion.cooldown >= 40' , "player" },
    }},

    {spells.phoenixFlames, 'player.hasTalent(4,3) and spells.phoenixFlames.charges >= 2' , "target" },
    {{"macro"}, 'player.plateCount > 2 and player.hasBuff(spells.hotStreak) and mouseover.isAttackable' , "/cast [@cursor] "..Flamestrike },
    {{"macro"}, 'player.plateCount > 2 and player.hasBuff(spells.hotStreak) and target.distance <= 5' , "/cast [@player] "..Flamestrike },
    
    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm) and not player.hasBuff(spells.combustion)' , "target" },
    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm) and player.myBuffDuration(spells.combustion) > 4.1' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
    {spells.fireBlast, 'not player.hasBuff(spells.hotStreak) and player.hasBuff(spells.heatingUp)'},
    {spells.livingBomb, 'player.hasTalent(6,3) and player.plateCount > 2 and target.timeToDie > 8' , "target" },
    
    {spells.blastWave, 'player.hasTalent(2,3) and not player.hasBuff(spells.combustion) and target.distance <= 5'},
    {spells.blastWave, 'player.hasTalent(2,3) and player.hasBuff(spells.combustion) and spells.fireBlast.charges == 0 and target.distance <= 5'},
    {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 and player.hasBuff(spells.combustion) and spells.fireBlast.charges == 0' , "target" },  
    {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 ' , "target" },
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
    {spells.scorch, 'player.hasBuff(spells.combustion) and not player.hasBuff(spells.hotStreak)' , "target" },
    {spells.scorch, 'not player.hasBuff(spells.hotStreak) and target.hp < 0.30' , "target" },
    {spells.scorch, 'player.isMoving' , "target" },
    {spells.fireball, 'not player.isMoving' , "target" },

}
,"mage_fire.simc")


