--[[[
@module Paladin Holy Rotation
@author htordeux
@version 7.0.3
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.rotations.register("PALADIN","HOLY",
{
    -- "Bouclier divin" ""Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'spells.blessingOfSacrifice.lastCasted(4) and player.hp < 0.55' , "player" },
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'player.isTarget and target.isRaidBoss' , "player" },
    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec. during that time the caster also cannot attack or use spells.
    {spells.divineProtection, 'spells.blessingOfSacrifice.lastCasted(4) and player.hp < 0.55 and not player.hasBuff(spells.divineShield)' , "player" },
    {spells.divineProtection, 'player.hp < 0.30 and not player.hasBuff(spells.divineShield)' , "player" },
    {spells.divineProtection, 'player.isTarget and target.isRaidBoss and not player.hasBuff(spells.divineShield)' , "player" },

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" },    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.30', "player" },
    {spells.layOnHands, 'heal.lowestInRaid.hp < 0.30', kps.heal.lowestInRaid },
    
    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'not heal.lowestTankInRaid.hasBuff(spells.bestowFaith) and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid },  
    -- "Blessing of Sacrifice"  -- Blessing of Sacrifice can be dangerous to your own life if used without a damage reduction cooldown such as Divine Protection or Divine Shield 
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.isUnit("player") and player.hp > 0.90 and spells.divineProtection.cooldown < kps.gcd' , kps.heal.lowestTankInRaid },
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.isUnit("player") and player.hp > 0.90 and spells.divineShield.cooldown < kps.gcd' , kps.heal.lowestTankInRaid },

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection
    -- "Blessing of Protection" -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'keys.ctrl' , "mouseover" },
    {spells.blessingOfProtection, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
    {spells.blessingOfProtection, 'player.hp < 0.30' , kps.heal.lowestUnitInRaid },
    {spells.blessingOfProtection, 'heal.lowestUnitInRaid.hp < 0.30' , kps.heal.lowestUnitInRaid },

    {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.cleanse, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable , "DISPEL" },
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.hammerOfJustice, 'focus.distance < 10 and focus.isCasting and focus.isAttackable' , "focus" },
        {spells.hammerOfJustice, 'target.distance < 10 and target.isCasting and target.isAttackable' , "target" },
        {spells.repentance, 'target.isCasting and target.distance < 30 and target.isAttackable' , "target" },
    }},
    
    -- APPLY MANUAL -- "Beacon of Faith" -- Mark a second target as a Beacon, mimicking the effects of Beacon of Light. Your heals will now heal both of your Beacons, but at 30% reduced effectiveness.
    --{spells.beaconOfFaith, 'player.hasTalent(7,2) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfLight) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfFaith) and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid },
    -- APPLY MANUAL -- "Guide de lumière" "Beacon of Light" -- Targeting this ally directly with Flash of Light or Holy Light also refunds 25% of Mana spent on those heals -- your heals on other party or raid members to also heal that ally for 40% of the amount healed.
    --{spells.beaconOfLight, 'not heal.lowestTankInRaid.hasBuff(spells.beaconOfLight) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfFaith) and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid },
    -- "Guide de vertu" "Beacon of Virtue" -- Replaces "Beacon of Light"  -- Applique un Guide de lumière sur la cible et 3 allié blessé à moins de 30 mètres pendant 8 sec. Vos soins leur rendent 40% du montant soigné.
    {spells.beaconOfVirtue, 'player.hasTalent(7,3) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfVirtue) and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid },

    -- "Horion sacré" "Holy Shock" -- Holy damage to an enemy. healing to an ally
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'mouseover.hp < 0.82' , "mouseover" },
    {spells.holyShock, 'heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestUnitInRaid.hp < 0.90' , kps.heal.lowestUnitInRaid },
    {spells.holyShock, 'heal.lowestUnitInRaid.hp > heal.lowestTankInRaid.hp and heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid },
    {spells.holyShock, 'target.isAttackable' , "target" , "holyShock_target" },

    -- "Maîtrise des auras" -- Renforce l’aura choisie et porte son rayon d’effet à 40 mètres pendant 8 sec.
    {spells.auraMastery, 'player.hasTalent(4,3) and heal.countLossInRange(0.85) > countFriend()' },
    -- "Règne de la loi" -- Vous augmentez de 50% la portée de vos soins
    {spells.ruleOfLaw, 'player.hasTalent(2,3) and heal.countLossInRange(0.85) > countFriend() and not player.hasBuff(spells.ruleOfLaw)' },
    -- "Jugement de lumière" -- permet aux 25 prochaines attaques réussies contre la cible de rendre (5% of Spell power) points de vie à l’attaquant.
    {spells.judgment, 'player.hasTalent(5,1) and target.isAttackable' , "target" },
    {spells.judgment, 'player.hasBuff(spells.avengingCrusader) and target.isAttackable' , "target" },
    -- "Vengeur sacré" --"Holy Avenger" -- Increases your haste by 30% and your Holy Shock healing by 30% for 20 sec.
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.lowestTankInRaid.hp < 0.65' },
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.78) > countFriend()' },
    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.82)*2 > heal.countInRange' },
    -- "Courroux vengeur" --"Avenging Wrath"  -- Damage, healing, and critical strike chance increased by 20%.
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.lowestTankInRaid.hp < 0.65' },
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.countLossInRange(0.78) > countFriend()' },
    {spells.avengingWrath, 'player.hasTalent(6,1) and heal.countLossInRange(0.82)*2 > heal.countInRange' },
    -- "Croisé vengeur --"Avenging Crusader" -- Replaces Avenging Wrath -- 3 nearby allies will be healed for 250% of the damage done. Crusader Strike, Judment damage increased by 30%.
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.lowestTankInRaid.hp < 0.65' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.78) > countFriend()' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.82)*2 > heal.countInRange' },
    
    -- "Lumière de l’aube" -- "Light of Dawn" -- healing up to 5 injured allies within a 15 yd frontal cone
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85,15) > 2 and target.distance <= 15' },
    -- "Prisme sacré" -- "Holy Prism" -- deals (75% of Spell power) Holy damage and radiates (50% of Spell power) healing to 5 allies within 15 yards. it heals for (100% of Spell power) and radiates (45% of Spell power) Holy damage to 5 enemies within 15 yards.
    {spells.holyPrism, 'player.hasTalent(5,2) and heal.countLossInRange(0.82) > 2 and target.isAttackable and targettarget.isFriend and targettarget.hp < 0.90' , "targettarget" },
    {spells.holyPrism, 'player.hasTalent(5,2) and heal.countLossInRange(0.82) > 2 and target.isAttackable' , "target" },

    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hp < 0.85 and player.hp > 0.90 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid },
    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestUnitInRaid.hp < 0.85 and player.hp > 0.90 and not heal.lowestUnitInRaid.isUnit("player")' , kps.heal.lowestUnitInRaid }, 

    {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and player.hp < 0.40' , "player"  }, 
    {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid  }, 
        
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" , "holyLight_mouseover" }, 
    {spells.flashOfLight, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" , "flashOfLight_mouseover" },
    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cast time of your next Holy Light by 1.5 sec or increases the healing of your next Flash of Light by 40%.
    -- "Révélations divines" "Divine Revelations" -- Healing an ally with Holy Light while empowered by Infusion of Light refunds 320 mana.
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and player.hp < 0.65 and player.hp > heal.lowestTankInRaid.hp' , "player"  },
    {spells.flashOfLight, 'not player.isMoving and player.hp < 0.65 and player.hp > heal.lowestTankInRaid.hp' , "player"  },
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid }, 
    {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.65' , kps.heal.lowestTankInRaid  }, 
    {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestUnitInRaid.hp < 0.65' , kps.heal.lowestUnitInRaid  } , 
    {spells.flashOfLight, 'not player.isMoving and heal.lowestUnitInRaid.hp < 0.65' , kps.heal.lowestUnitInRaid  },

    {spells.holyLight, 'not player.isMoving and heal.lowestUnitInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestUnitInRaid.hp < 0.90' , kps.heal.lowestUnitInRaid , "holyLight_unit" },
    {spells.holyLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid , "holyLight_tank" },

    -- Damage
    {spells.crusaderStrike, 'player.hasBuff(spells.avengingCrusader) and target.isAttackable and target.distance <= 10' , "target" },
    {spells.judgment, 'target.isAttackable' , "target" },
    {spells.consecration, 'not player.isMoving and target.isAttackable and target.distance <= 10' },
    {spells.crusaderStrike, 'target.isAttackable and target.isAttackable and target.distance <= 10' , "target" },
    
    {{"macro"}, 'true' , "/startattack" },

}
,"holy_paladin_bfa")
