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
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and not player.isMoving', "/cast [@player] "..LightsHammer},
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

    -- "Dispel" "Purifier" 527
    {spells.cleanse, 'target.isDispellable("Magic")' , "target" },
    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'player.hp < 0.70' , "player"},
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.35' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.35' , kps.heal.lowestTankInRaid },
    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    {spells.blessingOfProtection, 'player.hp < 0.35' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.35 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.35', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.35', "player" },
    -- "Bénédiction de sacrifice" dure 12 s ou player.hp < 0.20. Réduit les dégâts subis de 30%, mais vous transfère 100% des dégâts évités.
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.55 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")', kps.heal.lowestTankInRaid },

    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'mouseover.isHealable and (mouseover.isDispellable("Magic") or mouseover.isDispellable("Poison") or mouseover.isDispellable("Disease"))' , "mouseover" },
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid },
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid },
        {spells.cleanse, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
        {spells.cleanse, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
        {spells.cleanse, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable }, 
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.blindingLight, 'target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and player.isPVP' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isInterruptable' , "focus" },
    }},

    -- VENTHYR
    --{{"macro"}, 'keys.ctrl and spells.ashenHallow.cooldown == 0' , "/cast [@player] "..AshenHallow },
    --{{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    --{spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    --{spells.vanquishersHammer, 'player.holyPower < 5 and not player.hasBuff(spells.vanquishersHammer) and heal.lowestInRaid.hp < 0.85' , env.damageTarget},
    -- KYRIAN
    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds

    {spells.arcaneTorrent, 'player.holyPower < 4' },
    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },

    {spells.beaconOfLight, 'not mouseover.hasMyBuff(spells.beaconOfLight) and not mouseover.hasMyBuff(spells.beaconOfFaith) and mouseover.isRaidTank and mouseover.hp < 0.85' , "mouseover" },
    {spells.beaconOfLight, 'not focus.hasMyBuff(spells.beaconOfLight) and not focus.hasMyBuff(spells.beaconOfFaith) and focus.isRaidTank and focus.exists' , "focus" },
    {spells.beaconOfVirtue, 'mouseover.isRaidTank and mouseover.hp < 0.70' , "mouseover" },
    {spells.beaconOfVirtue, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and targettarget.isFriend' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    {{"nested"}, 'mouseover.isFriend' ,{
        {spells.wordOfGlory, 'mouseover.hp < 0.70 and player.hasBuff(spells.unendingLight)' , "mouseover"  },
        {spells.holyShock, 'mouseover.hp < 0.80' , "mouseover"   },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.55 and not spells.flashOfLight.isRecastAt("mouseover")' , "mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.80 and not spells.holyLight.isRecastAt("mouseover")' , "mouseover" },
    }},
    
    {{"nested"}, 'targetarget.isFriend' ,{
        {spells.wordOfGlory, 'targetarget.hp < 0.70 and player.hasBuff(spells.unendingLight)' , "targetarget"  },
        {spells.holyShock, 'targetarget.hp < 0.80' , "targetarget"   },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and targetarget.hp < 0.55 and not spells.flashOfLight.isRecastAt("targetarget")' , "targetarget" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and targetarget.hp < 0.80 and not spells.holyLight.isRecastAt("targetarget")' , "targetarget" },
    }},
    
--[[
    Blessing of Autumn -- Cooldowns recover 30% faster. 30 seconds remaining
    {spells.BlessingOfAutumn , 'true' ,  kps.heal.lowestTankInRaid },
    Blessing of Winter -- Frost damage and reduce enemies movement speed by 5% and attack speed by 2%, stacking 10 times.
    {spells.BlessingOfWinter , 'true' ,  kps.heal.lowestTankInRaid },
    Blessing of Spring -- Healing done increased by 15% and healing received increased by 30%. 30 seconds remaining
    {spells.BlessingOfSpring , 'true' ,  "player" },
    Blessing of Summer -- Attacks have a 40% chance to deal 30% additional damage as Holy. 30 seconds remaining
    {spells.BlessingOfSummer , 'mouseover.isFriend and mouseover.isRaidDamager' ,  "mouseover" },
]]

    --{spells.barrierOfFaith, 'true' ,  kps.heal.lowestTankInRaid },
    {spells.divineFavor, 'true'  },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 3' },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 3 and heal.lowestInRaid.hp < 0.55' },

    {spells.holyShock, 'player.holyPower < 5 and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.holyPower < 5 and heal.lowestInRaidGlimmer.hp < 0.80' , kps.heal.lowestInRaidGlimmer },
    -- "Word of Glory" -- 3 charges de puissance sacrée -- Vanquisher's Hammer -- Word of Glory to automatically trigger Light of Dawn
    -- "Unending Light -- Each Holy Power spent on Light of Dawn increases the healing of your next Word of Glory by 5%, up to a maximum of 45%.
    {spells.lightOfDawn, 'not player.hasBuff(spells.unendingLight)' , kps.heal.lowestInRaid },
    {{"nested"}, 'heal.lowestInRaid.hp < 0.55' ,{
        {spells.wordOfGlory, 'player.hp < 0.55' , "player" },
        {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid },
        {spells.wordOfGlory, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid },
    }},
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2' },
    -- Avoid using Shield of the Righteous, you will gain more damage from spamming Word of Glory or lightOfDawn increase the chance of proccing Awakening
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.70 and player.hasBuff(spells.unendingLight)' , kps.heal.lowestInRaid },

    -- Dump all your Holy Power before you cast Divine Toll
    {spells.divineToll, 'kps.multiTarget and heal.countLossInDistance(0.80) > 3' },
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cost of your next Flash of Light by 30% or causes your next Holy Light to generate 1 Holy Power / 1% mana
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight) and not spells.flashOfLight.lastCasted(2)', {
       {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
       {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
       {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and player.hp < 0.85 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming' , "player" , "holyLight_PLAYER" },
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hp < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "holyLight_LOWEST" },
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid , "holyLight_TANK" },
    -- GLIMMER
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp < player.hp and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.80' , "player" },
    {spells.holyShock, 'target.isFriend and target.hpIncoming < 0.80' , "target" },
    {spells.holyShock, 'targettarget.isFriend and targettarget.hpIncoming < 0.80' , "targettarget" },
    {spells.holyShock, 'focus.isFriend and focus.hpIncoming < 0.80' , "focus" },
    {spells.holyShock, 'heal.lowestInRaidGlimmer.hp  < 0.80 and not player.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaidGlimmer , "glimmer" },
    {spells.holyShock, 'heal.lowestInRaid.hp  < 0.80' , kps.heal.lowestInRaid },

    -- DAMAGE
    {{"nested"},'kps.damage', damageRotation},
    {spells.judgment, 'target.isAttackable' , env.damageTarget },
    {spells.holyPrism, 'heal.lowestInRaid.hpIncoming < 0.70' , kps.heal.lowestInRaid },
    {spells.holyPrism, 'target.isAttackable' , env.damageTarget },
    {spells.holyShock, 'target.isAttackable and not target.hasMyDebuff(spells.holyShock)' , env.damageTarget },
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and not player.isMoving', "/cast [@player] "..LightsHammer},
    {spells.hammerOfWrath, 'target.isAttackable' , env.damageTarget }, -- generate 1 Holy Power.
    {spells.crusaderStrike, 'player.holyPower < 5 and  target.isAttackable and target.distanceMax <= 10' , env.damageTarget}, -- generate 1 Holy Power.
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.isAttackable and target.distanceMax <= 10' },
    -- MARAAD
    {spells.lightOfTheMartyr, 'heal.lowestTankInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

--    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55' ,{
--        {spells.flashOfLight, 'player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
--        {spells.flashOfLight, 'heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
--        {spells.flashOfLight, 'heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
--    }},
--    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and spells.holyShock.cooldown > 2' ,{
--        {spells.holyLight, 'heal.lowestInRaid.hpIncoming < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming and heal.lowestInRaid.hpIncoming < player.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
--        {spells.holyLight, 'player.hpIncoming < 0.85 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming' , "player" , "heal_player" },
--        {spells.holyLight, 'heal.lowestTankInRaid.hpIncoming < 0.85' , kps.heal.lowestTankInRaid , "heal_tank" },
--    }},

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"holy_paladin_bfa")
    
