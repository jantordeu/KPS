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
kps.gui.addCustomToggle("PRIEST","SHADOW", "hekili", "Interface\\Icons\\spell_nature_slow", "hekili")
end)


kps.rotations.register("PRIEST","SHADOW",
{
    {spells.powerWordFortitude, 'not player.hasBuff(spells.powerWordFortitude) and not player.isInGroup', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },

    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    -- "Dissipation de masse"
    --{{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@player] "..MassDispel },
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Shadow Crash"
    {{"macro"}, 'keys.shift and spells.shadowCrash.cooldown == 0', "/cast [@cursor] "..ShadowCrash },
    {{"macro"}, 'mouseover.isAttackable and spells.shadowCrash.cooldown == 0 and not mouseover.isMoving', "/cast [@cursor] "..ShadowCrash },
    -- "Shackle Undead"
    --{spells.shackleUndead, 'not player.isMoving and target.isAttackable and not target.incorrectTarget and not target.hasDebuff(spells.shackleUndead)' , "target" },
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
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.70 and not player.hasBuff(spells.protectiveLight)', "player" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.40 and not spells.flashHeal.isRecastAt("player") and not spells.flashHeal.lastCasted(2)', "player" },
    -- "Power Word: Shield" -- "Body and Soul"
    {spells.powerWordShield, 'player.hp < 0.70 and not player.hasBuff(spells.vampiricEmbrace) and not player.hasBuff(spells.voidForm)' , "player"  },
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.psychicHorror, 'target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.psychicHorror, 'mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.silence, 'target.isInterruptable and target.castTimeLeft < 3' , "target" },
        {spells.silence, 'mouseover.isInterruptable and mouseover.castTimeLeft < 3' , "mouseover" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.mindBomb, 'player.isTarget and target.distanceMax  <= 30 and target.isCasting and target.castTimeLeft < 2' , "target" },
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
    --{spells.faeGuardians, 'not player.hasBuff(spells.benevolentFaerie)' , "player" },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and kps.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 10' , "/use 14" },
    
    {kps.hekili({
        spells.leapOfFaith,
        spells.massDispel
    }), 'kps.hekili'},
    

    {spells.powerInfusion, 'kps.multiTarget and player.hasBuff(spells.darkAscension)' },
    {spells.shadowWordDeath, 'spells.shadowfiend.cooldown > 45' , "target" },
    {spells.shadowWordDeath, 'target.hp < 0.20 and player.hp > 0.55' , "target" },
    {spells.devouringPlague, 'player.insanity > 70' , "target" },
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 6 and not spells.vampiricTouch.isRecastAt("target") and not spells.vampiricTouch.lastCasted(2)' , "target" },    
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 6' , "target"  },
    {spells.vampiricTouch, 'not player.isMoving and mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.vampiricTouch) < 6 and not spells.vampiricTouch.isRecastAt("mouseover") and not spells.vampiricTouch.lastCasted(2)' , "mouseover" },
    {spells.shadowWordPain, 'mouseover.inCombat and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 6' , "mouseover"   },
    --{spells.voidBolt, 'player.hasBuff(spells.voidForm)' , "target" , "voidBolt_voidForm" },
    --{spells.voidEruption, 'kps.multiTarget and not player.isMoving and not player.hasBuff(spells.voidForm)' },
    {spells.voidTorrent, 'not player.isMoving' , "target" , "voidBolt_voidForm" },

    {spells.darkAscension, 'kps.multiTarget and not player.isMoving' },
    {spells.devouringPlague, 'not target.hasMyDebuff(spells.devouringPlague)' , "target" },
    {spells.devouringPlague, 'player.hasBuff(spells.mindDevourer)' , "target" },
    {spells.mindBlast, 'player.hasBuff(spells.shadowyInsight)' , "target"  },
    {spells.mindBlast, 'not player.isMoving and spells.shadowfiend.cooldown > 45' , "target"  },
    {spells.mindBlast, 'not player.isMoving and spells.mindBlast.charges == 2' , "target"  },
    {spells.mindSpike, 'player.hasBuff(spells.surgeOfDarkness)' , "target"  },
    {spells.mindgames, 'not player.isMoving' , "target" },
    {spells.divineStar, 'not player.isMoving and target.isAttackable and target.distanceMax  <= 20' },
    {spells.shadowfiend, 'kps.multiTarget' , "target" },
    {spells.devouringPlague, 'true' , "target" },
    {spells.mindBlast, 'not player.isMoving' , "target"  },
    {spells.shadowWordPain, 'player.isMoving' , "target"  , "shadowWordPain_moving"  },
    {spells.mindFlay, 'not player.isMoving and player.hasBuff(spells.mindFlayInsanity)' , "target" },
    {spells.mindSpike, 'not player.isMoving' , "target"  },
    {spells.mindFlay, 'not player.isMoving and not player.isCastingSpell(spells.mindFlay)' , "target" },

},"priest_shadow_shadowlands")