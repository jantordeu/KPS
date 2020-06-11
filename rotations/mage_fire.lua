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
local IceBlock = spells.iceBlock.name
local Wristwraps = spells.item.hyperthreadWristwraps.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("MAGE","FIRE", "polymorph", "Interface\\Icons\\spell_nature_polymorph", "polymorph")
end)

kps.rotations.register("MAGE","FIRE",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --{{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- One Rune of Power and one Meteor should always be used 40 sec recharge
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and kps.lastSentSpell == spells.combustion.name', "/cast [@cursor] "..Meteor },
    {{"macro"}, 'player.hasTalent(7,3) and spells.meteor.cooldown == 0 and kps.lastSentSpell == spells.runeOfPower.name', "/cast [@cursor] "..Meteor },    
    -- COMBUSTION
    {spells.pyroblast, 'player.hasBuff(spells.combustion) and player.hasBuff(spells.hotStreak)', "target" , "pyroblast_combustion" },
    {{"macro"}, 'player.hasBuff(spells.combustion) and spells.fireBlast.charges == 0 and player.useItem(168989)', "/cast "..Wristwraps },
    {spells.fireBlast, 'player.hasBuff(spells.combustion) and kps.lastSentSpell == spells.pyroblast.name and not spells.fireBlast.isRecastAt("target")' , "target" , "fireBlast_combustion_last" },
    {spells.fireBlast, 'player.hasBuff(spells.combustion) and not player.hasBuff(spells.hotStreak) and not spells.fireBlast.isRecastAt("target")' , "target" , env.checkfireBlast },
    {spells.scorch, 'player.hasBuff(spells.combustion) and not player.hasBuff(spells.hotStreak)' , "target" , "scorch_combustion" },

    {{"nested"},'kps.cooldowns and not player.isMoving and player.hasTalent(3,3) and spells.combustion.cooldown < 2', {
        {spells.azerite.memoryOfLucidDreams },
        {spells.combustion, 'player.hasBuff(spells.runeOfPower) and player.hasBuff(spells.hotStreak)' , "player" , "combustion" },
        {spells.runeOfPower },
        {spells.fireBlast, 'not player.hasBuff(spells.hotStreak) and spells.fireBlast.charges == 3 and not spells.fireBlast.isRecastAt("target")' , env.damageTarget , "fireBlast_heatingUp" },
        {spells.combustion, 'player.hasBuff(spells.runeOfPower)' , "player" , "combustion" },
    }},

    {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},
    {{"macro"}, 'player.hasBuff(spells.iceBlock) and player.hp > 0.90' , "/cancelaura "..IceBlock },
    {spells.arcaneIntellect, 'not player.hasBuff(spells.arcaneIntellect)' , "player" },
    {spells.blazingBarrier, 'not player.hasBuff(spells.blazingBarrier) and not player.hasBuff(spells.combustion)'},
    {spells.slowFall, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.slowFall)' , "player" },
    {spells.invisibility, 'target.isRaidBoss and targettarget.isUnit("player")'},
    {spells.invisibility, 'player.isTarget and player.hp < 0.40'},
    {spells.spellsteal, 'target.isStealable' , "target" },

    {spells.polymorph, 'kps.polymorph and mouseover.isAttackable and not mouseover.hasDebuff(spells.polymorph)' , "mouseover" },
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
        {spells.counterspell, 'mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and not player.hasBuff(spells.combustion) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14    
    {{"macro"}, 'player.useTrinket(1) and not player.hasBuff(spells.combustion) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },

    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'not player.hasBuff(spells.combustion)' , "target" },

    -- One Rune of Power and one Meteor should always be used 40 sec recharge
    {{"nested"},'player.hasTalent(7,3) and player.hasTalent(3,3) and spells.meteor.cooldown == 0 and player.hasBuff(spells.runeOfPower)', {
        {{"macro"}, 'keys.shift', "/cast [@cursor] "..Meteor },
        {{"macro"}, 'mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..Meteor },
        {{"macro"}, 'target.isAttackable and target.distanceMax <= 5' , "/cast [@player] "..Meteor },
    }},

    -- STOPCASTING -- JUMP
    --{{"macro"}, 'player.hasBuff(spells.hotStreak)' , "/run _JumpOrAscendStart()" },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak)' , "/cast "..Pyroblast },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.scorch) and not player.hasBuff(spells.combustion)' , "/stopcasting" },
    --{{"macro"}, 'player.hasBuff(spells.hotStreak) and player.isCastingSpell(spells.fireball)' , "/stopcasting" },

    {{"nested"},'spells.flamestrike.cooldown == 0 and player.hasBuff(spells.hotStreak) and not player.hasBuff(spells.combustion)', {
        {{"macro"}, 'keys.shift' , "/cast [@cursor] "..Flamestrike },
        {{"macro"}, 'kps.multiTarget and player.plateCount >= 4 and target.isAttackable and target.distanceMax <= 5' , "/cast [@cursor] "..Flamestrike },
        {{"macro"}, 'kps.multiTarget and player.plateCount >= 4 and target.isAttackable' , "/cast [@cursor] "..Flamestrike },
    }},

    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastSentSpell == spells.pyroblast.name', env.damageTarget , "pyroblast_pyroblast"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastSentSpell == spells.fireBlast.name', "target" , "pyroblast_fireBlast"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastCastedSpell == spells.fireball.name', env.damageTarget , "pyroblast_fireball"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and kps.lastCastedSpell == spells.scorch.name', env.damageTarget , "pyroblast_scorch"},
    -- during hotStreak, fireball can proc heatingUp if crit, then pyroblast can proc again hotStreak if crit
    {{"macro"}, 'player.hasBuff(spells.combustion) and player.isCastingSpell(spells.fireball)' , "/stopcasting" },
    {spells.fireball,'player.hasBuff(spells.hotStreak) and not player.isMoving and not player.hasBuff(spells.combustion) and target.hp > 0.30 and not spells.fireball.isRecastAt("target")', "target" , "fireball_hotStreak"},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)', env.damageTarget , "pyroblast_hotStreak"},
    
    {spells.livingBomb,  'player.hasTalent(6,3) and not player.hasBuff(spells.combustion) and mouseover.isAttackable and not mouseover.hasMyDebuff(spells.livingBomb) and mouseover.hp > 0.90' , "mouseover" },
    {spells.livingBomb,  'player.hasTalent(6,3) and not player.hasBuff(spells.combustion) and target.isAttackable and not target.hasMyDebuff(spells.livingBomb) and target.hp > 0.30' , "target" },
    {spells.dragonsBreath, 'not player.hasBuff(spells.combustion) and target.isAttackable and target.distanceMax <= 5' , "target" },

    -- One Rune of Power and one Meteor should always be used 40 sec recharge
    {spells.runeOfPower, 'player.hasTalent(7,3) and player.hasTalent(3,3) and not player.isMoving and spells.runeOfPower.charges == 2 and spells.combustion.cooldown > 10 and spells.meteor.cooldown < 5 and target.isAttackable' },
    {spells.runeOfPower, 'player.hasTalent(7,3) and player.hasTalent(3,3) and not player.isMoving and spells.combustion.cooldown > 40 and spells.meteor.cooldown < 5 and target.isAttackable' },
    {spells.runeOfPower, 'player.hasTalent(7,3) and player.hasTalent(3,1) and not player.isMoving and spells.runeOfPower.charges == 2 and spells.combustion.cooldown > 10 and target.isAttackable' },
    {spells.runeOfPower, 'player.hasTalent(7,3) and player.hasTalent(3,1) and not player.isMoving and spells.combustion.cooldown > 40 and target.isAttackable' },
    
    -- Bonne série -- Hot Streak -- Your next Pyroblast or Flamestrike spell is instant cast, and causes double the normal Ignite damage.
    -- Réchauffement -- Heating Up -- Vous avez réussi un sort critique. Si le suivant est également critique, l’incantation de votre prochain sort Explosion pyrotechnique ou Choc de flammes sera instantanée et il infligera le double de dégâts avec Enflammer.
    {spells.fireBlast, 'spells.fireBlast.charges == 3 and not player.hasBuff(spells.hotStreak) and spells.combustion.cooldown > 25 and not spells.fireBlast.isRecastAt("target")' , "target", "fireBlast_charges_3" },
    {{"nested"}, 'player.hasBuff(spells.heatingUp) and not player.hasBuff(spells.hotStreak) and not spells.fireBlast.isRecastAt("target")', {
        {spells.fireBlast, 'spells.fireBlast.charges == 3 and not kps.cooldowns' , "target", "fireBlast_charges" },
        {spells.fireBlast, 'spells.fireBlast.charges == 3 and spells.combustion.cooldown > 8' , "target" , "fireBlast_cooldown_8" },
        {spells.fireBlast, 'spells.fireBlast.charges == 2 and spells.combustion.cooldown > 17' , "target" , "fireBlast_cooldown_17" },
        {spells.fireBlast, 'spells.combustion.cooldown > 25' ,  "target" , "fireBlast_cooldown_25" },
   }},
    -- "Phoenix Flames" -- Always deals a critical strike. 30 sec cooldown 3 charges
    {spells.phoenixFlames , 'player.hasTalent(4,3) and player.hasBuff(spells.heatingUp)' ,  env.damageTarget },

    {spells.scorch, 'player.isMoving', env.damageTarget },
    {spells.scorch, 'target.hp < 0.30 and target.isAttackable' , "target"  , "scorch_target" }, 
    {spells.scorch, 'mouseover.hp < 0.30 and mouseover.isAttackable' , "mouseover"  , "scorch_mouseover" },

    -- debuff "Conflagration" 226757 -- fireball -- spells.conflagration
    -- debuff "Ignite" 12654 -- Scorch & fireball -- spells.ignite
    {spells.fireball, 'not player.isMoving and not player.hasBuff(spells.combustion)' , env.damageTarget },

}
,"mage_fire")


