--[[[
@module Paladin Holy Rotation
@author htordeux
@version 7.0.3
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","HOLY", "addControl", "Interface\\Icons\\spell_holy_sealofmight", "addControl")
end)

kps.rotations.register("PALADIN","HOLY",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    
    -- ShouldInterruptCasting,
    --{{"macro"}, 'spells.holyLight.shouldInterrupt(0.95,kps.defensive)' , "/stopcasting" },
    {{"macro"}, 'spells.flashOfLight.shouldInterrupt(0.90,kps.defensive)' , "/stopcasting" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.65' ,"/use item:5512" },
    -- "Potion de soins abyssale" 169451
    {{"macro"}, 'player.useItem(169451) and player.hp <= 0.40' ,"/use item:169451" },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'player.hp < 0.30 and not player.hasDebuff(spells.forbearance)', "player" },
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },

    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'spells.blessingOfSacrifice.lastCasted(4)' , "player" },
    {spells.divineProtection, 'player.hp < 0.40' , "player" },
    -- "Blessing of Sacrifice"  -- transferring 30% of the damage taken by your target to you -- Blessing of Sacrifice can be dangerous to your own life if used without a damage reduction cooldown such as Divine Protection or Divine Shield 
    {spells.blessingOfSacrifice, 'heal.lowestTankInRaid.hp < 0.40 and not heal.lowestTankInRaid.isUnit("player") and player.hp > 0.85 and spells.divineProtection.cooldown < player.gcd' , kps.heal.lowestTankInRaid },    

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'player.hp < 0.30 and not player.hasDebuff(spells.forbearance)' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30 and not player.hasDebuff(spells.forbearance)' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTankInRaid.hasDebuff(spells.forbearance)' , kps.heal.lowestTankInRaid },
    {spells.divineShield, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.hasDebuff(spells.forbearance)' , kps.heal.lowestInRaid },

    {{"nested"},'kps.cooldowns', {
        {spells.cleanse, 'mouseover.isHealable and mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.cleanse, 'player.isDispellable("Magic")' , "player" },
        {spells.cleanse, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid },
        {spells.cleanse, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid },
        {spells.cleanse, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
    }},
    -- Interrupt
    {{"nested"}, 'kps.addControl',{
        {spells.hammerOfJustice, 'mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
        {spells.hammerOfJustice, 'target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    }},
    {{"nested"}, 'kps.interrupt' ,{
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting ' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting and focus.isInterruptable' , "focus" },
    }},
    -- PVP
    {spells.divineFavor, 'player.isPVP and heal.lowestInRaid.hp < 0.85' },

    -- APPLY MANUAL -- 
    -- "Beacon of Light" -- Targeting this ally directly with Flash of Light or Holy Light also refunds 25% of Mana spent on those heals 
    -- your heals on other party or raid members to also heal that ally for 40% of the amount healed.
    --{spells.beaconOfLight, 'not player.hasTalent(7,3) and focus.isHealable and not focus.hasBuff(spells.beaconOfLight) and not focus.hasBuff(spells.beaconOfFaith) and not focus.isUnit("player")' , "focus" },
    -- "Beacon of Faith" -- Mark a second target as a Beacon, mimicking the effects of Beacon of Light. Your heals will now heal both of your Beacons, but at 30% reduced effectiveness.
    --{spells.beaconOfFaith, 'player.hasTalent(7,2) and not player.hasBuff(spells.beaconOfFaith) and not player.hasBuff(spells.beaconOfLight)' , "player" },
    -- "Beacon of Virtue" -- Replaces "Beacon of Light"  -- Applique un Guide de lumière sur la cible et 3 allié blessé à moins de 30 mètres pendant 8 sec. Vos soins leur rendent 40% du montant soigné.
    --{spells.beaconOfVirtue, 'player.hasTalent(7,3) and not heal.lowestTankInRaid.hasBuff(spells.beaconOfVirtue)' , kps.heal.lowestTankInRaid },

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    -- "Bestow Faith" "Don de foi" -- Récupère (150% of Spell power) points de vie à expiration. -- 12 sec cd
    {spells.bestowFaith, 'player.hasTalent(1,2) and not heal.lowestTankInRaid.hasBuff(spells.bestowFaith)' , kps.heal.lowestTankInRaid },    
    -- "Règne de la loi" -- Vous augmentez de 50% la portée de vos soins
    {spells.ruleOfLaw, 'heal.countLossInRange(0.80) > 3 and not player.hasBuff(spells.ruleOfLaw)' },
    {spells.ruleOfLaw, 'spells.ruleOfLaw.charges == 2 and not player.hasBuff(spells.ruleOfLaw) and heal.lowestInRaid.hpIncoming < 0.85' },
    -- "Lumière de l’aube" -- "Light of Dawn" -- healing up to 5 injured allies within a 15 yd frontal cone
    {spells.lightOfDawn, 'player.isMoving and and heal.countLossInDistance(0.85,10) >= 1' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.80,10) >= 2' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.85,10) >= 3' },
    {spells.lightOfDawn, 'heal.countLossInDistance(0.90,10) >= 4' },
    {spells.lightOfDawn, 'heal.countLossInRange(0.80) >= 2 and player.hasBuff(spells.ruleOfLaw)' },
    {spells.lightOfDawn, 'heal.countLossInRange(0.85) >= 3 and player.hasBuff(spells.ruleOfLaw)' },
    {spells.lightOfDawn, 'heal.countLossInRange(0.90) >= 4 and player.hasBuff(spells.ruleOfLaw)' },

    -- AZERITE
    -- "Refreshment" -- Release all healing stored in The Well of Existence into an ally. This healing is amplified by 20%.
    {spells.azerite.refreshment, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid },
    -- "Overcharge Mana" "Surcharge de mana" -- each spell you cast to increase your healing by 4%, stacking. While overcharged, your mana regeneration is halted.
    {spells.azerite.overchargeMana, 'heal.countLossInRange(0.80) > 2' },
    -- "Souvenir des rêves lucides" "Memory of Lucid Dreams" -- augmente la vitesse de génération de la ressource ([Mana][Énergie][Maelström]) de 100% pendant 12 sec
    {spells.azerite.memoryOfLucidDreams, 'heal.countLossInRange(0.80) > 2' , kps.heal.lowestInRaid },
    
    -- APPLY MANUAL "Maîtrise des auras" -- Renforce l’aura choisie et porte son rayon d’effet à 40 mètres pendant 8 sec.
    --{spells.auraMastery, 'heal.countLossInRange(0.80)*2  > heal.countInRange' },

    {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.80)*2  > heal.countInRange' },
    {spells.avengingWrath, 'player.hasTalent(6,1) and not player.hasBuff(spells.avengingWrath) and heal.countLossInRange(0.80)*2  > heal.countInRange' },
    {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80)*2  > heal.countInRange' },

    -- MOUSEOVER
    {spells.holyShock, 'mouseover.isHealable and mouseover.hp < 0.65' , "mouseover" , "holyShock_mouseover"},
    {spells.holyShock, 'mouseover.isHealable and not mouseover.hasMyBuff(spells.glimmerOfLight)' , "mouseover" , "holyShock_mouseover"}, 
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.85 and heal.lowestTankInRaid.myBuffDuration(spells.glimmerOfLight) < 5' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'not heal.lowestTankInRaid.hasMyBuff(spells.glimmerOfLight) and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "holyShock_tank" },
    {spells.holyShock, 'heal.lowestInRaid.hpIncoming < 0.65 and not heal.lowestInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid , "holyShock_lowest" },
    {spells.holyShock, 'not heal.assistTankInRaid.hasMyBuff(spells.glimmerOfLight) and not heal.assistTankInRaid.isUnit("player")' , kps.heal.assistTankInRaid , "holyShock_assistTank" },
    {spells.holyShock, 'not player.hasMyBuff(spells.glimmerOfLight)' , "player" , "holyShock_player" },
    {spells.holyShock, 'heal.lowestInRaid.hpIncoming < 0.85 and not heal.lowestInRaid.hasMyBuff(spells.glimmerOfLight)' , kps.heal.lowestInRaid , "holyShock_lowest" },
    
    -- GLIMMER DAMAGE
    {{"nested"}, 'kps.multiTarget and heal.lowestInRaid.hpIncoming > 0.85' ,{
        {spells.judgment,  'true' , env.damageTarget },
        {spells.holyShock,  'mouseover.isAttackable and not mouseover.hasDebuff(spells.glimmerOfLight)' , "mouseover" },
        {spells.holyShock,  'true' , env.damageTarget },
        {spells.holyAvenger, 'kps.cooldowns and player.hasTalent(5,3)' },
        {spells.avengingWrath, 'kps.cooldowns and player.hasTalent(6,1)' },
        {spells.consecration, 'not target.isMoving and not player.isMoving and target.isAttackable and target.distance <= 10' },
        {spells.crusaderStrike, 'target.isAttackable and target.distance <= 10' , "target" },
    }},
    -- TAB targeting DAMAGE
    {spells.judgment, 'heal.lowestInRaid.hpIncoming > 0.85' , env.damageTarget },
    {spells.holyShock, 'heal.lowestInRaid.hpIncoming > 0.85 and target.isAttackable and not target.hasMyDebuff(spells.glimmerOfLight)' , "target" , "dmg_health" },


    {{"nested"}, 'mouseover.isHealable and mouseover.hp < 0.65' ,{
        {spells.holyShock, 'not player.hasBuff(spells.infusionOfLight)' , "mouseover"  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and mouseover.hp < 0.40' , "mouseover" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' , "mouseover" },
        {spells.holyShock, 'true' , "mouseover"  },
        {spells.flashOfLight, 'not player.isMoving and mouseover.hp < 0.40' , "mouseover" },
    }},
    {{"nested"}, 'player.hp < 0.65' ,{
        {spells.holyShock, 'not player.hasBuff(spells.infusionOfLight)' , "player"  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and player.hp < 0.55' , "player" },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' , "player" },
        {spells.holyShock, 'true' , "player"  },
        {spells.flashOfLight, 'not player.isMoving and player.hp < 0.40' , "player" },
    }},
    {{"nested"}, 'heal.lowestTankInRaid.hp < 0.65 and not heal.lowestTankInRaid.isUnit("player")' ,{
        {spells.holyShock, 'not player.hasBuff(spells.infusionOfLight)' , kps.heal.lowestTankInRaid  },
        {spells.flashOfLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight) and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' , kps.heal.lowestTankInRaid },
        {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid },
    }},
    {{"nested"}, 'heal.lowestInRaid.hp < 0.65' ,{
        {spells.holyShock, 'not player.hasBuff(spells.infusionOfLight)' , kps.heal.lowestInRaid  },
        {spells.holyLight, 'not player.isMoving and player.hasBuff(spells.infusionOfLight)' , kps.heal.lowestInRaid },
        {spells.holyShock, 'true' , kps.heal.lowestInRaid  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid },
    }},
    
    -- GLIMMER HEAL
    -- 216411/divine-purpose -- spells.divinePurposeHolyShock -- Divine Purpose Your next Holy Shock costs no mana. 10 seconds remaining
    -- 216413/divine-purpose -- spells.divinePurposeLightOfDawn -- Divine Purpose Your next Light of Dawn costs no mana. 10 seconds remaining
    {spells.holyShock, 'not heal.hasNotBuffGlimmer.isUnit("player")' , kps.heal.hasNotBuffGlimmer , "holyShock_GLIMMER" },
    {spells.holyShock, 'heal.lowestInRaid.hp < 0.85 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid },
    {spells.holyShock, 'player.hp < 0.85 and player.hp < heal.lowestTankInRaid.hp' , "player"  },
    {spells.holyShock, 'heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid },

    -- "Imprégnation de lumière" "Infusion of Light" -- Reduces the cast time of your next Holy Light by 1.5 sec or increases the healing of your next Flash of Light by 40%.
    -- "Révélations divines" "Divine Revelations" -- Healing an ally with Holy Light while empowered by Infusion of Light refunds 320 mana. 
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < 0.85 and player.hasBuff(spells.infusionOfLight)' ,{
        {spells.flashOfLight, 'player.hp < 0.40 and not spells.flashOfLight.isRecastAt("player")' , "player" , "flash_player_infusion" },
        {spells.flashOfLight, 'heal.lowestInRaid.hp < 0.40 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and not spells.flashOfLight.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "flash_lowest_infusion" },
        {spells.flashOfLight, 'heal.lowestTankInRaid.hp < 0.40 and not spells.flashOfLight.isRecastAt(heal.lowestInRaid.unit)' ,  kps.heal.lowestInRaid , "flash_tank_infusion" },
        {spells.holyLight, 'heal.lowestInRaid.hp < 0.85 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid , "heal_lowest_infusion" },
        {spells.holyLight, 'player.hp < 0.85 and player.hp < heal.lowestTankInRaid.hp' , "player" , "heal_player_infusion" },
        {spells.holyLight, 'heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid , "heal_tank_infusion" },
    }},

    {{"nested"},'kps.cooldowns', {
        -- "Vengeur sacré" --"Holy Avenger" -- Increases your haste by 30% and your Holy Shock healing by 30% for 20 sec.
        {spells.holyAvenger, 'player.hasTalent(5,3) and heal.lowestInRaid.hp < 0.40' },
        {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) > 3' },
        {spells.holyAvenger, 'player.hasTalent(5,3) and heal.countLossInRange(0.80) > 2' },
        -- "Courroux vengeur" --"Avenging Wrath"  -- Damage, healing, and critical strike chance increased by 20%.
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and player.hasTalent(6,1) and heal.lowestTankInRaid.hp < 0.40' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and player.hasTalent(6,1) and heal.countLossInRange(0.80) > 3' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and player.hasTalent(6,1) and heal.countLossInRange(0.80) > 2' },
        -- "Croisé vengeur --"Avenging Crusader" -- Replaces Avenging Wrath -- 3 nearby allies will be healed for 250% of the damage done. Crusader Strike, Judment damage increased by 30%.
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.lowestTankInRaid.hp < 0.40' },
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 3' },
        {spells.avengingCrusader, 'player.hasTalent(6,2) and heal.countLossInRange(0.80) > 2' },
    }},

    -- MOUSEOVER
    {spells.flashOfLight, 'not player.isMoving and mouseover.isHealable and mouseover.hp < 0.55' , "mouseover" , "flashOfLight_mouseover" },
    -- "Judgment" -- the target take 30% increased damage from your next Crusader Strike or Holy Shock
    {spells.judgment, 'true' , env.damageTarget },
    -- "Horion sacré" "Holy Shock" -- Holy damage to an enemy. healing to an ally -- "Glimmer of Light" -- Holy Shock leaves a Glimmer of Light on the target for 30 sec.
    {spells.holyShock, 'true' , env.damageTarget , "dmg_holyShock" },
    -- "Puissance du croisé -- Frappe du croisé diminue le temps de recharge de Horion sacré et de Lumière de l’aube de 1.5 s.
    {spells.crusaderStrike, 'player.hasTalent(1,1) and target.isAttackable and target.distance <= 5' , "target" },

    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestTankInRaid.hp < 0.85 and player.hp > 0.85 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid , "MARTYR_tank"},
    {spells.lightOfTheMartyr, 'player.isMoving and heal.lowestInRaid.hp < 0.85 and player.hp > 0.85 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid , "MARTYR_lowest"},

    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55' ,{
        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.55' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.55 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.55' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},

    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.65 and not player.isInRaid' ,{
        {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.65' , "player" , "FLASH_PLAYER"  },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.65 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
        {spells.flashOfLight, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.65' , kps.heal.lowestTankInRaid , "FLASH_TANK"  },
    }},

    -- DAMAGE
    {spells.consecration, 'not target.isMoving and not player.isMoving and target.isAttackable and target.distance <= 10' },
    {spells.crusaderStrike, 'target.isAttackable and target.distance <= 5' , "target" },
    
    {spells.holyLight, 'heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.hp < heal.lowestTankInRaid.hp and heal.lowestInRaid.hp < player.hp' , kps.heal.lowestInRaid , "heal_lowest" },
    {spells.holyLight, 'player.hp < 0.90 and player.hp < heal.lowestTankInRaid.hp' , "player" , "heal_player" },
    {spells.holyLight, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid , "heal_tank" },

    --{{"macro"}, 'true' , "/startattack" },

}
,"holy_paladin_bfa")
