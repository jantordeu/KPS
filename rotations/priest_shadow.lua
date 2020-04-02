--[[[
@module Priest Shadow Rotation
@author htordeux
@version 8.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local Dispersion = spells.dispersion.name
local MassDispel = spells.massDispel.name
local ShadowCrash = spells.shadowCrash.name


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "mindControl", "Interface\\Icons\\Priest_spell_leapoffaith_a", "mindControl")
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
    {spells.dispersion, 'player.hp < 0.30' },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.995' , "/cancelaura "..Dispersion },
    --"Fade" 586
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.65', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.65', "player" },
     -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.55 or player.hp < 0.55' },
     -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'kps.defensive and not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },   
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
        --{spells.arcaneTorrent, 'player.timeInCombat > 30 and target.isAttackable and target.distance <= 10' , "target" },
    }},
    
    -- {spells.psyfiend },

    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.levitate)' , "player" },
    
    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'player.hasBuff(spells.voidForm)' , env.damageTarget },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    {spells.azerite.memoryOfLucidDreams, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) > 17 and player.insanity > 39' , env.damageTarget },
    -- The Unbound Force -- causing shards of spells.azerite to strike your target for [(341 * (7.06061) + 341)] Fire damage over 2 sec. This damage is increased by 300% if it critically strikes
    {spells.azerite.theUnboundForce, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 15' , env.damageTarget },

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) > 17' , "/use 13"},
    {{"macro"}, 'player.hasTrinket(1) == 167555 and player.useTrinket(1) and player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) < 15' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(1) == 168905 and player.useTrinket(1) and player.hasBuff(spells.voidForm) and target.hasDebuff(spells.shiverVenom)' , "/use 14" },

    {spells.voidEruption, 'not player.isMoving and player.hasTalent(7,1) and player.insanity > 60 and spells.mindBlast.cooldown == 0' , env.damageTarget , "voidEruption_60" },
    {spells.voidEruption, 'not player.isMoving and player.hasTalent(7,1) and player.insanity > 70' , env.damageTarget , "voidEruption_70" },
    {spells.voidEruption, 'not player.isMoving and not player.hasTalent(7,1) and player.insanity > 90' , env.damageTarget , "voidEruption_90"  },
    {spells.darkAscension, 'player.hasTalent(7,2) and not player.hasBuff(spells.voidForm) and player.insanity < 60', env.damageTarget },
    
    {{"nested"}, 'not player.hasBuff(spells.voidForm)',{
        {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
        {spells.darkVoid, 'player.hasTalent(3,3) and not player.hasBuff(spells.voidForm) and not player.isMoving' , env.damageTarget , "darkVoid" },
        {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8' , "target" },
        {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount > 4' , env.damageTarget },
        {spells.mindBlast, 'not player.isMoving and player.insanity < 60' , env.damageTarget , "mindBlast_not_voidForm"},
        {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },
    }},

    --{{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindFlay)' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear)' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt" },

    {spells.shadowWordDeath, 'player.hasTalent(5,2) and target.hp < 0.20' , "target" },    
    {spells.shadowfiend, 'player.hasBuff(spells.voidForm) and player.buffStacks(spells.voidForm) > 15' , env.damageTarget },
    {{"macro"}, 'player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0 and target.isAttackable and not target.isMoving and target.distanceMax <= 5' , "/cast [@player] "..ShadowCrash },
    {{"macro"}, 'player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0 and mouseover.isAttackable and not mouseover.isMoving' , "/cast [@cursor] "..ShadowCrash },
    
    {spells.mindSear, 'kps.mindSear and not player.isMoving' , env.damageTarget },

    --{{spells.vampiricTouch,spells.shadowWordPain}, 'not player.isMoving and not player.hasTalent(3,2) and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and target.myDebuffDuration(spells.shadowWordPain) < 4.8' , "target" },
    {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8' , "target" },
    {spells.shadowWordPain, 'player.isMoving and target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 16.8' , "target" },
    --{{spells.vampiricTouch,spells.shadowWordPain}, 'not player.isMoving and not player.hasTalent(3,2) and focus.isAttackable and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and focus.myDebuffDuration(spells.shadowWordPain) < 4.8' , "focus" },
    {spells.vampiricTouch, 'focus.isAttackable and not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("focus")' , "focus"  },
    {spells.shadowWordPain, 'focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 4.8' , "focus"  },
    {spells.shadowWordPain, 'player.isMoving and focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 16.8' , "focus" },

    {spells.mindBlast, 'not player.isMoving and player.buffStacks(spells.voidForm) > 9' , env.damageTarget , "mindBlast_voidForm"},
    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount > 4' , env.damageTarget },

    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 6.3 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8' , "mouseover" },
    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.vampiricTouch) == 27.3 -- duration(21) + 30% (6.3) -- 70% (14.7)
    -- Pandemic allow DoTs to be refreshed upto 30% -- myDebuffDurationMax(spells.shadowWordPain) == 20.8 -- duration(16) + 30% (4.8) -- 70% (11.2)
    {spells.shadowWordPain, 'player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 16.8' , "mouseover" },
    {spells.shadowWordPain, 'player.isMoving and target.myDebuffDuration(spells.shadowWordPain) < 16.8' , "target" },
    {spells.shadowWordPain, 'player.isMoving and focus.myDebuffDuration(spells.shadowWordPain) < 16.8' , "focus" },

    {spells.mindBlast, 'not player.isMoving' , env.damageTarget , "mindBlast_voidForm"},
    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount > 2' , env.damageTarget },
    --{spells.mindSear, 'kps.multiTarget and not player.isMoving and player.hasBuff(spells.thoughtHarvester)' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_bfa")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]