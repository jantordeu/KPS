--[[[
@module Priest Shadow Rotation
@author htordeux
@version 8.0.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local Dispersion = spells.dispersion.name
local MassDispel = spells.massDispel.name
local ShadowCrash = spells.shadowCrash.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "control", "Interface\\Icons\\spell_nature_polymorph", "control")
end)

kps.rotations.register("PRIEST","SHADOW",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.FocusMouseoverShadow,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    --{{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.40' },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.995' , "/cancelaura "..Dispersion },
    --"Fade" 586
    {spells.fade, 'player.isTarget' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.72', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.72', "player" },
     -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.65' },
   
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        -- "Silence" 15487 -- debuff same ID
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 1' , "target" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 1' , "target" },
        {spells.psychicScream, 'not player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Mind Bomb" 205369 -- 30 yd range -- debuff "Explosion mentale" 226943 -- replace cri Psychic Scream
        {spells.mindBomb, 'player.hasTalent(4,2) and player.isTarget and target.distance <= 30 and target.isCasting' , "target" },
        --{spells.mindBomb, 'player.hasTalent(4,2) and not target.isControlled and target.distance <= 30' , "target" },
    }},
    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    {spells.arcaneTorrent, 'player.timeInCombat > 9 and target.isAttackable and target.distance <= 10' , "target" },

    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},
    {spells.mindControl, 'kps.control and focus.isAttackable and not focus.hasMyDebuff(spells.mindControl) and focus.myDebuffDuration(spells.mindControl) < 2' , "focus" },

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , "/use 13"},
    {{"macro"}, 'not player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , "/use 14"},
    {{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and not player.hasBuff(spells.voidForm) and player.timeInCombat > 30' , "/use [@player] 14" },

    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    {spells.levitate, 'player.isSwimming and not player.hasBuff(spells.levitate)' , "player" },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
     -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },

    --{{"macro"}, 'player.hasTalent(5,3) and mouseover.isAttackable', "/cast [@cursor] "..ShadowCrash },
    --{spells.shadowWordDeath, 'player.hasTalent(5,2) and target.hp < 0.20 and target.isAttackable' , "target" },

    --{{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and spells.mindFlay.cooldownTotal == 0 and player.isCastingSpell(spells.mindFlay)' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and spells.mindSear.cooldownTotal == 0 and player.isCastingSpell(spells.mindSear) and player.plateCount <= 3' , "/stopcasting" },
    {spells.voidBolt , 'player.hasBuff(spells.voidForm)' , env.damageTarget },
    {spells.shadowfiend, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , env.damageTarget },
    {spells.mindbender, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 9' , env.damageTarget },

    {spells.darkVoid, 'not player.isMoving and player.hasTalent(3,3) and not player.hasBuff(spells.voidForm) ' , env.damageTarget , "darkVoid" },
    --{spells.darkVoid, 'not player.isMoving and player.hasTalent(3,3) and player.plateCount >= 5 and player.plateCountDebuff(spells.shadowWordPain)*2 < player.plateCount' , env.damageTarget , "darkVoid" },
    {spells.mindBlast, 'not player.hasBuff(spells.voidForm) and not player.isMoving and not spells.voidEruption.isUsable' , env.damageTarget },
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and target.isAttackable and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4.8 and target.isAttackable' , "target" },

    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.vampiricTouch) == 27.3 -- duration(21) + 30% (6.3)
    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.shadowWordPain) == 20.8 -- duration(16) + 30% (4.8)
    {spells.shadowWordPain, 'player.isMoving and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 11.2' , "target" },
    {spells.shadowWordPain, 'player.isMoving and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 11.2' , "focus" },
    {spells.shadowWordPain, 'player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 11.2' , "mouseover" },

    {spells.darkAscension, 'player.hasTalent(7,2) and not player.hasBuff(spells.voidForm) and player.insanity < 90' , "target" , "darkAscension" },
    {spells.voidEruption, 'not player.isMoving and spells.voidEruption.isUsable and not player.hasBuff(spells.voidForm)' , "target" , "insanity_usable" },

    {spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and focus.isAttackable and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
    {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and focus.isAttackable' , 'focus' },

    {spells.mindBlast, 'not player.isMoving and player.plateCount <= 3' , env.damageTarget },
    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount >= 3' , env.damageTarget },

    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("mouseover")' , 'mouseover' },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8' , 'mouseover' },

    {spells.shadowMend, 'kps.defensive and not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
    --{{"macro"}, 'spells.mindBlast.cooldown == 0 and spells.mindFlay.cooldownTotal == 0 and player.isCastingSpell(spells.mindFlay)' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_bfa")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]