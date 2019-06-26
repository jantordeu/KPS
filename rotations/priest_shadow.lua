--[[[
@module Priest Shadow Rotation
@author htordeux
@version 8.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local Dispersion = spells.dispersion.name
local MassDispel = spells.massDispel.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "mindControl ", "Interface\\Icons\\Priest_spell_leapoffaith_a", "mindControl ")
end)

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "mindSear", "Interface\\Icons\\spell_shadow_mindshear", "mindSear")
end)


kps.rotations.register("PRIEST","SHADOW",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },

    {{"macro"}, 'FocusMouseoverShadow()' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --{{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.40' },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.995' , "/cancelaura "..Dispersion },
    --"Fade" 586
    {spells.fade, 'player.isTarget' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.65', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.65', "player" },
     -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.55' },
    
    -- BUTTON
    --{spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },
    --{spells.mindControl, 'keys.alt and target.isAttackable and not target.hasMyDebuff(spells.mindControl) and target.myDebuffDuration(spells.mindControl) < 2' , "target" },
   
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        -- "Silence" 15487 -- debuff same ID
        {spells.psychicHorror, 'player.hasTalent(4,3) and mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.psychicScream, 'not player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Mind Bomb" 205369 -- 30 yd range -- debuff "Explosion mentale" 226943 -- replace cri Psychic Scream
        {spells.mindBomb, 'player.hasTalent(4,2) and player.isTarget and target.distance <= 30 and target.isCasting' , "target" },
        -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    }},
    {spells.arcaneTorrent, 'player.timeInCombat > 30 and mouseover.isAttackable and mouseover.distance <= 10' , "target" },
    {spells.arcaneTorrent, 'player.timeInCombat > 30 and target.isAttackable and target.distance <= 10' , "target" },

    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , "/use 13"},
    {{"macro"}, 'not player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.85' , "/use [@player] 14" },

    {spells.voidEruption, 'not player.isMoving and player.hasTalent(7,1) and player.insanity >= 60' , env.damageTarget , "voidEruption_60" },
    {spells.voidEruption, 'not player.isMoving and not player.hasTalent(7,1) and player.insanity >= 90' , env.damageTarget , "voidEruption_90"  },
    {spells.darkAscension, 'player.hasTalent(7,2) and not player.hasBuff(spells.voidForm) and player.insanity <= 60', env.damageTarget },
    --{{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and spells.mindFlay.cooldownTotal == 0 and player.isCastingSpell(spells.mindFlay)' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidEruption.cooldown == 0 and spells.mindSear.cooldownTotal == 0 and player.isCastingSpell(spells.mindSear)' , "/stopcasting" },
    {spells.voidEruption, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt" },
    
    {spells.shadowfiend, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , env.damageTarget },
    {spells.mindbender, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , env.damageTarget },
    {spells.shadowCrash, 'player.hasTalent(5,3) and target.isAttackable' },
    --{spells.shadowWordDeath, 'player.hasTalent(5,2) and target.hp < 0.20' , "target" },
    {spells.concentratedFlame, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , env.damageTarget },

    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.vampiricTouch) == 27.3 -- duration(21) + 30% (6.3) -- 70% (14.7)
    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.shadowWordPain) == 20.8 -- duration(16) + 30% (4.8) -- 70% (11.2)
    {spells.shadowWordPain, 'player.isMoving and target.myDebuffDuration(spells.shadowWordPain) < 16.8' , "target" },
    {spells.shadowWordPain, 'player.isMoving and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 16.8' , "focus" },
    {spells.shadowWordPain, 'player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 16.8' , "mouseover" },

    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.levitate)' , "player" },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },
    {spells.shadowMend, 'kps.defensive and not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    {spells.powerWordShield, 'player.isMovingSince(1.2) and player.mana > 0.60 and player.insanity < 0.60 and not player.hasBuff(spells.voidForm) and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid , "SCHIELD_MOVING_lowest" },
    {spells.powerWordShield, 'kps.defensive and heal.lowestTankInRaid.isMovingTimer(1.4) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' ,  kps.heal.lowestTankInRaid },

    {{"nested"}, 'not player.hasBuff(spells.voidForm)',{
        {spells.darkVoid, 'kps.multiTarget and not player.isMoving and player.hasTalent(3,3)' , env.damageTarget , "darkVoid" },
        {spells.mindBlast, 'not player.isMoving and spells.mindBlast.charges == 2' , env.damageTarget },
        {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
        {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4.8' , "target" },
        {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
        {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8' , "mouseover" },
        {spells.vampiricTouch, 'focus.isAttackable and not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
        {spells.shadowWordPain, 'focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8' , 'focus' },
        {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    }},

    {{spells.vampiricTouch,spells.shadowWordPain}, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4.8' , "target" },

    {spells.mindSear, 'kps.mindSear and not player.isMoving' , env.damageTarget },

    {{spells.vampiricTouch,spells.shadowWordPain}, 'not player.isMoving and focus.isAttackable and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.vampiricTouch.isRecastAt("focus")' , "focus" },
    {spells.vampiricTouch, 'focus.isAttackable and not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("focus")' , "focus"  },
    {spells.shadowWordPain, 'focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8' , "focus"  },

    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.voidForm) and player.plateCount < 4' , env.damageTarget },
    {spells.mindSear, 'kps.multiTarget not player.isMoving and player.hasBuff(spells.voidForm) and player.plateCount >= 4 and focus.myDebuffDuration(spells.vampiricTouch) > 6.3 and focus.myDebuffDuration(spells.shadowWordPain) > 4.8' , env.damageTarget },

    {{spells.vampiricTouch,spells.shadowWordPain}, 'mouseover.inCombat and mouseover.isAttackable and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },    
    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8' , "mouseover" },

    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount >= 4' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount >= 3' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_bfa")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]