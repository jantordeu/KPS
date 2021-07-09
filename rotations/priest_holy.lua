--[[[
@module Priest Holy Rotation
@author htordeux
@version 9.0.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local HolyWordSanctify = spells.holyWordSanctify.name
local SpiritOfRedemption = spells.spiritOfRedemption.name
local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name
local DoorOfShadows = spells.doorOfShadows.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","HOLY", "holynova", "Interface\\Icons\\spell_holy_holynova", "holynova")
end)


local damageRotation = {
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.80', "target" },
    {spells.powerInfusion, 'target.hp > 0.70 or target.isElite' },
    {spells.holyWordChastise, 'true' , env.damageTarget },
    {spells.holyFire, 'not player.isMoving' , env.damageTarget },
    {spells.smite, 'not player.isMoving' , env.damageTarget },
    {spells.holyNova, 'player.isMoving and target.distance <= 10'},
}

-- kps.defensive to avoid overheal
kps.rotations.register("PRIEST","HOLY",
{
    --{{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.hp == 0' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption)' ,{
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.circleOfHealing, 'true' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.prayerOfHealing, 'true' , kps.heal.lowestInRaid},
    }},
    
    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isHealable and mouseover.isRaidTank' , "/focus mouseover" },

    env.holyWordSanctifyMessage,

    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'player.hasTalent(3,2) and targettarget.isFriend and targettarget.hp < 0.40' , "targettarget" },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and focus.isFriend and focus.hp < 0.40' , "focus" },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    {spells.guardianSpirit, 'player.hp < 0.30' , "player" },
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'targettarget.isFriend and targettarget.hp < 0.70' , "targettarget" },
    {spells.holyWordSerenity, 'focus.isFriend and focus.hp < 0.70' , "focus" },
    {spells.holyWordSerenity, 'player.hp < 0.70' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },

    -- "Flash Concentration" -- Reduces the cast time of your Heal by 0.2 sec and increases its healing by 3%. 20 seconds remaining 
    {spells.flashHeal, 'not spells.flashHeal.lastCasted(13) and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid , "flashHeal_Concentration_last" },
    {spells.flashHeal, 'player.buffDuration(spells.flashConcentration) < 7 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid , "flashHeal_Concentration_duration" },
    {spells.flashHeal, 'player.hasBuff(spells.surgeOfLight) and player.buffDuration(spells.surgeOfLight) < 7' , kps.heal.lowestInRaid , "flashHeal_duration_surge"  },
    {spells.flashHeal, 'player.hasBuff(spells.surgeOfLight) and player.buffStacks(spells.flashConcentration) < 4' , kps.heal.lowestInRaid , "flashHeal_stacks_surge" },
    
    -- guardianFaerie -- buff Reduces damage taken by 20%. Follows your Power Word: Shield.
    {spells.powerWordShield, 'spells.faeGuardians.lastCasted(5) and not heal.lowestTankInRaid.hasBuff(spells.guardianFaerie) and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },    
    -- benevolentFaerie -- buff Increases the cooldown recovery rate of your target's major ability by 100%. Follows your Flash Heal (holy) Shadow Mend (shadow,disc)
    {spells.faeGuardians, 'player.buffDuration(spells.flashConcentration) > 15' , "target" },

    -- "Dissipation de masse"
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Holy Word: Sanctify"
    {{"macro"}, 'keys.shift and spells.holyWordSanctify.cooldown == 0', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.80) > 2 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isFriend', "mouseover" },

    {spells.fade, 'player.isTarget and player.isInGroup' },
    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.60 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    --{spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},
    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {{"nested"}, 'kps.interrupt' ,{
        {spells.holyWordChastise, 'player.hasTalent(4,2) and target.isInterruptable and target.isCasting' , "target" },
        {spells.holyWordChastise, 'player.hasTalent(4,2) and mouseover.isInterruptable and mouseover.isCasting' , "mouseover" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },
    }},
    -- PVP
    {{"nested"}, 'player.isPVP' ,{
        {spells.prayerOfMending, 'true' , "player" },
        {spells.holyWard, 'true' , "player" },
        {spells.guardianSpirit, 'player.hp < 0.70 and player.isTarget' , "player" },
        {spells.renew, 'player.hp < 0.85 and not player.hasMyBuff(spells.renew)' , "player" },
        {spells.powerWordShield, 'player.hp < 0.70 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.circleOfHealing, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    }},

    {spells.circleOfHealing, 'heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid },
    {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30 and target.isAttackable' },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 2' },
    -- "Prayer of Mending" LASTCAST
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfMending.lastCasted(5) and heal.lowestInRaid.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid ,"flashHeal_POM" },
    {spells.heal, 'not player.isMoving and spells.prayerOfMending.lastCasted(5) and player.hasBuff(spells.flashConcentration) and heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid , "heal_POM" },
    -- "Prayer of Mending"
    {spells.prayerOfMending, 'not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid },
    {spells.prayerOfMending, 'true' , kps.heal.hasNotBuffMending },

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and targettarget.isHealable and targettarget.hp < 0.80' , "/use [@targettarget] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and focus.isHealable' , "/use [@focus] 14" },
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30' , "/use 14" },

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Apotheosis" for PARTY
    {{"nested"}, 'not player.isMoving and player.hasBuff(spells.apotheosis)',{
        {spells.heal, 'player.hasBuff(spells.flashConcentration) and heal.lowestInRaid.hp < 0.80 and player.buffStacks(spells.flashConcentration) > 3' , kps.heal.lowestInRaid , "heal_lowest_apotheosis" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid , "flashHeal_lowest_apotheosis" },
        {spells.prayerOfHealing, 'heal.countLossInRange(0.80) > 2 and not spells.prayerOfHealing.lastCasted(6)' , kps.heal.lowestInRaid , "POH_apotheosis" },
        {spells.heal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid , "heal_lowest_apotheosis" },
    }},
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.50 and spells.holyWordSerenity.cooldown > 6' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestInRaid.hp < 0.50 and heal.countLossInRange(0.70) > 2' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.countLossInRange(0.70) > 2' },

    {spells.powerInfusion, 'heal.lowestInRaid.hp < 0.40 and heal.countLossInRange(0.70) > 4' , "player" },
    {spells.powerInfusion, 'heal.lowestInRaid.hp < 0.40 and heal.countLossInRange(0.70) > 2 and not player.isInRaid' , "player" },
    {spells.powerInfusion, 'mouseover.isFriend and mouseover.isRaidDamager', "mouseover" },
    
    -- ShouldInterruptCasting
    {{"macro"}, 'spells.heal.shouldInterrupt(0.90, kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.90, kps.defensive and player.buffDuration(spells.flashConcentration) > 9)' , "/stopcasting" }, 
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.90), kps.defensive)' , "/stopcasting" },

    -- Boss ALTIMOR
    --{spells.holyWordSerenity, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },
    --{spells.heal, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },
    -- MOUSEOVER
    {spells.holyWordSerenity, 'mouseover.isFriend and mouseover.hp < 0.70' , "mouseover" },
    {spells.flashHeal, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt("mouseover")' , "mouseover" },
    {spells.heal, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.80' , "mouseover" },
    {spells.heal, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.85 and not player.isInRaid' , "mouseover" },
    -- DAMAGE
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20 and player.hp > 0.80', "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
    {spells.holyNova, 'kps.holynova' },

    -- DEFAULT TANK
    {spells.flashHeal, 'not player.isMoving and focus.isFriend and focus.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt("focus")' , "focus" },
    {spells.heal, 'not player.isMoving and focus.isFriend and focus.hp < 0.70' , "focus" },
    {spells.flashHeal, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt("targettarget")' , "targettarget" },
    {spells.heal, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.70' , "targettarget" },
    -- "Flash Concentration" -- Reduces the cast time of your Heal by 0.2 sec and increases its healing by 3%. 15 seconds remaining -- IsEquippedItem(173249)
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt("player")', "player", "flash_player_Concentration"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)', kps.heal.lowestTankInRaid, "flash_tank_Concentration"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and player.buffStacks(spells.flashConcentration) < 4 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid, "flash_lowest_Concentration"  },
    {spells.heal, 'not player.isMoving and player.hp < 0.70', "player", "heal_player_Concentration"  },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70', kps.heal.lowestTankInRaid, "heal_tank_Concentration"  },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.70', kps.heal.lowestInRaid, "heal_lowest_Concentration"  },

    -- "Prayer of Healing" -- Holy Word: Sanctify Cooldown reduced by 6 sec when you cast Prayer of Healing and by 2 sec when you cast Renew.
    {spells.prayerOfHealing, 'not player.isMoving and spells.holyWordSanctify.cooldown > 15 and heal.countLossInRange(0.85) > 4 and not spells.prayerOfHealing.lastCasted(6)' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and spells.holyWordSanctify.cooldown > 15 and heal.countLossInRange(0.85) > 2 and not spells.prayerOfHealing.lastCasted(6) and not player.isInRaid' , kps.heal.lowestInRaid , "POH" },
    {spells.heal, 'not player.isMoving and player.hasTalent(1,2) and heal.countLossInRange(0.80) > 2 and not spells.heal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "heal_POH" },
    
    {{"nested"},'kps.multiTarget', damageRotation},
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hpIncoming > 0.70 and player.buffDuration(spells.flashConcentration) > 7', env.damageTarget, "smite_health"},
    {spells.smite, 'not player.isMoving and player.hasBuff(spells.wrathfulFaerie) and player.buffDuration(spells.flashConcentration) > 7', env.damageTarget, "smite_health"},
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.70 and player.hasBuff(spells.flashConcentration)', kps.heal.lowestInRaid, "heal_lowest_Concentration"  },

    {{"nested"}, 'player.isMoving' ,{
        {spells.powerWordShield, 'player.hp < 0.60 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'heal.lowestTankInRaid.hp < 0.60 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.60 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid },
        {spells.renew, 'heal.lowestTankInRaid.hp < 0.60 and not heal.lowestTankInRaid.hasMyBuff(spells.renew)' , kps.heal.lowestTankInRaid },
        {spells.renew, 'player.hp < 0.60 and not player.hasMyBuff(spells.renew)' , "player" },
        {spells.renew, 'heal.lowestInRaid.hp < 0.60 and not heal.lowestInRaid.hasMyBuff(spells.renew)' , kps.heal.lowestInRaid },
    }},
    -- "Soins rapides"
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.50 and not spells.flashHeal.isRecastAt("player")' , "player", "flashHeal_player" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.50 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "flashHeal_tank"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.50 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "flashHeal_lowest" },
    -- "Soins"
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp', kps.heal.lowestInRaid, "heal_lowest"  },
    {spells.heal, 'not player.isMoving and player.hp < 0.80 and player.hp  < heal.lowestTankInRaid.hp', "player" , "heal_player"  },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.80', kps.heal.lowestTankInRaid , "heal_tank"  },
    -- Damage
    {spells.smite, 'not player.isMoving', env.damageTarget, "smite_filler"},

}
,"priest_holy_shadowlands")


-- MACRO --
--[[

#showtooltip Rénovation
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Rénovation

#showtooltip Soins rapides
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Soins rapides

#showtooltip Esprit gardien
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Esprit gardien

#showtooltip Prière de guérison
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Prière de guérison

#showtooltip Prière de soins
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Prière de soins

#showtooltip Purifier
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Purifier

#showtooltip Mot sacré : Sérénité
/cast [@mouseover,exists,nodead,help][exists,nodead,help][@player] Mot sacré : Sérénité

#showtooltip Supplique
/cast [@mouseover,exists,nodead,help][@player] Supplique

#showtooltip Mot de pouvoir : Bouclier
/cast [@mouseover,exists,nodead,help][@player] Mot de pouvoir : Bouclier

]]--


