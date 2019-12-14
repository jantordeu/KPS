--[[[
@module Mage Fire Rotation
@author htordeux
@version 8.2.5
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
    {{"macro"}, 'FocusMouseoverFire()' , "/focus mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.blazingBarrier, 'player.incomingDamage > 0'},
   {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.spellsteal, 'target.isStealable' , "target" },

    {{"nested"},'kps.cooldowns', {
        {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
        {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
        {spells.removeCurse, 'heal.lowestTankInRaid.isDispellable("Curse")' , kps.heal.lowestTankInRaid },
        {spells.removeCurse, 'heal.lowestInRaid.isDispellable("Curse")' , kps.heal.lowestInRaid },
        {spells.removeCurse, 'heal.isCurseDispellable' , kps.heal.isMagicDispellable },
    }},

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

    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'not player.hasBuff(spells.combustion)' , "target" },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec

    {{"nested"},'kps.cooldowns and not player.isMoving and target.isAttackable', {
        -- Memory of Lucid Dreams should be use it before casting Rune of Power
        {spells.azerite.memoryOfLucidDreams, 'spells.combustion.cooldown < player.gcd and spells.fireBlast.charges > 0' , "target" },
    	{spells.runeOfPower, 'player.hasBuff(spells.azerite.memoryOfLucidDreams) and spells.combustion.cooldown < player.gcd and spells.fireBlast.charges > 0 ' , "player" , "buff_azerite" },
    	{spells.combustion, 'player.hasBuff(spells.azerite.memoryOfLucidDreams) and player.hasBuff(spells.runeOfPower)' , "target" , "buff_azerite" },
        {spells.combustion, 'player.hasBuff(spells.azerite.memoryOfLucidDreams) and spells.runeOfPower.lastCasted(3)' , "target" , "lastCasted_runeOfPower" },
        {spells.combustion, 'player.hasBuff(spells.azerite.memoryOfLucidDreams) and player.hasTalent(3,1)' , "target" , "buff_azerite" },
    }},

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14    
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 5 and target.isAttackable' , "/use 14" },
    
    -- Bonne série -- Hot Streak -- Your next Pyroblast or Flamestrike spell is instant cast, and causes double the normal Ignite damage.
    -- Réchauffement -- Heating Up -- Vous avez réussi un sort critique. Si le suivant est également critique, l’incantation de votre prochain sort Explosion pyrotechnique ou Choc de flammes sera instantanée et il infligera le double de dégâts avec Enflammer.

    -- One Rune of Power and one Meteor should always be used with Combustion
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges == 1 and spells.combustion.cooldown > 45 and spells.meteor.cooldown > 9 and spells.fireBlast.charges > 0 and target.isAttackable' , "player" , "runeOfPower_charges_1 " },
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges == 2 and spells.combustion.cooldown > 9 and target.isAttackable' , "player" , "runeOfPower_charges_2 " },
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges > 0 and spells.combustion.cooldown > 45 and spells.meteor.cooldown < 7 and target.isAttackable' , "player" , "runeOfPower_meteor"},

    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower) and target.distanceMax <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower) and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },

    {{"nested"}, 'kps.multiTarget and target.isAttackable', {
        {spells.dragonsBreath, 'target.distanceMax <= 10' , "target" },
        {spells.livingBomb, 'player.hasTalent(6,3)' , "target" },
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and player.hasBuff(spells.combustion)' , "target" },
        {{"macro"}, 'keys.shift and player.plateCount >= 3 and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak)' , "/cast [@cursor] "..Flamestrike },
        {{"macro"}, 'player.plateCount >= 3 and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Flamestrike },
        {{"macro"}, 'player.plateCount >= 3 and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and mouseover.isAttackable' , "/cast [@cursor] "..Flamestrike },
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp)', "target" },
        {spells.scorch, 'target.isAttackable and target.distanceMax <= 10 and player.plateCount >= 3' , "target" },
        {spells.scorch, 'focus.isAttackable and target.distanceMax <= 10 and player.plateCount >= 3' , "focus" },
    }},

	{{"nested"}, 'player.hasBuff(spells.combustion) and target.isAttackable', {
    	{{"macro"}, 'keys.shift and player.hasTalent(7,3) and spells.meteor.cooldown == 0 ', "/cast [@cursor] "..Meteor },
    	{{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
    	{{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },
     	{spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
        {spells.scorch, 'target.isAttackable' , "target" },
        {spells.scorch, 'focus.isAttackable' , "focus" },
        {spells.scorch, 'mouseover.isAttackable' , "mouseover" },
    }},
    
    -- debuff "Ignite" 12654 -- Scorch & fireball -- spells.ignite
    -- debuff "Conflagration" 226757 -- fireball -- spells.conflagration

    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm)' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp) and spells.combustion.cooldown > 17' , "target" },
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp) and spells.combustion.cooldown > 9 and spells.fireBlast.charges > 1' , "target" },

    {{"macro"}, 'keys.shift and spells.meteor.cooldown == 0 and player.hasTalent(7,3)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },

    {spells.dragonsBreath, 'target.isAttackable and target.distanceMax <= 10' , "target" },
    {spells.scorch, 'spells.fireBlast.charges == 0 and target.distanceMax <= 5 and target.isAttackable' , "target" },
    {spells.scorch, 'target.hp < 0.30 and target.distanceMax <= 5 and target.isAttackable' , "target" },
    {spells.scorch, 'player.isMoving and target.isAttackable' , "target" },
    {spells.scorch, 'player.isMoving and focus.isAttackable' , "focus" },

    -- Fireball to generate Heating Up
    {{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.fireball)' , "/stopcasting" },
    {spells.fireball, 'not player.isMoving and focus.isAttackable and not focus.hasMyDebuff(spells.conflagration)' , "focus"  },
    {spells.fireball, 'not player.isMoving and focus.isAttackable and not focus.hasMyDebuff(spells.ignite)' , "focus"  },
    {spells.fireball, 'not player.isMoving' , "target" }, 

}
,"mage_fire")


