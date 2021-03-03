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
    {{"macro"}, 'FocusMouseoverShadow()' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    
    -- "Door of Shadows" 
    {{"macro"}, 'not player.isMoving and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Shadow Crash"
    {{"macro"}, 'keys.shift and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    {{"macro"}, 'mouseover.inCombat and mouseover.isAttackable and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    -- "Door of Shadows" 
    {{"macro"}, 'not player.isMoving and spells.doorOfShadows.cooldown == 0 and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Dispersion" 47585
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.95' , "/cancelaura "..Dispersion },
    {spells.dispersion, 'player.hp < 0.30' },
    --"Fade" 586
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- PVP
    {spells.psyfiend, 'player.isTarget and player.isPVP' , "player" },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.lowestInRaid.hp < 0.55' },
    -- "Power Word: Shield" 17 -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.2) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.powerWordShield) and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_HEALTH" },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not spells.shadowMend.isRecastAt("player")' , "player" },  
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40 and not player.hasBuff(spells.vampiricEmbrace)' , "player" }, 
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.2) and not player.hasBuff(spells.levitate)' , "player" },

    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        -- "Silence" 15487 -- debuff same ID
        {spells.psychicHorror, 'player.hasTalent(4,3) and mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 2' , "target" },
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
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving and player.timeInCombat > 9' , "/use 13" },
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9' , "/use 13" },
    {{"macro"}, 'player.useTrinket(1) and not player.isMoving and player.timeInCombat > 5' , "/use 14" },
    
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.15 and player.hp > 0.70' , "target" },
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "target" },
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.hp < 0.20 and player.hp > 0.70 and not target.isElite' , "mouseover" },
    
    {spells.powerInfusion, 'kps.multiTarget' },
    {spells.shadowfiend, 'player.hasBuff(spells.powerInfusion)' , env.damageTarget },
    {spells.shadowfiend, 'player.hasBuff(spells.voidForm)' , env.damageTarget },
    {spells.voidEruption, 'kps.multiTarget and not player.isMoving and player.insanity > 40' , env.damageTarget , "voidEruption"  },

    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindSear) and spells.mindSear.cooldown == 0' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidBolt.cooldown == 0 and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , env.damageTarget , "voidBolt" },
    {{"macro"}, 'spells.mindBlast.cooldown == 0 and player.hasBuff(spells.talbadarStratagem) and player.isCastingSpell(spells.mindFlay) and spells.mindFlay.cooldown == 0' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.talbadarStratagem)' , env.damageTarget , "mindBlast_talbadar" },
    {spells.mindBlast, 'player.hasBuff(spells.darkThoughts)' , env.damageTarget , 'mindBlast_darkThoughts' },

    {spells.voidTorrent, 'not player.hasBuff(spells.voidForm) and player.insanity < 40' , env.damageTarget }, 
    {spells.mindgames, 'not player.isMoving' , env.damageTarget }, 
    {spells.searingNightmare, 'kps.mindSear and player.hasTalent(3,3) and player.isCastingSpell(spells.mindSear)' , "target" , "searingNightmare" },
    {spells.mindSear, 'kps.mindSear and not player.isMoving and player.insanity > 30' , env.damageTarget , "mindSear_mindSear" },

    {spells.vampiricTouch, 'not player.isMoving and target.isAttackable and target.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4' , "target" },
    {spells.devouringPlague, 'target.isAttackable and target.myDebuffDuration(spells.devouringPlague) < 2' , "target" },

    {spells.vampiricTouch, 'player.hasBuff(spells.unfurlingDarkness) and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 4' , "mouseover" },
    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover")' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4' , "mouseover" },

    {spells.shadowWordPain, 'player.isMoving' , env.damageTarget },
    {spells.mindBlast, 'not player.isMoving' , env.damageTarget , },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , env.damageTarget },

},"priest_shadow_shadowlands")




