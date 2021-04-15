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
    
    {{"macro"}, 'spells.powerWordRadiance.shouldInterrupt(heal.countLossInRange(0.80), kps.defensive and not kps.rampUp)' , "/stopcasting" },
    {{"macro"}, 'spells.shadowMend.shouldInterrupt(0.85, kps.defensive and not kps.rampUp)' , "/stopcasting" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift and spells.powerWordBarrier.cooldown == 0', "/cast [@cursor] "..Barriere },
    -- "Door of Shadows" 
    --{{"macro"}, ' keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    --{spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pain Suppression"
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.30' , "player"},
    {spells.painSuppression, 'keys.alt and mouseover.isHealable' , "mouseover" },
    
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt("player")' , "player" },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt("mouseover")' , "mouseover" }, 
    }},
    
    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },   
    }},

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},

    {spells.desperatePrayer, 'player.hp < 0.60' , "player" },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.60 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" },
    -- PVP
    {{"nested"}, 'player.isPVP' ,{
        {spells.darkArchangel, 'player.myBuffDuration(spells.atonement) > 8' , "player" },
        {spells.powerWordShield, 'player.hp < 0.80 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.painSuppression, 'player.isStun and player.hp < 0.60' , "player" },
    }},
 
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9' , "/use [@player] 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and targettarget.isHealable and targettarget.hp < 0.80' , "/use [@targettarget] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and targettarget.isHealable' , "/use [@targettarget] 14" },
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30' , "/use 14" },
    
    --{spells.halo, 'not player.isMoving and player.hasTalent(6,3)' },
    --{spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' , "target" },  
    {spells.evangelism, 'kps.rampUp and player.hasTalent(7,3) and spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.lastCasted(9)' },
    {spells.spiritShell, 'kps.rampUp and player.hasTalent(7,2) and spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.lastCasted(9)' },
    -- RAPTURE -- MANUAL --{spells.rapture, 'not player.hasTalent(7,2) and heal.countLossInRange(0.60)*2 > heal.countInRange' },
    
    {{"nested"},'kps.groupSize() == 1', {
        {spells.rapture, 'player.hp < 0.40 and spells.painSuppression.cooldown > 0' },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.80 and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" , "shadowMend_targettarget" },
        {spells.powerWordShield, 'targettarget.isFriend and not targettarget.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "shield_targettarget" },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player"  },
    }},
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.80' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
    -- MOUSEOVER
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.70 and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.hp < 0.90 and mouseover.isHealable and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover") and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover" },
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" , "shadowMend_mouseover_urg"},
    {spells.penance, 'mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" , "penance_mouseover_urg"},
    -- TANK
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "shadowMend_tank" },
    {spells.penance, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "penance_tank_urg" },
    -- PLAYER
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.70 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player")' , "player" },
    {spells.powerWordShield, 'player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player"  },
    {spells.penance, 'player.hp < 0.40' , "player"  , "penance_player_urg" },
   -- ATONEMENT DAMAGE
    {{"nested"},'kps.multiTarget', {
        {spells.powerInfusion, 'target.hp > 0.80 or target.isElite' },
        {spells.shadowfiend, 'target.hp > 0.80 or target.isElite' , env.damageTarget },
        {spells.mindgames, 'not player.isMoving and target.hasMyDebuff(spells.schism)' , env.damageTarget },
        {spells.schism, 'not player.isMoving' , env.damageTarget },
        {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
        {spells.penance, 'true' , env.damageTarget  },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},
    -- RADIANCE
    {{"nested"},'kps.rampUp and heal.hasBuffAtonementCount < 5', {
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not player.hasDebuff(spells.weakenedSoul)' , "shield_rampup_player"  },
        {spells.powerWordShield, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_rampUp_lowest" },
        {spells.powerWordShield, 'heal.lowestUnitInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestUnitInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestUnitInRaid , "shield_rampUp_lowest" },
        {spells.powerWordShield, 'true' , kps.heal.hasNotBuffAtonement , "shield_rampUp_lowest_buff" },
    }},
    {{"nested"},'kps.rampUp and not player.isMoving and heal.hasBuffAtonementCount < heal.countInRange and heal.hasBuffAtonementCount > 4', {
        {spells.powerWordRadiance, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid, "radiance_rampUp_lowest" },
        {spells.powerWordRadiance, 'heal.lowestUnitInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt(heal.lowestUnitInRaid.unit)' , kps.heal.lowestUnitInRaid , "radiance_rampUp_lowest" },
        {spells.powerWordRadiance, 'player.myBuffDuration(spells.atonement) < 9 and not spells.powerWordRadiance.isRecastAt("player")' , "player", "radiance_rampUp_player" },
        {spells.powerWordRadiance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 9 and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid, "radiance_rampUp_tank" },
    }},
    -- DAMAGE
    {spells.powerWordSolace, 'true' , env.damageTarget  },
    {spells.penance, 'true' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving and heal.hasBuffAtonement.hp < 1' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.70' , env.damageTarget },
    -- LOWEST
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowest_atonement" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.70 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_atonement" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid , "shadowMend_lowest_urg" },
    -- DAMAGE
    {spells.mindSear, 'not player.isMoving and player.plateCount > 3' , env.damageTarget },
    {spells.smite, 'not player.isMoving' , env.damageTarget },
    {spells.holyNova, 'player.isMoving and target.distance <= 10' },

}
,"priest_discipline_Shadowlands")


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--