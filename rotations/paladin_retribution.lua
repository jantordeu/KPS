--[[[
@module Paladin Retribution Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.runAtEnd(function()
   kps.gui.addCustomToggle("PALADIN","RETRIBUTION", "tankhammer", "Interface\\Icons\\spell_holy_sealofmight", "tankhammer")
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
    --{spells.greaterBlessingOfKings, 'player.isInGroup and not heal.lowestTankInRaid.hasBuff(spells.greaterBlessingOfKings)' , kps.heal.lowestTankInRaid },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'mouseover.isHealable and mouseover.hp < 0.30' ,"mouseover" },

    {spells.layOnHands, 'player.hp < 0.40', 'player'},
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.flashOfLight, 'player.hasTalent(6,1) and player.hp < 0.80 and player.buffStacks(spells.selflessHealer) >= 3', "player" },
    {spells.wordOfGlory , 'player.hasTalent(6,3) and player.hp < 0.65'}, 

    -- "Main d’entrave" -- Movement speed reduced by 70%. 10 seconds remaining
    {spells.handOfHindrance, 'kps.tankhammer and mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    {spells.handOfHindrance, 'kps.tankhammer and target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    -- Interrupt
    {spells.hammerOfJustice, 'kps.tankhammer and mouseover.distance <= 10 and mouseover.isAttackable and mouseover.distanceMax <= 10 and mouseover.isMoving' , "mouseover" },
    {spells.hammerOfJustice, 'kps.tankhammer and target.distance <= 10 and target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
    {{"nested"}, 'kps.interrupt',{
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isCasting' , "focus" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isCasting ' , "target" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting ' , "target" },
        -- "Repentir" "Repentance" -- Forces an enemy target to meditate, incapacitating them for 1 min.
        {spells.repentance, 'player.hasTalent(3,2) and target.isCasting ' , "target" },
    }},

    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
        {spells.cleanseToxins, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable },
    }},
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" },
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'mouseover.isHealable and mouseover.hp < 0.40' , "mouseover"},
    {spells.blessingOfProtection, 'player.hp < 0.55' , "player"},

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 20' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 5 and target.debuffStacks(spells.razorCoral) == 0' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 5 and target.debuffStacks(spells.razorCoral) >= 4' , "/use 14" },

    -- AZERITE
    {spells.azerite.concentratedFlame, 'target.isAttackable and target.distanceMax <= 30' , "target" },
    {spells.azerite.memoryOfLucidDreams, 'target.isAttackable and player.hasBuff(spells.avengingWrath) and player.myBuffDuration(spells.avengingWrath)' , "target" },
    {spells.azerite.theUnboundForce, 'target.isAttackable and target.distanceMax <= 30' , "target" },
   
    {spells.inquisition, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) < 5 and player.holyPower >= 3' , "target" , "inquisition_5" },
    {spells.inquisition, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) < 15 and spells.executionSentence.cooldown < 10 and player.holyPower >= 3' , "target" , "inquisition_15" },
    {spells.inquisition, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) < 20 and spells.avengingWrath.cooldown < 15 and player.holyPower >= 3' , "target" , "inquisition_20" },
    {{"nested"},'kps.cooldowns', {
        {spells.avengingWrath, 'target.isAttackable and player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) > 25 and target.distanceMax <= 10' },
        {spells.avengingWrath, 'target.isAttackable and player.hasTalent(7,1) and target.distanceMax <= 10' },
        {spells.crusade, 'target.isAttackable and player.hasTalent(7,2) and target.distanceMax <= 10' },
    }},

    {spells.hammerOfWrath, 'player.hasTalent(2,3) and player.holyPower <= 4' , "target" }, -- Generates 1 Holy Power.
    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.distanceMax <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.wakeOfAshes, 'player.holyPower <= 1 and target.distanceMax <= 10 and spells.avengingWrath.cooldown > player.gcd' , "target" },
    {spells.executionSentence, 'true' , "target" , "executionSentence" },

    {spells.divineStorm, 'kps.multiTarget' , "target" , "divineStorm" },
    {spells.templarsVerdict, 'player.hasBuff(spells.righteousVerdict)' , "target" , "templarsVerdict_righteousVerdict" },
    {spells.templarsVerdict, 'target.hasMyDebuff(spells.judgment)' , "target" , "templarsVerdict_judgment" },
    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower)' , "target" , "divineStorm_empyreanPower" },
    {spells.templarsVerdict, 'true' , "target" , "templarsVerdict" },

    {spells.judgment, 'target.distanceMax <= 30' , "target" }, -- 10 sec cd -- Generates 1 Holy Power
    {spells.consecration, 'player.hasTalent(4,2) and not target.isMoving and target.distanceMax <= 10' }, -- Generates 1 Holy Power.
    {spells.crusaderStrike, 'target.distanceMax <= 10'}, --Generates 1 Holy Power

    -- "Empyrean Power" 286393 -- buff -- Your next Divine Storm is free and deals 0 additional damage.
    -- "Blade of Wrath" 281178 -- buff -- Your next Blade of Justice deals 25% increased damage.
    --{{"macro"}, 'true' , "/startattack" },

}
,"paladin_retribution_bfa")
