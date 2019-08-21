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
   
    {spells.painSuppression, 'focus.isHealable and focus.hp < 0.55 and spells.penance.cooldown > 4' , "focus" },
    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.55 and spells.penance.cooldown > 4' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.55 and spells.penance.cooldown > 4' , "player"},
    {spells.painSuppression, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},

    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },   
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
    {{"macro"}, 'player.useTrinket(0) and heal.lowestInRaid.hp < 0.65' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and not player.isInGroup' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'not player.isMoving and player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.65' , "/use [@player] 14" },
    {{"macro"}, 'not player.isMoving and not player.hasTrinket(1) == 165569 and player.useTrinket(1) and spells.schism.lastCasted(7)' , "/use 14" },
    
    -- GROUPHEAL
    -- heal.lossHealthRaid` - Returns the loss Health for all raid members
    -- heal.lossHealthRaidAtonement - Returns the loss Health for all raid members with buff atonement
    -- heal.hasBuffCount(spells.atonement)
    -- heal.hasNotBuffAtonementCount(0.80) -- count unit below 0.80 health without atonement buff
    -- heal.hasBuffAtonementCount(0.80) -- count unit below 0.80 health with atonement buff
    -- heal.countLossInRange(0.80) -- count unit below 0.80 health
    -- heal.countInRange -- count unit inrange
    -- heal.hasNotBuffAtonement.hp < 0.90 -- UNIT with lowest health without Atonement Buff on raid -- default "player" 
    -- heal.hasBuffAtonement.hp < 0.90 - UNIT with lowest health with Atonement Buff on raid e.g. -- default "player"

    {spells.shadowWordPain,'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")', "target" , "pain_mouseover"},
    {spells.purgeTheWicked,'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")', "target" , "pain_mouseover"},
    {spells.mindbender, 'player.hasTalent(3,2) and spells.powerWordRadiance.lastCasted(5)' , env.damageTarget },
    {spells.shadowfiend, 'not player.hasTalent(3,2) and spells.powerWordRadiance.lastCasted(5)' , env.damageTarget },
    
    {{"nested"}, 'kps.defensive' , {
        {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "powerWordShield_tank" },
        {spells.powerWordRadiance, 'not player.isMoving and player.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player" },
        {spells.powerWordRadiance, 'not player.isMoving and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },
        {spells.evangelism },
        {spells.overchargeMana },
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3)' , env.damageTarget },
        {spells.penance, 'true' , env.damageTarget },
        {spells.powerWordSolace, 'true' , env.damageTarget },
        {spells.shadowWordPain,'mouseovertarget.isAttackable and not player.hasTalent(6,1) and mouseovertarget.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseovertarget")', "mouseovertarget" , "pain_mouseovertarget"},
    	{spells.purgeTheWicked,'mouseovertarget.isAttackable and player.hasTalent(6,1) and mouseovertarget.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseovertarget")', "mouseovertarget" , "pain_mouseovertarget"},
        {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},
    
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.85) >= 3 and target.distance <= 10' , "target" },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) >= 3' },
    {spells.shadowCovenant, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) >= 3' , kps.heal.lowestInRaid },
    {spells.luminousBarrier, 'player.hasTalent(7,2) and heal.countLossInRange(0.80)*2 > heal.countInRange' },

    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {{spells.powerWordShield,spells.shadowMend}, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
        {{spells.powerWordShield,spells.penance}, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < 0.80' , "player" },
        {spells.powerWordShield, 'targettarget.isHealable and not targettarget.hasBuff(spells.powerWordShield) and targettarget.hp < 0.80' , "targettarget" },
        {spells.powerWordShield, 'not heal.lowestUnitInRaid.hasBuff(spells.powerWordShield) and heal.lowestUnitInRaid.hp < 0.65' , kps.heal.lowestUnitInRaid },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" }, 
    }},
    {spells.rapture, 'heal.hasNotBuffAtonementCount(0.65) >= 3 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    
    --AZERITE
    {spells.concentratedFlame, 'heal.lossHealthRaidAtonement > 0' , kps.heal.lowestInRaid },
    {spells.memoryOfLucidDreams, 'heal.lossHealthRaidAtonement > 0' , kps.heal.lowestInRaid },
    {spells.overchargeMana,'heal.hasBuffAtonementCount(0.90) >= 5 and spells.powerWordRadiance.lastCasted(5)' , kps.heal.lowestInRaid },
    {spells.evangelism, 'player.hasTalent(7,3) and heal.hasBuffAtonementCount(0.90) >= 5 and spells.powerWordRadiance.lastCasted(5)' },
    -- RADIANCE
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "radiance_tank" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and player.myBuffDuration(spells.atonement) < 2 and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) >= 3 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.90) >= 5 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },

    -- TANK
    {spells.penance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2 and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "penance_defensive_tank" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "powerWordShield_tank" },
    -- FOCUS
    {spells.shadowMend, 'not player.isMoving and focus.isHealable and focus.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("focus")' , "focus" , "shadowMend_focus" },
    {spells.powerWordShield, 'focus.isHealable and focus.myBuffDuration(spells.atonement) < 2 and not focus.hasDebuff(spells.weakenedSoul)' , "focus", "powerWordShield_focus" },
    -- PLAYER
    {spells.penance, 'player.myBuffDuration(spells.atonement) > 2 and player.hp < 0.40' , "player"  , "penance_defensive_player" },
    {spells.shadowMend, 'not player.isMoving and player.hp <  0.85 and player.myBuffDuration(spells.atonement) < 2' , "player" , "shadowMend_player" },
    {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and player.hp < 0.85 and not player.hasDebuff(spells.weakenedSoul)' , "player" , "powerWordShield_player" },

    {spells.schism, 'not player.isMoving and heal.hasBuffAtonementCount(0.80) >= 3' , env.damageTarget , "hasBuffAtonementCount" },
    {spells.schism, 'not player.isMoving and heal.hasBuffAtonementCount(0.65) >= 1' , env.damageTarget , "hasBuffAtonementCount" },
    {spells.powerWordSolace, 'spells.shadowMend.lastCasted(5) and heal.hasBuffAtonementCount(0.90) >= 1' , env.damageTarget , "solace_shadowMend_lastCasted" },
    {spells.penance, 'spells.shadowMend.lastCasted(5) and heal.hasBuffAtonementCount(0.80) >= 1' , env.damageTarget , "penance_shadowMend_lastCasted" },

    {spells.holyNova, 'player.hasBuff(spells.suddenRevelation)' },
    {spells.holyNova, 'kps.holyNova and target.distance <= 10' },
    
    -- NOT ISINGROUP -- not player.isInGroup
    {{"nested"}, 'kps.multiTarget' , {
        {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 2 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'focus.isFriend and focus.myBuffDuration(spells.atonement) < 2 and focus.hp < 0.85 and not focus.hasDebuff(spells.weakenedSoul)' , "focus" },
        {spells.powerWordShield, 'mouseover.isFriend and mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.85 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" },
        {spells.powerWordShield, 'targettarget.isFriend and targettarget.hp < 0.85 and targettarget.myBuffDuration(spells.atonement) < 2 and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" , "powerWordShield_targettarget" },

        {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("focus")' , "focus" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("focus")' , "focus" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },

        {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.65 and not spells.shadowMend.isRecastAt("player")' , "player" },
        {spells.shadowMend, 'not player.isMoving and focus.isFriend and focus.hp < 0.65 and not spells.shadowMend.isRecastAt("focus")' , "focus" },
        {spells.shadowMend, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.65 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.65 and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" },

        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and target.isAttackable and spells.powerWordSolace.cooldown < 7' , "target" },
        {spells.schism, 'not player.isMoving and player.hasTalent(1,3) and target.isAttackable and spells.penance.cooldown < 7' , "target" },
        {spells.powerWordSolace, 'player.hasTalent(3,3) and target.isAttackable' , "target" },
        {spells.penance, 'target.isAttackable' , "target" },
        {spells.mindbender, 'player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(3,2) and target.isAttackable' , "target" },
        {spells.smite, 'not player.isMoving and target.isAttackable' , "target" },
    }},

    -- MOUSEOVER HEALABLE
    {{"nested"}, 'mouseover.isHealable' , {
    {spells.shadowWordPain,'mouseovertarget.isAttackable and not player.hasTalent(6,1) and mouseovertarget.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseovertarget")', "mouseovertarget" , "pain_mouseovertarget"},
    {spells.purgeTheWicked,'mouseovertarget.isAttackable and player.hasTalent(6,1) and mouseovertarget.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseovertarget")', "mouseovertarget" , "pain_mouseovertarget"},
    {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.80 and mouseover.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.myBuffDuration(spells.atonement) < 2 and mouseover.hp < 0.90 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover" },
    {spells.powerWordSolace, 'mouseovertarget.isAttackable and mouseover.myBuffDuration(spells.atonement) > 2 and mouseover.hp < 0.90' , "mouseovertarget" , "solace_mouseovertarget" },
    {spells.penance, 'mouseovertarget.isAttackable and mouseover.myBuffDuration(spells.atonement) > 2 and mouseover.hp < 0.80' , "mouseovertarget" , "penance_mouseovertarget" },
    {spells.shadowMend, 'not player.isMoving and mouseover.hp < 0.40' , "mouseover" , "shadowMend_mouseover_lowhp"},
    {spells.smite, 'not player.isMoving and mouseovertarget.isAttackable and mouseover.myBuffDuration(spells.atonement) > 2' , "mouseovertarget" , "smite_mouseovertarget" },
    {spells.powerWordShield, 'mouseover.hp < 0.40 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover_lowhp" },
    }},

    -- MOUSEOVER ATTACKABLE
    {{"nested"}, 'mouseover.isAttackable and mouseover.inCombat' , {    
    {spells.purgeTheWicked,'player.hasTalent(6,1) and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")', "mouseover" , "pain_mouseover"},
    {spells.shadowWordPain,'player.hasTalent(6,1) and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")', "mouseover" , "pain_mouseover"},    
    {spells.shadowMend, 'not player.isMoving and mouseovertarget.isHealable and mouseovertarget.hp < 0.80 and mouseovertarget.myBuffDuration(spells.atonement) < 2 and not spells.shadowMend.isRecastAt("mouseovertarget")' , "mouseovertarget" , "shadowMend_mouseovertarget"},
    {spells.powerWordShield, 'mouseovertarget.isHealable and mouseovertarget.hp < 0.90 and mouseovertarget.myBuffDuration(spells.atonement) < 2  and not mouseovertarget.hasDebuff(spells.weakenedSoul)' , "mouseovertarget" , "powerWordShield_mouseovertarget" },
    {spells.powerWordSolace, 'mouseovertarget.myBuffDuration(spells.atonement) > 2 and mouseovertarget.hp < 0.90', "mouseover" , "solace_mouseover"},
    {spells.penance, 'mouseovertarget.myBuffDuration(spells.atonement) > 2 and mouseovertarget.hp < 0.80', "mouseover" , "penance_offensive_mouseover"},
    {spells.shadowMend, 'not player.isMoving and mouseovertarget.isHealable and mouseovertarget.hp < 0.40' , "mouseovertarget" , "shadowMend_mouseovertarget_lowhp"},
    {spells.smite, 'not player.isMoving and mouseovertarget.myBuffDuration(spells.atonement) > 2', "mouseover" , "smite_mouseover"},
    {spells.powerWordShield, 'mouseovertarget.isHealable and mouseovertarget.hp < 0.40 and not mouseovertarget.hasDebuff(spells.weakenedSoul)' , "mouseovertarget" , "powerWordShield_mouseovertarget_lowhp" },
    }},    

    {spells.powerWordSolace, 'heal.hasBuffAtonementCount(0.90) >= 1' , env.damageTarget , "hasNotBuffAtonementCount" },
    {spells.smite, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.90) == 0' , env.damageTarget , "hasNotBuffAtonementCount" },
    {spells.penance, 'heal.hasBuffAtonementCount(0.80) >= 1' , env.damageTarget , "hasNotBuffAtonementCount" },    
    {spells.smite, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) == 0' , env.damageTarget , "hasNotBuffAtonementCount" },
    {spells.shadowMend, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) == 1 and not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "shadowMend_lhasNotBuffAtonement" },
    {spells.powerWordShield, 'heal.hasNotBuffAtonementCount(0.80) == 1 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "powerWordShield_hasNotBuffAtonement" },

    -- EMERGENCY
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" , "shadowMend_player" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK" },

    {spells.holyNova, 'player.isMoving and heal.countLossInDistance(0.85,10) >= 3' },
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