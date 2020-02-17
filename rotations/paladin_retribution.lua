--[[[
@module Paladin Retribution Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","RETRIBUTION", "addControl", "Interface\\Icons\\spell_holy_sealofmight", "addControl")
end)

kps.rotations.register("PALADIN","RETRIBUTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distanceMax <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distanceMax <= 10' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- "Shield of Vengeance" -- Creates a barrier of holy light that absorbs (30 / 100 * Total health) damage for 15 sec.
    {spells.shieldOfVengeance, 'player.incomingDamage > player.incomingHeal and target.distanceMax <= 10'},
    {spells.greaterBlessingOfKings, 'not player.isInGroup and not player.hasBuff(spells.greaterBlessingOfKings) and player.incomingDamage > player.incomingHeal' , "player" },

    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'player.hp < 0.40' , "player"},
    {spells.blessingOfProtection, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },    
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },

    {spells.layOnHands, 'player.hp < 0.30', 'player'},
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.flashOfLight, 'player.hasTalent(6,1) and player.hp < 0.80 and player.buffStacks(spells.selflessHealer) >= 3', "player" },
    {spells.wordOfGlory , 'player.hasTalent(6,3) and player.hp < 0.65'}, 
    
    {spells.divineShield, 'player.hp < 0.30 and not player.hasDebuff(spells.forbearance)' , "player" },

    {{"nested"}, 'kps.addControl',{
		-- "Main d’entrave" -- Movement speed reduced by 70%. 10 seconds remaining
    	{spells.handOfHindrance, 'mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    	{spells.handOfHindrance, 'target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    	{spells.hammerOfJustice, 'mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    	{spells.hammerOfJustice, 'target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
        {spells.hammerOfJustice, 'mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isCasting' , "mouseover" },
    	{spells.hammerOfJustice, 'target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    {{"nested"}, 'kps.interrupt',{
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting ' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting and focus.isInterruptable' , "focus" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
    }},

    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
        {spells.cleanseToxins, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable },
    }},
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" },

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 20' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and target.debuffStacks(spells.razorCoral) == 0' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and player.buffDuration(spells.avengingWrath) > 20 and kps.timeInCombat > 30' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and player.buffDuration(spells.crusade) > 20 and kps.timeInCombat > 30' , "/use 14" },

    -- AZERITE
    -- "Guardian of Azeroth" -- invoque un gardien d’Azeroth pendant 30 sec. 3 min cooldown.
    {spells.azerite.guardianOfAzeroth, 'kps.cooldowns and target.isAttackable' , "target" },
    --{spells.azerite.concentratedFlame, 'target.isAttackable and target.distanceMax <= 30' , "target" },
    --{spells.azerite.theUnboundForce, 'target.isAttackable and target.distanceMax <= 30' , "target" },
    {spells.azerite.memoryOfLucidDreams, 'target.isAttackable and player.myBuffDuration(spells.avengingWrath) > 15' , "target" },
    {spells.azerite.memoryOfLucidDreams, 'target.isAttackable and player.myBuffDuration(spells.crusade) > 15' , "target" },

    {spells.inquisition, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) < 15 and player.holyPower >= 2' , "target" },
    {{"nested"},'kps.cooldowns', {
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and target.isAttackable and player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) > 25 and target.distanceMax <= 10' },
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and target.isAttackable and player.hasTalent(7,1) and target.distanceMax <= 10' },
        {spells.crusade, 'target.isAttackable and player.hasTalent(7,2) and target.distanceMax <= 10' },
    }},

    {spells.executionSentence, 'player.hasTalent(1,3) and target.distanceMax <= 20' , "target" , "executionSentence" },
    {spells.hammerOfWrath, 'player.hasTalent(2,3)' , "target" }, -- Generates 1 Holy Power.
        
    {spells.divineStorm, 'kps.multiTarget' , "target" , "divineStorm_multitarget" },
    {spells.templarsVerdict, 'player.hasBuff(spells.righteousVerdict)' , "target" , "templarsVerdict_righteousVerdict" },
    {spells.templarsVerdict, 'target.hasMyDebuff(spells.judgment)' , "target" , "templarsVerdict_judgment" },
    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower)' , "target" , "divineStorm_empyreanPower" },
    {spells.divineStorm, 'player.plateCount >= 3' , "target" , "divineStorm_plateCount" },
    {spells.templarsVerdict, 'true' , "target" , "templarsVerdict" },

    {spells.judgment, 'not target.hasMyDebuff(spells.judgment) and target.distanceMax <= 30' , "target" }, -- 10 sec cd -- Generates 1 Holy Power
    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.distanceMax <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.wakeOfAshes, 'player.holyPower <= 1 and spells.avengingWrath.cooldown > 30 and target.distanceMax <= 10' , "target" },

    {spells.judgment, 'target.distanceMax <= 30' , "target" }, -- 10 sec cd -- Generates 1 Holy Power
    {spells.consecration, 'player.hasTalent(4,2) and not player.isMoving and not target.isMoving and target.distanceMax <= 10' }, -- Generates 1 Holy Power.
    {spells.crusaderStrike, 'target.distanceMax <= 10'}, --Generates 1 Holy Power

    -- "Empyrean Power" 286393 -- buff -- Your next Divine Storm is free and deals 0 additional damage.
    -- "Blade of Wrath" 281178 -- buff -- Your next Blade of Justice deals 25% increased damage.
    {{"macro"}, 'true' , "/startattack" },

}
,"paladin_retribution_bfa")
