--[[[
@module Priest Discipline Rotation
@author htordeux
@version 9.0.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name
local Barriere = spells.powerWordBarrier.name
local DoorOfShadows = spells.doorOfShadows.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "rampUp", "Interface\\Icons\\ability_shaman_astralshift", "rampUp")
end)


kps.rotations.register("PRIEST","DISCIPLINE",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --env.haloMessage,
    
    {{"macro"}, 'spells.powerWordRadiance.shouldInterrupt(heal.countLossInRange(0.85), kps.defensive and not kps.rampUp)' , "/stopcasting" },
    {{"macro"}, 'spells.shadowMend.shouldInterrupt(0.85, kps.defensive and not kps.rampUp)' , "/stopcasting" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift and spells.powerWordBarrier.cooldown == 0', "/cast [@cursor] "..Barriere },
    -- "Door of Shadows" 
    {{"macro"}, ' keys.alt and not player.isMoving and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    --{spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pain Suppression"
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.30' , "player"},
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
    
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" }, 
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield)' , "player" },
        {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'not heal.hasNotBuffShield.isUnit("player")' , kps.heal.hasNotBuffShield },
    }},
    
    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },   
        --{spells.arcaneTorrent, 'player.timeInCombat > 30 and target.isAttackable and target.distance <= 10' , "target" },
    }},

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},

    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.55 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" },
    -- PVP
    {{"nested"}, 'player.isPVP' ,{
        {spells.darkArchangel, 'player.isPVP and player.myBuffDuration(spells.atonement) > 8' , "player" },
        {spells.powerWordShield, 'player.hp < 0.70 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.painSuppression, 'player.isStun and player.hp < 0.55' , "player" },
    }},
 
    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving and player.timeInCombat > 9' , "/use [@player] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and targettarget.isHealable' , "/use [@targettarget] 14" },
    {{"macro"}, 'player.useTrinket(1) and not player.isMoving and player.timeInCombat > 5' , "/use 14" },

    {{"nested"},'kps.multiTarget and kps.groupSize() == 1', {
        {spells.rapture, 'player.hp < 0.40 and spells.painSuppression.cooldown > 0' },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.70 and not spells.shadowMend.isRecastAt("player")' , "player" , "shadowMend_player"  },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.80 and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" , "shadowMend_targettarget" },
        {spells.powerWordShield, 'targettarget.isFriend and not targettarget.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "shield_targettarget" },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player"  },
    }},
    -- DAMAGE
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.15 and player.hp > 0.70' , "target" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "target" },
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "mouseover" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
    
    {{"nested"},'kps.multiTarget', {
        {spells.powerInfusion, 'kps.cooldowns and (target.hp > 0.80 or target.isElite)' },
        {spells.shadowfiend, 'target.isElite or target.hp > 0.80' , env.damageTarget },
        {spells.mindgames, 'not player.isMoving and target.hasMyDebuff(spells.schism)' , env.damageTarget },
        {spells.schism, 'not player.isMoving' , env.damageTarget },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
        {spells.penance, 'true' , env.damageTarget  },
        {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
        {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' , "target" },
        {spells.mindSear, 'not player.isMoving and player.plateCount > 3' , env.damageTarget },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
        {spells.holyNova, 'player.isMoving and target.distance <= 10' },
    }},
    
    {spells.evangelism, 'player.hasTalent(7,3) and heal.hasBuffAtonementCount > 9 and spells.powerWordRadiance.charges == 0 and target.isBoss' },
    {spells.evangelism, 'not player.isInRaid and player.hasTalent(7,3) and heal.hasBuffAtonementCount > 4 and spells.powerWordRadiance.lastCasted(9) and target.isBoss' },

    -- ATONEMENT RAMP UP
    {{"nested"},'kps.rampUp and player.hasBuff(spells.spiritShell)', {
        {spells.powerInfusion, 'true' },
        {spells.shadowfiend, 'true' , env.damageTarget },
        {spells.mindgames, 'not player.isMoving and spells.schism.lastCasted(9)' , env.damageTarget },
        {spells.schism, 'not player.isMoving' , env.damageTarget },
        {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
        {spells.penance, 'true' , env.damageTarget },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},
    {{"nested"},'kps.rampUp and heal.hasBuffAtonementCount < 5', {
        {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_rampUp_lowest" },
        {spells.powerWordShield, 'not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit) and not heal.hasNotBuffAtonement.hasDebuff(spells.weakenedSoul)' , kps.heal.hasNotBuffAtonement , "shield_lowest_rampUp" },
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank_rampUp" },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  , "shield_player_rampUp" },
    }},
    {{"nested"},'kps.rampUp', {
        {spells.powerWordRadiance, 'not player.isMoving and heal.lowestInRaid.myBuffDuration(spells.atonement) < 5 and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_rampUp_lowest" },
        {spells.powerWordRadiance, 'not player.isMoving and not heal.hasNotBuffAtonement.isUnit("player") and not spells.powerWordRadiance.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "radiance_rampUp_lowest" },
        {spells.powerWordRadiance, 'not player.isMoving and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5 and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid, "radiance_tank_rampUp" },
        {spells.powerWordRadiance, 'not player.isMoving and player.myBuffDuration(spells.atonement) < 5 and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player_rampUp" },
    }},
    {spells.spiritShell, 'kps.rampUp and player.hasTalent(7,2) and spells.powerWordRadiance.charges == 0' },

    -- RADIANCE
    {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.80) > 4 and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_count" },
    {spells.powerWordRadiance, 'not player.isInRaid and not player.isMoving and heal.countLossInRange(0.80) > 2 and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_count" },
    --{spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 2' },
    --{spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' },
    -- MOUSEOVER
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.80 and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover") and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover" },  
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" , "shadowMend_mouseover_urg"},
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.30 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover_urg" },  
    -- DAMAGE
    {spells.mindgames, 'not player.isMoving and spells.schism.lastCasted(9)' , env.damageTarget },
    {spells.schism, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.70 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2 and player.myBuffDuration(spells.atonement) > 2' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.80 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2 and player.myBuffDuration(spells.atonement) > 2' , env.damageTarget },
    {spells.powerWordSolace, 'heal.hasBuffAtonement.hp < 1' , env.damageTarget  },
    {spells.penance, 'heal.hasBuffAtonement.hp < 1' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.myBuffDuration(spells.atonement) > 2 and heal.lowestInRaid.hp > 0.55' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.80' , env.damageTarget },
    -- TANK
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank" },
    {spells.penance, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "penance_tank" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid  , "shadowMend_tank" },
    -- PLAYER
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.70 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player")' , "player" },
    {spells.powerWordShield, 'player.hp < 0.70 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
    {spells.powerWordShield, 'not player.isInRaid and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
    {spells.penance, 'player.hp < 0.40' , "player"  , "penance_player" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" , "shadowMend_player"  },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player"  },
    -- RAPTURE
    {spells.rapture, 'not player.hasTalent(7,2) and player.isMoving and heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTankInRaid.hasBuff(spells.painSuppression)' }, 
    {spells.rapture, 'not player.hasTalent(7,2) and player.isMoving and player.hp < 0.30 and not player.hasBuff(spells.painSuppression)' },
    {spells.rapture, 'not player.hasTalent(7,2) and heal.countLossInRange(0.80)*2  > heal.countInRange and spells.powerWordRadiance.charges == 0' },
    -- LOWEST
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowest_atonement" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.70 and not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_atonement" },
    {spells.shadowMend, 'not player.isInRaid and not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowest_atonement" },
    {spells.powerWordShield, 'not player.isInRaid and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_atonement" },
    -- EMERGENCY
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player_urg" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "shadowMend_lowest_urg" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid , "shadowMend_tank_urg" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_urg" },
    -- DAMAGE
    --{spells.mindSear, 'not player.isMoving and player.plateCount > 2' , env.damageTarget },
    {spells.smite, 'not player.isMoving' , env.damageTarget },
    {spells.holyNova, 'player.isMoving and target.distance <= 10' },

}
,"priest_discipline_Shadowlands")


--AZERITE
-- "Vitality Conduit"
--{spells.azerite.vitalityConduit, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
-- "Concentrated Flame"
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
--"Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
--{spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--