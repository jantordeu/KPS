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

kps.runAtEnd(function()
kps.gui.addCustomToggle("PRIEST","SHADOW", "control", "Interface\\Icons\\spell_nature_slow", "control")
end)


kps.rotations.register("PRIEST","SHADOW",
{
    {spells.powerWordFortitude, 'not player.hasBuff(spells.powerWordFortitude) and not player.isInGroup', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },

    {spells.desperatePrayer, 'player.hp < 0.50' , "player" },
    -- "Dissipation de masse"
    --{{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@player] "..MassDispel },
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0 ', "/cast [@cursor] "..MassDispel },
    -- "Shadow Crash"
    --{{"macro"}, 'keys.shift and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    --{{"macro"}, 'mouseover.inCombat and mouseover.isAttackable and player.hasTalent(5,3) and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    -- "Shackle Undead"
    {spells.shackleUndead, 'kps.control and not player.isMoving and target.isAttackable and not target.incorrectTarget and not target.hasDebuff(spells.shackleUndead)' , "target" },
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isFriend and spells.leapOfFaith.cooldown == 0', "mouseover" },
    -- "Fade"
    {spells.fade, 'player.isTarget' },
    {spells.fade, 'player.incomingDamage > player.incomingHeal and player.hp < 0.70' },
    -- "Dispersion" 47585
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.90' , "/cancelaura "..Dispersion },
    {spells.dispersion, 'player.hp < 0.30' },
    -- "Etreinte vampirique" -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'heal.countLossInRange(0.70) > 4 and heal.lowestInRaid.hp < 0.55' },
    {spells.vampiricEmbrace, 'kps.groupSize() == 1 and player.hp < 0.55' },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40 and not spells.shadowMend.isRecastAt("player") and not spells.shadowMend.lastCasted(2) and not player.hasBuff(spells.voidForm)' , "player" },
    -- "Power Word: Shield" -- "Body and Soul"
    {spells.powerWordShield, 'player.hasTalent(2,1) and player.isMovingSince(1.6) and not player.hasBuff(spells.bodyAndSoul) and not player.hasDebuff(spells.weakenedSoul)' , "player" , "SCHIELD_MOVING" },
    {spells.powerWordShield, 'player.hp < 0.55 and not player.hasBuff(spells.vampiricEmbrace) and not player.hasDebuff(spells.weakenedSoul) and not player.hasBuff(spells.voidForm)' , "player" , "SCHIELD_HEALTH" },
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.psychicHorror, 'player.hasTalent(4,3) and target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.psychicHorror, 'player.hasTalent(4,3) and mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
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

    -- VENTHYR
    --{spells.mindgames, 'not player.isMoving' , "target" },
    --{{"macro"}, ' keys.alt and not player.isMoving and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    --{spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.voidForm) and player.hp < 0.55' , "player" },
    --{spells.unholyNova, 'kps.multiTarget and not player.isMoving' },
    -- NIGHTFAE
    {spells.faeGuardians, 'not player.hasBuff(spells.benevolentFaerie)' , "player" },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and kps.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 10' , "/use 14" },

    {spells.shadowWordDeath, 'IsEquippedItem(173244) and spells.shadowfiend.cooldown > 45' , "target" },
    {spells.shadowWordDeath, 'target.hp < 0.20 and player.hp > 0.55' , "target" },
    {spells.devouringPlague, 'player.insanity > 70' , "target" },
    {spells.devouringPlague, 'not player.hasBuff(spells.livingShadow)' , "target" },
    {spells.voidBolt, 'player.hasBuff(spells.voidForm)' , "target" , "voidBolt_voidForm" },
    {spells.mindBlast, 'player.hasBuff(spells.darkThoughts)' , "target" , 'mindBlast_darkThoughts' },
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 5 and not spells.vampiricTouch.isRecastAt("target") and not spells.vampiricTouch.lastCasted(2)' , "target" },    
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 5' , "target"  },
    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 5 and not spells.vampiricTouch.isRecastAt("mouseover") and not spells.vampiricTouch.lastCasted(2)' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 5' , "mouseover"   },
    {spells.mindSear, 'kps.mindSear and not player.hasBuff(spells.voidForm) and not player.isMoving' , "target" },
    {spells.voidBolt, 'player.hasBuff(spells.dissonantEchoes)' , "target" , "voidBolt_dissonantEchoes"  },
    {spells.devouringPlague, 'player.hasBuff(spells.mindDevourer)' , "target" , "plague_mindDevourer" },
    {spells.powerInfusion, 'kps.multiTarget' },
    {spells.shadowfiend, 'kps.multiTarget' , "target" },
    {spells.voidEruption, 'kps.multiTarget and not player.isMoving and not player.hasBuff(spells.voidForm)' },
    {spells.devouringPlague, 'true' , "target" },
    {spells.mindBlast, 'not player.isMoving' , "target"  },
    {spells.voidTorrent, 'not player.isMoving and player.insanity <= 40 and not player.hasBuff(spells.voidForm)' , "target" },
    {spells.shadowWordPain, 'player.isMoving' , "target"  , "shadowWordPain_moving"  },
    --{spells.vampiricTouch, 'not player.isMoving and not spells.vampiricTouch.isRecastAt("target") and not spells.vampiricTouch.lastCasted(2)' , "target" },   
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , "target" },

},"priest_shadow_shadowlands")