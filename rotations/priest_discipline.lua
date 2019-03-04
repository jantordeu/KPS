--[[[
@module Priest Discipline Rotation
@author htordeux
@version 8.0.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name
local Barriere = spells.powerWordBarrier.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "mouseOver", "Interface\\Icons\\priest_spell_leapoffaith_a", "mouseOver")
end)

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "holyNova", "Interface\\Icons\\spell_holy_holynova", "holyNova")
end)

-- Talents:
-- castigation with Contrition
-- Schisme with Sins of the Many
-- Penance defensive better heal with atonement on target


kps.rotations.register("PRIEST","DISCIPLINE",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    --{{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    env.haloMessage,
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Barriere },
    
   {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
   {spells.painSuppression, 'mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" },
   {spells.painSuppression, 'player.hp < 0.40' , "player" },

    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },   
    {spells.arcaneTorrent, 'player.timeInCombat > 9 and target.isAttackable' , "target" },

    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
    }},

    -- "Dispel" "Purifier" 527
    {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable , "DISPEL" },
    }},

--    {spells.fireBlood, 'player.isDispellable("Magic")' , "player" },
--    {spells.fireBlood, 'player.isDispellable("Disease")' , "player" },
--    {spells.fireBlood, 'player.isDispellable("Poison")' , "player" },
--    {spells.fireBlood, 'player.isDispellable("Curse")' , "player" },
    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    {{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingFor(2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.6) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player", "SCHIELD_MOVING" },

    -- TRINKETS -- SLOT 0 /use 13
    -- "Inoculating Extract" 160649 -- "Extrait d’inoculation" 160649
    {{"macro"}, 'player.hasTrinket(0) == 160649 and player.useTrinket(0) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 13" },
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < 0.82' , "player" },
        {spells.powerWordShield, 'not heal.lowestUnitInRaid.hasBuff(spells.powerWordShield) and heal.lowestUnitInRaid.hp < 0.82' , kps.heal.lowestUnitInRaid },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield) and mouseover.hp < 0.82' , "mouseover" },
    }},
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.hasBuff(spells.painSuppression)' , kps.heal.lowestTankInRaid },
    {spells.rapture, 'spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.cooldown > kps.gcd and heal.hasNotBuffAtonementCount(0.55) > 2' },

    {spells.luminousBarrier, 'player.hasTalent(7,2) and heal.countLossInRange(0.82)*2 > heal.countInRange' },
    {spells.shadowCovenant, 'player.hasTalent(5,3) and heal.countLossInRange(0.82) > 2' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) > 2' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90)*2 >= heal.countInRange' , kps.heal.lowestInRaid },
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.90) > 2 and target.distance <= 30' , "target" },
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.90)*2 >= heal.countInRange and target.distance <= 30' , "target" },
    {spells.holyNova, 'kps.holyNova' , "target" },

    -- GROUPHEAL
    -- heal.lossHealthRaid` - Returns the loss Health for all raid members
    -- heal.atonementHealthRaid - Returns the loss Health for all raid members with buff atonement
    -- heal.hasBuffCount(spells.atonement)
    -- heal.hasNotBuffAtonementCount(0.82) -- count unit below 0.82 health without atonement buff
    -- heal.hasBuffAtonementCount(0.82) -- count unit below 0.82 health with atonement buff
    -- heal.countLossInRange(0.82) -- count unit below 0.82 health
    -- heal.hasNotBuffAtonement.hp < 0.92 -- UNIT with lowest health without Atonement Buff on raid -- default "player" 
    -- heal.hasBuffAtonement.hp < 0.92 - UNIT with lowest health with Atonement Buff on raid e.g. -- default "player" 

    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.82) > 2 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5' , kps.heal.lowestTankInRaid , "radiance" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.82) > 2 and player.myBuffDuration(spells.atonement) < 5' , "player" , "radiance" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.82) > 2 and not heal.hasNotBuffAtonement.isUnit("player") ' , kps.heal.hasNotBuffAtonement , "radiance_NotBuffAtonement" },
    {spells.powerWordRadiance, 'not player.isMoving and mouseover.isHealable and heal.hasNotBuffAtonementCount(0.82) > 2' , "mouseover" , "radiance_mouseover"},

    {spells.powerWordShield, 'mouseover.isHealable and mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.92 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover" },
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.55 and mouseover.myBuffDuration(spells.atonement) < 2' , "mouseover" , "shadowMend_mouseover"},

    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "powerWordShield_tank" },
    {spells.powerWordShield, 'player.hp < 0.82 and player.myBuffDuration(spells.atonement) < 2 and not player.hasDebuff(spells.weakenedSoul)' , "player" , "powerWordShield_player" },
    {spells.powerWordShield, 'target.isAttackable and targettarget.isHealable and targettarget.myBuffDuration(spells.atonement) < 2 and targettarget.hp < 0.92 and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "powerWordShield_targettarget" },

    {spells.evangelism, 'player.hasTalent(7,3) and spells.powerWordRadiance.charges == 0' },
    {spells.powerWordSolace, 'player.hasTalent(3,3)' , env.damageTarget },
    {spells.penance, 'spells.schism.lastCasted(7)' , env.damageTarget },
    {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonementCount(0.82) >= 2' , env.damageTarget },
    {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonement.hp < 0.65' , env.damageTarget },
    {spells.mindbender, 'player.hasTalent(3,2) and spells.powerWordRadiance.lastCasted(7)' , env.damageTarget },
    {spells.shadowfiend, 'not player.hasTalent(3,2) and spells.powerWordRadiance.lastCasted(7)' , env.damageTarget },
    {spells.penance, 'heal.hasBuffAtonement.hp < 0.82' , env.damageTarget  },
    {spells.smite, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.82' , env.damageTarget  },

    {{"nested"}, 'kps.mouseOver and mouseover.isHealable' , {
        {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
        {spells.powerWordShield, 'mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.92 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover" },
        {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.55 and mouseover.myBuffDuration(spells.atonement) < 2' , "mouseover" , "shadowMend_mouseover"},
        {spells.penance, 'heal.hasBuffAtonement.hp < 0.92 and mouseovertarget.isAttackable' , "mouseovertarget" , "penance_mouseover" },
        {spells.shadowWordPain, 'mouseovertarget.isAttackable and not mouseovertarget.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("mouseovertarget")' , "mouseovertarget" , "pain_mouseover" },
        {spells.smite, 'not player.isMoving and mouseovertarget.isAttackable' , "mouseovertarget" , "smite_mouseover" },
    }},

    {{"nested"}, 'kps.mouseOver and mouseover.isAttackable' , {
        {spells.shadowMend, 'not player.isMoving and mouseovertarget.isHealable and mouseovertarget.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseovertarget")' , "mouseovertarget" , "shadowMend_mouseovertarget"},
        {spells.powerWordShield, 'mouseovertarget.isHealable and mouseovertarget.myBuffDuration(spells.atonement) < 2 and mouseovertarget.hp < 0.92 and not mouseovertarget.hasDebuff(spells.weakenedSoul)' , "mouseovertarget" , "powerWordShield_mouseovertarget" },
        {spells.shadowMend, 'not player.isMoving and mouseovertarget.isHealable and mouseovertarget.hp < 0.55 and mouseovertarget.myBuffDuration(spells.atonement) < 2' , "mouseovertarget" , "shadowMend_mouseovertarget"},
        {spells.penance, 'heal.hasBuffAtonement.hp < 0.92', "mouseover" , "penance_mouseovertarget"},
        {spells.shadowWordPain,'not mouseover.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("mouseover")', "mouseover" , "pain_mouseovertarget"},
        {spells.smite, 'not player.isMoving', "mouseover" , "smite_mouseovertarget"},
    }},

    -- NOT ISINGROUP
    {{"nested"}, 'kps.multiTarget' , {
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'mouseover.isFriend and mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.92 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" },
        {spells.powerWordShield, 'target.isAttackable and targettarget.isFriend and targettarget.myBuffDuration(spells.atonement) < 2 and targettarget.hp < 0.92 and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "powerWordShield_targettarget" },
        {spells.shadowMend, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.55 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.shadowWordPain, 'target.isAttackable and not target.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("target")' , "target" },
        {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and not mouseover.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
        {spells.powerWordSolace, 'player.hasTalent(3,3) and target.isAttackable' , "target" },
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and target.isAttackable and spells.penance.cooldown < 6' , "target" },
        {spells.penance, 'target.isAttackable' , "target" },
        {spells.divineStar, 'player.hasTalent(6,2) and target.isAttackable and target.distance <= 30' , "target" },
        {spells.mindbender, 'player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.smite, 'not player.isMoving and target.isAttackable' , "target" },
    }},

    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and spells.penance.cooldown > kps.gcd' , kps.heal.lowestTankInRaid },
    {spells.penance, 'heal.lowestTankInRaid.hp < 0.65 ' , kps.heal.lowestTankInRaid  },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and spells.penance.cooldown > kps.gcd' , "player" },
    {spells.penance, 'player.hp < 0.65 ' , "player"  },

    {spells.shadowWordPain, 'target.isAttackable and not target.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("target")' , env.damageTarget },
    {spells.shadowWordPain, 'focus.isHealable and focustarget.isAttackable and not focustarget.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("focustarget")' , "focustarget" },
    {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonementCount(0.82) >= 2' , env.damageTarget , "schism_offensive" },
    {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonement.hp < 0.65' , env.damageTarget , "schism_offensive" },
    {spells.penance, 'heal.hasBuffAtonement.hp < 0.92' , env.damageTarget , "penance_offensive" },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.55' , env.damageTarget , "smite_offensive" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.55', kps.heal.lowestInRaid ,  "shadowMend_lowest" },

}
,"priest_discipline_bfa")


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--