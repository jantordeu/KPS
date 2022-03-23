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
    {spells.holyShock, 'mouseover.isAttackable and not mouseover.hasMyDebuff(spells.glimmerOfLight) and target.isAttackable and target.hasMyDebuff(spells.glimmerOfLight)' , "mouseover" },
    {spells.holyShock, 'true' , env.damageTarget },
    {spells.shieldOfTheRighteous, 'true' , env.damageTarget }, -- cost 3 holy power
    {spells.holyPrism, 'player.hasTalent(2,3)' , env.damageTarget },
    {spells.lightsHammer, 'player.hasTalent(1,3)' , env.damageTarget },
    {spells.hammerOfWrath, 'player.hasBuff(spells.avengingWrath)' , env.damageTarget }, -- 1 holypower
    {spells.crusaderStrike, 'target.distanceMax  <= 10' , env.damageTarget},
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 10' },    
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
    {spells.divineProtection, 'player.hp < 0.70' },
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    {spells.blessingOfProtection, 'player.hp < 0.30' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.30', "player" },

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
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and player.isPVP' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isInterruptable' , "focus" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},

    -- VENTHYR
    {{"macro"}, 'keys.ctrl and spells.ashenHallow.cooldown == 0' , "/cast [@player] "..AshenHallow },
    {{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    {spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    {spells.vanquishersHammer, 'not player.hasBuff(spells.vanquishersHammer)' , env.damageTarget},
    -- NIGHTFAE
    -- Blessing of Winter Frost damage and reduce enemies' movement speed 
    --{spells.blessingOfWinter, 'true' },
    -- Blessing of Autumn Cooldowns recover 30% faster.
    --{spells.blessingOfAutumn, 'spells.avengingWrath.cooldown > 9' },
    -- Blessing of Summer Attacks have a 40% chance to deal 30% additional damage as Holy.
    --{spells.blessingOfSummer, 'player.holyPower >= 3' },
    -- KYRIAN
    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds
    -- Dump all your Holy Power BEFORE you cast Divine Toll -- want to be using Divine Toll during your wings windows
    --{spells.divineToll, 'kps.multiTarget and heal.countLossInDistance(0.85) > 3' },
    --{spells.divineToll, 'kps.multiTarget and heal.countLossInDistance(0.85) > 2 and not player.isInRaid' },

    -- PVP
    {spells.divineFavor, 'player.isPVP and player.hp < 0.70' },
    {spells.arcaneTorrent, 'true' },
    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'player.hasTalent(1,2) and not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and targettarget.isFriend' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" }, 
 
    -- Boss ALTIMOR
    --{spells.wordOfGlory, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.holyShock, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.flashOfLight, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },   
    -- MOUSEOVER 
    {{"nested"}, 'mouseover.isHealable' ,{
        {spells.holyShock, 'mouseover.hp < 0.80' , "mouseover"  , "holyShock_mouseover" },
        {spells.wordOfGlory, 'mouseover.hp < 0.70' , "mouseover"  , "wordOfGlory_mouseover" },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.70' , "mouseover" , "flash_mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.85' , "mouseover" , "holyLight_mouseover" }, 
    }},

    {{"nested"}, 'kps.multiTarget' ,{
        -- "Holy Avenger" -- "Vengeur sacré" -- Votre génération de puissance sacrée est triplée pendant 20 sec.
        {spells.holyAvenger, 'player.hasTalent(5,2) and not player.hasBuff(spells.avengingWrath) and heal.lowestTankInRaid.hp < 0.40' },
        {spells.holyAvenger, 'player.hasTalent(5,2) and not player.hasBuff(spells.avengingWrath) and kps.damage' },
        -- "Courroux vengeur" -- "Avenging Wrath"  -- augmente vos dégâts, vos soins et vos chances de coup critique de 20% pendant 20 sec.
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and kps.damage' }, 
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 4' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 2 and heal.lowestInRaid.hp < 0.50' },
        -- "Croisé vengeur -- "Avenging Crusader" -- Crusader Strike, Judgment and auto-attack damage increased by 30%. -- 3 nearby allies will be healed for 250% of the damage done. Dure 20 sec.
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.70) > 4' },
        {spells.avengingCrusader, 'player.hasTalent(6,2) and kps.damage' },
     }},
    {spells.beaconOfVirtue, 'player.hasTalent(7,1) and heal.countLossInDistance(0.85) > 3' , kps.heal.lowestTankInRaid },
    {{"macro"}, 'player.hasTalent(1,3) and heal.countLossInDistance(0.85) > 3 and spells.lightsHammer.cooldown == 0', "/cast [@player] "..LightsHammer},
    {spells.wordOfGlory, 'player.hasBuff(spells.vanquishersHammer) and heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'player.hasBuff(spells.ruleOfLaw)' },
    {spells.ruleOfLaw, 'player.hasTalent(4,3) and heal.countLossInRange(0.85) > 3 and not spells.ruleOfLaw.lastCasted(9)' },
    {spells.wordOfGlory, 'heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid },
    {spells.wordOfGlory, 'player.hp < 0.50' , "player" },
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid },
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée 
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 3' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2 and not player.isInRaid' },
    -- "Word of Glory" -- 3 charges de puissance sacrée
    -- Avoid using Shield of the Righteous, you will gain more damage from spamming Word of Glory to increase the chance of proccing Awakening
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'player.holyPower == 5' , kps.heal.lowestInRaid },

    -- GLIMMER
    {spells.holyShock, 'heal.defaultTank.hp < 0.70' , kps.heal.defaultTank },
    {spells.holyShock, 'heal.defaultTarget .hp < 0.70' , kps.heal.defaultTarget },
    {spells.holyShock, 'heal.lowestTankInRaid.myBuffDuration(spells.glimmerOfLight) < 6' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'player.myBuffDuration(spells.glimmerOfLight) < 6' , "player" },
    {spells.holyShock, 'heal.lowestInRaid.hp < player.hp and heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.85' , "player" },
    -- DAMAGE
    {spells.holyShock, 'mouseover.isAttackable and not mouseover.hasMyDebuff(spells.glimmerOfLight) and target.isAttackable and target.hasMyDebuff(spells.glimmerOfLight)' , "mouseover" },
    {spells.holyShock, 'true' , env.damageTarget },
    {{"nested"},'kps.damage', damageRotation},

    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cost of your next Flash of Light by 30% or causes your next Holy Light to generate 1 Holy Power.
    -- you can cast a Flash of Light or Holy Light on the target affected by Beacon of Light to generate one Holy Power.
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight) and not spells.flashOfLight.lastCasted(2)', {
        {spells.flashOfLight, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
        {spells.flashOfLight, 'player.hp < 0.70' , "player" , "FLASH_PLAYER" },
        {spells.flashOfLight, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid  , "FLASH_LOWEST" },
        {spells.holyLight, 'heal.lowestInRaid.hp < 0.85 and spells.holyShock.cooldown > 2' , kps.heal.lowestInRaid  , "holyLight_LOWEST" },s
    }},
    {{"nested"}, 'IsEquippedItem(178926)' ,{
        {spells.lightOfTheMartyr, 'heal.lowestTankInRaid.hpIncoming < 0.50 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
        {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.50 and player.hpIncoming > 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},
    }},
    -- DAMAGE
    {spells.judgment, 'true' , env.damageTarget },
    {spells.crusaderStrike, 'target.distanceMax  <= 10' , env.damageTarget},
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {spells.consecration, 'not player.isMoving and target.isAttackable and not target.isMoving and target.distanceMax <= 10' },

    {spells.lightOfTheMartyr, 'heal.lowestTankInRaid.hpIncoming < 0.85 and player.hpIncoming > 0.70 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.85 and player.hpIncoming > 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

--    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.50' ,{
--        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.50' , "player" , "FLASH_PLAYER"  },
--        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.50 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
--        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.50' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
--    }},
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and spells.holyShock.cooldown > 2' ,{
        {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming and heal.lowestInRaid.hpIncoming < player.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
        {spells.holyLight, 'not player.isMoving and player.hpIncoming < 0.85 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming' , "player" , "heal_player" },
        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.85' , kps.heal.lowestTankInRaid , "heal_tank" },
    }},

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"holy_paladin_bfa")


-- AZERITE
--"Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
--"Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
--{spells.azerite.memoryOfLucidDreams, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
--spells.azerite.concentratedFlame, 'target.isAttackable' , "target" },
    
