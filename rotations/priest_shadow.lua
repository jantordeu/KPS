--[[[
@module Priest Shadow Rotation
@author htordeux
@version 9.0.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local Dispersion = spells.dispersion.name
local MassDispel = spells.massDispel.name
local ShadowCrash = spells.shadowCrash.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","SHADOW", "mindSear", "Interface\\Icons\\spell_shadow_mindshear", "mindSear")
end)


kps.rotations.register("PRIEST","SHADOW",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'FocusMouseoverShadow()' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.30' },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.995' , "/cancelaura "..Dispersion },
    --"Fade" 586
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.useItem(5512) and player.hp < 0.65', "/use item:5512" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.55' },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'kps.defensive and not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },   
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.levitate)' , "player" },
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
    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable},
    }},
    
    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable and not player.hasBuff(spells.voidForm)' , "/use 13" },

    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    --{spells.azerite.concentratedFlame, 'player.hasBuff(spells.voidForm) and target.isAttackable' , env.damageTarget },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    --{spells.azerite.memoryOfLucidDreams, 'player.hasBuff(spells.voidForm) and target.isAttackable and player.buffStacks(spells.voidForm) > 17 and player.insanity > 39' , env.damageTarget },
    -- The Unbound Force -- causing shards of spells.azerite to strike your target for [(341 * (7.06061) + 341)] Fire damage over 2 sec. This damage is increased by 300% if it critically strikes
    --{spells.azerite.theUnboundForce, 'player.hasBuff(spells.voidForm) and target.isAttackable and player.buffStacks(spells.voidForm) < 15' , env.damageTarget },
    
    {spells.shadowWordDeath, 'mouseover.inCombat and mouseover.isAttackable and mouseover.hp < 0.20' , "mouseover" , "shadowWordDeath" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20' , "target" , "shadowWordDeath" },
    
    {spells.voidEruption, 'not player.isMoving and player.insanity > 40 and target.hp > 0.20' , env.damageTarget , "voidEruption"  },
    {spells.voidEruption, 'not player.isMoving and player.insanity > 40 and target.isElite' , env.damageTarget , "voidEruption"  },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear)' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt" },
    {spells.powerInfusion, 'target.hp > 0.50 or target.isElite' , env.damageTarget },


    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 7 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 5' , "mouseover" },
    {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 7 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 5' , "target" },     
    {spells.vampiricTouch, 'not player.isMoving and focus.isAttackable and focus.myDebuffDuration(spells.vampiricTouch) < 7 and not spells.vampiricTouch.isRecastAt("focus")' , "focus" },
    {spells.shadowWordPain, 'focus.isAttackable and focus.myDebuffDuration(spells.shadowWordPain) < 5' , "focus" },

    {spells.mindgames, 'true' , env.damageTarget }, 
    {spells.devouringPlague, 'not kps.mindSear and spells.voidEruption.cooldown > 6 and target.isAttackable and not target.hasMyDebuff(spells.devouringPlague)' , "target" },
    {spells.searingNightmare, 'kps.mindSear and player.hasTalent(3,3) and player.isCastingSpell(spells.mindSear) and not spells.searingNightmare.isRecastAt("target")' , "target" , "searingNightmare" },

    {spells.vampiricTouch , 'player.hasBuff(spells.unfurlingDarkness)' , env.damageTarget , "vampiricTouch_unfurlingDarkness" },    
    {spells.mindBlast, 'player.hasBuff(spells.darkThoughts)' , env.damageTarget , 'mindBlast_darkThoughts' },
    {spells.mindSear, 'kps.mindSear and not player.isMoving' , env.damageTarget , "mindSear_mindSear" },

    {spells.voidTorrent, 'target.hp > 0.20' , env.damageTarget },
    {spells.shadowfiend, 'target.hp > 0.20' , env.damageTarget },
    {spells.mindbender, 'target.hp > 0.20' , env.damageTarget },

    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindSear, 'kps.multiTarget and not player.isMoving and player.plateCount > 2' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_bfa")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]