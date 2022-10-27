--[[[
@module Priest Holy Rotation
@author htordeux
@version 9.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest

local HolyWordSanctify = spells.holyWordSanctify.name
local SpiritOfRedemption = spells.spiritOfRedemption.name
local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name
local DoorOfShadows = spells.doorOfShadows.name

kps.runAtEnd(function()
kps.gui.addCustomToggle("PRIEST","HOLY", "control", "Interface\\Icons\\spell_nature_slow", "control")
end)


local damageRotation = {
    {spells.shadowWordDeath, 'target.hp < 0.20 and player.hp > 0.55', "target" },
    {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("target")' , "target" },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("mouseover")' , "mouseover" },
    {spells.powerInfusion, 'kps.groupSize() == 1' },
    {spells.holyWordChastise, 'true' , "target" },
    {spells.holyFire, 'not player.isMoving' , "target" },
    {spells.smite, 'not player.isMoving' , "target" },
    {spells.holyNova, 'player.isMoving'},
}

-- kps.defensive to avoid overheal
kps.rotations.register("PRIEST","HOLY",
{
    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.countInRange == 0' , "/cancelaura "..SpiritOfRedemption },
    {spells.holyWordSerenity, 'player.hasBuff(spells.spiritOfRedemption)' , kps.heal.lowestInRaid},
    {spells.prayerOfMending, 'player.hasBuff(spells.spiritOfRedemption)' , kps.heal.lowestInRaid},
    {spells.circleOfHealing, 'player.hasBuff(spells.spiritOfRedemption)' , kps.heal.lowestInRaid},
    {spells.flashHeal, 'player.hasBuff(spells.spiritOfRedemption)' , kps.heal.lowestInRaid},

    {spells.powerWordFortitude, 'not player.hasBuff(spells.powerWordFortitude) and not player.isInGroup', "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isHealable and mouseover.isRaidTank' , "/focus mouseover" },
    
    -- "Flash Concentration" -- Reduces the cast time of your Heal by 0.2 sec and increases its healing by 3%. 20 seconds remaining
    {spells.flashHeal, 'not player.isMoving and IsEquippedItem(178927) and not player.hasBuff(spells.flashConcentration)', kps.heal.lowestInRaid , "flashHeal_Concentration_buff" },
    {{"nested"}, 'player.hasBuff(spells.flashConcentration) and player.hasBuff(spells.surgeOfLight)' ,{
        {spells.flashHeal, 'player.buffDuration(spells.surgeOfLight) < 5' , kps.heal.lowestInRaid , "flashHeal_duration_surge"  },
        {spells.flashHeal, 'player.buffDuration(spells.flashConcentration) < 5' , kps.heal.lowestInRaid , "flashHeal_concentration_surge" },
        {spells.flashHeal, 'player.buffStacks(spells.flashConcentration) < 4' , kps.heal.lowestInRaid , "flashHeal_stacks_surge" },
    }},
    {{"nested"}, 'player.hasBuff(spells.flashConcentration) and not player.hasBuff(spells.surgeOfLight)' ,{
        {spells.flashHeal, 'not player.isMoving and player.buffDuration(spells.flashConcentration) < 6 and not spells.flashHeal.isRecastAt("player")' , "player", "flashHeal_concentration_player" },
    }},
    
    {spells.desperatePrayer, 'player.hp < 0.55' , "player" },  
    -- "Dispel" "Purifier"
    {spells.purify, 'target.isDispellable("Magic")' , "target" },    
    -- "Dissipation de masse"
    --{{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@player] "..MassDispel },
    {{"macro"}, 'keys.ctrl and spells.massDispel.cooldown == 0', "/cast [@cursor] "..MassDispel },
    -- "Holy Word: Sanctify"
    {{"macro"}, 'keys.shift and spells.holyWordSanctify.cooldown == 0', "/cast [@cursor] "..HolyWordSanctify },
    {{"macro"}, 'heal.countLossInDistance(0.85) > 2 and spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },    
    -- "Shackle Undead"
    {spells.shackleUndead, 'kps.control and not player.isMoving and target.isAttackable and not target.incorrectTarget and not target.hasDebuff(spells.shackleUndead)' , "target" },
    -- "Leap of Faith"
    {spells.leapOfFaith, 'keys.alt and mouseover.isFriend and spells.leapOfFaith.cooldown == 0', "mouseover" },
    -- "Fade"
    {spells.fade, 'player.isTarget' },
    {spells.fade, 'player.incomingDamage > player.incomingHeal and player.hp < 0.70' },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,3) and not player.isSwimming and player.isMovingSince(2) and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Levitate" 1706
    --{spells.levitate, 'player.IsFallingSince(1.4) and not player.hasBuff(spells.levitate)' , "player" },
    
    -- "Guardian Spirit" 47788
    {spells.guardianSpirit, 'player.hasTalent(3,2) and targettarget.isFriend and targettarget.hp < 0.40' , "targettarget" },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and player.hp < 0.40' , "player" },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and focus.isFriend and focus.hp < 0.40' , "focus" },
    {spells.guardianSpirit, 'player.hasTalent(3,2) and heal.lowestInRaid.hp < 0.30' ,  kps.heal.lowestInRaid },
    {spells.guardianSpirit, 'targettarget.isFriend and targettarget.hp < 0.30' , "targettarget" },
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.guardianSpirit, 'player.hp < 0.30' , "player" },
    {spells.guardianSpirit, 'focus.isFriend and focus.hp < 0.30' , "focus" },
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'mouseover.isFriend and mouseover.hp < 0.70' , "mouseover" },
    {spells.holyWordSerenity, 'targettarget.isFriend and targettarget.hp < 0.70' , "targettarget" },
    {spells.holyWordSerenity, 'target.isFriend and target.hp < 0.70' , "target" },
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'player.hp < 0.70' , "player"},
    {spells.holyWordSerenity, 'focus.isFriend and focus.hp < 0.70' , "focus" },
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },

    -- NECROLORD
    --{spells.fleshcraft, 'not player.isMoving' , "player" },
    --{spells.unholyNova, 'not player.isMoving' },
    -- VENTHYR
    --{spells.mindgames, 'not player.isMoving and target.isAttackable' , "target" },
    --{{"macro"}, ' keys.alt and not player.isMoving and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NIGHTFAE
    -- Haunted Mask prioritise the CDR from Benevolent Faerie over the DR from Guardian Faerie
    -- guardianFaerie DR -- buff Reduces damage taken by 20%. Follows your Power Word: Shield.
    -- benevolentFaerie CDR -- buff Increases the cooldown recovery rate of your target's major ability by 100%. Follows your Flash Heal (holy) Shadow Mend (shadow,disc)  
    -- wrathfulFaerie MANA -- debuff target -- Any direct attacks against the target restore 0.5% Mana or 3 Insanity. Follows your Shadow Word: Pain
    -- faeGuardians on Enemy -- Guardian Faerie and Benevolent Faerie are applied to yourself, Wrathful Faerie is applied to your enemy target.
    -- faeGuardians on Friendly -- Guardian Faerie and Benevolent Faerie are applied to your friendly target, Wrathful Faerie is applied to a nearby enemy target.
    {spells.powerWordShield, 'targettarget.isFriend and target.isAttackable and target.hasMyDebuff(spells.wrathfulFaerie) and not targettarget.hasMyBuff(spells.guardianFaerie)' , "targettarget" },
    {spells.shadowWordPain, 'target.isAttackable and not target.hasMyDebuff(spells.wrathfulFaerie) and player.hasBuff(spells.benevolentFaerie)',  "target" },
    --{spells.faeGuardians, 'target.isFriend and target.isRaidDamager and target.name == "Klïnda"' , "target" },
    --{spells.faeGuardians, 'target.isFriend and target.isRaidDamager and target.name == "Olimphy"' , "target" },
    {spells.faeGuardians, 'player.mana < 0.85 and target.isAttackable and not target.hasMyDebuff(spells.wrathfulFaerie) and not player.hasBuff(spells.benevolentFaerie)' , "target" },
    {spells.faeGuardians, 'spells.divineHymn.cooldown > 10 and target.isAttackable and not target.hasMyDebuff(spells.wrathfulFaerie) and not player.hasBuff(spells.benevolentFaerie)' , "target" },

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100%
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.lowestInRaid.hp < 0.40' },
    {spells.apotheosis, 'player.hasTalent(7,2) and heal.countLossInRange(0.70) > 2 and not player.isInRaid' },
    {spells.powerInfusion, 'heal.countLossInRange(0.55) > 2 and not player.isInRaid' , "player" },
    --{spells.powerInfusion, 'mouseover.isFriend and mouseover.isRaidDamager and mouseover.isClassName("WARLOCK")', "mouseover" },
    --{spells.powerInfusion, 'mouseover.isFriend and mouseover.isRaidDamager and mouseover.isClassName("MAGE")', "mouseover" },
    --{spells.powerInfusion, 'mouseover.isFriend and mouseover.isRaidDamager and mouseover.isClassName("DRUID")', "mouseover" },
    -- RAID UNIT BUFF
    --{spells.powerInfusion, 'mouseover.isFriend and mouseover.isRaidDamager and mouseover.name == "Olimphy"', "mouseover" },
    {spells.powerInfusion, 'focus.isFriend and focus.name == "Olimphy" and kps.timers.check("powerInfusion") > 0', "focus" },

    -- LOWEST URGENCE
    {spells.flashHeal, 'not player.isMoving and and IsEquippedItem(178927) and player.buffStacks(spells.flashConcentration) < 3 and heal.lowestInRaid.hp < 0.55', kps.heal.lowestInRaid },
    {spells.heal, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.85' , "mouseover" },
    {spells.heal, 'not player.isMoving and target.isFriend and target.hpIncoming < 1 and not target.isInRaid', "target" },
    {spells.heal, 'not player.isMoving and player.hasBuff(spells.divineConversation) and heal.lowestInRaid.hp < 0.85 and not spells.heal.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid  , "divineConversation" },
    {spells.heal, 'not player.isMoving and player.hasBuff(spells.divineConversation) and spells.holyWordSerenity.cooldown > 30 and not spells.heal.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid  , "divineConversation" },
    -- "Prayer of Mending"
    {spells.prayerOfMending, 'not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending) and heal.lowestInRaid.hp > 0.55' , kps.heal.lowestTankInRaid },
    {spells.circleOfHealing, 'heal.countLossInRange(0.85) > 2' , kps.heal.lowestInRaid },
    -- LOWEST URGENCE
    {spells.heal, 'not player.isMoving and target.isFriend and target.hp < 0.55' , "target" },
    {spells.heal, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.55' , "targettarget" },
    {spells.heal, 'not player.isMoving and player.hp < 0.55', "player" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55', kps.heal.lowestTankInRaid },
    {spells.heal, 'not player.isMoving and focus.isFriend and focus.hp < 0.55', "focus" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.55', kps.heal.lowestInRaid },

    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},
    {{"nested"}, 'kps.interrupt' ,{
        {spells.dispelMagic, 'target.isAttackable and target.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "target" },
        {spells.dispelMagic, 'mouseover.isAttackable and mouseover.isBuffDispellable and not spells.dispelMagic.lastCasted(9)' , "mouseover" },
        {spells.holyWordChastise, 'player.hasTalent(4,2) and target.isInterruptable and target.isCasting and target.castTimeLeft < 2' , "target" },
        {spells.holyWordChastise, 'player.hasTalent(4,2) and mouseover.isInterruptable and mouseover.isCasting and mouseover.castTimeLeft < 2' , "mouseover" },
        {spells.shiningForce, 'player.hasTalent(4,3) and player.isTarget and target.distanceMax  <= 10 and target.isCasting and target.castTimeLeft < 2' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and player.hasTalent(4,3) and spells.shiningForce.cooldown > 0 and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
        {spells.psychicScream, 'kps.groupSize() == 1 and not player.hasTalent(4,3) and player.isTarget and target.distanceMax  <= 10 and target.isCasting' , "player" },
    }},

    -- TRINKETS -- SLOT 0 /use 13 -- "Aigrette fumante" "Tuft of Smoldering Plumage"
    {{"macro"}, 'player.useTrinket(0) and target.isFriend and target.hp < 0.70 and kps.timeInCombat > 5' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and mouseover.isFriend and mouseover.hp < 0.70 and kps.timeInCombat > 5' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and targettarget.isHealable and targettarget.hp < 0.70' , "/use [@targettarget] 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 15' , "/use 14" },
    
    {{"nested"}, 'player.isMoving' ,{
        {spells.renew, 'player.hp < 0.55 and not player.hasMyBuff(spells.renew)' , "player" },
        {spells.renew, 'heal.lowestTankInRaid.hp < 0.55 and not heal.lowestTankInRaid.hasMyBuff(spells.renew)' , kps.heal.lowestTankInRaid },
        {spells.renew, 'heal.lowestInRaid.hp < 0.55 and not heal.lowestInRaid.hasMyBuff(spells.renew)' , kps.heal.lowestInRaid },
        {spells.powerWordShield, 'player.hp < 0.55 and not player.hasDebuff(spells.weakenedSoul)' , "player" },
        {spells.powerWordShield, 'heal.lowestTankInRaid.hp < 0.55 and not heal.lowestTankInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestTankInRaid },
        {spells.powerWordShield, 'heal.lowestInRaid.hp < 0.55 and not heal.lowestInRaid.hasDebuff(spells.weakenedSoul)' , kps.heal.lowestInRaid },
    }},

    -- ShouldInterruptCasting
    {{"macro"}, 'spells.heal.shouldInterrupt(0.90, kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashHeal.shouldInterrupt(0.90, kps.defensive and player.buffDuration(spells.flashConcentration) > 9)' , "/stopcasting" }, 
    {{"macro"}, 'spells.prayerOfHealing.shouldInterrupt(heal.countLossInRange(0.90), kps.defensive)' , "/stopcasting" },
    -- DAMAGE
    {spells.divineStar, 'not player.isMoving and target.isAttackable and player.hasTalent(6,2) and target.distanceMax  <= 20' },
    {spells.halo, 'not player.isMoving and player.hasTalent(6,3) and heal.countLossInRange(0.85) > 2' },
    {{"nested"},'kps.multiTarget and not kps.control and target.isAttackable', damageRotation },
    -- "Flash Concentration"
    {spells.heal, 'not player.isMoving and mouseover.isFriend and mouseover.hp < 0.70' , "mouseover" },
    {spells.heal, 'not player.isMoving and target.isFriend and target.hp < 0.70' , "target" },
    {spells.heal, 'not player.isMoving and targettarget.isFriend and targettarget.hp < 0.70' , "targettarget" },
    {spells.heal, 'not player.isMoving and player.hp < 0.70', "player" },
    {spells.heal, 'not player.isMoving and focus.isFriend and focus.hp < 0.70' , "focus" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70', kps.heal.lowestTankInRaid },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.70', kps.heal.lowestInRaid  },
    -- DAMAGE
    {{"nested"}, 'not kps.control' ,{
        {spells.shadowWordPain, 'target.isAttackable and target.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("target") and not target.hasDebuff(spells.shackleUndead)' , "target" },
        {spells.shadowWordPain, 'targettarget.isAttackable and targettarget.myDebuffDuration(spells.shadowWordPain) < 5 and not spells.shadowWordPain.isRecastAt("targettarget") and not targettarget.hasDebuff(spells.shackleUndead)' , "targettarget" },
        {spells.holyWordChastise, 'target.isAttackable and not player.hasBuff(spells.divineConversation) and spells.holyWordSerenity.cooldown > 15 and not target.hasDebuff(spells.shackleUndead)' , "target" },
        {spells.holyWordChastise, 'targettarget.isAttackable and not player.hasBuff(spells.divineConversation) and spells.holyWordSerenity.cooldown > 15 and not targettarget.hasDebuff(spells.shackleUndead)' , "targettarget" },
    }},
    -- "Prayer of Healing" -- Holy Word: Sanctify Cooldown reduced by 6 sec when you cast Prayer of Healing and by 2 sec when you cast Renew.
    {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.85) > 2 and spells.holyWordSanctify.cooldown > 6 and not spells.prayerOfHealing.lastCasted(6)' , kps.heal.lowestInRaid },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85', kps.heal.lowestInRaid  },
    {spells.heal, 'not player.isMoving and mouseover.isFriend and mouseover.hpIncoming < 0.85' , "mouseover" },
    {spells.heal, 'not player.isMoving and target.isFriend and target.hpIncoming < 0.85' , "target" },
    {spells.heal, 'not player.isMoving and targettarget.isFriend and targettarget.hpIncoming < 0.85' , "targettarget" },
    {spells.heal, 'not player.isMoving and focus.isFriend and focus.hpIncoming < 0.85', "focus" },
    -- DAMAGE
    --{spells.holyFire, 'not player.isMoving and not kps.control and target.isAttackable and not target.hasDebuff(spells.shackleUndead)' , "target" },
    {spells.smite, 'not player.isMoving and not kps.control and target.isAttackable and not target.hasDebuff(spells.shackleUndead)', "target" },
    {spells.smite, 'not player.isMoving and not kps.control and targettarget.isAttackable and not targettarget.hasDebuff(spells.shackleUndead)', "targettarget" },

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


