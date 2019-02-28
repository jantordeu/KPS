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
    env.haloMessage,
    --env.ShouldInterruptCasting,
    {{"macro"}, 'spells.heal.shouldInterrupt(0.95)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.85)' , "/stopcasting" },
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.80))' , "/stopcasting" },

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.isUnit("player")' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption) and not heal.lowestInRaid.isUnit("player")' ,{
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.divineHymn},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid},
        {spells.renew, 'not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid},
    }},
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget and player.isInGroup' },
    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'player.hp < 0.30' , kps.heal.lowestTankInRaid},
    --{spells.guardianSpirit, 'target.isRaidBoss and targettarget.isHealable and not targettarget.isRaidTank' , "targettarget" },
    {spells.guardianSpirit, 'mouseover.isHealable and mouseover.hp < 0.30' , "mouseover" },
    {spells.guardianSpirit, 'focus.isHealable and focus.hp < 0.30' , "focus" },
    --{spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
    
    -- "Holy Word: Serenity" -- set at 0.55 to avoid spam FH
    {{spells.holyWordSerenity,spells.prayerOfHealing}, 'not player.isMoving and heal.countLossInRange(0.80) > 2 and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "POH_holyWordSerenity" },
    {{spells.holyWordSerenity,spells.prayerOfHealing}, 'not player.isMoving and heal.countLossInRange(0.80) > 2 and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid , "POH_holyWordSerenity" },
    {spells.holyWordSerenity, 'mouseover.isHealable and mouseover.hp < 0.40' , "mouseover" },
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'player.hp < 0.40' , "player"},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Holy Word: Sanctify" -- macro does not work for @target, @mouseover... ONLY @cursor and @player -- Cooldown reduced by 6 sec when you cast Prayer of Healing and by 2 sec when you cast Renew
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"}, 'mouseover.isHealable and mouseover.isRaidTank and mouseover.hp < 0.80', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"},'heal.countLossInDistance(0.80,10) > 2' , "/cast [@player] "..HolyWordSanctify },

    -- "Dispel" "Purifier" 527
    {spells.purify, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
    }},
    -- "Dissipation de la magie" -- Dissipe la magie sur la cible ennemie, supprimant ainsi 1 effet magique bénéfique.
    {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "target" },
    {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(6)' , "mouseover" },

    {{"nested"}, 'kps.interrupt' ,{
        {spells.holyWordChastise, 'player.hasTalent(4,2) and target.isAttackable and target.isCasting' , "target" },
        {spells.holyWordChastise, 'player.hasTalent(4,2) and mouseover.isAttackable and mouseover.isCasting' , "mouseover" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'not player.hasTalent(4,3) and player.isTarget and target.distance <= 10 and target.isCasting' , "player" },
    }},

    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    {{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' ,"/use item:5512" },
    -- "Soins rapides" 2060 Important Unit
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and not spells.flashHeal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 not spells.flashHeal.isRecastAt("player")' , "player" , "FLASH_PLAYER"  },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingFor(1.2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    {spells.levitate, 'player.isFallingFor(1.2) and not player.hasBuff(spells.levitate)' , "player" },

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.55 and heal.countLossInRange(0.80)*2 >= heal.countInRange' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestTankInRaid.hp < 0.55 and heal.countLossInRange(0.80) > 3' },

    -- "Surge Of Light"
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.buffStacks(spells.surgeOfLight) == 2' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.72' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 4' , kps.heal.lowestInRaid},
    }},
    {spells.circleOfHealing, 'player.isMoving and heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid  },
    {spells.circleOfHealing, 'heal.lowestTankInRaid.hp < 0.90 and heal.lowestUnitInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
    {spells.circleOfHealing, 'heal.countLossInRange(0.90) > 2' , kps.heal.lowestInRaid },
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid }, 
    {spells.prayerOfMending, 'not player.isMoving' , kps.heal.hasNotBuffMending , "POM" },
    -- kps.lastCast["name"] ne fonctionne pas si lastCast etait une macro 'kps.lastCast["name"] == spells.prayerOfMending' or 'spells.prayerOfMending.lastCasted(4)'
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfMending.lastCasted(4) and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid ,"FLASH_POM" },
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfMending.lastCasted(4) and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_POM" },
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfHealing.lastCasted(4) and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid ,"FLASH_POH" },
    {spells.flashHeal, 'not player.isMoving and spells.prayerOfHealing.lastCasted(4) and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_POH" },

    -- TRINKETS
    -- SLOT 0 /use 13
    -- "Inoculating Extract" 160649 -- "Extrait d’inoculation" 160649
    {{"macro"}, 'player.hasTrinket(0) == 160649 and player.useTrinket(0) and targettarget.exists and targettarget.isFriend' , "/use [@targettarget] 13" },
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(0)' , "/use 13" },
    -- SLOT 1 /use 14
    {{"macro"}, 'player.timeInCombat > 30 and player.useTrinket(1) and heal.lowestInRaid.hp < 0.80' , "/use 14" },

    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90) > 2' , kps.heal.lowestInRaid },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.90)*2 >= heal.countInRange' , kps.heal.lowestInRaid },
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.90) > 2 and target.distance <= 30' , "target" },
    {spells.divineStar, 'player.hasTalent(6,2) and heal.countLossInRange(0.90)*2 >= heal.countInRange and target.distance <= 30' , "target" },
    {spells.holyNova, 'kps.holyNova' , "target" },

    -- "Prayer of Healing" 596
    {spells.prayerOfHealing, 'kps.mouseOver and mouseover.isHealable and not player.isMoving and mouseover.hpIncoming < 0.80 and heal.countLossInRange(0.80) > 3' , "mouseover" ,"POH_mouseover" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.80) > 2 and heal.countLossInRange(0.90) > 4' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.80) > 3' , kps.heal.lowestInRaid , "POH" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.80)*2 >= heal.countInRange' , kps.heal.lowestInRaid , "POH" },

    -- DAMAGE
    {{"nested"}, 'kps.multiTarget' , {
       {spells.prayerOfMending, 'not player.isMoving and heal.hasBuffStacks(spells.prayerOfMending) < 5' , kps.heal.hasNotBuffMending },
       {spells.holyWordChastise, 'target.isAttackable' , "target" },
       {spells.holyWordChastise, 'targettarget.isAttackable', "targettarget" },
       {spells.holyWordChastise, 'focustarget.isAttackable', "focustarget" },
       {spells.holyFire, 'target.isAttackable' , "target" },
       {spells.holyFire, 'targettarget.isAttackable', "targettarget" },
       {spells.holyFire, 'focustarget.isAttackable', "focustarget" },
       {spells.holyNova, 'kps.holyNova' , "target" },
       {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
       {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
       {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },
    }},
    
    -- "Renew" 139
    {{"nested"}, 'player.isMoving' ,{
        {spells.renew, 'heal.lowestTankInRaid.hp < 0.92 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
        {spells.renew, 'player.hp < 0.92 and not player.hasBuff(spells.renew)' , "player" },
        {spells.renew, 'mouseover.isHealable and mouseover.hp < 1 and not mouseover.hasBuff(spells.renew)' , "mouseover" },
        {spells.holyNova, 'heal.countLossInDistance(0.92,10) >= 3' , "target" },
        {spells.renew, 'heal.lowestInRaid.hp < 0.92 and not heal.lowestInRaid.hasBuff(spells.renew)' , kps.heal.lowestInRaid, "RENEW_LOWEST" },
    }},
    {{"nested"}, 'heal.countInRange <= 5' ,{
        {spells.renew, 'heal.lowestTankInRaid.hp < 0.90 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
        {spells.renew, 'heal.lowestUnitInRaid.hpIncoming < 0.90 and not heal.lowestUnitInRaid.hasBuff(spells.renew)' , kps.heal.lowestUnitInRaid, "RENEW_LOWEST" },
        {spells.flashHeal, 'not player.isMoving and heal.lowestUnitInRaid.hp < 0.65 and heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestUnitInRaid , "FLASH_LOWEST" },
        {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid , "FLASH_TANK" },
    }},
    -- "Soins rapides" 2060 RAID
    {spells.flashHeal, 'not player.isMoving and heal.lowestUnitInRaid.hp < 0.40 and heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestUnitInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 and player.hp < heal.lowestTankInRaid.hp' , "player" , "FLASH_PLAYER"  },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    -- "Soins de lien" 32546 -- lowestUnitInRaid ~= lowestTankInRaid
    {{"nested"}, 'not player.isMoving and player.hasTalent(5,2) and heal.lowestTankInRaid.hp < 0.90 and heal.lowestUnitInRaid.hp < 0.90' , {
        {spells.bindingHeal, 'heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp and not heal.lowestUnitInRaid.isUnit("player")' , kps.heal.lowestUnitInRaid ,"BINDING_LOWEST" },
        {spells.bindingHeal, 'heal.lowestUnitInRaid.hp > heal.lowestTankInRaid.hp and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid ,"BINDING_TANK" },
    }},
    -- "Soins" 2060
    {spells.renew, 'spells.holyWordSanctify.cooldown > 6 and heal.lowestTankInRaid.hp < 0.90 and not heal.lowestTankInRaid.hasBuff(spells.renew)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
    {spells.renew, 'spells.holyWordSanctify.cooldown > 6 and player.hp < 0.90 and not player.hasBuff(spells.renew)' , "player", "RENEW_PLAYER" },
    
    {{"nested"}, 'player.hasTalent(1,2) and heal.lossHealthRaid > 15000' , {
        {spells.heal, 'not spells.heal.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
        {spells.heal, 'not spells.heal.isRecastAt(heal.lowestUnitInRaid.unit)' , kps.heal.lowestUnitInRaid },
    }},
    
    {spells.heal, 'not player.isMoving and heal.lowestUnitInRaid.hpIncoming < 0.90 and heal.lowestUnitInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestUnitInRaid , "heal_lowest" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.95 and spells.holyWordSerenity.cooldown > 6' , kps.heal.lowestInRaid },

    {spells.holyFire, 'player.isMoving' , env.damageTarget },
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


