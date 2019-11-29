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
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.blazingBarrier, 'player.incomingDamage > 0'},
   {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
   {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
   {spells.spellsteal, 'target.isStealable' , "target" },

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
    {spells.concentratedFlame, 'not player.hasBuff(spells.combustion)' , "target" },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    -- Memory of Lucid Dreams should be use it before casting Rune of Power.
    {spells.memoryOfLucidDreams, 'spells.combustion.cooldown < kps.gcd and spells.runeOfPower.charges > 0 and spells.fireBlast.charges > 0' , "target" },
    
    {{"nested"}, 'player.hasBuff(spells.memoryOfLucidDreams)', {
    	{spells.combustion, 'not player.isMoving and spells.combustion.cooldown == 0 and spells.fireBlast.charges > 0 and player.hasBuff(spells.runeOfPower)' , "target" },
    	{spells.runeOfPower, 'not player.isMoving and not player.hasBuff(spells.runeOfPower) and spells.combustion.cooldown == 0 and spells.fireBlast.charges > 0' , "player" },
    }},
    {spells.combustion, 'not player.isMoving and spells.runeOfPower.lastCasted(2)' , "target" },
    {spells.combustion, 'not player.isMoving and spells.combustion.cooldown == 0 and spells.fireBlast.charges > 0 and player.hasBuff(spells.runeOfPower)' , "target" },
    {spells.runeOfPower, 'not player.isMoving and not player.hasBuff(spells.runeOfPower) and spells.combustion.cooldown < kps.gcd and spells.fireBlast.charges > 0' , "player" },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14    
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    -- Bonne série -- Hot Streak -- Your next Pyroblast or Flamestrike spell is instant cast, and causes double the normal Ignite damage.
    -- Réchauffement -- Heating Up -- Vous avez réussi un sort critique. Si le suivant est également critique, l’incantation de votre prochain sort Explosion pyrotechnique ou Choc de flammes sera instantanée et il infligera le double de dégâts avec Enflammer.

    -- One Rune of Power and one Meteor should always be used with Combustion
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges == 2 and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45' , "player" },
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges > 0 and spells.meteor.cooldown < 7 and spells.combustion.cooldown > 45 ' , "player" },

    {{"macro"}, 'keys.shift and player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower) and target.distanceMax <= 5', "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and player.hasBuff(spells.runeOfPower) and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },

    {{"nested"}, 'kps.multiTarget', {
        {spells.dragonsBreath, 'target.distanceMax <= 10' , "target" },
        {spells.livingBomb, 'player.hasTalent(6,3)' , "target" },
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and player.hasBuff(spells.combustion)'},
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
        {{"macro"}, 'keys.shift and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak)' , "/cast [@cursor] "..Flamestrike },
        {{"macro"}, 'spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and target.isAttackable and not target.isMoving and target.distanceMax <= 5' , "/cast [@player] "..Flamestrike },
        {{"macro"}, 'spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Flamestrike },
        {spells.fireball, 'not player.isMoving and mouseover.isAttackable and not mouseover.hasMyDebuff(spells.ignite)' , "mouseover" },
    }},

	{{"nested"}, 'player.hasBuff(spells.combustion)', {
    	{{"macro"}, 'keys.shift and player.hasTalent(7,3) and spells.meteor.cooldown == 0 ', "/cast [@cursor] "..Meteor },
    	{{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and target.isAttackable and not target.isMoving and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
    	{{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },
     	{spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
        {spells.phoenixFlames, 'player.hasTalent(4,3) and player.hasBuff(spells.heatingUp)' , "target" },
        {spells.scorch, 'true' , "target" },
    }},

    {{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.fireball)' , "/stopcasting" },
    {spells.pyroblast, 'player.hasTalent(7,2) and player.hasBuff(spells.pyroclasm)' , "target" },
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},
    {spells.fireBlast, 'spells.fireBlast.charges == 3'},
    {spells.phoenixFlames, 'player.hasTalent(4,3) and spells.phoenixFlames.charges == 3' , "target" },
    {{"macro"}, 'keys.shift and spells.meteor.cooldown == 0 and player.hasTalent(7,3)', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and target.isAttackable and not target.isMoving and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and spells.combustion.cooldown > 45 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },
    {spells.dragonsBreath, 'target.isAttackable and target.distanceMax <= 10' , "target" },
    {spells.scorch, 'target.hp < 0.30' , "target" },
    {spells.scorch, 'player.isMoving' , "target" },
    -- Fireball to generate Heating Up
    {spells.fireball, 'focus.isAttackable and not player.isMoving and not focus.hasMyDebuff(spells.ignite)' , "focus"  },
    {spells.fireball, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and not mouseover.hasMyDebuff(spells.ignite)' , "mouseover" },
    {spells.fireball, 'not player.isMoving' , "target" }, 

}
,"mage_fire")


