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

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
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
    {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },


    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and player.plateCount >= 3' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and player.isTarget and spells.shiningForce.cooldown > 0 and target.distance <= 10 and player.plateCount >= 3' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and player.plateCount >= 3' , "player" },
    }},

    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    {{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' ,"/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingFor(2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.6) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player", "SCHIELD_MOVING" },

    {spells.fireBlood, 'player.isDispellable("Magic")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Disease")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Poison")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Curse")' , "player" },

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable , "DISPEL" },
    }},

    -- TRINKETS -- SLOT 0 /use 13
    -- "Inoculating Extract" 160649 -- "Extrait d’inoculation" 160649
    {{"macro"}, 'player.hasTrinket(0) == 160649 and player.useTrinket(0) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 13" },
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield)' , "player" },
        {spells.powerWordShield, 'not heal.lowestUnitInRaid.hasBuff(spells.powerWordShield) and heal.lowestUnitInRaid.hp < 0.80' , kps.heal.lowestUnitInRaid },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" , "powerWordShield_mouseover" },
    }},
    
    {spells.holyNova, 'kps.holyNova and target.distance < 10' , "target" },
    {spells.luminousBarrier, 'player.hasTalent(7,2) and heal.countLossInRange(0.80)*2 > heal.countInRange' },
    {spells.shadowCovenant, 'player.hasTalent(5,3) and heal.countLossInRange(0.80)*2 > heal.countInRange' , kps.heal.lowestInRaid },
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 2 and target.isAttackable and target.distance <= 30' , "target" },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.80) > 2' },

    {spells.evangelism, 'player.hasTalent(7,3) and spells.powerWordRadiance.charges == 0' },
    {{"nested"}, 'spells.powerWordRadiance.lastCasted(7)' , {
        {spells.powerWordSolace, 'player.hasTalent(3,3)' , env.damageTarget },
        {spells.penance, 'spells.schism.lastCasted(6)' , env.damageTarget , "penance_radiance_schism" },
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonement.hp < 1' , env.damageTarget , "schism_radiance" },
        {spells.mindbender, 'player.hasTalent(3,2)' , env.damageTarget },
        {spells.shadowfiend, 'not player.hasTalent(3,2)' , env.damageTarget },
        {spells.penance, 'heal.hasBuffAtonement.hp < 1' , env.damageTarget , "penance_radiance" },
        {spells.smite, 'not player.isMoving' , env.damageTarget , "smite_radiance" },
    }},
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.hasBuff(spells.painSuppression)' , kps.heal.lowestTankInRaid },
    {spells.rapture, 'spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.cooldown > kps.gcd and heal.hasNotBuffAtonementCount(0.80) > 2' },

    -- NOT ISINGROUP
    {{"nested"}, 'kps.multiTarget' , {
        {spells.rapture, 'player.hp < 0.40' , "player" },
        {spells.powerWordShield, 'player.hasBuff(spells.rapture) and not player.hasBuff(spells.powerWordShield)' , "player" },
        {spells.powerWordShield, 'target.isAttackable and targettarget.isFriend and targettarget.myBuffDuration(spells.atonement) < 1 and targettarget.hp < 1 and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" },
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 1 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 1 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordRadiance, 'mouseover.isFriend and not player.isMoving and heal.hasNotBuffAtonementCount(0.80) > 2' , "mouseover" , "radiance_mouseover"},
        {spells.shadowMend, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.55 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.powerWordShield, 'mouseover.isFriend and mouseover.myBuffDuration(spells.atonement) < 1 and mouseover.hp < 1 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.penance, 'player.hp < 0.65' , "player" },
        {spells.powerWordSolace, 'player.hasTalent(3,3) and target.isAttackable' , "target" },
        {spells.holyNova, 'kps.holyNova and target.distance <= 10' },
        {spells.shadowWordPain, 'target.isAttackable and not target.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("target")' , "target" }, 
        {spells.shadowWordPain, 'focus.isAttackable and not focus.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("focus")' , "focus" },
        {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and not mouseover.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and target.isAttackable and spells.penance.cooldown < 6' , "target" },
        {spells.penance, 'target.isAttackable' , "target" },
        {spells.divineStar, 'player.hasTalent(6,2) and target.isAttackable and target.distance <= 30' , "target" },
        {spells.mindbender, 'player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.smite, 'not player.isMoving and target.isAttackable' , "target" },
    }},

    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and spells.penance.cooldown > kps.gcd' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.penance, 'heal.lowestTankInRaid.hp < 0.65 ' , kps.heal.lowestTankInRaid  },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" , "shadowMend_player" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and spells.penance.cooldown > kps.gcd' , "player" , "shadowMend_player" },
    {spells.penance, 'player.hp < 0.65 ' , "player"  },

    {{"nested"}, 'kps.mouseOver and mouseover.isHealable' , {
        {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.80) - heal.hasBuffAtonementCount(0.80) > 2' , "mouseover" , "radiance_mouseover"},
        {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
        {spells.shadowMend, 'not player.isMoving and mouseover.myBuffDuration(spells.atonement) < 1 and mouseover.hp < 0.55' , "mouseover" , "shadowMend_mouseover"},
        {spells.powerWordShield, 'mouseover.myBuffDuration(spells.atonement) < 1 and mouseover.hp < 1 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover" },
        {spells.penance, 'mouseover.myBuffDuration(spells.atonement) > 1 and mouseover.hp < 0.80 and mouseovertarget.isAttackable' , "mouseovertarget" , "penance_mouseover_offensive" },
        {spells.shadowWordPain, 'mouseover.myBuffDuration(spells.atonement) > 1 and mouseovertarget.isAttackable and not spells.shadowWordPain.isRecastAt("mouseovertarget")' , "mouseovertarget" , "pain_mouseover" },
        {spells.smite, 'not player.isMoving and mouseover.myBuffDuration(spells.atonement) > 1 and mouseovertarget.isAttackable' , "mouseovertarget" , "smite_mouseover" },
        {spells.penance, 'mouseover.myBuffDuration(spells.atonement) > 1 and mouseovertarget.isAttackable' , "mouseovertarget" , "penance_mouseover_offensive" },
    }},

    -- GROUPHEAL
    -- heal.lossHealthRaid` - Returns the loss Health for all raid members
    -- heal.atonementHealthRaid - Returns the loss Health for all raid members with buff atonement
    -- heal.hasBuffCount(spells.atonement)
    -- heal.hasNotBuffAtonementCount(0.80) -- count unit below 0.80 health without atonement buff
    -- heal.hasBuffAtonementCount(0.80) -- count unit below 0.80 health with atonement buff
    -- heal.countLossInRange(0.80) -- count unit below 0.80 health
    -- heal.atonementHealthRaid -- Returns the loss Health for all raid members with buff atonement
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementImportantUnitCount > 2', kps.heal.lowestTankInRaid , "radiance_count" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) > 2 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5' , kps.heal.lowestTankInRaid , "radiance" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) > 2 and player.myBuffDuration(spells.atonement) < 5' , "player" , "radiance" },  
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) > 2' , kps.heal.hasNotBuffAtonement , "radiance" },
    {spells.powerWordShield, 'heal.hasNotBuffAtonementImportantUnitCount > 0' , kps.heal.hasNotBuffAtonementImportantUnit , "hasNotBuffAtonementImportantUnit" },

    {spells.shadowWordPain, 'target.isAttackable and not target.hasMyDebuff(spells.shadowWordPain) and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.powerWordSolace, 'player.hasTalent(3,3) and heal.hasBuffAtonement.hp < 1' , env.damageTarget },
    {spells.penance, 'heal.hasBuffAtonement.hp < 0.80' , env.damageTarget , "penance_offensive" },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.55' , env.damageTarget },
    {spells.shadowMend, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.55', kps.heal.lowestInRaid ,  "shadowMend_lowest" },
    {spells.powerWordShield, 'heal.hasNotBuffAtonement.hp < 0.80 and not heal.hasNotBuffAtonement.isUnit("player") and not heal.hasNotBuffAtonement.hasDebuff(spells.weakenedSoul)' , kps.heal.hasNotBuffAtonement ,  "powerWordShield_lowest" },
    {spells.smite, 'not player.isMoving' , env.damageTarget },

}
,"priest_discipline_bfa")


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--