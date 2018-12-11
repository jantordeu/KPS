--[[[
@module Paladin Protection Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","PROTECTION", "taunt", "Interface\\Icons\\spell_nature_reincarnation", "taunt")
end)

kps.runAtEnd(function()
    kps.gui.addCustomToggle("PALADIN","PROTECTION", "pauseRotation", "Interface\\Icons\\Spell_frost_frost", "pauseRotation")
end)

kps.rotations.register("PALADIN","PROTECTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'not focus.isAttackable' , "/clearfocus" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },

    {spells.cleanseToxins, 'player.isDispellable("Disease")' , "player" },
    {spells.cleanseToxins, 'player.isDispellable("Poison")' , "player" },
    
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    
    -- Interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.hammerOfJustice, 'focus.distance < 10 and focus.isCasting' , "focus" },
        {spells.hammerOfJustice, 'target.distance < 10 and target.isCasting' , "target" },
        {spells.blindingLight, 'target.distance < 10 and target.isCasting' , "target" },
        {spells.blindingLight, 'target.distance < 10 and player.plateCount > 2' , "target" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting' , "target" },
        {spells.rebuke, 'focus.isCasting' , "focus" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'not player.isUnit("mouseover") and mouseover.hp < 0.40 and mouseover.isHealable' , "mouseover"},
    {spells.blessingOfProtection, 'player.hp < 0.55' , "player"},

    {{"nested"}, 'kps.pauseRotation',{
        {spells.handOfTheProtector, 'player.hasTalent(5,3) and player.incomingDamage > player.incomingHeal and player.hp < 0.82' },
        {spells.lightOfTheProtector, 'not player.hasTalent(5,3) and player.incomingDamage > player.incomingHeal and player.hp < 0.82' },
        {spells.judgment, 'target.isAttackable and target.distance < 30 and target.myDebuffDuration(spells.judgment) < 2' , "target" },
        {spells.consecration, 'not player.isMoving and not target.hasMyDebuff(spells.consecration) and target.distance <= 10' , "target" , "consecration_target" },
        {spells.hammerOfTheRighteous, 'not player.hasTalent(1,3) and player.hasBuff(spells.consecration) and target.distance <= 10', "target" , "hammerOfTheRighteous" },
    }},
    {{"pause"}, 'kps.pauseRotation', 2},
    -- "Hand of Reckoning" -- taunt
    {spells.handOfReckoning, 'kps.taunt and not player.isTarget' , "target" , "taunt" },

    -- "Avenging Wrath" -- "Courroux vengeur" -- Dégâts, soins et chances de coup critique augmentés de 20%. pendant 20 sec.
    {spells.avengingWrath, 'player.incomingDamage > player.incomingHeal and player.hp < 0.85' },
    {spells.avengingWrath, 'player.incomingDamage - player.incomingHeal > player.hpMax * 0.10' },
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health
    {spells.layOnHands, 'player.hp < 0.40' },
    -- "Main du protecteur" talent replace "Lumière du protecteur" -- rendre à une cible alliée 30% de ses points de vie manquants.
    {spells.handOfTheProtector, 'player.hasTalent(5,3) and player.incomingDamage > player.incomingHeal and player.hp < 0.82' },
    {spells.lightOfTheProtector, 'not player.hasTalent(5,3) and player.incomingDamage > player.incomingHeal and player.hp < 0.82' },

    -- "Ardent Defender" -- Reduces all damage you take by 20% for 8 sec -- cd 2 min -- next attack that would otherwise kill you will instead bring you to 20% of your maximum health.
    {spells.ardentDefender, 'player.hp < 0.72 and player.incomingDamage > player.incomingHeal' },
    {spells.ardentDefender, 'player.hp < 0.72 and player.incomingDamage > player.incomingHeal' },
    -- "Guardian of Ancient Kings" -- 5 min cd Damage taken reduced by 50% 8 seconds remaining
    {spells.guardianOfAncientKings, 'player.hp < 0.65 and not player.hasBuff(spells.shieldOfTheRighteous) and not player.hasBuff(spells.ardentDefender)' },
    -- "Divine Shield" -- Protects you from all damage and spells for 8 sec. 
    {spells.divineShield, 'player.hp < 0.30' },

    {spells.avengersShield, 'spells.avengersShield.isUsable and target.distance <= 10 and not target.hasMyDebuff(spells.avengersShield)' , "target" , "avengersShield_isUsable" },
    {spells.judgment, 'target.isAttackable and target.distance < 30 and target.myDebuffDuration(spells.judgment) < 2' , "target" },
    {spells.consecration, 'not player.isMoving and not target.hasMyDebuff(spells.consecration) and target.distance <= 10' , "target" , "consecration_target" },
    {spells.consecration, 'not player.isMoving and not player.hasBuff(spells.consecration) and target.distance <= 10' , "player" , "consecration_player" },
    -- "Marteau béni" -- "Blessed Hammer" Talent Remplace Marteau du vertueux -- dégâts du Sacré aux ennemis et les affaiblit, réduisant de 12% les dégâts de leur prochaine attaque automatique contre vous.
    {spells.blessedHammer, 'player.hasTalent(1,3) and target.myDebuffDuration(spells.blessedHammer) < 2 and target.distance <= 10' , "target" , "blessedHammer" },
    {spells.consecration, 'not player.isMoving and not target.hasMyDebuff(spells.consecration) and target.distance <= 10' , "target" , "consecration_target" },
    {spells.consecration, 'not player.isMoving and not player.hasBuff(spells.consecration) and target.distance <= 10' , "player" , "consecration_player" },
    -- "Bouclier du vengeur" -- "Avenger's Shield" -- Augmente de 20% les effets de votre prochain Bouclier du vertueux. -- dégâts du Sacré, avant de rebondir sur 2 ennemis proches supplémentaires.
    {spells.avengersShield, 'target.distance <= 10' , "target" , "avengersShield" },
    -- "Hammer of the Righteous" -- "Marteau du vertueux" -- inflige (27% of Attack power)% points de dégâts physiques. -- If you're standing in your Consecration, it also causes a wave of light that hits all nearby enemies for light Holy damage.
    {spells.hammerOfTheRighteous, 'not player.hasTalent(1,3) and player.hasBuff(spells.consecration) and target.distance <= 10', "target" , "hammerOfTheRighteous" },
    -- "Bouclier du vertueux" -- "Shield of the Righteous" -- causing (33% of Attack power) Holy damage and increasing your Armor by (150 * Strength / 100) for 4.5 sec. 18 sec recharge
    -- "Avenger's Valor" --"Vaillance du vengeur" -- Buff The effects of your next Shield of the Righteous are increased by 20%.
    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous) and player.incomingDamage > player.incomingHeal and player.hasBuff(spells.avengersValor) and not player.hasBuff(spells.shieldOfTheRighteous)' , "target" , "shieldOfTheRighteous_avengersValor"},
    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous) and player.incomingDamage > player.incomingHeal and not player.hasBuff(spells.shieldOfTheRighteous)' , "target" , "shieldOfTheRighteous_incomingDamage"},

    {spells.flashOfLight, 'not player.isMoving and not player.isInGroup and player.hp < 0.72 and target.distance > 10', 'player'},
    {spells.judgment, 'target.isAttackable and target.distance > 10' , "target" },

    
    {{"macro"}, 'true' , "/startattack" },

 }
,"paladin_protection_bfa")
