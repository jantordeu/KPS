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

local damageRotation = {
    {spells.powerInfusion, 'true' },
    {spells.shadowfiend, 'true' , env.damageTarget },
    {spells.schism, 'not player.isMoving' , env.damageTarget , "schism_rampup" },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget , "mindBlast_rampup" },
    {spells.powerWordSolace, 'true' , env.damageTarget , "solace_rampup" },
    {spells.penance, 'true' , env.damageTarget , "penance_rampup" },
    {spells.smite, 'not player.isMoving' , env.damageTarget , "smite_rampup" },
}


kps.rotations.register("PRIEST","DISCIPLINE",{

    {spells.powerWordFortitude, 'not player.hasBuff(spells.powerWordFortitude) and not player.isInGroup', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isHealable and mouseover.isRaidTank' , "/focus mouseover" },
    
    {{"macro"}, 'spells.powerWordRadiance.shouldInterrupt(heal.countLossInRange(0.95), kps.defensive and not kps.rampUp)' , "/stopcasting" },
    {{"macro"}, 'spells.shadowMend.shouldInterrupt(0.95, kps.defensive and not kps.rampUp)' , "/stopcasting" },

    -- "Dispel" "Purifier" 527
    {spells.purify, 'target.isDispellable("Magic")' , "target" },
    -- "Dissipation de masse"
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@player] "..MassDispel },
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier"
    {{"macro"}, 'keys.shift and spells.powerWordBarrier.cooldown == 0', "/cast [@cursor] "..Barriere },

    -- "Pain Suppression"
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.30' , "player"},
    {spells.painSuppression, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },

    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isFriend and spells.leapOfFaith.cooldown == 0 and spells.doorOfShadows.cooldown > 0', "mouseover" },
    -- "Door of Shadows" 
    {{"macro"}, ' keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    {spells.fade, 'player.isTarget' },
    {spells.desperatePrayer, 'player.hp < 0.50' , "player" },
    -- "Angelic Feather"
    --{{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    --{spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" },

    -- RAPTURE
    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt("mouseover")' , "mouseover" },
        {spells.powerWordShield, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestInRaid.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not player.hasBuff(spells.powerWordShield) and not spells.powerWordShield.isRecastAt("player")' , "player" },
        {spells.powerWordShield, 'not UnitIsUnit("player",heal.hasNotBuffAtonement.unit) and not spells.powerWordShield.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement },
    }},
    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,3) and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },   
    }},
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},

    -- guardianFaerie -- buff Reduces damage taken by 20%. Follows your Power Word: Shield.
    -- benevolentFaerie -- buff Increases the cooldown recovery rate of your target's major ability by 100%. Follows your Flash Heal (holy) Shadow Mend (shadow,disc)  
    -- wrathfulFaerie -- debuff target -- Any direct attacks against the target restore 0.5% Mana or 3 Insanity. Follows your Shadow Word: Pain
    {spells.powerWordShield, 'targettarget.isFriend and target.hasMyDebuff(spells.wrathfulFaerie) and not targettarget.hasBuff(spells.guardianFaerie) and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" },
    {spells.faeGuardians, 'target.isAttackable and not target.hasMyDebuff(spells.wrathfulFaerie)' , "target" },
    -- Venthyr
    {spells.mindgames, 'target.isAttackable' , "target" },
 
    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and not player.isMoving and kps.timeInCombat > 5' , "/use 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and targettarget.isHealable and targettarget.hp < 0.80' , "/use [@targettarget] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and focus.isHealable' , "/use [@focus] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30' , "/use 14" },
    
    {{"nested"},'kps.groupSize() == 1', {
        {spells.rapture,'player.hp < 0.40 and spells.painSuppression.cooldown > 0'},
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.80 and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("targettarget") and not spells.shadowMend.lastCasted(2)' , "targettarget" },
        {spells.powerWordShield, 'targettarget.isFriend and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.40' , "targettarget" },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not spells.shadowMend.lastCasted(2)' , "player" },
    	{spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player" },
    	{spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" },
    	{spells.penance, 'player.isMoving and player.hp < 0.40' , "player" },
    }},
    -- TANK
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.80 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.shadowMend.lastCasted(2)' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt(heal.lowestTankInRaid.unit) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    {spells.penance, 'player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    -- PLAYER
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("player") and not spells.shadowMend.lastCasted(2)' , "player" },
    {spells.powerWordShield, 'player.hp < 0.80 and player.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt("player") and not player.hasDebuff(spells.weakenedSoul)' , "player" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" },
    {spells.penance, 'player.isMoving and player.hp < 0.40' , "player" },
    -- MOUSEOVER
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.80 and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover") and not spells.shadowMend.lastCasted(2)' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.80 and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt("mouseover") and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "shield_mouseover" },
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" , "shadowMend_mouseover_urg"},
    -- DAMAGE
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and heal.lowestInRaid.hp > 0.50', "target" },
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.50' , "mouseover" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , "target" , "target_pain" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" , "mouseover_pain" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("target")' , "target" , "target_purge" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" , "mouseover_purge" },
    {spells.divineStar, 'player.hasTalent(6,2) and target.distanceMax  <= 20 and target.isAttackable' , "target" },
    -- RAMPUP
    {spells.spiritShell, 'player.hasTalent(7,2) and spells.powerWordRadiance.charges == 0' },
    {spells.evangelism, 'player.hasTalent(7,3) and spells.powerWordRadiance.charges == 0' },
    {{"nested"},'kps.rampUp', {
        {spells.rapture, 'true' },
        {spells.powerWordRadiance, 'not player.isMoving and heal.hasBuffCount(spells.atonement) < heal.countInRange' , kps.heal.lowestInRaid, "radiance_rampUp_count" },
        {spells.powerWordRadiance, 'not player.isMoving and heal.hasBuffCount(spells.atonement) < heal.countInRange' , "player", "radiance_rampUp_count" },
    }},
    {{"nested"},'kps.multiTarget', damageRotation },
    {{"nested"},'player.hasTalent(7,2) and player.hasBuff(spells.spiritShell)', damageRotation},
    {{"nested"},'kps.rampUp and heal.countLossAtonementInRange(0.80) > 4', damageRotation },
    -- NOT RAMPUP
    {{"nested"},'not kps.rampUp', {
        {spells.schism, 'not player.isMoving and heal.countLossAtonementInRange(0.80) > 2 and spells.powerWordRadiance.lastCasted(9)' , "target" },
        {spells.mindBlast, 'not player.isMoving and heal.countLossAtonementInRange(0.80) > 2' , "target" },
        {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.80) > heal.countLossAtonementInRange(0.80) and spells.powerWordRadiance.charges == 2' ,  kps.heal.lowestInRaid  },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
        {spells.penance, 'true' , env.damageTarget  },
        {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp > 0.70' , env.damageTarget },
        {spells.smite, 'not player.isMoving and heal.lowestInRaid.myBuffDuration(spells.atonement) > 2' , env.damageTarget },
    }},
    -- TARGETTARGET
    {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.80 and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("targettarget") and not spells.shadowMend.lastCasted(2)' , "targettarget" },
    {spells.powerWordShield, 'targettarget.hp < 0.80 and targettarget.isFriend and targettarget.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" },
    {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.40' , "targettarget" },
    -- LOWEST
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.50 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit) and not spells.shadowMend.lastCasted(2)' , kps.heal.lowestInRaid , "shadowMend_lowest_atonement" },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.50 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordShield.isRecastAt(heal.lowestInRaid.unit) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "shield_lowest_atonement" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid , "shadowMend_lowest_urg" },
    -- DAMAGE
    {spells.mindSear, 'not kps.rampUp and not player.isMoving and player.plateCount > 3' , env.damageTarget },
    {spells.smite, 'not kps.rampUp and not player.isMoving' , env.damageTarget },
    {spells.holyNova, 'player.isMoving and target.distanceMax  <= 10' },

}
,"priest_discipline_Shadowlands")


-- MACRO --
--[[

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Châtiment

#showtooltip Pénitence
/cast [@mouseover,exists,nodead,help] Mot de pouvoir : Bouclier; [@mouseover,exists,nodead,harm] Pénitence

]]--