--[[[
@module Paladin Holy Rotation
@author htordeux
@version 7.0.3
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","HOLY", "tankhammer", "Interface\\Icons\\spell_holy_sealofmight", "tankhammer")
end)



kps.rotations.register("PALADIN","HOLY",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    
    -- ShouldInterruptCasting,
    {{"macro"}, 'spells.holyLight.shouldInterrupt(0.95,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.65' ,"/use item:5512" },
    -- "Potion de soins abyssale" 169451
    {{"macro"}, 'player.useItem(169451) and player.hp <= 0.40' ,"/use item:169451" },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'player.hp < 0.30', "player" },
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    
    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec. during that time the caster also cannot attack or use spells
    {spells.divineProtection, 'spells.blessingOfSacrifice.lastCasted(4) and not player.hasBuff(spells.divineShield)' , "player" },
    {spells.divineProtection, 'player.hp < 0.40 and not player.hasBuff(spells.divineShield)' , "player" },
    {spells.divineProtection, 'player.isTarget and target.isRaidBoss' , "player" },
    
    -- "Bouclier divin" ""Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.divineShield, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },
    {spells.blessingOfProtection, 'player.hp < 0.30' , "player" },

    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid },
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid },
        {spells.cleanse, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable , "DISPEL" },
    }},
    -- Interrupt
    {spells.hammerOfJustice, 'kps.tankhammer and mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    {spells.hammerOfJustice, 'kps.tankhammer and target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    {{"nested"}, 'kps.interrupt' ,{
        {spells.hammerOfJustice, 'focus.distance <= 10 and focus.isCasting and focus.isAttackable' , "focus" },
        {spells.hammerOfJustice, 'target.distance <= 10 and target.isCasting and target.isAttackable' , "target" },
        {spells.hammerOfJustice, 'focustarget.distance <= 10 and focustarget.isCasting and focustarget.isAttackable' , "focustarget" },
        -- "Repentir" "Repentance" -- Forces an enemy target to meditate, incapacitating them for 1 min.
        {spells.repentance, 'player.hasTalent(3,2) and target.isCasting and target.isAttackable' , "target" },
    }},

    -- APPLY MANUAL -- 
    -- "Beacon of Light" -- Targeting this ally directly with Flash of Light or Holy Light also refunds 25% of Mana spent on those heals -- your heals on other party or raid members to also heal that ally for 40% of the amount healed.
    {spells.beaconOfLight, 'not player.hasTalent(7,3) and focus.isHealable and not focus.hasBuff(spells.beaconOfLight) and not focus.hasBuff(spells.beaconOfFaith) and not focus.isUnit("player")' , "focus" },
    -- "Beacon of Faith" -- Mark a second target as a Beacon, mimicking the effects of Beacon of Light. Your heals will now heal both of your Beacons, but at 30% reduced effectiveness.
    --{spells.beaconOfFaith, 'player.hasTalent(7,2) and not player.hasBuff(spells.beaconOfFaith) and not player.hasBuff(spells.beaconOfLight)' , "player" },
    -- "Beacon of Virtue" -- Replaces "Beacon of Light"  -- Applique un Guide de lumière sur la cible et 3 allié blessé à moins de 30 mètres pendant 8 sec. Vos soins leur rendent 40% du montant soigné.
    {spells.beaconOfVirtue, 'player.hasTalent(7,3) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfVirtue) and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'not heal.lowestTankInRaid.hasBuff(spells.bestowFaith) and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid },    
    -- "Règne de la loi" -- Vous augmentez de 50% la portée de vos soins
    {spells.ruleOfLaw, 'heal.countLossInRange(0.80) > 3 and not player.hasBuff(spells.ruleOfLaw)' },
    {spells.ruleOfLaw, 'spells.ruleOfLaw.charges == 2 and not player.hasBuff(spells.ruleOfLaw) and heal.lowestInRaid.hpIncoming < 0.85' },
    -- "Lumière de l’aube" -- "Light of Dawn" -- healing up to 5 injured allies within a 15 yd frontal cone
    {spells.lightOfDawn, 'not player.isMoving and heal.countLossInRange(0.82) > 2 and target.distance <= 30' },
    {spells.lightOfDawn, 'not player.isMoving and heal.countLossInRange(0.92) > 4 and target.distance <= 30' },
    {spells.lightOfDawn, 'not player.isMoving and heal.countLossInRange(0.86) > 3 and target.distance <= 30' },
    {spells.lightOfDawn, 'not player.isMoving and heal.countLossInRange(0.82) > 2 and heal.countInRange <= 5' },
    -- PVP
    {spells.divineFavor, 'player.isPVP' },

    -- AZERITE
    -- "Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
    {spells.azerite.refreshment, 'player.buffValue(spells.azerite.theWellOfExistence) > 19000 and heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    -- "Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
    {spells.azerite.overchargeMana, 'heal.countLossInRange(0.80) > 2' },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    {spells.azerite.memoryOfLucidDreams, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
    
    -- APPLY MANUAL "Maîtrise des auras" -- Renforce l’aura choisie et porte son rayon d’effet à 40 mètres pendant 8 sec.

    {{"nested"}, 'kps.tankhammer and heal.lowestTankInRaid.hp < 0.80' ,{
        {spells.holyShock, 'not heal.lowestTankInRaid.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestTankInRaid },
        {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "holyLight_TANK" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
        -- "Blessing of Sacrifice"  -- Blessing of Sacrifice can be dangerous to your own life if used without a damage reduction cooldown such as Divine Protection or Divine Shield 
        {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.isUnit("player") and player.hp > 0.90 and spells.divineProtection.cooldown < player.gcd' , kps.heal.lowestTankInRaid },
        {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hp < 0.80 and player.hp > 0.90 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid , "heal_tank" },
    }},

    -- Damage
    {{"nested"}, 'kps.multiTarget and heal.lowestInRaid.hpIncoming > 0.85' ,{
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestInRaid.hpIncoming < 0.85' , kps.heal.lowestInRaid },
    {spells.holyAvenger, 'player.hasTalent(5,3)' },
    {spells.avengingWrath, 'player.hasTalent(6,1)' },
    {spells.judgment,  'true' , env.damageTarget },
    {spells.holyShock,  'true' , env.damageTarget },
    {spells.crusaderStrike, 'target.isAttackable and target.distance <= 10' , "target" },
    {spells.consecration, 'not player.isMoving and target.isAttackable and target.distance <= 10' },
    }},

    -- "Vengeur sacré" --"Holy Avenger" -- Increases your haste by 30% and your Holy Shock healing by 30% for 20 sec.
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.lowestInRaid.hp < 0.40 and heal.countInRange <= 5' },
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) > 3' },
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) > 2 and heal.countInRange <= 5' },
    -- "Courroux vengeur" --"Avenging Wrath"  -- Damage, healing, and critical strike chance increased by 20%.
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.lowestTankInRaid.hp < 0.40 and heal.countInRange <= 5' },
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.countLossInRange(0.80) > 3' },
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.countLossInRange(0.80) > 2 and heal.countInRange <= 5' },
    -- "Croisé vengeur --"Avenging Crusader" -- Replaces Avenging Wrath -- 3 nearby allies will be healed for 250% of the damage done. Crusader Strike, Judment damage increased by 30%.
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.lowestTankInRaid.hp < 0.40 and heal.countInRange <= 5' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 3' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 2 and heal.countInRange <= 5' },


    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cast time of your next Holy Light by 1.5 sec or increases the healing of your next Flash of Light by 40%.
    -- "Révélations divines" "Divine Revelations" -- Healing an ally with Holy Light while empowered by Infusion of Light refunds 320 mana.
    {spells.holyShock, 'mouseover.isHealable and not mouseover.hasBuff(spells.glimmerOfLight)' , "mouseover" ,  "holyShock_mouseover" },
    {spells.holyShock, 'mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" },
    -- "Horion sacré" "Holy Shock" -- Holy damage to an enemy. healing to an ally -- "Glimmer of Light" -- Holy Shock leaves a Glimmer of Light on the target for 30 sec.
    {spells.holyShock, 'not player.hasBuff(spells.glimmerOfLight)' , "player" },
    {spells.holyShock, 'not heal.lowestTankInRaid.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'not heal.lowestInRaid.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid },
    {spells.holyShock, 'not heal.lowestUnitInRaid.hasBuff(spells.glimmerOfLight)' , kps.heal.lowestUnitInRaid },
    {spells.holyShock, 'not heal.hasNotBuffGlimmer.isUnit("player")' , kps.heal.hasNotBuffGlimmer , "GLIMMER" },
    
    {spells.holyShock, 'player.hp < 0.65' , "player" },
    {spells.holyShock, 'heal.lowestInRaid.hp < 0.65 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid },

    {spells.holyShock, 'heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'heal.lowestUnitInRaid.hp < 0.90' , kps.heal.lowestUnitInRaid },
    {spells.holyShock, 'heal.lowestInRaid.hp > 0.90' , env.damageTarget },

    {{"nested"}, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' ,{
    {spells.flashOfLight, 'player.hp < 0.55' , "player" , "holyLight_PLAYER" },
    {spells.flashOfLight, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid , "holyLight_TANK" },
    {spells.flashOfLight, 'heal.lowestInRaid.hp < 0.55' , kps.heal.lowestInRaid , "holyLight_LOWEST" },
    {spells.holyLight, 'heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "heal_lowest" },
    {spells.holyLight, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    {spells.holyLight, 'player.hp < 0.90' , "player" , "heal_player" },
    }},

    -- "Jugement de lumière" -- permet aux 25 prochaines attaques réussies contre la cible de rendre (5% of Spell power) points de vie à l’attaquant.
    {spells.judgment, 'player.hasTalent(5,1) and target.isAttackable' , "target" },
    -- "Puissance du croisé -- Frappe du croisé diminue le temps de recharge de Horion sacré et de Lumière de l’aube de 1.5 s.
    {spells.crusaderStrike, 'player.hasTalent(1,1) and target.isAttackable and target.distance <= 10' , "target" },

    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hp < 0.80 and player.hp > 0.90 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestInRaid.hp < 0.80 and player.hp > 0.90 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},
    -- MOUSEOVER
    {spells.flashOfLight, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" , "flashOfLight_mouseover" },        
    {spells.holyLight, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.90' , "mouseover" , "holyLight_mouseover" },

    {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55 and player.incomingDamage > player.incomingHeal' , "player" , "FLASH_PLAYER"  },
    {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hp < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.incomingDamage > heal.lowestInRaid.incomingHeal' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.90 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
    {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    
    {{"nested"}, 'not player.isMoving and heal.countInRange <= 5' ,{
        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.70 and player.incomingDamage > player.incomingHeal' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.incomingDamage > heal.lowestInRaid.incomingHeal' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
        {spells.holyLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.90 and heal.lowestInRaid.hpIncoming < heal.lowestTankInRaid.hpIncoming' , kps.heal.lowestInRaid , "heal_lowest" },
        {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },
    }},

    -- Damage
    {spells.judgment, 'true' , env.damageTarget },
    {spells.holyShock, 'true' , env.damageTarget },
    {spells.crusaderStrike, 'target.isAttackable and target.distance <= 5' , "target" },
    {spells.consecration, 'not player.isMoving and target.isAttackable and target.distance <= 10' },

    --{{"macro"}, 'true' , "/startattack" },

}
,"holy_paladin_bfa")
