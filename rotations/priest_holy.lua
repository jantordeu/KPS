--[[[
@module Priest Holy Rotation
@author htordeux
@version 8.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local HolyWordSanctify = spells.holyWordSanctify.name
local SpiritOfRedemption = spells.spiritOfRedemption.name
local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name

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
    env.haloMessage,
    -- ShouldInterruptCasting
    {{"macro"}, 'spells.heal.shouldInterrupt(0.95, kps.defensive and spells.holyWordSerenity.cooldown < 6)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.85, kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.85), kps.defensive)' , "/stopcasting" },

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.isUnit("player")' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption) and not heal.lowestInRaid.isUnit("player")' ,{
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        --{spells.holyWordSalvation, 'player.hasTalent(7,3) and heal.countLossInRange(0.85) > 2'},
        {spells.circleOfHealing, 'true' , kps.heal.lowestInRaid},
        {spells.halo },
        {spells.prayerOfHealing, 'heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'true' , kps.heal.lowestInRaid},
    }},
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'player.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'focus.isHealable and focus.hp < 0.30' , "focus" },
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
 
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'player.hp < 0.65' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" },
    {spells.holyWordSerenity, 'heal.countLossInRange(0.80) > 2 and heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
    {spells.holyWordSerenity, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid},
    -- "Surge Of Light"
--    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
--        {spells.flashHeal, 'player.buffStacks(spells.surgeOfLight) == 2' , kps.heal.lowestInRaid},
--        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
--        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 4' , kps.heal.lowestInRaid},
--    }},

    -- BUTTON
    {spells.leapOfFaith, 'keys.alt and mouseover.isHealable', "mouseover" },

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Holy Word: Sanctify" -- macro does not work for @target, @mouseover -- ONLY @cursor and @player -- Cooldown reduced by 6 sec when you cast Prayer of Healing and by 2 sec when you cast Renew
    {{"macro"}, 'keys.shift and spells.holyWordSanctify.cooldown == 0', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.85,10) > 2 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.90,10) > 4 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
    {{"macro"}, 'mouseover.isHealable and mouseover.hp < 0.80 and spells.holyWordSanctify.cooldown == 0' , "/cast [@cursor] "..HolyWordSanctify },
    
    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},
    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {{"nested"}, 'kps.interrupt',{
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    }},
    
    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,2) and spells.holyWordSerenity.cooldown > 6 and heal.lowestTankInRaid.hp < 0.55'},
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.55 and heal.countLossInRange(0.85) > 3'},
    {{"nested"}, 'not player.isMoving and player.hasBuff(spells.apotheosis)',{
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK_apotheosis" },
        {spells.prayerOfHealing, 'heal.countLossInRange(0.85) > 3' , kps.heal.lowestInRaid , "POH_apotheosis" },
        {spells.prayerOfHealing, 'heal.countLossInRange(0.85) > 2 and heal.countLossInRange(0.90) > 4' , kps.heal.lowestInRaid , "POH" },
    }},

    {{"nested"}, 'kps.interrupt' ,{
        {spells.holyWordChastise, 'player.hasTalent(4,2) and target.isInterruptable and target.isCasting' , "target" },
        {spells.holyWordChastise, 'player.hasTalent(4,2) and mouseover.isInterruptable and mouseover.isCasting' , "mouseover" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
    }},

    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(1.6) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    
    --AZERITE
    -- "Vitality Conduit"
    {spells.azerite.vitalityConduit, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
    --"Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
    {spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
    {spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    -- "Concentrated Flame"
    {spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.65' , kps.heal.lowestInRaid },
    {spells.azerite.concentratedFlame, 'target.isAttackable' , "target" },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and heal.countLossInRange(0.85) > 2' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.hasTrinket(1) == 160649 and player.useTrinket(1) and targettarget.exists and targettarget.isHealable' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.hasTrinket(1) == 165569 and player.useTrinket(1) and player.hp < 0.65' , "/use [@player] 14" },

    {spells.holyNova, 'kps.holyNova and target.distance <= 10' , "target" },
    {spells.circleOfHealing, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
    {spells.circleOfHealing, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) > 4' , kps.heal.lowestInRaid },

    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },
    {spells.renew, 'player.hpIncoming < 0.70 and not player.hasBuff(spells.renew)' , "player" },    
    -- "Renew" 139
    {{"nested"}, 'player.isMoving' ,{
        {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid},
        {spells.holyWordSerenity, 'player.hp < 0.70' , "player"},
        {spells.renew, 'heal.lowestTankInRaid.hpIncoming < 0.90 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
        {spells.circleOfHealing, 'heal.lowestInRaid.hpIncoming < 0.90' , kps.heal.lowestInRaid  },
        {spells.renew, 'player.hpIncoming < 0.90 and not player.hasBuff(spells.renew)' , "player" },
        {spells.renew, 'mouseover.isHealable and mouseover.hpIncoming < 0.95 and not mouseover.hasBuff(spells.renew)' , "mouseover" },
        {spells.holyNova, 'heal.countLossInDistance(0.90,10) > 2' , "target" },
        {spells.renew, 'heal.lowestInRaid.hpIncoming < 0.90 and not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid, "RENEW_LOWEST" },
    }},
    
    -- "Soins rapides" 2060 Important Unit
    {{"nested"}, 'not player.isMoving and spells.prayerOfHealing.lastCasted(3.4)' ,{
        {spells.flashHeal, 'player.hp < 0.55' , "player" ,"FLASH_POH" },
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid ,"FLASH_POH" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_POH" },
    }},
    {{"nested"}, 'not player.isMoving and spells.prayerOfMending.lastCasted(3.4)' ,{
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "POH" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3' , kps.heal.lowestTankInRaid , "POH" },
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid ,"FLASH_POM" },
        {spells.flashHeal, 'player.hp < 0.55' , "player" ,"FLASH_POM" },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_POM" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid , "POH" },
    }},
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid },
    {spells.prayerOfMending, 'not player.isMoving' , kps.heal.hasNotBuffMending , "POM" },

    -- MOUSEOVER
    {spells.flashHeal, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.55 and not spells.flashHeal.isRecastAt("mouseover")' , "mouseover" , "FLASH_mouseover" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 and not spells.flashHeal.isRecastAt("player")' , "player" ,"FLASH_player" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid ,"FLASH_tank" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid ,"FLASH_lowest" },

    -- "Prayer of Healing" 596
    {spells.prayerOfHealing, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.80 and heal.countLossInRange(0.80) > 2' , "mouseover" ,"POH_mouseover" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2 and player.isInGroup' , kps.heal.lowestInRaid , "POH_party" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2 and heal.countLossInRange(0.90) > 4' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 3' , kps.heal.lowestTankInRaid , "POH" },

    -- DAMAGE
    {{"nested"}, 'kps.multiTarget and target.isAttackable and heal.lowestInRaid.hp > 0.85' , {
       {spells.holyWordChastise, 'true' , env.damageTarget },
       {spells.holyFire, 'true' , env.damageTarget },
       {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) > 4' },
       {spells.smite, 'not player.isMoving' , env.damageTarget },
    }},

    -- "Soins rapides" 2060 GROUP
    {{"nested"}, 'not player.isInRaid' ,{
        {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.65 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid , "FLASH_TANK" },
        {spells.renew, 'player.hpIncoming < 0.90 and not player.hasBuff(spells.renew)' , "player" },
        {spells.renew, 'heal.lowestTankInRaid.hp < 0.90 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
        {spells.renew, 'heal.lowestInRaid.hpIncoming < 0.90 and not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid, "RENEW_LOWEST" },
    }},
    -- "Soins rapides" 2060 RAID
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55' , "player" , "FLASH_PLAYER"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    -- "Soins"
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.90 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    {spells.heal, 'not player.isMoving and spells.holyWordSerenity.cooldown > 6' , kps.heal.lowestInRaid , "heal_serenity" },

    --{spells.holyFire, 'player.isMoving' , env.damageTarget },
    {spells.smite, 'not player.isMoving', env.damageTarget },

}
,"priest_holy_bfa")


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


