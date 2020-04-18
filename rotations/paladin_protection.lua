--[[[
@module Paladin Protection Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","PROTECTION", "addControl", "Interface\\Icons\\spell_holy_sealofmight", "addControl")
end)

kps.rotations.register("PALADIN","PROTECTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    
    -- "Hand of Reckoning"
    {spells.handOfReckoning, 'kps.addControl and target.isAttackable and not targettarget.isUnit("player")' , "target" , "taunt" },

    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },

    {spells.cleanseToxins, 'player.isDispellable("Disease")' , "player" },
    {spells.cleanseToxins, 'player.isDispellable("Poison")' , "player" },
    
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.useItem(5512) and player.hpIncoming < 0.55', "/use item:5512" },
    -- "Potion de soins abyssale" 169451
    --{{"macro"}, 'player.useItem(169451) and player.hp <= 0.40' ,"/use item:169451" },
    
    -- Interrupts
    {{"nested"}, 'kps.addControl',{
    	{spells.hammerOfJustice, 'mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    	{spells.hammerOfJustice, 'target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting ' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting and focus.isInterruptable' , "focus" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    -- "Avenging Wrath" -- "Courroux vengeur" -- Dégâts, soins et chances de coup critique augmentés de 20%. pendant 20 sec.
    {spells.avengingWrath, 'player.hp < 0.65 and spells.handOfTheProtector.cooldown < player.gcd' },
    {spells.avengingWrath, 'player.hp < 0.65 and spells.lightOfTheProtector.cooldown < player.gcd' },
    -- "Main du protecteur" talent replace "Lumière du protecteur"
    {spells.handOfTheProtector, 'player.hasTalent(5,3) and player.hp < 0.65' },
    {spells.lightOfTheProtector, 'not player.hasTalent(5,3) and player.hp < 0.65' },
    
    -- AZERITE
    -- Each cast of Concentrated Flame deals 100% increased damage or healing. This bonus resets after every third cast.
    {spells.azerite.concentratedFlame, 'target.isAttackable and target.distanceMax <= 30' , "target" },
    {spells.azerite.memoryOfLucidDreams, 'player.hpIncoming < 0.65' , "target" },
    {spells.azerite.aegisOfTheDeep, 'player.hpIncoming < 0.80'},
    {spells.azerite.azerothUndyingGift, 'player.hpIncoming < 0.80'},

    -- "Ardent Defender" -- Reduces all damage you take by 20% for 8 sec -- cd 2 min -- next attack that would otherwise kill you will instead bring you to 20% of your maximum health.
    {spells.ardentDefender, 'target.isCasting ' , "ardentDefender_casting" },
    {spells.ardentDefender, 'player.hpIncoming < 0.65 and spells.handOfTheProtector.cooldown > player.gcd' }, 
    {spells.ardentDefender, 'player.hpIncoming < 0.65 and spells.lightOfTheProtector.cooldown > player.gcd' },
    -- "Guardian of Ancient Kings" -- 5 min cd Damage taken reduced by 50% 8 seconds remaining
    {spells.guardianOfAncientKings, 'player.hpIncoming < 0.40 and not player.hasBuff(spells.ardentDefender) and spells.ardentDefender.cooldown > player.gcd' },
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'mouseover.hp < 0.40 and mouseover.isHealable' , "mouseover"},
    {spells.blessingOfProtection, 'player.hpIncoming < 0.40 and not player.hasBuff(spells.ardentDefender) and not player.hasBuff(spells.guardianOfAncientKings)' , "player"},
    -- "Divine Shield" -- Protects you from all damage and spells for 8 sec. 
    {spells.divineShield, 'player.hpIncoming < 0.30 and not player.hasDebuff(spells.forbearance)' },
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health
    {spells.layOnHands, 'player.hpIncoming < 0.40' },

    -- "Bouclier du vengeur" -- "Avenger's Shield"
    -- Buff "Poussée de bouclier" -- "Soaring Shield" -- 278954/soaring-shield Bouclier du vengeur frappe désormais 4 ennemi et confère un bonus de 104 à la Maîtrise par ennemi touché pendant 8 sec.
    -- Buff "Avenger's Valor" -- "Vaillance du vengeur" -- The effects of your next Shield of the Righteous are increased by 20%.
    -- Debuff "Bouclier du vengeur" -- "Avenger's Shield" -- Silenced 3 seconds remaining

    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous) and player.hasBuff(spells.avengersValor) and spells.shieldOfTheRighteous.charges == 3 ' , "target" , "shieldOfTheRighteous_charges"},
    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous) and player.hasBuff(spells.avengersValor) and player.hpIncoming < 0.80 and spells.shieldOfTheRighteous.charges == 2 ' , "target" , "shieldOfTheRighteous_health_80"},
    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous) and player.hpIncoming < 0.65' , "target" , "shieldOfTheRighteous_health_65"},
    -- "Bouclier du vertueux" -- "Shield of the Righteous" -- causing (33% of Attack power) Holy damage and increasing your Armor by (150 * Strength / 100) for 4.5 sec. 18 sec recharge
    {spells.avengersShield, 'target.distanceMax <= 10 and target.isCasting and target.castTimeLeft < 2' , "target" , "avengersShield_casting" },
    {spells.avengersShield, 'target.distanceMax <= 10 and player.myBuffDuration(spells.avengersValor) < 2' , "target" , "avengersShield_isUsable" },

    {spells.judgment, 'target.isAttackable and target.distanceMax <= 30 and target.myDebuffDuration(spells.judgment) < 2' , "target" },
    {spells.judgment, 'player.hasTalent(2,2) and target.isAttackable and target.distanceMax <= 30 and spells.judgment.charges == 2' , "target" },
    {spells.consecration, 'not player.isMoving and not player.hasBuff(spells.consecration) and target.distanceMax <= 10' , "player" , "consecration_player" },
    -- "Marteau béni" -- "Blessed Hammer" Talent Remplace Marteau du vertueux -- dégâts du Sacré aux ennemis et les affaiblit, réduisant de 12% les dégâts de leur prochaine attaque automatique contre vous.
    {spells.blessedHammer, 'player.hasTalent(1,3) and target.myDebuffDuration(spells.blessedHammer) < 2 and target.distance <= 10' , "target" , "blessedHammer" },
    -- "Hammer of the Righteous" -- "Marteau du vertueux" -- inflige (27% of Attack power)% points de dégâts physiques. -- If you're standing in your Consecration, it also causes a wave of light that hits all nearby enemies for light Holy damage.
    {spells.hammerOfTheRighteous, 'not player.hasTalent(1,3) and player.hasBuff(spells.consecration) and target.distanceMax <= 10', "target" , "hammerOfTheRighteous" },

    {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.40', 'player'},

 }
,"paladin_protection_bfa")
