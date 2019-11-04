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
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.blazingBarrier, 'player.incomingDamage > 0'},
   {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
   {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
   {spells.spellsteal, 'target.isStealable' , "target" },

    {{"macro"}, 'player.hasTalent(7,3) and player.hasBuff(spells.runeOfPower) and target.distance <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and player.hasBuff(spells.combustion) and target.distance <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and player.hasBuff(spells.runeOfPower)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and player.hasBuff(spells.combustion)', "/cast [@cursor] "..Meteor },

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
        
    {{"nested"}, 'player.hasBuff(spells.combustion)', {
        {{spells.pyroblast,spells.fireBlast}, 'spells.fireBlast.charges > 0' , "target" },
        {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 ' , "target" },  
        {{spells.pyroblast,spells.scorch}, 'true', "target" },
    }},
     
    {spells.phoenixFlames, 'player.hasTalent(4,3) and spells.phoenixFlames.charges >= 2' , "target" },
    {{"macro"}, 'keys.ctrl and player.hasBuff(spells.hotStreak)' , "/cast [@cursor] "..Flamestrike },
    {{"macro"}, 'player.plateCount > 2 and player.hasBuff(spells.hotStreak) and target.distance <= 5' , "/cast [@player] "..Flamestrike },
    
    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm)' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
  
    {spells.dragonsBreath, 'player.plateCount > 2 and target.distance <= 5 ' , "target" },  
    {spells.livingBomb, 'player.hasTalent(6,3) and player.plateCount > 2' , "target" },
    
    {spells.blastWave, 'player.hasTalent(2,3) and not player.hasBuff(spells.combustion) and target.distance <= 5'},
    {spells.blastWave, 'player.hasTalent(2,3) and player.hasBuff(spells.combustion) and spells.fireBlast.charges == 0 and target.distance <= 5'},

    {spells.scorch, 'target.hp < 0.30' , "target" },
    {spells.scorch, 'player.isMoving' , "target" },
    {spells.fireball, 'not player.isMoving' , "target" }, -- Fireball to generate Heating Up

}
,"mage_fire.simc")


