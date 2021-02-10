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


kps.rotations.register("PRIEST","SHADOW",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'FocusMouseoverShadow()' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    
    -- "Door of Shadows" 
    {{"macro"}, 'not player.isMoving and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Shadow Crash"
    {{"macro"}, 'keys.shift and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    {{"macro"}, 'mouseover.isAttackable and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    -- "Door of Shadows" 
    {{"macro"}, 'not player.isMoving and spells.doorOfShadows.cooldown == 0 and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Dispersion" 47585
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.95' , "/cancelaura "..Dispersion },
    {spells.dispersion, 'player.hp < 0.35' },
    --"Fade" 586
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    {spells.desperatePrayer, 'player.hp < 0.65' , "player" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.55' },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.65 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },  
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40 and not player.hasBuff(spells.vampiricEmbrace)' , "player" }, 
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.levitate)' , "player" },

    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        -- "Silence" 15487 -- debuff same ID
        {spells.psychicHorror, 'player.hasTalent(4,3) and mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,2) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
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
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving' , "/use 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9' , "/use 13" },
    {{"macro"}, 'player.useTrinket(1) and not player.isMoving' , "/use 14" },

    -- PVP
    {spells.psyfiend, 'player.isPVP' , "player" },

    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear) and spells.mindSear.cooldown == 0' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt" },
    {spells.voidEruption, 'not player.isMoving and player.insanity > 40 and target.hp > 0.20' , env.damageTarget , "voidEruption"  },
    {spells.voidEruption, 'not player.isMoving and player.insanity > 40 and target.isElite' , env.damageTarget , "voidEruption"  },
 
    {spells.powerInfusion, 'kps.cooldowns and target.hp > 0.80 or target.isElite' },
    {spells.shadowfiend, 'target.hp > 0.20 and spells.voidEruption.cooldown < 3' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving and target.hasMyDebuff(spells.devouringPlague)' , env.damageTarget },

    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.15 and player.hp > 0.70' , "target" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "target" },
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "mouseover" },

    {spells.vampiricTouch, 'player.hasBuff(spells.unfurlingDarkness) and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 4' , "mouseover" },
    {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4' , "target" },
    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4' , "mouseover" },

    {spells.devouringPlague, 'target.isAttackable and player.insanity > 90' , "target" },
    {spells.mindBlast, 'player.hasBuff(spells.darkThoughts)' , env.damageTarget , 'mindBlast_darkThoughts' },
    {spells.mindBlast, 'not player.isMoving and spells.mindBlast.charges == 2' , env.damageTarget },

    {spells.searingNightmare, 'kps.mindSear and player.hasTalent(3,3) and player.isCastingSpell(spells.mindSear) and not spells.searingNightmare.lastCasted(5)' , "target" , "searingNightmare" },
    {spells.devouringPlague, 'target.isAttackable and not target.hasMyDebuff(spells.devouringPlague)' , "target" },
    {spells.mindSear, 'kps.mindSear and not player.isMoving' , env.damageTarget , "mindSear_mindSear" },

    {spells.voidTorrent, 'not player.hasBuff(spells.voidForm) and player.insanity < 40' , env.damageTarget },   
    {spells.mindgames, 'not player.isMoving' , env.damageTarget }, 

    {spells.shadowWordPain, 'player.isMoving' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_shadowlands")


--kps.rotations.register("PRIEST","SHADOW",{
--
--    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear) and spells.mindSear.cooldown == 0' , "/stopcasting" },
--    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
--
--    {kps.hekili({}), 'true'},
--
--},"Hekili")


-- MACRO --
--[[

#showtooltip Mot de l’ombre : Douleur
/cast [@mouseover,exists,nodead,harm][@target] Mot de l’ombre : Douleur

––]]

-- AZERITE
-- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
--{spells.azerite.concentratedFlame, 'player.hasBuff(spells.voidForm) and target.isAttackable' , env.damageTarget },
-- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
--{spells.azerite.memoryOfLucidDreams, 'player.hasBuff(spells.voidForm) and target.isAttackable and player.buffStacks(spells.voidForm) > 17 and player.insanity > 39' , env.damageTarget },
-- The Unbound Force -- causing shards of spells.azerite to strike your target for [(341 * (7.06061) + 341)] Fire damage over 2 sec. This damage is increased by 300% if it critically strikes
--{spells.azerite.theUnboundForce, 'player.hasBuff(spells.voidForm) and target.isAttackable and player.buffStacks(spells.voidForm) < 15' , env.damageTarget },