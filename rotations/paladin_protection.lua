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
        {spells.handOfReckoning, 'target.isAttackable and not targettarget.isUnit("player")' , "target" , "taunt" },
        {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous)' , "target" , "shieldOfTheRighteous_charges"},
        {spells.ardentDefender },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.avengersShield, 'target.distanceMax <= 10 and target.isCasting' , "target" , "avengersShield_casting" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting ' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting and focus.isInterruptable' , "focus" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
    }},

    -- "Ardent Defender" -- Reduces all damage you take by 20% for 8 sec -- cd 2 min -- next attack that would otherwise kill you will instead bring you to 20% of your maximum health.
    {spells.ardentDefender, 'player.hpIncoming < 0.70 and target.isCasting' },    
    -- "Guardian of Ancient Kings" -- 5 min cd Damage taken reduced by 50% 8 seconds remaining
    {spells.guardianOfAncientKings, 'player.hpIncoming < 0.50 and not player.hasBuff(spells.ardentDefender)' },
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    --{spells.blessingOfProtection, 'mouseover.hp < 0.40 and mouseover.isHealable' , "mouseover"},
    {spells.blessingOfProtection, 'player.hpIncoming < 0.40 and not player.hasBuff(spells.ardentDefender) and not player.hasBuff(spells.guardianOfAncientKings)' , "player"},
    
    -- "Avenging Wrath" -- "Courroux vengeur" -- Dégâts, soins et chances de coup critique augmentés de 20%. pendant 20 sec.
    {spells.avengingWrath, 'player.hp < 0.50' },
    {spells.wordOfGlory, 'player.hp < 0.70 and player.hasBuff(spells.shiningLight)'},
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health
    {spells.layOnHands, 'player.hpIncoming < 0.30' },
    -- "Divine Shield" -- Protects you from all damage and spells for 8 sec. 
    {spells.divineShield, 'player.hpIncoming < 0.30' },
    
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    {spells.judgment, 'target.isAttackable' , "target" },
	{spells.consecration, 'not player.isMoving and not player.hasBuff(spells.consecration) and target.distanceMax <= 5' , "player" , "consecration_player" },
    -- "Bouclier du vertueux" -- "Shield of the Righteous"
    {spells.shieldOfTheRighteous, 'not player.hasBuff(spells.shieldOfTheRighteous)' , "target" , "shieldOfTheRighteous"},
    -- Kyrian Covenant Ability -- cast Holy Shock, Avenger's Shield, or Judgment on up to 5 targets within 30 yds
    {spells.divineToll, 'true' , "target" },    
    -- "Bouclier du vengeur" -- "Avenger's Shield"
    {spells.avengersShield, 'target.distanceMax <= 10' , "target" },

	-- "Hammer of Wrath" -- Only usable on enemies that have less than 20% health
    {spells.hammerOfWrath, 'target.isAttackable' , "target" },
    -- "Marteau béni" -- "Blessed Hammer" Talent Remplace Marteau du vertueux -- dégâts du Sacré aux ennemis et les affaiblit, réduisant les dégâts de leur prochaine attaque automatique contre vous.
    {spells.blessedHammer, 'player.hasTalent(1,3) and target.distanceMax <= 10' , "target" , "blessedHammer" },
    -- "Hammer of the Righteous" -- "Marteau du vertueux" -- If you're standing in your Consecration, it also causes a wave of light that hits all nearby enemies for light Holy damage.
    {spells.hammerOfTheRighteous, 'player.hasBuff(spells.consecration) and target.distanceMax <= 10', "target" , "hammerOfTheRighteous" },

    {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.30', 'player'},
    {{"macro"}, 'target.isAttackable and target.distanceMax <= 5' , "/startattack" },

 }
,"paladin_protection_bfa")
