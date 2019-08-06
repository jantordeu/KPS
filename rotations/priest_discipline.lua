--[[[
@module Priest Discipline Rotation
@author htordeux
@version 8.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name
local Barriere = spells.powerWordBarrier.name


--kps.runAtEnd(function()
--   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "mouseOver", "Interface\\Icons\\priest_spell_leapoffaith_a", "mouseOver")
--end)

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "holyNova", "Interface\\Icons\\spell_holy_holynova", "holyNova")
end)

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "mindControl", "Interface\\Icons\\Priest_spell_leapoffaith_a", "mindControl ")
end)


kps.rotations.register("PRIEST","DISCIPLINE",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --env.haloMessage,
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Barriere },
    
    -- BUTTON
    --{spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },
    --{spells.mindControl, 'keys.alt and target.isAttackable and not target.hasMyDebuff(spells.mindControl) and target.myDebuffDuration(spells.mindControl) < 2' , "target" },
   
    {spells.painSuppression, 'focus.exists and focus.hp < 0.30 and focus.isRaidTank' , "focus" },
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30 and heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    {spells.painSuppression, 'player.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},

    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },   
    {spells.arcaneTorrent, 'player.timeInCombat > 30 and mouseover.isAttackable and mouseover.distance <= 10' , "target" },
    --{spells.arcaneTorrent, 'player.timeInCombat > 30 and target.isAttackable and target.distance <= 10' , "target" },

    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
    }},

    -- "Dispel" "Purifier" 527
    {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},

    --{spells.fireBlood, 'player.isDispellable("Magic") or player.isDispellable("Disease") or player.isDispellable("Poison") or player.isDispellable("Curse")' , "player" },
    {{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player", "SCHIELD_MOVING" },

    -- TRINKETS -- SLOT 0 /use 13
    -- "Inoculating Extract" 160649 -- "Extrait d’inoculation" 160649
    --{{"macro"}, 'player.hasTrinket(0) == 160649 and player.useTrinket(0) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 13" },
    {{"macro"}, 'player.useTrinket(0) and heal.lowestInRaid.hp < 0.40' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'not player.isMoving and not player.hasTrinket(1) == 165569 and player.useTrinket(1)' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.65' , "/use [@player] 14" },
    
    -- GROUPHEAL
    -- heal.lossHealthRaid` - Returns the loss Health for all raid members
    -- heal.lossHealthRaidAtonement - Returns the loss Health for all raid members with buff atonement
    -- heal.hasBuffCount(spells.atonement)
    -- heal.hasNotBuffAtonementCount(0.80) -- count unit below 0.80 health without atonement buff
    -- heal.hasBuffAtonementCount(0.80) -- count unit below 0.80 health with atonement buff
    -- heal.countLossInRange(0.80) -- count unit below 0.80 health
    -- heal.hasNotBuffAtonement.hp < 0.90 -- UNIT with lowest health without Atonement Buff on raid -- default "player" 
    -- heal.hasBuffAtonement.hp < 0.90 - UNIT with lowest health with Atonement Buff on raid e.g. -- default "player"
    
    {{spells.powerWordShield,spells.penance}, 'player.hasBuff(spells.rapture) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    {{spells.powerWordShield,spells.shadowMend}, 'not player.isMoving and player.hasBuff(spells.rapture) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < 0.80' , "player" },
        {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.80 and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },    
        {spells.powerWordShield, 'targettarget.isHealable and not targettarget.hasBuff(spells.powerWordShield) and targettarget.hp < 0.80' , "targettarget" },
        {spells.powerWordShield, 'not heal.lowestUnitInRaid.hasBuff(spells.powerWordShield) and heal.lowestUnitInRaid.hp < 0.55' , kps.heal.lowestUnitInRaid },
    }},
    {spells.rapture, 'heal.hasNotBuffAtonementCount(0.55) >= 3 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    
    --AZERITE
    {spells.concentratedFlame, 'heal.lossHealthRaidAtonement > 0' , kps.heal.lowestInRaid },
    {spells.memoryOfLucidDreams, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid },
    {spells.overchargeMana,'heal.hasBuffAtonementCount(0.80) >= 5 and spells.powerWordRadiance.lastCasted(5)' , kps.heal.lowestInRaid },
    {spells.evangelism, 'player.hasTalent(7,3) and spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.lastCasted(5)' },
    
    -- TANK 
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "powerWordShield_tank" },
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.isRaidTank and mouseover.hp < 0.65 and mouseover.myBuffDuration(spells.atonement) < 2' , "mouseover" },
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.isRaidTank and mouseover.myBuffDuration(spells.atonement) < 2 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" },
    -- PLAYER
    {spells.shadowMend, 'not player.isMoving and player.hp <  0.65 and player.myBuffDuration(spells.atonement) < 2' , "player" , "shadowMend_player" },
    {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and player.hp < 0.90 and not player.hasDebuff(spells.weakenedSoul)' , "player" , "powerWordShield_player" },

    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "radiance_tank" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and player.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.90) >= 3 and spells.powerWordRadiance.charges == 2 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement },

    {{"nested"}, 'heal.hasBuffAtonementCount(0.80) >= 3' , {
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3)' , env.damageTarget },
        {spells.mindbender, 'player.hasTalent(3,2)' , env.damageTarget },
        {spells.shadowfiend, 'not player.hasTalent(3,2)' , env.damageTarget },
        {spells.penance, 'true' , env.damageTarget  },
        {spells.powerWordSolace, 'player.hasTalent(3,3)' , env.damageTarget },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},

    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.90) >= 3 and target.distance <= 10' , "target" },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) >= 3' },
    {spells.shadowCovenant, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) >= 3' , kps.heal.lowestInRaid },
    {spells.luminousBarrier, 'player.hasTalent(7,2) and heal.countLossInRange(0.80)*2 > heal.countInRange' },
    {spells.holyNova, 'kps.holyNova and heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2' },
    {spells.holyNova, 'player.hasBuff(spells.suddenRevelation) and heal.countLossInDistance(0.90,10) >= 3' },
    
    -- NOT ISINGROUP
    {{"nested"}, 'kps.multiTarget' , {
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'focus.isFriend and focus.myBuffDuration(spells.atonement) < 2 and focus.hp < 0.90 and not focus.hasDebuff(spells.weakenedSoul)' , "focus" },
        {spells.powerWordShield, 'mouseover.isFriend and mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.90 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" },
        {spells.powerWordShield, 'targettarget.isFriend and targettarget.hp < 0.90 and targettarget.myBuffDuration(spells.atonement) < 2 and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "powerWordShield_targettarget" },

        {spells.powerWordSolace, 'player.hasTalent(3,3) and target.isAttackable' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("focus")' , "focus" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("focus")' , "focus" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },

        {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.65 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.shadowMend, 'not player.isMoving and focus.isFriend and focus.hp < 0.65 and not spells.shadowMend.isRecastAt("focus")' , "focus" },
        {spells.shadowMend, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.65 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.65 and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" },

        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and target.isAttackable and spells.penance.cooldown < 7' , "target" },
        {spells.penance, 'target.isAttackable' , "target" },
        {spells.powerWordSolace, 'player.hasTalent(3,3) and target.isAttackable' , "target" },
        {spells.mindbender, 'player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.smite, 'not player.isMoving and target.isAttackable' , "target" },
    }},
    
    {spells.powerWordSolace, 'player.hasTalent(3,3) and heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2' , env.damageTarget },
    {spells.shadowWordPain,'not player.hasTalent(6,1) and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")', "target" , "pain_mouseover"},
    {spells.purgeTheWicked,'player.hasTalent(6,1) and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")', "target" , "pain_mouseover"},
    {spells.shadowWordPain,'mouseover.isAttackable and mouseover.inCombat and not player.hasTalent(6,1) and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")', "mouseover" , "pain_mouseover"},
    {spells.purgeTheWicked,'mouseover.isAttackable and mouseover.inCombat and player.hasTalent(6,1) and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")', "mouseover" , "pain_mouseover"},

    -- TANK 
    {spells.penance, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "penance_defensive" },
    {spells.penance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and heal.lowestTankInRaid.hp < 0.90' , env.damageTarget },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    
    -- PLAYER
    {spells.penance, 'player.myBuffDuration(spells.atonement) > 2 and player.hp < 0.40' , "player"  , "penance_defensive" },
    {spells.penance, 'player.myBuffDuration(spells.atonement) > 2 and player.hp < 0.90' , env.damageTarget  , "penance_offensive" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" },

    -- MOUSEOVER HEALABLE
    {{"nested"}, 'mouseover.isHealable' , {
        {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.65 and mouseover.myBuffDuration(spells.atonement) < 2' , "mouseover" , "shadowMend_mouseover"},
        {spells.powerWordShield, 'mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.90 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover" },
        {spells.penance, 'mouseover.myBuffDuration(spells.atonement) > 2 and mouseover.hp < 0.40' , "mouseover" , "penance_defensive_mouseover" },
        {spells.penance, 'mouseover.myBuffDuration(spells.atonement) > 2 and mouseover.hp < 0.90 and mouseovertarget.isAttackable' , "mouseovertarget" , "penance_offensive_mouseovertarget" },
        {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.40' , "mouseover" , "shadowMend_mouseover"},
        {spells.smite, 'not player.isMoving and mouseovertarget.isAttackable' , "mouseovertarget" , "smite_mouseovertarget" },
    }},

     -- MOUSEOVER ATTACKABLE
    {{"nested"}, 'mouseover.isAttackable and mouseovertarget.isHealable' , {
        {spells.shadowMend, 'not player.isMoving and mouseovertarget.hp < 0.65 and mouseovertarget.myBuffDuration(spells.atonement) < 2' , "mouseovertarget" , "shadowMend_mouseovertarget"},
        {spells.powerWordShield, 'mouseovertarget.myBuffDuration(spells.atonement) < 2 and mouseovertarget.hp < 0.90 and not mouseovertarget.hasDebuff(spells.weakenedSoul)' , "mouseovertarget" , "powerWordShield_mouseovertarget" },
        {spells.penance, 'mouseovertarget.myBuffDuration(spells.atonement) > 2 and mouseovertarget.hp < 0.40' , "mouseovertarget" , "penance_defensive_mouseovertarget" },
        {spells.penance, 'mouseovertarget.myBuffDuration(spells.atonement) > 2 and mouseovertarget.hp < 0.90' , "mouseover" , "penance_offensive_mouseover" },
        {spells.shadowMend, 'not player.isMoving and mouseovertarget.hp < 0.40' , "mouseovertarget" , "shadowMend_mouseovertarget"},
        {spells.smite, 'not player.isMoving', "mouseover" , "smite_mouseover"},
    }},

    -- LOWESTINRAID
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.65 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2', kps.heal.lowestInRaid ,  "shadowMend_lowest" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)', kps.heal.lowestInRaid ,  "powerWordShield_lowest" },
    {spells.penance, 'heal.lowestInRaid.myBuffDuration(spells.atonement) > 2 and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid  , "penance_defensive" },
    {spells.penance, 'heal.lowestInRaid.myBuffDuration(spells.atonement) > 2 and heal.lowestInRaid.hp < 0.90' , env.damageTarget  , "penance_offensive" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.40', kps.heal.lowestInRaid ,  "shadowMend_lowest" },

    {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and heal.hasBuffAtonementCount(0.80) >= 3 and spells.penance.cooldown < 7' , env.damageTarget  , "schism_offensive" },
    {spells.penance, 'heal.hasBuffAtonement.hp < 0.90' , env.damageTarget  , "penance_offensive" },
    {spells.smite, 'not player.isMoving' , env.damageTarget , "smite_offensive" },
    {spells.holyNova, 'player.isMoving and heal.countLossInDistance(0.90,10) >= 3' },

}
,"priest_discipline_bfa")


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--