--[[[
@module Paladin Holy Rotation
@author htordeux
@version 9.0.5
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

local AshenHallow = spells.ashenHallow.name 
local DoorOfShadows = spells.doorOfShadows.name
local LightsHammer = spells.lightsHammer.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","HOLY", "damage", "Interface\\Icons\\spell_holy_avenginewrath", "damage")
end)

local damageRotation = {
    {spells.judgment, 'true' , env.damageTarget },
    {spells.holyShock, 'true' , env.damageTarget },
    {spells.divineToll, 'kps.multiTarget' , env.damageTarget },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath)' }, 
    {spells.shieldOfTheRighteous, 'true' , env.damageTarget }, -- cost 3 holy power
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and target.isAttackable and target.distanceMax <= 10 and not player.isMovingSince(2)', "/cast [@player] "..LightsHammer},
    {spells.crusaderStrike, 'target.isAttackable and target.distanceMax <= 10' , env.damageTarget},
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.isAttackable and target.distanceMax <= 10' },
}

kps.rotations.register("PALADIN","HOLY",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseovertarget.isFriend' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isHealable and mouseover.isRaidTank' , "/focus mouseover" },

    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },

    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'player.hp < 0.70' , "player"},
    -- "Unending Light -- Each Holy Power spent on Light of Dawn increases the healing of your next Word of Glory by 5%, up to a maximum of 45%.
    {spells.wordOfGlory, 'player.hp < 0.40 and player.hasBuff(spells.unendingLight)' , "player" },
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.40 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and player.hasBuff(spells.unendingLight)' , kps.heal.lowestInRaid },
    {spells.wordOfGlory, 'heal.lowestTankInRaid.hp < 0.40 and player.hasBuff(spells.unendingLight)' , kps.heal.lowestTankInRaid },
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.35 and not heal.lowestTankInRaid .hasDebuff(spells.forbearance)' , kps.heal.lowestTankInRaid },
    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    {spells.blessingOfProtection, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.35 and not heal.lowestInRaid.isRaidTank and not heal.lowestInRaid.hasDebuff(spells.forbearance)' , kps.heal.lowestInRaid },
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)', "player" },
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.35 and not heal.lowestTankInRaid.hasDebuff(spells.forbearance)', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'heal.lowestInRaid.hp < 0.35 and not heal.lowestInRaid.hasDebuff(spells.forbearance)', kps.heal.lowestInRaid },
    -- "Bénédiction de sacrifice" dure 12 s ou player.hp < 0.20. Réduit les dégâts subis de 30%, mais vous transfère 100% des dégâts évités.
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.55 and player.hpIncoming > 0.80 and not heal.lowestTankInRaid.isUnit("player")', kps.heal.lowestTankInRaid },
    {spells.blessingOfSacrifice, 'focus.hp < 0.55 and player.hpIncoming > 0.80 and focus.isRaidTank', "focus" },
    {spells.blessingOfSacrifice, 'heal.lowestInRaid.hp < 0.55 and player.hpIncoming > 0.80 and not heal.lowestInRaid.isUnit("player")', kps.heal.lowestInRaid },

    -- "Dispel" "Purifier" 527
    {spells.cleanse, 'target.isDispellable("Magic")' , "target" },
    {spells.cleanse, 'target.isDispellable("Poison")' , "target" },
    {spells.cleanse, 'target.isDispellable("Disease")' , "target" },
    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Poison")' , "mouseover" },
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid },
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid },
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.blindingLight, 'target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isInterruptable' , "target" },
    }},

    -- VENTHYR
    --{{"macro"}, 'keys.ctrl and spells.ashenHallow.cooldown == 0' , "/cast [@player] "..AshenHallow },
    --{{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    --{spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    --{spells.vanquishersHammer, 'player.holyPower < 5 and not player.hasBuff(spells.vanquishersHammer) and heal.lowestInRaid.hp < 0.85' , env.damageTarget},
    -- KYRIAN
    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds
    
    {{"nested"}, 'player.myBuffDuration(spells.BlessingOfDawn) < 3' ,{
        {spells.judgment, 'target.isAttackable' , env.damageTarget }, -- generate 1 Holy Power
        {spells.arcaneTorrent, 'player.holyPower < 5' }, -- generate 1 Holy Power
        {spells.holyShock, 'player.holyPower < 5' , kps.heal.lowestInRaid }, -- generate 1 Holy Power
        {spells.crusaderStrike, 'target.isAttackable and target.distanceMax <= 10 and player.holyPower < 5' , env.damageTarget}, -- generate 1 Holy Power
        {spells.hammerOfWrath, 'target.isAttackable and player.holyPower < 5' , env.damageTarget }, -- generate 1 Holy Power
    }},
    -- If on 5 Holy Power, Spend Holy Power on Light of Dawn or, Word of Glory for spot healing or with Empyrean Legacy buff up. Shield of the Righteous for damage on 3 or more targets.
    -- Empyrean Legacy -- Word of Glory to automatically activate Light of Dawn with 25% increased effectiveness.
    {{"nested"}, 'player.holyPower == 5' ,{
    	{spells.wordOfGlory, 'player.hasBuff(spells.empyreanLegacy) and heal.countLossInDistance(0.85) > 2' , kps.heal.lowestInRaid },
    	{spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2' , kps.heal.lowestInRaid },
        {spells.lightOfDawn, 'not player.hasBuff(spells.unendingLight)' , kps.heal.lowestInRaid },
        {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    	{spells.shieldOfTheRighteous, 'heal.lowestInRaid.hpIncoming > 0.85' , env.damageTarget }, -- cost 3 holy power
        {spells.lightOfDawn, 'true' , kps.heal.lowestInRaid },
    }},
    --{spells.beaconOfLight, 'not mouseover.hasMyBuff(spells.beaconOfLight) and not mouseover.hasMyBuff(spells.beaconOfFaith) and mouseover.isRaidTank and mouseover.hp < 0.85' , "mouseover" },
    --{spells.beaconOfLight, 'not focus.hasMyBuff(spells.beaconOfLight) and not focus.hasMyBuff(spells.beaconOfFaith) and focus.isRaidTank and focus.exists' , "focus" },
    -- Guide de vertu -- Beacon of Virtue -- Vous appliquez un Guide de lumière sur la cible et 3 allié blessé à moins de 0 mètres pendant 8 sec.
    {spells.beaconOfVirtue, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'not player.hasBuff(spells.infusionOfLight) and player.isCastingSpell(spells.holyLight)' , "/stopcasting" },
    {{"macro"}, 'not player.hasBuff(spells.infusionOfLight) and player.isCastingSpell(spells.flashOfLight)' , "/stopcasting" },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and targettarget.isFriend' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },
    
    --Blessing of Autumn -- Cooldowns recover 30% faster. 30 seconds remaining -- Windwalker Monks, Evokers, Warlocks, Player
    {spells.BlessingOfAutumn , 'true' ,  "player" },
    --Blessing of Winter -- Vous bénissez une soigneuse ou un soigneur allié pendant 30 sec, ce qui lui rend 1% de son mana toutes les 2 s.
    {spells.BlessingOfWinter , 'true' ,  "player" },
    --Blessing of Spring -- Healing done increased by 15% and healing received increased by 30%. 30 seconds remaining
    {spells.BlessingOfSpring , 'true' ,  "player" },
    --Blessing of Summer -- Attacks have a 40% chance to deal 30% additional damage as Holy. 30 seconds remaining -- Mage , Warrior, Evoker, Ret Pally 
    {spells.BlessingOfSummer , 'mouseover.isFriend and mouseover.isRaidDamager' ,  "mouseover" }, -- mouseover.isClassName("WARRIOR")
    
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 3' },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 3 and heal.lowestInRaid.hp < 0.55' },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 2 and not player.isInRaid' },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 2 and heal.lowestInRaid.hp < 0.55 and not player.isInRaid' },
    -- Dump all your Holy Power before you cast Divine Toll
    {spells.divineToll, 'kps.multiTarget and player.holyPower < 2 and heal.countLossInDistance(0.70) > 2', kps.heal.lowestInRaid }, -- generate 1 Holy Power per target hit
    {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.divineFavor) and heal.lowestInRaid.hpIncoming < 0.60' , kps.heal.lowestInRaid },
    {spells.divineFavor, 'heal.lowestInRaid.hpIncoming < 0.60'  }, -- cd 45 s 

    {spells.wordOfGlory, 'player.hp < 0.60 and player.hasBuff(spells.unendingLight)' , "player"  },
    {spells.holyShock, 'player.hp < 0.60' , "player"   },
    {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.divineFavor) and player.hpIncoming < 0.60' , "player" },
    {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and player.hp < 0.60 and not spells.flashOfLight.isRecastAt("player") and not spells.flashOfLight.lastCasted(2)' , "player" },
    {{"nested"}, 'target.isFriend' ,{
        {spells.wordOfGlory, 'target.hp < 0.60 and player.hasBuff(spells.unendingLight)' , "target"  },
        {spells.holyShock, 'target.hp < 0.80' , "target"   },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and target.hp < 0.60 and not spells.flashOfLight.isRecastAt("target") and not spells.flashOfLight.lastCasted(2)' , "target" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and target.hp < 0.80 and not spells.holyLight.isRecastAt("target") and not spells.holyLight.lastCasted(2)' , "target" },
    }},
    {{"nested"}, 'mouseover.isFriend' ,{
        {spells.intercession, 'keys.shift and mouseover.isDead' , "mouseover"  },
        {spells.wordOfGlory, 'mouseover.hp < 0.60 and player.hasBuff(spells.unendingLight)' , "mouseover"  },
        {spells.holyShock, 'mouseover.hp < 0.80' , "mouseover"   },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.divineFavor) and heal.lowestInRaid.hpIncoming < 0.60' , "mouseover" },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.60 and not spells.flashOfLight.isRecastAt("mouseover") and not spells.flashOfLight.lastCasted(2)' , "mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.80 and not spells.holyLight.isRecastAt("mouseover") and not spells.holyLight.lastCasted(2)' , "mouseover" },
    }},

    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    --{spells.bestowFaith, 'not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },
    --{spells.barrierOfFaith, 'true' ,  kps.heal.lowestTankInRaid },
    -- Faveur divine -- Les soins de votre prochain sort Éclair lumineux ou Lumière sacrée sont augmentés de 60% et son temps d’incantation est réduit de 30%.
    -- Empyrean Legacy -- Jugement renforce Mot de gloire afin qu’il active automatiquement Lumière de l’aube avec une efficacité augmentée de 25%.
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée
    -- Avoid using Shield of the Righteous, you will gain more damage from spamming Word of Glory or lightOfDawn increase the chance of proccing Awakening
    {spells.ruleOfLaw , 'heal.countLossInRange(0.85) > 3 and not player.hasBuff(spells.ruleOfLaw )' , kps.heal.lowestInRaid },
    {spells.wordOfGlory, 'player.hasBuff(spells.empyreanLegacy) and heal.countLossInDistance(0.85) > 2' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'not player.isMoving and not player.hasBuff(spells.unendingLight)' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2' },
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid },
    {spells.judgment, 'player.holyPower < 5 and target.isAttackable and not player.hasBuff(spells.empyreanLegacy)' , env.damageTarget }, -- generate 1 Holy Power
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and heal.countLossInDistance(0.85) > 2 and not player.isMovingSince(2)', "/cast [@player] "..LightsHammer},
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and target.isAttackable and target.distanceMax <= 10 and not player.isMovingSince(2)', "/cast [@player] "..LightsHammer},
    -- GLIMMER
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp < player.hp and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.80' , "player" },
    {spells.holyShock, 'targettarget.isFriend and targettarget.hpIncoming < 0.80' , "targettarget" },
    {spells.holyShock, 'target.isFriend and target.hpIncoming < 0.80' , "target" },
    {spells.holyShock, 'focus.isFriend and focus.hpIncoming < 0.80' , "focus" },
    {spells.holyShock, 'heal.lowestInRaidGlimmer.hp  < 0.80 and not player.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaidGlimmer , "glimmer" },
    {spells.holyShock, 'target.isAttackable and not target.hasMyDebuff(spells.holyShock)' , env.damageTarget },
    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cost of your next Flash of Light by 30% or causes your next Holy Light to generate 1 Holy Power / 1% mana
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight) and not spells.flashOfLight.lastCasted(2)', {
       {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
       {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
       {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight) and not spells.holyLight.lastCasted(2)', {
    	{spells.holyLight, 'not player.isMoving and player.hp < 0.80 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming ' , "player" , "holyLight_PLAYER" },
    	{spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "holyLight_LOWEST" },
    	{spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.80' , kps.heal.lowestTankInRaid , "holyLight_TANK" },
    }},
    -- DAMAGE
    {{"nested"},'kps.damage', damageRotation},
    {spells.judgment, 'player.holyPower < 5 and target.isAttackable' , env.damageTarget }, -- generate 1 Holy Power
    {spells.hammerOfWrath, 'player.holyPower < 5 and target.isAttackable' , env.damageTarget }, -- generate 1 Holy Power.
    {spells.crusaderStrike, 'player.holyPower < 5 and spells.holyShock.cooldown > 3 and target.isAttackable and target.distanceMax <= 10' , env.damageTarget}, -- generate 1 Holy Power
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.isAttackable and target.distanceMax <= 10' },
    -- MARAAD
    {spells.lightOfTheMartyr, 'heal.lowestTankInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"holy_paladin_df")
    
