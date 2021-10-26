--[[[
@module Priest Shadow Rotation
@author htordeux
@version 9.0.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local Dispersion = spells.dispersion.name
local MassDispel = spells.massDispel.name
local ShadowCrash = spells.shadowCrash.name
local DoorOfShadows = spells.doorOfShadows.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "mindSear", "Interface\\Icons\\spell_shadow_mindshear", "mindSear")
end)


kps.rotations.register("PRIEST","SHADOW",
{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Shadow Crash"
    {{"macro"}, 'keys.shift and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    {{"macro"}, 'mouseover.inCombat and mouseover.isAttackable and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isFriend', "mouseover" },
    {spells.fade, 'player.isTarget and player.isInGroup' },
    {spells.desperatePrayer, 'player.hp < 0.60' , "player" },
    --{{"macro"}, 'player.hp < 0.60 and player.useItem(5512)' , "/use item:5512" },
    -- "Dispersion" 47585
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.90' , "/cancelaura "..Dispersion },
    {spells.dispersion, 'player.hp < 0.30' },
    -- PVP
    {spells.psyfiend, 'player.isTarget and player.isPVP' , "player" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.countLossInRange(0.80) > 4' },
    {spells.vampiricEmbrace, 'kps.groupSize() == 1 and player.hp < 0.50' },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.50 and not spells.shadowMend.isRecastAt("mouseover") and not player.isInRaid' , "mouseover" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.70 and not spells.shadowMend.isRecastAt("player") and not spells.shadowMend.lastCasted(9) and not player.isInRaid' , "player" },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.50 and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    -- guardianFaerie -- buff Reduces damage taken by 20%. Follows your Power Word: Shield.
    {spells.powerWordShield, 'targettarget.isFriend and targettarget.hp < 0.70 and target.hasMyDebuff(spells.wrathfulFaerie) and not targettarget.hasBuff(spells.guardianFaerie) and not targettarget.hasDebuff(spells.weakenedSoul)' , "targettarget" },
    -- benevolentFaerie -- buff Increases the cooldown recovery rate of your target's major ability by 100%. Follows your Flash Heal (holy) Shadow Mend (shadow,disc)
    -- wrathfulFaerie -- debuff target -- Any direct attacks against the target restore 0.5% Mana or 3 Insanity. Follows your Shadow Word: Pain
    {spells.faeGuardians, 'target.isAttackable and kps.timeInCombat < 19 and not target.hasMyDebuff(spells.wrathfulFaerie) and player.hasBuff(spells.voidForm) and spells.shadowfiend.cooldown > 2' , "target" },
    {spells.faeGuardians, 'target.isAttackable and kps.timeInCombat > 19 and not target.hasMyDebuff(spells.wrathfulFaerie) and not player.hasBuff(spells.voidForm) and spells.voidEruption.cooldown > 9' , "target" },
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.psychicHorror, 'player.hasTalent(4,3) and mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,2) and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.mindBomb, 'player.hasTalent(4,2) and player.isTarget and target.distanceMax  <= 30 and target.isCasting and target.castTimeLeft < 2' , "target" },
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },
    }},
    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving and kps.timeInCombat > 5' , "/use 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and targettarget.isHealable and targettarget.hp < 0.80' , "/use [@targettarget] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and not player.isMoving and kps.timeInCombat > 30' , "/use 14" },

    {spells.shadowfiend, 'player.hasBuff(spells.voidForm)' , env.damageTarget },
    {spells.powerInfusion, 'kps.multiTarget and not player.isMoving and player.hasBuff(spells.voidForm)' },
    {spells.powerInfusion, 'kps.multiTarget and not player.isMoving and spells.voidEruption.cooldown > 29' },
    {{"macro"}, 'player.hasBuff(spells.dissonantEchoes) and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.dissonantEchoes) and player.isCastingSpell(spells.mindSear) and spells.mindSear.cooldown == 0' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.dissonantEchoes)' , env.damageTarget , "voidBolt_dissonantEchoes"  },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear) and spells.mindSear.cooldown == 0' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt_voidForm" },

    {spells.searingNightmare, 'kps.mindSear and player.hasTalent(3,3) and player.isCastingSpell(spells.mindSear)' , "target" , "searingNightmare" },
    {{"macro"}, 'player.insanity > 85 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.devouringPlague, 'player.insanity > 85' , env.damageTarget },
    {{"macro"}, 'player.insanity < 30 and player.isCastingSpell(spells.mindSear)' , "/stopcasting" },
    {spells.mindSear, 'kps.mindSear and not player.isMoving and player.hasTalent(3,3) and player.insanity >= 30 and target.myDebuffDuration(spells.vampiricTouch) > 7' , env.damageTarget , "mindSear_mindSear" },

    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.50' , "mouseover" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.50' , "target" },
    {spells.shadowWordDeath, 'IsEquippedItem(173244) and player.hasBuff(spells.voidForm) and player.hp > 0.50' , env.damageTarget },

    {{"macro"}, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 7 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },      
    {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 7 and not spells.vampiricTouch.isRecastAt("target")' , "target" },    
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("target")' , "target"  },
    {spells.mindBlast, 'not player.isMoving and spells.mindBlast.charges == 2' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving and IsEquippedItem(173244) and player.hasBuff(spells.voidForm)' , env.damageTarget },
    {{"macro"}, 'spells.mindBlast.cooldown == 0 and player.hasBuff(spells.talbadarStratagem) and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.talbadarStratagem)' , env.damageTarget , "mindBlast_talbadar" },
    {{"macro"}, 'player.hasBuff(spells.mindDevourer) and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.devouringPlague, 'player.hasBuff(spells.mindDevourer)' , env.damageTarget },

    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 7 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover"   },
    {spells.voidEruption, 'kps.multiTarget and not player.isMoving and not player.hasBuff(spells.voidForm) and spells.mindBlast.cooldown > 0' },
    {spells.devouringPlague, 'true' , env.damageTarget },
    {spells.mindBlast, 'player.hasBuff(spells.darkThoughts) and player.isCastingSpell(spells.mindFlay)' , env.damageTarget , 'mindBlast_darkThoughts' },
    {spells.shadowWordPain, 'player.isMoving and target.isAttackable' , "target"  , "shadowWordPain_moving"  },
    {spells.shadowWordPain, 'player.isMoving and mouseover.inCombat and mouseover.isAttackable' , "mouseover" , "shadowWordPain_moving"  },
    {spells.voidTorrent, 'not player.isMoving and player.insanity <= 40 and not player.hasBuff(spells.voidForm)' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay) and target.myDebuffDuration(spells.vampiricTouch) > 5' , env.damageTarget },

},"priest_shadow_shadowlands")