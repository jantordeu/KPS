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

kps.rotations.register("PRIEST","SHADOW",{

    {spells.powerWordFortitude, 'not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    --env.FocusMouseoverShadow,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

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
        {spells.psychicScream, 'not player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and player.plateCount >= 3' , "player" },
        -- "Mind Bomb" 205369 -- 30 yd range -- debuff "Explosion mentale" 226943 -- replace cri Psychic Scream
        {spells.mindBomb, 'player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and target.isCasting' , "target" },
        {spells.mindBomb, 'player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and player.plateCount > 3 ' , "target" },
    }},
    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    -- "Purify Disease" 213634
    {spells.fireBlood, 'player.isDispellable("Magic")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Disease")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Poison")' , "player" },
    {spells.fireBlood, 'player.isDispellable("Curse")' , "player" },
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidForm)' , "/use 13"},
    {{"macro"}, 'player.useTrinket(1) and player.hasBuff(spells.voidForm)' , "/use 14"},

    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    {spells.levitate, 'player.isSwimming and not player.hasBuff(spells.levitate)' , "player" },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.65 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    {spells.powerWordShield, 'player.hp < 0.40 and not player.hasBuff(spells.powerWordShield) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
     -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not spells.shadowMend.isRecastAt("player")' , "player" },
    --{spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.55 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
    
    {{"macro"}, 'player.hasTalent(5,3) and mouseover.isAttackable', "/cast [@cursor] "..ShadowCrash },
    {spells.shadowWordDeath, 'player.hasTalent(5,2) and target.hp < 0.20 and target.isAttackable' , "target" },
    {{"nested"}, 'not player.hasBuff(spells.voidForm) and not player.isMoving and not spells.voidEruption.isUsable',{
        {spells.darkVoid, 'player.hasTalent(3,3)' , env.damageTarget , "darkVoid" },
        {{"macro"}, 'spells.mindBlast.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > kps.gcd and spells.mindFlay.cooldownTotal == 0' , "/stopcasting" },
        {spells.mindBlast, 'true' , env.damageTarget },
    }},

    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > kps.gcd and spells.mindFlay.cooldownTotal == 0' , "/stopcasting" },
    {spells.voidBolt , "player.hasBuff(spells.voidForm)" , env.damageTarget },
    {spells.shadowfiend, 'target.isAttackable and player.buffStacks(spells.voidForm) > 5' , env.damageTarget },
    {spells.mindbender, 'target.isAttackable and player.buffStacks(spells.voidForm) > 5' , env.damageTarget }, 

    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and target.isAttackable and not spells.vampiricTouch.isRecastAt("target")' , env.damageTarget },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4.8 and target.isAttackable' , env.damageTarget },

    {spells.darkAscension, 'player.hasTalent(7,2) and not player.hasBuff(spells.voidForm) and player.insanity > 50 and player.insanity < 90' , "target" , "darkAscension" },
    {spells.voidEruption, 'spells.voidEruption.isUsable and not player.hasBuff(spells.voidForm)' , "target" , "insanity_usable" },

    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount > 4' , env.damageTarget },
    {spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and focus.isAttackable and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
    {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 4.8 and focus.isAttackable' , 'focus' },
    {{"nested"}, 'kps.multiTarget and mouseover.inCombat and mouseover.isAttackable',{
        {spells.vampiricTouch, 'not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("mouseover")' , 'mouseover' },
        {spells.shadowWordPain, 'mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8' , 'mouseover' },
    }},

    {{"macro"}, 'spells.mindBlast.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > kps.gcd and spells.mindFlay.cooldownTotal == 0' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving ' , env.damageTarget },

},"priest_shadow_bfa")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]