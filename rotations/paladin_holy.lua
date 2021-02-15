--[[[
@module Paladin Holy Rotation
@author htordeux
@version 7.0.3
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","HOLY", "damage", "Interface\\Icons\\spell_holy_righteousfury", "damage")
end)

kps.rotations.register("PALADIN","HOLY",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.95,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.85,kps.defensive)' , "/stopcasting" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    -- "Potion de soins abyssale" 169451

    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'player.hp < 0.70' , "player" },

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'player.hp < 0.30' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    {spells.blessingOfProtection, 'keys.shift and not mouseover.isRaidTank' , "mouseover" },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.divineShield, 'keys.shift and mouseover.isHealable' , "mouseover" },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.30', "player" },

    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid },
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid },
        {spells.cleanse, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting and focus.isInterruptable' , "focus" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    -- PVP
    {{"nested"}, 'player.isPVP' ,{
    	{spells.divineFavor, 'heal.lowestInRaid.hp < 0.85' },
    	{spells.holyShock, 'player.hp < 0.85' , "player"  },
    	{spells.flashOfLight, 'player.hasBuff(spells.infusionOfLight) and player.hp < 0.55 and not spells.flashOfLight.isRecastAt("player")' , "player" , "flash_player_infusion" },
    	{spells.holyLight, 'player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hp < 0.85 and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid , "heal_lowest_infusion" },
    	{spells.holyLight, 'player.hasBuff(spells.infusionOfLight) and player.hp < 0.85' , "player" , "heal_player_infusion" },
    }},
    
    -- "Hammer of Wrath" -- Only usable on enemies that have less than 20% health
    {spells.hammerOfWrath, 'target.isAttackable and target.hp < 0.20' , "target" },
    -- "Word of Glory" -- 3 charges de puissance sacrée	
    {spells.wordOfGlory, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.80) > 3 and player.holyPower == 5' },
    {spells.wordOfGlory, 'player.holyPower == 5' , kps.heal.lowestInRaid },
    
    -- Beacon of Light - Although this does not generate Holy Power directly, you can cast a Flash of Light or Holy Light on the target affected by Beacon of Light to generate one Holy Power.
    {spells.flashOfLight, 'not player.isMoving and player.holyPower < 3 and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hpIncoming < 0.80' ,  kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },

    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'player.hasTalent(1,2) and not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },    
    -- "Règne de la loi" -- Vous augmentez de 50% la portée de vos soins
    {spells.ruleOfLaw, 'player.hasTalent(4,3) and heal.countLossInRange(0.85) > heal.countLossInDistance(0.85) and not player.hasBuff(spells.ruleOfLaw)' },
    -- "Lumière de l’aube" -- "Light of Dawn" -- 3 charges de puissance sacrée	
    {spells.lightOfDawn, 'heal.countLossInDistance(0.80) > 3' },

    {spells.holyAvenger, 'player.hasTalent(5,2) and heal.countLossInRange(0.80)*2  > heal.countInRange' },
    {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80)*2  > heal.countInRange' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80)*2  > heal.countInRange' },
    
    {{"nested"},'kps.multiTarget', {
        -- "Vengeur sacré" --"Holy Avenger" -- Your Holy Power generation is tripled for 20 sec
        {spells.holyAvenger, 'player.hasTalent(5,2) and heal.countLossInRange(0.80) > 3' },
        {spells.holyAvenger, 'player.hasTalent(5,2) and heal.countLossInRange(0.80) > 2 and heal.lowestInRaid.hp < 0.55' },
        -- "Courroux vengeur" --"Avenging Wrath"  -- Damage, healing, and critical strike chance increased by 20%.
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 3' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80) > 2 and heal.lowestInRaid.hp < 0.55' },
        -- "Croisé vengeur --"Avenging Crusader" -- Crusader Strike, Judgment and auto-attack damage increased by 30%. -- 3 nearby allies will be healed for 250% of the damage done.
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 3' },
    }},
    
    -- MOUSEOVER 
    {{"nested"}, 'mouseover.isHealable and mouseover.hp < 0.80' ,{
        {spells.holyShock, 'mouseover.isHealable and not mouseover.hasMyBuff(spells.glimmerOfLight)' , "mouseover" , "holyShock_mouseover"}, 
        {spells.holyShock, 'not player.hasBuff(spells.infusionOfLight)' , "mouseover"  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.55' , "mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' , "mouseover" },
        {spells.holyShock, 'mouseover.hp < 0.55' , "mouseover"  },
        {spells.flashOfLight, 'not player.isMoving and mouseover.hp < 0.55' , "mouseover" },
    }},

    -- GLIMMER
    {spells.holyShock, 'not heal.lowestTankInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'not heal.lowestInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid , "holyShock_lowest" },
    {spells.holyShock, 'not player.hasMyBuff(spells.glimmerOfLight)' , "player" , "holyShock_player" },
    {spells.holyShock, 'heal.lowestTankInRaid.hpIncoming < 0.70 and heal.lowestTankInRaid.myBuffDuration(spells.glimmerOfLight) < 5' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'not heal.lowestInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid , "holyShock_lowest" },
    
    -- DAMAGE
    {{"nested"}, 'kps.damage and target.isAttackable',{
        {spells.avengingWrath },
        -- "Hammer of Wrath" -- Only usable on enemies that have less than 20% health
        {spells.hammerOfWrath, 'target.isAttackable and target.hp < 0.20' , "target" },
        {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 5' },
        {spells.judgment, 'true' , env.damageTarget }, 
        {spells.holyShock, 'true' , env.damageTarget },
        {spells.crusaderStrike, 'player.hasTalent(1,1) and target.distance <= 5' , env.damageTarget },
        -- "Bouclier du vertueux" -- "Shield of the Righteous" -- cost 3 holy power
        {spells.shieldOfTheRighteous, 'true' , env.damageTarget },
    }},

    {spells.holyShock, 'player.hp < 0.70' , "player" , "holyShock_player" },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid },
    {spells.holyShock, 'target.isAttackable and not target.hasMyDebuff(spells.glimmerOfLight)' , "target" , "target_holyShock"},
    
    -- "Imprégnation de lumière" "Infusion of Light" 
    -- reduit le coût de votre prochain Éclair lumineux de 30% ou augmentent les soins prodigués par votre prochain sort Lumière sacrée de 30%.
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and player.hasBuff(spells.infusionOfLight)' ,{
        {spells.flashOfLight, 'player.hp < 0.55 and not spells.flashOfLight.isRecastAt("player")' , "player" , "flash_player_infusion" },
        {spells.flashOfLight, 'heal.lowestTankInRaid.hp < 0.55 and not spells.flashOfLight.isRecastAt(heal.lowestTankInRaid.unit)' ,  kps.heal.lowestTankInRaid , "flash_tank_infusion" },
        {spells.flashOfLight, 'heal.lowestInRaid.hp < 0.55 and not spells.flashOfLight.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "flash_lowest_infusion" },
        -- Beacon of Light - Although this does not generate Holy Power directly, you can cast a Flash of Light or Holy Light on the target affected by Beacon of Light to generate one Holy Power.
        {spells.flashOfLight, 'not player.isMoving and player.holyPower < 3 and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hpIncoming < 0.80 and heal.lowestTankInRaid.hasBuff(spells.beaconOfLight)' ,  kps.heal.lowestTankInRaid },
        {spells.holyLight, 'heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid , "heal_lowest_infusion" },
        {spells.holyLight, 'player.hp < 0.80 and player.hp < heal.lowestTankInRaid.hp' , "player" , "heal_player_infusion" },
        {spells.holyLight, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid , "heal_tank_infusion" },
    }},

    {spells.holyShock, 'heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.80 and player.hp < heal.lowestTankInRaid.hp' , "player"  },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid },

    -- "Hammer of Wrath" -- Only usable on enemies that have less than 20% health
    {spells.hammerOfWrath, 'target.isAttackable and target.hp < 0.20' , "target" },
    {spells.judgment, 'target.isAttackable' , env.damageTarget },
    {spells.holyShock, 'target.isAttackable' , env.damageTarget },
    {spells.crusaderStrike, 'player.hasTalent(1,1) and target.isAttackable and target.distance <= 5' , "target" },
    {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 5' },

    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hp < 0.80 and player.hp > 0.90 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestInRaid.hp < 0.80 and player.hp > 0.90 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55' ,{
        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},

    {{"nested"}, 'not player.isMoving and spells.holyShock.cooldown > 2 and heal.lowestInRaid.hp < 0.80' ,{
        {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid , "heal_lowest" },
        {spells.holyLight, 'not player.isMoving and player.hp < 0.80 and player.hp < heal.lowestTankInRaid.hp' , "player" , "heal_player" },
        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid , "heal_tank" },
    }},

    {{"macro"}, 'true' , "/startattack" },

}
,"holy_paladin_bfa")


-- AZERITE
--"Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
--{spells.azerite.overchargeMana, 'heal.countLossInRange(0.85)*2 > heal.countInRange' }, -- MANUAL
--"Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
--{spells.azerite.memoryOfLucidDreams, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
--{spells.azerite.concentratedFlame, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid },
--spells.azerite.concentratedFlame, 'target.isAttackable' , "target" },
    
