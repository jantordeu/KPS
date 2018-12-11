--[[[
@module Priest Holy Rotation
@author htordeux
@version 8.0.1
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local HolyWordSanctify = spells.holyWordSanctify.name
local SpiritOfRedemption = spells.spiritOfRedemption.name
local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","HOLY", "mouseOver", "Interface\\Icons\\priest_spell_leapoffaith_a", "mouseOver")
end)

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","HOLY", "holyNova", "Interface\\Icons\\spell_holy_holynova", "holyNova")
end)

-- kps.defensive to avoid overheal


kps.rotations.register("PRIEST","HOLY",{

    {spells.powerWordFortitude, 'not player.isInGroup and not player.hasBuff(spells.powerWordFortitude)', "player" },

    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.holyWordSanctifyMessage,
    --env.ShouldInterruptCasting,
    {{"macro"}, 'spells.heal.shouldInterrupt(0.95)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.85)' , "/stopcasting" },
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.85))' , "/stopcasting" },

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.isUnit("player")' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption) and not heal.lowestInRaid.isUnit("player")' ,{
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.divineHymn},
        {spells.prayerOfHealing, 'kps.lastCast["name"] == spells.flashHeal' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid},
        {spells.renew, 'not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid},
    }},
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.35' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'player.hp < 0.35' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'kps.mouseOver and mouseover.isHealable and mouseover.hp < 0.35' , "mouseover" },
    --{spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.35' , kps.heal.lowestInRaid},
    
    -- "Holy Word: Serenity" -- set at 0.55 to avoid spam FH
    {{spells.holyWordSerenity,spells.prayerOfHealing}, 'not player.isMoving and heal.countLossInRange(0.78) > 2 and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "POH_holyWordSerenity" },
    {{spells.holyWordSerenity,spells.prayerOfHealing}, 'not player.isMoving and heal.countLossInRange(0.78) > 2 and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid , "POH_holyWordSerenity" },
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'player.hp < 0.40' , "player"},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},
    {spells.holyWordSerenity, 'kps.mouseOver and mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" },
    
    -- "Holy Word: Sanctify"
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HolyWordSanctify },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    --{spells.divineHymn, 'keys.alt and not player.isMoving and heal.countLossInRange(0.72) * 2 > heal.countInRange' },
    --{spells.holyWordSalvation, 'keys.alt and player.hasTalent(7,3) and not player.isMoving and heal.countLossInRange(0.65) * 2 > heal.countInRange' },
    --{spells.symbolOfHope, 'not player.isMoving and heal.lowestInRaid.hp > 0.85 and player.mana < 0.55' },

    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },
    {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },

    {{"nested"}, 'kps.interrupt' ,{
        {spells.holyWordChastise, 'target.isAttackable and target.isCasting' , "target" },
        {spells.holyWordChastise, 'mouseover.isAttackable and mouseover.isCasting' , "mouseover" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and player.plateCount >= 3' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and player.isTarget and spells.shiningForce.cooldown > 0 and target.distance <= 10 and player.plateCount >= 3' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and player.plateCount >= 3' , "player" },
    }},

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.hasBossDebuff' , kps.heal.hasBossDebuff },
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},

    {spells.giftOfTheNaaru, 'player.hp < 0.72' , "player" },
    {spells.desperatePrayer, 'player.hp < 0.72' , "player" },
    {{"macro"}, 'player.hp < 0.72 and player.useItem(5512) and ' ,"/use item:5512" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.65 and not spells.flashHeal.isRecastAt("player")' , "player" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingFor(1.2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.2) and not player.hasBuff(spells.levitate)' , "player" },

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.55 and heal.countLossInRange(0.78) > 2' },

    -- "Surge Of Light"
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.buffStacks(spells.surgeOfLight) == 2' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.72' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 4' , kps.heal.lowestInRaid},
    }},
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid }, 
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.40' , kps.heal.hasNotBuffMending , "POM" },
    -- kps.lastCast["name"] ne fonctionne pas si lastCast etait une macro 'kps.lastCast["name"] == spells.prayerOfMending' or 'spells.prayerOfMending.lastCasted(4)'
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfMending.lastCasted(4) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid ,"FLASH_POM" },
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfMending.lastCasted(4) and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_POM" },
    {spells.flashHeal, 'kps.mouseOver and mouseover.isHealable and not player.isMoving and mouseover.hp < 0.55' , "mouseover" ,"FLASH_mouseover" },
    {spells.bindingHeal, 'kps.mouseOver and mouseover.isHealable and not player.isMoving and player.hasTalent(5,2) and not mouseover.isUnit("player")' , "mouseover" ,"BINDING_mouseover" },

    -- TRINKETS
    -- SLOT 0 /use 13
    -- "Inoculating Extract" 160649 -- "Extrait d’inoculation" 160649
    {{"macro"}, 'player.hasTrinket(0) == 160649 and player.useTrinket(0) and targettarget.exists and targettarget.isFriend' , "/use [@targettarget] 13" },
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(0)' , "/use 13" },
    -- SLOT 1 /use 14
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(1) and heal.lowestInRaid.hp < 0.85' , "/use 14" },

    {spells.holyNova, 'kps.holyNova and target.distance < 10' , "target" },
    {spells.circleOfHealing, 'heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid  },
    {spells.circleOfHealing, 'heal.lowestTankInRaid.hp < 0.90 and heal.lowestUnitInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
    {spells.circleOfHealing, 'heal.lowestTankInRaid.hp < 0.85 and player.isMoving' , kps.heal.lowestTankInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 4' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85)*2 > heal.countInRange' , kps.heal.lowestInRaid },
    {spells.divineStar, 'player.hasTalent(6,2) and targettarget.isHealable and targettarget.hp < 0.90 and target.isAttackable and target.distance <= 30' , "target" },

    -- "Holy Word: Sanctify" -- macro does not work for @target, @mouseover... ONLY @cursor and @player -- Cooldown reduced by 6 sec when you cast Prayer of Healing and by 2 sec when you cast Renew
    {{"macro"},'heal.countLossInDistance(0.82,10) > 4' , "/cast [@player] "..HolyWordSanctify },
    {{"macro"},'player.isMoving and heal.countLossInDistance(0.82,10) > 2' , "/cast [@player] "..HolyWordSanctify },
    -- "Prayer of Healing" 596
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfHealing.lastCasted(4) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid ,"FLASH_POH" },
    {{spells.renew,spells.prayerOfHealing}, 'not player.isMoving and heal.countLossInRange(0.78) > 4 and heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid , "POH_renew" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.78) > 4' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.78)*2 > heal.countInRange' , kps.heal.lowestInRaid , "POH" },
    -- "Soins rapides" 2060 Important Unit
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 not spells.flashHeal.isRecastAt("player")' , "player" , "FLASH_PLAYER"  },

    -- DAMAGE
    {spells.holyNova, 'player.isMoving and target.distance < 10 and heal.countLossInDistance(0.85,10) > 2' , "target" },
    {spells.holyFire, 'heal.lowestInRaid.hp > 0.55' , env.damageTarget },
    {{"nested"}, 'kps.multiTarget' , {
       {spells.prayerOfMending, 'not player.isMoving and heal.hasBuffStacks(spells.prayerOfMending) < 5' , kps.heal.hasNotBuffMending },
       {spells.holyWordChastise, 'target.isAttackable' , "target" },
       {spells.holyWordChastise, 'targettarget.isAttackable', "targettarget" },
       {spells.holyWordChastise, 'focustarget.isAttackable', "focustarget" },
       {spells.holyFire, 'target.isAttackable' , "target" },
       {spells.holyFire, 'targettarget.isAttackable', "targettarget" },
       {spells.holyFire, 'focustarget.isAttackable', "focustarget" },
       {spells.holyNova, 'kps.holyNova and target.distance < 10 and target.isAttackable' , "target" },
       {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
       {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
       {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },
    }},

    -- "Renew" 139 
    {{"nested"}, 'player.isMoving' ,{
        {spells.renew, 'not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
        {spells.renew, 'kps.mouseOver and mouseover.isHealable and mouseover.hp < 0.90 and not mouseover.hasBuff(spells.renew)' , "mouseover" },
        {spells.renew, 'player.hp < 0.90 and not player.hasBuff(spells.renew)' , "player" },
        {spells.renew, 'heal.lowestInRaid.hp < 0.90 and not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid, "RENEW_LOWEST" },
    }},
    {spells.renew, 'heal.lowestTankInRaid.hpIncoming < 0.90 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
    -- "Soins rapides" 2060 RAID
    {spells.flashHeal, 'not player.isMoving and heal.lowestUnitInRaid.hp < 0.40 and heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestUnitInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 and player.hp < heal.lowestTankInRaid.hp' , "player" , "FLASH_PLAYER"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    -- "Soins rapides" 2060 PARTY
    {spells.flashHeal, 'not player.isMoving and heal.countInRange <= 5 and heal.lowestUnitInRaid.hp < 0.65 and heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestUnitInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.countInRange <= 5 and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid , "FLASH_TANK" },
    -- "Soins de lien" 32546 -- lowestUnitInRaid ~= lowestTankInRaid
    {{"nested"}, 'not player.isMoving and player.hasTalent(5,2) and heal.lowestTankInRaid.hp < 0.85 and heal.lowestUnitInRaid.hp < 0.85' , {
        {spells.bindingHeal, 'heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp and not heal.lowestUnitInRaid.isUnit("player")' , kps.heal.lowestUnitInRaid ,"BINDING_LOWEST" },
        {spells.bindingHeal, 'heal.lowestUnitInRaid.hp > heal.lowestTankInRaid.hp and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid ,"BINDING_TANK" },
    }},
    -- "Soins" 2060
    {spells.heal, 'not player.isMoving and spells.holyWordSerenity.cooldown > 6' , kps.heal.lowestInRaid },
    {spells.renew, 'player.hpIncoming < 0.90 and not player.hasBuff(spells.renew)' , "player", "RENEW_PLAYER" },
    {spells.renew, 'heal.countInRange <= 5 and heal.lowestUnitInRaid.hpIncoming < 0.90 and not heal.lowestUnitInRaid.hasBuff(spells.renew)' , kps.heal.lowestUnitInRaid, "RENEW_LOWEST" },
    {spells.heal, 'kps.mouseOver and mouseover.isHealable and not player.isMoving and mouseover.hpIncoming < 0.90' , "mouseover" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.90' , kps.heal.lowestInRaid , "heal_lowest" },
    
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


