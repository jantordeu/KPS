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
    {{"macro"}, 'not player.isMoving and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pain Suppression"
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.40' , "player"},
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},
    
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield)' , "player" },
        {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" }, 
        {spells.powerWordShield, 'not heal.hasNotBuffShield.isUnit("player")' , kps.heal.hasNotBuffShield },
    }},
    
    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.isInGroup and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.isInGroup and not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
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

    {spells.desperatePrayer, 'player.hp < 0.65' , "player" },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.65 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" },
    -- PVP
    {spells.darkArchangel, 'player.isPVP and heal.hasBuffAtonementCount > 2' , "player" }, 

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving' , "/use [@player] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and targettarget.isHealable' , "/use [@targettarget] 14" },
    {{"macro"}, 'player.useTrinket(1) and not player.isMoving' , "/use 14" },

    -- PLAYER
    {spells.shadowMend, 'not player.isMoving and player.myBuffDuration(spells.atonement) < 2 and player.hp < 0.90 and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" },
    {spells.powerWordShield, 'not player.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul) ' , "player"  },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player"  },
    -- TANK
    {spells.shadowMend, 'not player.isMoving and not heal.lowestTankInRaid.isUnit("player") and heal.lowestTankInRaid.hp < 0.90 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "shadowMend_tank" },
    
    -- DAMAGE
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.50' , "mouseover" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.50' , "target" },
    {{"nested"},'kps.multiTarget', {
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and not targettarget.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" , "shadowMend_targettarget" },
        {spells.powerWordShield, 'targettarget.isFriend and not targettarget.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "shield_targettarget" },
        {spells.powerInfusion, 'target.hp > 0.50' , env.damageTarget },
        {spells.powerInfusion, 'target.isElite and target.hp > 0.20' , env.damageTarget },
        {spells.mindbender, 'player.hasTalent(3,2) and target.isElite' , env.damageTarget },
        {spells.shadowfiend, 'target.isElite' , env.damageTarget },
        {spells.mindgames, 'not player.isMoving and target.hasMyDebuff(spells.schism)' , env.damageTarget },
        {spells.schism, 'not player.isMoving' , env.damageTarget },
        {spells.mindBlast, 'not player.isMoving and spells.schism.cooldown > 6' , env.damageTarget },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
        {spells.penance, 'player.hasBuff(spells.powerOfTheDarkSide)' , env.damageTarget  },
        {spells.penance, 'true' , env.damageTarget  },
        {spells.rapture, 'player.hp < 0.40 and spells.painSuppression.cooldown > 0 and spells.schism.cooldown > 3' },
        {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' , "target" },
        {spells.mindSear, 'not player.isMoving and player.plateCount > 2' , env.damageTarget },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
        {spells.holyNova, 'target.distance <= 10' },
    }},
    -- ATONEMENT RAMP UP
    {{"nested"},'kps.rampUp and not player.isMoving and not player.isInRaid', {
        {spells.powerWordRadiance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid, "radiance_tank_rampUp" },
        {spells.powerWordRadiance, 'player.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player_rampUp" },
        {spells.powerWordRadiance, 'not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_rampUp" },
        {spells.powerWordRadiance, 'not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit) and not spells.powerWordRadiance.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "radiance_rampUp" },
    }}, 
    {{"nested"},'kps.rampUp and heal.hasBuffAtonementCount < 6 and player.isInRaid', {
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 7 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank" },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 7 and not spells.shadowMend.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player"  },
        {spells.powerWordShield, 'not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_rampUp" },
        {spells.powerWordShield, 'not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit) and not heal.hasNotBuffAtonement.hasDebuff(spells.weakenedSoul)' , kps.heal.hasNotBuffAtonement , "shield_rampUp" },
    }},
    {{"nested"},'kps.rampUp and not player.isMoving', {
        {spells.powerWordRadiance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid, "radiance_tank_rampUp" },
        {spells.powerWordRadiance, 'player.myBuffDuration(spells.atonement) < 5 and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player_rampUp" },
        {spells.powerWordRadiance, 'not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_rampUp" },
        {spells.powerWordRadiance, 'not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit) and not spells.powerWordRadiance.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "radiance_rampUp" },
    }},

    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 2'  },
    {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' },
    {spells.evangelism, 'player.hasTalent(7,3) and heal.hasBuffAtonementCount > 9 and spells.powerWordRadiance.charges == 0' },
    {spells.spiritShell, 'player.hasTalent(7,2) and heal.hasBuffAtonementCount > 9 and spells.powerWordRadiance.charges == 0' },
    {spells.evangelism, 'player.hasTalent(7,3) and heal.hasBuffAtonementCount > 4 and not player.isInRaid' },
    {spells.spiritShell, 'player.hasTalent(7,2) and heal.hasBuffAtonementCount > 4 and not player.isInRaid' },
    -- RADIANCE
    {spells.powerWordRadiance, 'not player.isMoving and not player.isInRaid and heal.countLossInRange(0.80) > 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_count" },
    {{"nested"},'not player.isMoving and heal.countLossInRange(0.80) > 3', {
       {spells.powerWordRadiance, 'not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "radiance_lowest_count" },
       {spells.powerWordRadiance, 'player.hp < 0.80 and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player" },
       {spells.powerWordRadiance, 'heal.lowestTankInRaid.hp < 0.80 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "radiance_tank" },
       {spells.powerWordRadiance, 'not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit) and not spells.powerWordRadiance.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "radiance" },
    }},
     -- RAPTURE
    {spells.rapture, 'heal.countLossInRange(0.80)*2  > heal.countInRange and spells.powerWordRadiance.charges == 0 and spells.schism.cooldown > 3' },
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and spells.painSuppression.cooldown > 0 and spells.schism.cooldown > 3' },   
    {spells.rapture, 'player.hp < 0.40 and spells.painSuppression.cooldown > 0 and spells.schism.cooldown > 3' },

    -- MOUSEOVER
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.80 and not mouseover.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("mouseover") and not spells.powerWordRadiance.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.80 and not mouseover.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("mouseover") and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover" },  
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" , "shadowMend_mouseover_urg"},
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.50 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover_urg"},
    {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.80) > 2 and mouseover.isHealable and mouseover.hp < 0.80 and not spells.shadowMend.isRecastAt("mouseover") and not spells.powerWordRadiance.isRecastAt("mouseover")' , "mouseover" , "radiance_mouseover"},
    -- DAMAGE
    {spells.mindgames, 'not player.isMoving and target.hasMyDebuff(spells.schism)' , env.damageTarget },
    {spells.schism, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.65' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving and heal.hasBuffAtonement.hp < 0.80' , env.damageTarget },
    {spells.powerWordSolace, 'heal.hasBuffAtonement.hp < 1' , env.damageTarget  },
    {spells.penance, 'heal.hasBuffAtonement.hp < 1' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.hasNotBuffAtonement.hp > 0.80' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hasMyBuff(spells.atonement) and heal.lowestInRaid.hp > 0.65' , env.damageTarget },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.80' , env.damageTarget },
    -- EMERGENCY
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.65' , "player" , "shadowMend_player"  },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.65 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "shadowMend_lowest" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'player.hp < 0.50 and not player.hasDebuff(spells.weakenedSoul)' , "player" , "shield_player_lowhp" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.50 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowestInRaid_lowhp" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.hp < 0.50 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "shield_tank_lowhp" },
    -- LOWEST
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowest_health" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_health" },
    -- DAMAGE
    {spells.mindSear, 'not player.isMoving and player.plateCount > 2' , env.damageTarget },
    {spells.smite, 'not player.isMoving' , env.damageTarget },
    {spells.holyNova, 'target.distance <= 10' },

}
,"priest_discipline_Shadowlands")


--AZERITE
-- "Vitality Conduit"
--{spells.azerite.vitalityConduit, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
-- "Concentrated Flame"
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
--"Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
--{spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--