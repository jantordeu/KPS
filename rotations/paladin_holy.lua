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
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.55 and player.hpIncoming > 0.70', kps.heal.lowestTankInRaid },

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
    {spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    {spells.vanquishersHammer, 'player.holyPower < 4 and not player.hasBuff(spells.vanquishersHammer)' , env.damageTarget},
    -- KYRIAN
    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds
    -- Dump all your Holy Power BEFORE you cast Divine Toll -- want to be using Divine Toll during your wings windows
    {spells.divineToll, 'kps.multiTarget and heal.countLossInDistance(0.80) > 3' },

    -- PVP
    {spells.arcaneTorrent, 'player.holyPower < 4' },
    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    --{spells.bestowFaith, 'not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and targettarget.isFriend' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" }, 
 
    -- Boss ALTIMOR
    --{spells.wordOfGlory, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.holyShock, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.flashOfLight, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },
    
    {{"nested"}, 'targettarget.isFriend' ,{
        {spells.wordOfGlory, 'targettarget.hp < 0.70' , "targettarget" },
        {spells.holyShock, 'targettarget.hp < 0.80' , "targettarget"  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and targettarget.hp < 0.55 and not spells.flashOfLight.isRecastAt("targettarget")' , "targettarget"  },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and targettarget.hp < 0.80' , "targettarget" }, 
    }},

    {{"nested"}, 'target.isFriend' ,{
        {spells.wordOfGlory, 'target.hp < 0.70' , "target" },
        {spells.holyShock, 'target.hp < 0.80' , "target"  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and target.hp < 0.55 and not spells.flashOfLight.isRecastAt("target")' , "target"  },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and target.hp < 0.80' , "target" }, 
    }},  

    {{"nested"}, 'mouseover.isFriend' ,{
        {spells.wordOfGlory, 'mouseover.hp < 0.70' , "mouseover"  },
        {spells.holyShock, 'mouseover.hp < 0.80' , "mouseover"   },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.55 and not spells.flashOfLight.isRecastAt("mouseover")' , "mouseover" , "flashOfLight_mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.80 and not spells.holyLight.isRecastAt("mouseover")' , "mouseover" , "holyLight_mouseover" },
    }},

    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 3' },
    {spells.avengingWrath, 'kps.multiTarget and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 3 and heal.lowestInRaid.hp < 0.55' },

    {spells.beaconOfLight, 'not mouseover.hasMyBuff(spells.beaconOfLight) and mouseover.isRaidTank and mouseover.hp < 0.85' , "mouseover" },
    {spells.beaconOfLight, 'not focus.hasMyBuff(spells.beaconOfLight) and focus.isRaidTank and focus.exists' , "focus" },
    {spells.beaconOfVirtue, 'mouseover.isRaidTank and mouseover.hp < 0.85' , "mouseover" },
    {spells.beaconOfVirtue, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },

    {spells.holyShock, 'player.holyPower < 5 and player.hp < 0.70' , "player" },
    {spells.holyShock, 'player.holyPower < 5 and heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.holyPower < 5 and heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid },
    -- "Word of Glory" -- 3 charges de puissance sacrée
    {spells.wordOfGlory, 'player.hasBuff(spells.vanquishersHammer) and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid }, 
    {spells.wordOfGlory, 'player.hp < 0.55' , "player" },
    {spells.wordOfGlory, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid },
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid },
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée 
    {spells.ruleOfLaw, 'player.holyPower > 2 and heal.countLossInDistance(0.85) > 3' },
    {spells.lightOfDawn, 'player.hasBuff(spells.ruleOfLaw)' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2' },
    -- Avoid using Shield of the Righteous, you will gain more damage from spamming Word of Glory or lightOfDawn increase the chance of proccing Awakening
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'player.holyPower == 5 and heal.countLossInDistance(0.90) > 2 and not player.hasBuff(spells.avengingWrath)' , kps.heal.lowestInRaid },
    {spells.wordOfGlory, 'player.holyPower == 5 and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },

    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hp > 0.55 and heal.lowestInRaid.hp < 0.85 and not spells.holyLight.lastCasted(2)' , kps.heal.lowestInRaid , "holyLight_LOWEST" },    
    -- GLIMMER
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp < player.hp and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.80' , "player" },
    {spells.holyShock, 'target.isFriend and target.hpIncoming < 0.80' , "target" },
    {spells.holyShock, 'targettarget.isFriend and targettarget.hpIncoming < 0.80' , "targettarget" },
    {spells.holyShock, 'focus.isFriend and focus.hpIncoming < 0.80' , "focus" },
    {spells.holyShock, 'heal.lowestInRaidGlimmer.hp  < 0.80 and not player.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaidGlimmer , "glimmer" },
    {spells.holyShock, 'heal.lowestInRaid.hp  < 0.80' , kps.heal.lowestInRaid },
    
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cost of your next Flash of Light by 30% or causes your next Holy Light to generate 1 Holy Power / 1% mana
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight) and not spells.flashOfLight.lastCasted(2)', {
       {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
       {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hp < 0.85 and not spells.holyLight.lastCasted(2)' , kps.heal.lowestInRaid , "holyLight_LOWEST" },
    -- DAMAGE
    {{"nested"},'kps.damage', damageRotation},
    {spells.judgment, 'target.isAttackable' , env.damageTarget },
    {spells.holyShock, 'target.isAttackable and not target.hasMyDebuff(spells.holyShock)' , env.damageTarget },
    {{"macro"}, 'spells.lightsHammer.cooldown == 0 and not player.isMoving', "/cast [@player] "..LightsHammer},
    {spells.hammerOfWrath, 'target.isAttackable' , env.damageTarget }, -- generate 1 Holy Power.
    {spells.crusaderStrike, 'player.holyPower < 5 and  target.isAttackable and target.distanceMax <= 10' , env.damageTarget}, -- generate 1 Holy Power.
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.isAttackable and target.distanceMax <= 10' },
    -- MARAAD
    {spells.lightOfTheMartyr, 'heal.lowestTankInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

--    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55' ,{
--        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
--        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
--        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
--    }},
--    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and spells.holyShock.cooldown > 2' ,{
--        {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming and heal.lowestInRaid.hpIncoming < player.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
--        {spells.holyLight, 'not player.isMoving and player.hpIncoming < 0.85 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming' , "player" , "heal_player" },
--        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.85' , kps.heal.lowestTankInRaid , "heal_tank" },
--    }},

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"holy_paladin_bfa")
    
