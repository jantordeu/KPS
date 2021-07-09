--[[[
@module Paladin Holy Rotation
@author htordeux
@version 9.0.5
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","HOLY", "damage", "Interface\\Icons\\spell_holy_avenginewrath", "damage")
end)


local damageRotation = {
    {spells.holyShock, 'true' , env.damageTarget },
    {spells.divineToll, 'true' , env.damageTarget },
    {spells.shieldOfTheRighteous, 'true' , env.damageTarget }, -- cost 3 holy power
    {spells.holyPrism, 'player.hasTalent(2,3)' , env.damageTarget },
    {spells.lightsHammer, 'player.hasTalent(1,3)' , env.damageTarget },
    {spells.judgment, 'true' , env.damageTarget },
    {spells.crusaderStrike, 'target.distance <= 5' , env.damageTarget},
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 5' },    
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
    {spells.divineProtection, 'player.hp < 0.80' },

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'player.hp < 0.30' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    
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
    -- PVP
    {{"nested"}, 'player.isPVP' ,{
        {spells.holyShock, 'player.myBuffDuration(spells.glimmerOfLight) < 2' , "player" },
        {spells.divineFavor, 'player.hp < 0.70' },
        {spells.lightOfTheMartyr, 'heal.lowestInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.80 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid  , "FLASH_LOWEST" },
    }},

    {spells.arcaneTorrent, 'true' },
    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'player.hasTalent(1,2) and not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and targettarget.isFriend' , "/use [@targettarget] 14" },
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" }, 
 
    -- Boss ALTIMOR
    --{spells.wordOfGlory, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.holyShock, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },  
    --{spells.flashOfLight, 'not player.isMoving and target.isFriend and target.hp < 0.90' , "target" },   
    -- MOUSEOVER 
    {{"nested"}, 'mouseover.isHealable' ,{
        {spells.holyShock, 'mouseover.hp < 0.85' , "mouseover"  , "holyShock_mouseover" },
        {spells.wordOfGlory, 'mouseover.hp < 0.70' , "mouseover"  , "wordOfGlory_mouseover" },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.60' , "mouseover" , "flash_mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.80' , "mouseover" , "holyLight_mouseover" }, 
    }},

    {{"nested"}, 'kps.multiTarget' ,{
        -- "Holy Avenger" -- "Vengeur sacré" -- Votre génération de puissance sacrée est triplée pendant 20 sec.
        {spells.holyAvenger, 'player.hasTalent(5,2) and not player.hasBuff(spells.avengingWrath) and heal.lowestTankInRaid.hp < 0.40' },
        {spells.holyAvenger, 'player.hasTalent(5,2) and kps.damage' },
        -- "Courroux vengeur" -- "Avenging Wrath"  -- augmente vos dégâts, vos soins et vos chances de coup critique de 20% pendant 20 sec.
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and kps.damage' }, 
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 4' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.70) > 2 and heal.lowestInRaid.hp < 0.40' },
        -- "Croisé vengeur -- "Avenging Crusader" -- Crusader Strike, Judgment and auto-attack damage increased by 30%. -- 3 nearby allies will be healed for 250% of the damage done. Dure 20 sec.
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.70) > 4' },
        {spells.avengingCrusader, 'player.hasTalent(6,2) and kps.damage' },
     }},

    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds
    {spells.divineToll, 'heal.countLossInRange(0.85) > 2' , env.damageTarget },
    {spells.lightOfDawn, 'player.hasBuff(spells.ruleOfLaw)' },
    {spells.ruleOfLaw, 'player.hasTalent(4,3) and heal.countLossInRange(0.85) > 4 and not spells.ruleOfLaw.lastCasted(9)' },
    {spells.wordOfGlory, 'heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid },
    {spells.wordOfGlory, 'player.hp < 0.50' , "player" },
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid },
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée  
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 4' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85) > 2 and not player.isInRaid' },
    -- "Word of Glory" -- 3 charges de puissance sacrée
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'player.holyPower == 5 and heal.countLossInDistance(0.90) > 1' },
    -- Avoid using Shield of the Righteous, you will gain more damage from spamming Word of Glory to increase the chance of proccing Awakening
    {spells.wordOfGlory, 'player.hasTalent(6,3)' , kps.heal.lowestInRaid },

    -- DEFAULT TANK
    {spells.holyShock, 'focus.isFriend and focus.hp < 0.70' , "focus" },
    {spells.holyShock, 'target.isFriend and target.hp < 0.70' , "target" },
    {spells.holyShock, 'targettarget.isFriend and targettarget.hp < 0.70' , "targettarget" },
    {spells.holyShock, 'player.hp < 0.70' , "player"  },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
    -- GLIMMER
    {spells.holyShock, 'heal.lowestTankInRaid.myBuffDuration(spells.glimmerOfLight) < 6' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'player.myBuffDuration(spells.glimmerOfLight) < 6 and player.hp < 1' , "player" },
    {spells.holyShock, 'heal.lowestInRaid.myBuffDuration(spells.glimmerOfLight) < 6 and heal.lowestInRaid.hp < 1' , kps.heal.lowestInRaid },
    {spells.holyShock, 'heal.hasNotBuffGlimmer.myBuffDuration(spells.glimmerOfLight) < 6 and heal.hasNotBuffGlimmer.hp < 1' , kps.heal.hasNotBuffGlimmer },
    {spells.holyShock, 'target.isAttackable and not target.hasMyDebuff(spells.glimmerOfLight)' , "target" },
    {spells.holyShock, 'target.isAttackable and kps.groupSize() == 1' , "target" },
    {spells.holyShock, 'true' , kps.heal.lowestInRaid },
    
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    -- "Imprégnation de lumière" "Infusion of Light" -- reduit le coût de votre prochain Éclair lumineux de 30% ou augmentent les soins prodigués par votre prochain sort Lumière sacrée de 30%.
    -- "Beacon of Light" -- Although this does not generate Holy Power directly, you can cast a Flash of Light or Holy Light on the target affected by Beacon of Light to generate one Holy Power.
    {{"nested"},'not player.isMoving and player.hasBuff(spells.infusionOfLight)', {
        {spells.flashOfLight, 'kps.groupSize() == 1 and player.hp < 0.85' , "player" , "FLASH_PLAYER" },
        {spells.flashOfLight, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
        {spells.flashOfLight, 'player.hp < 0.70' , "player" , "FLASH_PLAYER" },
        {spells.flashOfLight, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid  , "FLASH_LOWEST" },
        {spells.holyLight, 'heal.lowestInRaid.hp < 0.85 and spells.holyShock.cooldown > 2' , kps.heal.lowestInRaid  , "holyLight_LOWEST" },
    }},
    -- DAMAGE    
    {{"nested"},'kps.damage', damageRotation},
    {spells.judgment, 'true' , env.damageTarget },
    {spells.crusaderStrike, 'target.distance <= 5' , env.damageTarget},
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 5' },

    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.80 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestInRaid.hpIncoming < 0.70 and player.hpIncoming > 0.80 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.50' ,{
        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.50' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.50 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.50' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and spells.holyShock.cooldown > 2' ,{
        {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.85 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming and heal.lowestInRaid.hpIncoming < player.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
        {spells.holyLight, 'not player.isMoving and player.hpIncoming < 0.85 and player.hpIncoming < heal.lowestTankInRaid.hpIncoming' , "player" , "heal_player" },
        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.85' , kps.heal.lowestTankInRaid , "heal_tank" },
    }},

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 5' , "/startattack" },

}
,"holy_paladin_bfa")


-- AZERITE
--"Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
--{spells.azerite.overchargeMana, 'heal.countLossInRange(0.85)*2 > heal.countInRange' }, -- MANUAL
--"Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
--{spells.azerite.memoryOfLucidDreams, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
--spells.azerite.concentratedFlame, 'target.isAttackable' , "target" },
    
