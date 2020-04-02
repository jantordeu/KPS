--[[[
@module Mage Fire Rotation
@author htordeux
@version 8.3 Talents (3,2,3,1,1,2,3)
]]--
local spells = kps.spells.mage
local env = kps.env.mage

local Meteor = spells.meteor.name
local Flamestrike = spells.flamestrike.name
local Pyroblast = spells.pyroblast.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("MAGE","FIRE", "polymorph", "Interface\\Icons\\spell_nature_polymorph", "polymorph")
end)

kps.rotations.register("MAGE","FIRE",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'FocusMouseoverFire()' , "/focus mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

   {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
   {spells.blazingBarrier, 'not player.hasBuff(spells.blazingBarrier) and not player.hasBuff(spells.combustion) and player.hp < 0.95'},
   {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
   {spells.spellsteal, 'target.isStealable' , "target" },

    {{"nested"},'kps.cooldowns', {
        {spells.removeCurse, 'mouseover.isHealable and mouseover.isDispellable("Curse")' , "mouseover" },
        {spells.removeCurse, 'player.isDispellable("Curse")' , "player" },
        {spells.removeCurse, 'heal.lowestTankInRaid.isDispellable("Curse")' , kps.heal.lowestTankInRaid },
        {spells.removeCurse, 'heal.lowestInRaid.isDispellable("Curse")' , kps.heal.lowestInRaid },
        {spells.removeCurse, 'heal.isCurseDispellable' , kps.heal.isMagicDispellable },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.counterspell, 'target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.counterspell, 'focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
    }},

    {spells.invisibility, 'target.isRaidBoss and player.isTarget'},
    --{{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},

    {spells.polymorph, 'kps.polymorph and focus.isAttackable and focus.hasMyDebuff(spells.polymorph) and focus.myDebuffDuration(spells.polymorph) < 3' , "focus" },

    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'not player.hasBuff(spells.combustion)' , "target" },

    -- One Rune of Power and one Meteor should always be used 40 sec recharge
    {{"nested"},'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and player.hasBuff(spells.runeOfPower)', {
        {{"macro"}, 'keys.shift', "/cast [@cursor] "..Meteor },
        {{"macro"}, 'target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
        {{"macro"}, 'mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },
    }},

    -- STOPCASTING
    --{{"macro"}, 'player.hasBuff(spells.hotStreak)' , "/run _JumpOrAscendStart()" },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak)' , "/cast "..Pyroblast },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.scorch) and not player.hasBuff(spells.combustion)' , "/stopcasting" },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.fireball)' , "/stopcasting" },
    -- COMBUSTION
    {{"nested"},'kps.cooldowns and not player.isMoving and spells.combustion.cooldown < 5 and target.isAttackable', {
        {spells.combustion, 'player.hasBuff(spells.runeOfPower) and kps.lastSentSpell == spells.meteor.name' },
        {spells.combustion, 'player.hasBuff(spells.runeOfPower) and spells.meteor.cooldown > 0' },
        {spells.runeOfPower, 'spells.azerite.memoryOfLucidDreams.cooldown > 0' },
        {spells.azerite.memoryOfLucidDreams },
        -- avoid fireball before activate combustion and buff runeOfPower
        {spells.scorch, 'true', env.damageTarget },
    }},
    {{"nested"}, 'player.hasBuff(spells.combustion)', {
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak)', env.damageTarget },
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp) and not spells.fireBlast.isRecastAt("target")' , env.damageTarget },
        {spells.scorch, 'true' , env.damageTarget },
    }},
    
    {{"macro"}, 'keys.shift and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak)' , "/cast [@cursor] "..Flamestrike },
    {{"macro"}, 'player.plateCount >= 5 and spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Flamestrike },
    -- during hotStreak, fireball can proc heatingUp if crit, then pyroblast can proc again hotStreak if crit
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastSentSpell == spells.pyroblast.name', env.damageTarget , "pyroblast_pyroblast"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastSentSpell == spells.fireBlast.name', env.damageTarget , "pyroblast_fireBlast"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastCastedSpell == spells.fireball.name', env.damageTarget , "pyroblast_fireball"},

    --{spells.fireball, 'not player.isMoving and not player.hasBuff(spells.combustion) and player.hasBuff(spells.hotStreak) and not spells.fireball.isRecastAt("target")', env.damageTarget , "fireball_hotStreak"},
    {spells.fireball, 'not player.isMoving and target.hp > 0.30 and player.hasBuff(spells.hotStreak) and not spells.fireball.isRecastAt("target")', env.damageTarget , "fireball_hotStreak"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)', env.damageTarget , "pyroblast_hotStreak"},
    -- One Rune of Power and one Meteor should always be used 40 sec recharge
    {spells.runeOfPower, 'not player.isMoving and spells.runeOfPower.charges == 2 and spells.combustion.cooldown > 9 and spells.meteor.cooldown < 5 and target.isAttackable' },
    {spells.runeOfPower, 'not player.isMoving and spells.combustion.cooldown > 45 and spells.meteor.cooldown < 5 and target.isAttackable' },
    -- Bonne série -- Hot Streak -- Your next Pyroblast or Flamestrike spell is instant cast, and causes double the normal Ignite damage.
    -- Réchauffement -- Heating Up -- Vous avez réussi un sort critique. Si le suivant est également critique, l’incantation de votre prochain sort Explosion pyrotechnique ou Choc de flammes sera instantanée et il infligera le double de dégâts avec Enflammer.

    {{"nested"}, 'player.hasBuff(spells.heatingUp) and not player.hasBuff(spells.hotStreak) and not spells.fireBlast.isRecastAt(damageTarget())', {
        -- you can use Fire Blast while casting
        {spells.fireBlast, 'spells.fireBlast.charges == 3' ,  env.damageTarget , "fireBlast_charges_3" },
        {spells.fireBlast, 'spells.combustion.cooldown > 16' ,  env.damageTarget , "fireBlast_cooldown" },
        {spells.fireBlast, 'spells.fireBlast.charges == 2 and not kps.cooldowns' ,  env.damageTarget , "fireBlast_charges_2" },
        -- "Phoenix Flames" -- Always deals a critical strike. 30 sec cooldown 3 charges
        {spells.phoenixFlames , 'player.hasTalent(4,3)' ,  env.damageTarget },
    }},

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and not player.hasBuff(spells.combustion) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14    
    {{"macro"}, 'player.useTrinket(1) and not player.hasBuff(spells.combustion) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },

    {spells.dragonsBreath, 'target.isAttackable and target.distanceMax <= 5' , "target" },
    {spells.livingBomb,  'player.hasTalent(6,3)' , env.damageTarget },
    {{"nested"}, 'player.isMoving', {
        {spells.scorch, 'target.isAttackable and not target.hasMyDebuff(spells.ignite)' , "target"  },
        {spells.scorch, 'focus.isAttackable and not focus.hasMyDebuff(spells.ignite)' , "focus" },
        {spells.scorch, 'mouseover.isAttackable and not mouseover.hasMyDebuff(spells.ignite)' , "mouseover" },
        {spells.scorch, 'true', env.damageTarget },
    }},
    -- debuff "Ignite" 12654 -- Scorch & fireball -- spells.ignite
    {spells.scorch, 'player.isMoving', env.damageTarget },
    {spells.scorch, 'target.hp < 0.30 and target.isAttackable' , "target"  , "scorch_hp" },
    {spells.scorch, 'focus.hp < 0.30 and focus.isAttackable' , "focus"  , "scorch_hp" },
    {spells.scorch, 'mouseover.hp < 0.30 and mouseover.isAttackable' , "mouseover"  , "scorch_hp" },
    {spells.scorch, 'player.hasBuff(spells.combustion)', env.damageTarget },

    -- debuff "Conflagration" 226757 -- fireball -- spells.conflagration
    {spells.fireball, 'not player.isMoving and player.hasTalent(6,2) and target.isAttackable and not target.hasMyDebuff(spells.conflagration)' , "target" , "fireball_1" },
    {spells.fireball, 'not player.isMoving and player.hasTalent(6,2) and focus.isAttackable and not focus.hasMyDebuff(spells.conflagration)' , "focus" ,  "fireball_2" },
    {spells.fireball, 'not player.isMoving' , env.damageTarget , "fireball_3" },

}
,"mage_fire")


