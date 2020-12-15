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
   kps.gui.addCustomToggle("PRIEST","HOLY", "holyNova", "Interface\\Icons\\spell_holy_holynova", "holyNova")
end)


-- kps.defensive to avoid overheal
kps.rotations.register("PRIEST","HOLY",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

    env.holyWordSanctifyMessage,

    -- ShouldInterruptCasting
    {{"macro"}, 'spells.heal.shouldInterrupt(0.95, kps.defensive and spells.holyWordSerenity.cooldown < 6)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.85, kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.85), kps.defensive)' , "/stopcasting" },

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.hp < 0.10' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption) and not heal.lowestInRaid.isUnit("player")' ,{
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.circleOfHealing, 'true' , kps.heal.lowestInRaid},
        {spells.halo, 'true' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) < 5' , kps.heal.lowestInRaid},
        {spells.heal, 'heal.lowestInRaid.hp < 0.65 and player.hasBuff(spells.flashConcentration)' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid},
        {spells.prayerOfHealing, 'true' , kps.heal.lowestInRaid},
    }},
    

    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'player.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
 
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'player.hp < 0.55' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'mouseover.isHealable and mouseover.hp < 0.45' , "mouseover" },
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.55 and heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },

    -- "Dissipation de masse"
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Holy Word: Sanctify"
    {{"macro"}, 'keys.shift and spells.holyWordSanctify.cooldown == 0', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.80,10) > 2 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.85,10) > 3 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.80,10) > 1 and spells.holyWordSanctify.cooldown == 0 and not player.isInRaid' , "/cast [@player] "..HolyWordSanctify },
    -- "Door of Shadows" 
    {{"macro"}, 'not player.isMoving and keys.alt', "/cast [@cursor] "..DoorOfShadows},
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
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
        {spells.psychicScream, 'not player.isInGroup and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.isInGroup and not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    }},
    
    {spells.desperatePrayer, 'player.hp < 0.65' , "player" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.hp < 0.65 and player.useItem(5512)' , "/use item:5512" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    
    -- "Prayer of Mending"
    {spells.prayerOfMending, 'player.isPVP' , "player" },
    {spells.prayerOfMending, 'not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid },
    {spells.prayerOfMending, 'true' , kps.heal.hasNotBuffMending },
    
    -- PVP
    {{"nested"}, 'player.hp < 0.80 and player.isPVP' ,{
        {spells.holyWard, 'true' , "player" },
        {spells.powerWordShield, 'not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.renew, 'not player.hasBuff(spells.renew)' , "player" },
        {spells.flashHeal, 'not player.isMoving and IsEquippedItem(173249) and player.buffStacks(spells.flashConcentration) < 5' , kps.heal.lowestInRaid},
        {spells.heal, 'not player.isMoving and player.hasBuff(spells.flashConcentration)' },
        {spells.flashHeal, 'not player.isMoving' , "player" , "flashHeal_player" },
    }},
    
    -- "Flash Concentration" -- Reduces the cast time of your Heal by 0.2 sec and increases its healing by 3%. 15 seconds remaining
    {spells.flashHeal, 'not player.isMoving and player.hasBuff(spells.flashConcentration) and player.buffDuration(spells.flashConcentration) < 5 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit) and not spells.flashHeal.lastCasted(5)' , kps.heal.lowestInRaid , "flashHeal_Concentration_duration" },    
    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Apotheosis" for PARTY
    {{"nested"}, 'not player.isMoving and player.hasBuff(spells.apotheosis)',{
        {spells.heal, 'player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and heal.lowestInRaid.hpIncoming  < 0.70 and heal.lowestInRaid.hpIncoming  < heal.lowestTankInRaid.hpIncoming ' , kps.heal.lowestInRaid , "heal_lowest_apotheosis" },
    	{spells.heal, 'player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and heal.lowestTankInRaid.hpIncoming  < 0.70' , kps.heal.lowestTankInRaid , "heal_tank_apotheosis"  },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid , "flashHeal_tank_apotheosis" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "flashHeal_lowest_apotheosis" },
        {spells.prayerOfHealing, 'heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid , "POH_apotheosis" },
        {spells.heal, 'heal.lowestInRaid.hp < 0.80 and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3' , kps.heal.lowestInRaid , "heal_lowest_apotheosis" },
    }},
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.55 and spells.holyWordSerenity.cooldown > 2' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestInRaid.hp < 0.65 and heal.countLossInRange(0.80) > 2' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.countLossInRange(0.65) > 2' },

    {spells.powerInfusion, 'heal.lowestTankInRaid.hp < 0.40 and spells.holyWordSerenity.cooldown > 2 and not player.isInRaid' },
    {spells.powerInfusion, 'heal.lowestInRaid.hp < 0.55 and heal.countLossInRange(0.80) > 4' },
    {spells.powerInfusion, 'heal.lowestInRaid.hp < 0.55 and heal.countLossInRange(0.80) > 2 and not player.isInRaid' },
    {spells.powerInfusion, 'heal.countLossInRange(0.65) > 3' },

    -- MOUSEOVER
    {spells.heal, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.80 and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3' , "mouseover" , "heal_mouseover" },
    {spells.flashHeal, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.55' , "mouseover" , "flashHeal_mouseover" },
    {spells.flashHeal, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.65 and not player.isInRaid' , "mouseover" , "flashHeal_mouseover" },
    {spells.prayerOfHealing, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.85 and heal.countLossInRange(0.85) > 2 and not player.isInRaid' , "mouseover" , "prayerOfHealing_mouseover" },
    
    -- URGENCE
    {spells.flashHeal, 'not player.isMoving and IsEquippedItem(173249) and not player.hasBuff(spells.flashConcentration) and heal.lowestInRaid.hpIncoming < 0.80 and not spells.flashHeal.lastCasted(5)' , kps.heal.lowestInRaid , "flashHeal_Concentration_buff"  },
    {spells.flashHeal, 'not player.isMoving and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) < 5 and heal.lowestInRaid.hpIncoming < 0.65 and not spells.flashHeal.lastCasted(5)' , kps.heal.lowestInRaid , "flashHeal_Concentration_stacks"  },
   
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < 0.65 and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and kps.lastCastedSpell ~= spells.heal.name' ,{
        {spells.heal, 'heal.lowestTankInRaid.hp < 0.65 and not spells.heal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid ,"heal_tank_Concentration" },
        {spells.heal, 'player.hp < 0.65 and not spells.heal.isRecastAt("player")' , "player" ,"heal_player_Concentration" },
        {spells.heal, 'not spells.heal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid ,"heal_lowest_Concentration" },
    }},
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < 0.55 and kps.lastCastedSpell ~= spells.flashHeal.name' ,{
        {spells.flashHeal, 'player.hp < 0.55 and not spells.flashHeal.isRecastAt("player")' , "player" ,"flashHeal_player" },
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid ,"flashHeal_tank" },
        {spells.flashHeal, 'not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid ,"flashHeal_lowest" },
    }},

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and heal.countLossInRange(0.85) > 2' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and not player.isMoving' , "/use [@player] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.hasTrinket(1) == 160649 and player.useTrinket(1) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.65' , "/use [@player] 14" },
    
    {spells.circleOfHealing, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 3' },
    {spells.mindgames, 'not player.isMoving and heal.lowestInRaid.hp < 0.85' , env.damageTarget },
    {spells.divineStar, 'player.hasTalent(6,2) and target.distance <= 30' },

    -- "Prayer of Healing" LASTCAST
    {{"nested"}, 'not player.isMoving and spells.prayerOfHealing.lastCasted(4) and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3' ,{
        {spells.heal, 'player.hp < 0.80' , "player" , "heal_POH_Concentration" },
        {spells.heal, 'heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "heal_POH_Concentration" },
        {spells.heal, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid , "heal_POH_Concentration" },
    }},
    {{"nested"}, 'not player.isMoving and spells.prayerOfHealing.lastCasted(4)' ,{
        {spells.flashHeal, 'player.hp < 0.55' , "player" , "flashHeal_POH" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "flashHeal_POH" },
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "flashHeal_POH" },
    }},
    -- "Prayer of Mending" LASTCAST
    {{"nested"}, 'not player.isMoving and spells.prayerOfMending.lastCasted(4) and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3' ,{
        {spells.heal, 'player.hp < 0.80' , "player" , "heal_POM_Concentration" },
        {spells.heal, 'heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "heal_POM_Concentration" },
        {spells.heal, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid , "heal_POM_Concentration" },
    }},
    {{"nested"}, 'not player.isMoving and spells.prayerOfMending.lastCasted(4)' ,{
        {spells.flashHeal, 'player.hp < 0.55' , "player" ,"flashHeal_POM" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid ,"flashHeal_POM" },
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid ,"flashHeal_POM" },
    }},
    -- "Prayer of Mending" LASTCAST
    {{"nested"}, 'not player.isMoving and spells.prayerOfMending.lastCasted(4)' ,{
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "POH_POM" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3' , kps.heal.lowestTankInRaid , "POH_POM" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2 and not player.isInRaid' , kps.heal.lowestInRaid , "POH_POM" },
    }},
    -- "Prayer of Healing"
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3' , kps.heal.lowestTankInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2 and not player.isInRaid' , kps.heal.lowestInRaid , "POH" },

    {{"nested"}, 'player.isMoving' ,{
        {spells.renew, 'heal.lowestTankInRaid.hpIncoming < 0.80 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid },
        {spells.renew, 'player.hpIncoming < 0.80 and not player.hasBuff(spells.renew)' , "player" },
        {spells.powerWordShield, 'player.hp < 0.65 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.65 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid },
        {spells.renew, 'heal.lowestInRaid.hpIncoming < 0.65 and not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid },
        {spells.renew, 'heal.lowestInRaid.hpIncoming < 0.80 and not heal.lowestInRaid.hasBuff(spells.renew) and not player.isInRaid' , kps.heal.lowestInRaid },
        {spells.holyNova, 'heal.countLossInDistance(0.85,10) > 2' , "target" },
    }},

    -- "Flash Concentration" -- Reduces the cast time of your Heal by 0.2 sec and increases its healing by 3%. 15 seconds remaining -- IsEquippedItem(173249)
    {spells.heal, 'not player.isMoving and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and heal.lowestInRaid.hp < 0.80  and not spells.heal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "heal_lowest_Concentration" },
    {spells.heal, 'not player.isMoving and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and heal.lowestInRaid.hpIncoming  < 0.80 and heal.lowestInRaid.hpIncoming  < heal.lowestTankInRaid.hpIncoming ' , kps.heal.lowestInRaid , "heal_lowest_Concentration" },
    {spells.heal, 'not player.isMoving and player.hasBuff(spells.flashConcentration) and player.buffStacks(spells.flashConcentration) > 3 and heal.lowestTankInRaid.hpIncoming  < 0.80' , kps.heal.lowestTankInRaid , "heal_tank_Concentration"  },

    -- DAMAGE
    {spells.shadowWordDeath, 'target.isAttackable and target.hp < 0.20' , "target" , "shadowWordDeath" },
    {spells.shadowWordDeath, 'mouseover.inCombat and mouseover.isAttackable and mouseover.hp < 0.20' , "mouseover" , "shadowWordDeath" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("target") and heal.lowestInRaid.hp > 0.70' , "target" },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4.8 and not spells.shadowWordPain.isRecastAt("mouseover") and heal.lowestInRaid.hp > 0.70' , "mouseover" },
    {{"nested"}, 'kps.multiTarget and target.isAttackable' , {
        {spells.powerInfusion, 'not player.isInGroup and target.hp > 0.55' , env.damageTarget },
        {spells.powerInfusion, 'not player.isInGroup and target.isElite and target.hp > 0.20' , env.damageTarget },
        {spells.holyWordChastise, 'true' , env.damageTarget },
        {spells.holyFire, 'not player.isMoving' , env.damageTarget },
        {spells.mindgames, 'not player.isMoving' , env.damageTarget },
        {spells.smite, 'not player.isMoving' , env.damageTarget },
        {spells.holyNova, 'target.distance <= 10' , "target" },
    }},

    -- "Soins rapides" PARTY
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.65 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming and not player.isInRaid' , kps.heal.lowestInRaid , "flashHeal_lowest" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.65 and not player.isInRaid' , kps.heal.lowestTankInRaid , "flashHeal_tank"  },
    -- "Soins rapides"
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "flashHeal_lowest" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "flashHeal_tank"  },
    -- "Soins"
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.85' , kps.heal.lowestTankInRaid , "heal_tank" },

    {spells.smite, 'not player.isMoving', env.damageTarget },

}
,"priest_holy_shadowlands")

--AZERITE
-- "Vitality Conduit"
--{spells.azerite.vitalityConduit, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
--"Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
--{spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
-- "Concentrated Flame"
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
--{spells.azerite.concentratedFlame, 'target.isAttackable' , "target" },


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


