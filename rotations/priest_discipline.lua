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

    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.55 and spells.penance.cooldown > 4' , kps.heal.lowestTankInRaid},
    {spells.painSuppression, 'player.hp < 0.55 and spells.penance.cooldown > 4' , "player"},
    {spells.painSuppression, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},

    {{"nested"}, 'kps.interrupt' ,{
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(7)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(7)' , "mouseover" },   
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

    --AZERITE
    {spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    -- "Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
    {spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    {spells.azerite.memoryOfLucidDreams, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    -- "Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
    -- MANUAL --{spells.azerite.overchargeMana , 'spells.powerWordRadiance.charges > 0 and spells.schism.cooldown < 9 and heal.countLossInRange(0.85)*2 > heal.countInRange' },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and heal.countLossInRange(0.80) > 2' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.hasTrinket(1) == 160649 and player.useTrinket(1) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.65' , "/use [@player] 14" },
    {{"macro"}, 'player.hasTrinket(1) == 168905 and player.useTrinket(1) and target.hasDebuff(spells.shiverVenom)' , "/use 14" },
    --{{"macro"}, 'player.useTrinket(1) and spells.schism.lastCasted(7)' , "/use 14" },

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

    {{"nested"}, 'player.hasBuff(spells.rapture)' , {
        {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < 0.85' , "player" },
        {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield) and heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasBuff(spells.powerWordShield) and mouseover.hp < 0.85' , "mouseover" }, 
        {spells.powerWordShield, 'heal.hasNotBuffAtonement.hp < 0.85 and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement },
    }},

    -- TANK
    {spells.penance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) > 2 and not heal.lowestTankInRaid.isUnit("player") and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  , "penance_defensive_tank" },
    {spells.shadowMend, 'not player.isMoving and not heal.lowestTankInRaid.isUnit("player") and not heal.lowestTankInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "shadowMend_tank" },
    {spells.powerWordShield, 'not heal.lowestTankInRaid.isUnit("player") not heal.lowestTankInRaid.hasMyBuff(spells.atonement) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit) and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "powerWordShield_tank" },
    -- PLAYER
    {spells.penance, 'player.myBuffDuration(spells.atonement) > 2 and player.hp < 0.40' , "player"  , "penance_defensive_player" },
    {spells.shadowMend, 'not player.isMoving and not player.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "shadowMend_player" },
    {spells.powerWordShield, 'not player.hasMyBuff(spells.atonement) and not player.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt("player") and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "powerWordShield_player" },

    -- RADIANCE
    {{"nested"}, 'spells.powerWordRadiance.lastCasted(9)' , {
        {spells.evangelism, 'spells.powerWordRadiance.charges == 0 and heal.hasBuffAtonementCount(0.82) > 3' },
        {spells.schism, 'not player.isMoving and heal.hasBuffAtonementCount(0.82) > 3' , env.damageTarget },
        {spells.mindbender, 'player.hasTalent(3,2) and heal.hasBuffAtonementCount(0.82) > 3' , env.damageTarget },
        {spells.shadowfiend, 'not player.hasTalent(3,2) and heal.hasBuffAtonementCount(0.82) > 3' , env.damageTarget }, 
        {spells.penance, 'true' , env.damageTarget  },
        {spells.powerWordSolace, 'true' , env.damageTarget  },
    }},
    {spells.powerWordRadiance, 'not player.isMoving and mouseover.isHealable and heal.hasNotBuffAtonementCount(0.82) > 3 and not spells.powerWordRadiance.isRecastAt("mouseover")' , "mouseover" , "radiance_mouseover" },  
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.82) > 3 and not heal.hasNotBuffAtonement.isUnit("player") and not spells.powerWordRadiance.isRecastAt("heal.hasNotBuffAtonement.unit")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },
    {spells.powerWordRadiance, 'kps.multiTarget and not player.isMoving and not heal.hasNotBuffAtonement.isUnit("player") and not spells.powerWordRadiance.isRecastAt("heal.hasNotBuffAtonement.unit")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement" },

    -- RAPTURE MANUAL
    {spells.rapture, 'heal.hasNotBuffAtonementCount(0.65) > 3 and spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.cooldown > 4 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    {spells.rapture, 'heal.lowestTankInRaid.hp < 0.40 and spells.painSuppression.cooldown > 0 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },
    {spells.rapture, 'player.hp < 0.40 and spells.painSuppression.cooldown > 0 and spells.penance.cooldown > 4 and spells.schism.cooldown > 4' },

    {spells.holyNova, 'player.hasBuff(spells.suddenRevelation)' },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) > 4' , kps.heal.lowestInRaid },
    {spells.shadowCovenant, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) > 3' , kps.heal.lowestInRaid },
    {spells.luminousBarrier, 'player.hasTalent(7,2) and heal.countLossInRange(0.80) > 4' },

    -- NOT ISINGROUP
    {{"nested"}, 'kps.defensive' , {
        {spells.shadowMend, 'not player.isMoving and not player.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("player")' , "player" , "shadowMend_player_def"  },
        {spells.powerWordShield, 'not player.hasMyBuff(spells.atonement) and not player.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt("player")' , "powerWordShield_player_def" },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and not targettarget.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" , "shadowMend_targettarget" },
        {spells.powerWordShield, 'targettarget.isFriend and targettarget.hp < 0.90 and not targettarget.hasMyBuff(spells.atonement) and not targettarget.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt("targettarget")' , "targettarget" , "powerWordShield_targettarget" },

        {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("focus")' , "focus" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("focus")' , "focus" },
        {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },

        {spells.holyNova, 'kps.holyNova and target.distance <= 10' },
        {spells.schism, 'not player.isMoving and spells.powerWordSolace.cooldown < 7' , env.damageTarget },
        {spells.schism, 'not player.isMoving and spells.penance.cooldown < 7' , env.damageTarget },
        {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 20' , "target" },
        {spells.powerWordSolace, 'true' , env.damageTarget },
        {spells.penance, 'true' , env.damageTarget },
        {spells.mindbender, 'player.hasTalent(3,2)' , env.damageTarget },
        {spells.shadowfiend, 'not player.hasTalent(3,2)' , env.damageTarget },
        {spells.holyNova, 'player.isMoving and target.distance <= 10' },
        {spells.shadowMend, 'not player.isMoving and player.hp < 0.40' , "player" },
        {spells.shadowMend, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.40' , "targettarget" },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},

--    {{"nested"}, 'player.hasBuff(spells.azerite.overchargeMana) and spells.azerite.overchargeMana.cooldown < 23' , {
--        {spells.evangelism, 'spells.powerWordRadiance.lastCasted(7)' },
--        {spells.schism, 'not player.isMoving' , env.damageTarget , "overchargeMana" },
--        {spells.shadowWordPain,'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")', "target" , "overchargeMana" },
--        {spells.purgeTheWicked,'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")', "target" , "overchargeMana" },
--        {spells.mindbender, 'player.hasTalent(3,2)' , env.damageTarget , "overchargeMana" },
--        {spells.shadowfiend, 'not player.hasTalent(3,2)' , env.damageTarget , "overchargeMana" },
--        {spells.powerWordSolace, 'true' , env.damageTarget , "overchargeMana" },
--        {spells.penance, 'true' , env.damageTarget , "overchargeMana" },
--        {spells.smite, 'not player.isMoving' , env.damageTarget , "overchargeMana" },
--    }},
--    
--    {{"nested"}, 'player.hasBuff(spells.azerite.overchargeMana) and spells.azerite.overchargeMana.cooldown > 23' , {
--        {spells.powerWordShield, 'not heal.lowestTankInRaid.isUnit("player") and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 5 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid , "powerWordShield_tank_multiTarget" },
--        {spells.powerWordShield, 'player.myBuffDuration(spells.atonement) < 5 and not player.hasDebuff(spells.weakenedSoul)' , "player" , "powerWordShield_player_multiTarget" },
--        {spells.powerWordRadiance, 'not player.isMoving and not heal.lowestTankInRaid.hasMyBuff(spells.atonement) and not heal.lowestTankInRaid.isUnit("player") and not spells.powerWordRadiance.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "radiance_tank_multiTarget" },
--        {spells.powerWordRadiance, 'not player.isMoving and not player.hasMyBuff(spells.atonement) and not spells.powerWordRadiance.isRecastAt("player")' , "player" , "radiance_player_multiTarget" },
--        {spells.powerWordRadiance, 'not player.isMoving and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "radiance_hasNotBuffAtonement_multiTarget" },
--        {spells.powerWordShield, 'heal.hasNotBuffAtonementCount(0.80) > 0 and not heal.hasNotBuffAtonement.hasDebuff(spells.weakenedSoul) and not heal.hasNotBuffAtonement.isUnit("player")' , kps.heal.hasNotBuffAtonement , "powerWordShield_hasNotBuffAtonement_multiTarget" },
--        {spells.evangelism, 'spells.powerWordRadiance.lastCasted(7)' },
--        {spells.shadowWordPain,'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")', "target" , "multiTarget" },
--        {spells.purgeTheWicked,'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")', "target" , "multiTarget" },
--        {spells.mindbender, 'player.hasTalent(3,2)' , env.damageTarget , "multiTarget" },
--        {spells.shadowfiend, 'not player.hasTalent(3,2)' , env.damageTarget , "multiTarget" },
--    }},

    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("focus")' , "focus" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 4.8 and not spells.purgeTheWicked.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("focus")' , "focus" },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },

    {spells.penance, 'heal.hasBuffAtonementCount(0.90) > 0' , env.damageTarget , "hasBuffAtonementCount" },
    {spells.powerWordSolace, 'true' , env.damageTarget  , "hasBuffAtonementCount" },
    {spells.smite, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.80) == 0' , env.damageTarget , "hasBuffAtonementCount_80" },

    {spells.shadowMend, 'mouseover.isHealable and not player.isMoving and mouseover.hp < 0.90 and not mouseover.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "shadowMend_mouseover"},
    {spells.powerWordShield, 'mouseover.isHealable and not mouseover.hasMyBuff(spells.atonement) and mouseover.hp < 0.90 and not mouseover.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" , "powerWordShield_mouseover" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and not heal.lowestInRaid.hasMyBuff(spells.atonement) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowestInRaid"},
    {spells.powerWordShield, 'not heal.lowestInRaid.hasMyBuff(spells.atonement) and heal.lowestInRaid.hp < 0.90 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "powerWordShield_lowestInRaid" },

    -- EMERGENCY
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55' , "player" , "FLASH_PLAYER"  },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK" },

    {spells.smite, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.65) == 0' , env.damageTarget , "hasBuffAtonementCount_65" },
    {spells.shadowMend, 'not player.isMoving and heal.hasNotBuffAtonementCount(0.65) >= 1 and not heal.hasNotBuffAtonement.isUnit("player") and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "shadowMend_hasNotBuffAtonement" },    
    {spells.powerWordShield, 'heal.hasNotBuffAtonementCount(0.65) >= 1 and not heal.hasNotBuffAtonement.isUnit("player") and not heal.hasNotBuffAtonement.hasDebuff(spells.weakenedSoul) and not spells.shadowMend.isRecastAt(heal.hasNotBuffAtonement.unit)' , kps.heal.hasNotBuffAtonement , "powerWordShield_hasNotBuffAtonement" },

    {spells.powerWordShield, 'player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not mouseover.hasDebuff(spells.weakenedSoul)' , "mouseover" , "powerWordShield_mouseover_lowhp" },
    {spells.powerWordShield, 'player.isMoving and heal.lowestInRaid.hp < 0.40 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "powerWordShield_lowestInRaid_lowhp" },
    {spells.holyNova, 'player.isMoving and heal.countLossInDistance(0.85,10) > 2' },
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