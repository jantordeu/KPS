--[[[
@module Paladin Retribution Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

kps.rotations.register("PALADIN","RETRIBUTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    
    {spells.greaterBlessingOfKings, 'not player.isInGroup and not player.hasBuff(spells.greaterBlessingOfKings)' , "player" },
    {spells.greaterBlessingOfKings, 'player.isInGroup and not heal.lowestTankInRaid.hasBuff(spells.greaterBlessingOfKings)' , kps.heal.lowestTankInRaid },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'mouseover.isHealable and mouseover.hp < 0.30' ,"mouseover" },
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        -- "Main d’entrave" -- Movement speed reduced by 70%. 10 seconds remaining
        {spells.handOfHindrance, 'target.isMovingTimer(1.4)' , "target" },
        {spells.handOfHindrance, 'focus.isMovingTimer(1.4)' , "focus" },
    }},
    {spells.layOnHands, 'player.hp < 0.40', 'player'},
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.flashOfLight, 'player.hasTalent(6,1) and player.hp < 0.80 and player.buffStacks(spells.selflessHealer) >= 3', "player" },
    {spells.wordOfGlory , 'player.hasTalent(6,3) and player.hp < 0.72'}, 
      
    -- Interrupt
    {{"nested"}, 'kps.interrupt',{
        {spells.hammerOfJustice, 'focus.distance <= 10 and focus.isCasting' , "focus" },
        {spells.hammerOfJustice, 'target.distance <= 10 and target.isCasting ' , "target" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distance <= 10 and target.isCasting ' , "target" },
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
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30' , "/use 14" },
    
    -- "Shield of Vengeance" -- Creates a barrier of holy light that absorbs (30 / 100 * Total health) damage for 15 sec.
    {spells.shieldOfVengeance, 'player.incomingDamage > player.incomingHeal and target.distance <= 10'},

    -- AZERITE
    {spells.concentratedFlame, 'target.isAttackable and target.distance <= 30' , "target" },
    {spells.memoryOfLucidDreams, 'target.isAttackable and player.hasBuff(spells.avengingWrath) and player.myBuffDuration(spells.avengingWrath) < 17' , "target" },
    {spells.theUnboundForce, 'target.isAttackable and target.distance <= 30' , "target" },
   
    {spells.inquisition, 'player.hasTalent(7,3) and player.holyPower >= 2 and player.myBuffDuration(spells.inquisition) <= 12' , "target" , "inquisition" },
    {spells.avengingWrath, 'kps.cooldowns and target.isAttackable and player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) >= 20 and target.distance <= 10' },
    {spells.avengingWrath, 'kps.cooldowns and target.isAttackable and player.hasTalent(7,1) and target.distance <= 10' },
    {spells.crusade, 'kps.cooldowns and target.isAttackable and player.hasTalent(7,2) and target.distance <= 10' },

    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower)' , "target" , "divineStorm_empyreanPower" },
    {spells.divineStorm, 'player.plateCount >= 2' , "target" , "divineStorm" },
    {spells.divineStorm, 'kps.multiTarget' , "target" , "divineStorm" },
    {spells.executionSentence, 'true' , "target" , "executionSentence" },
    {spells.templarsVerdict, 'true' , "target" , "templarsVerdict" },
    
    {spells.wakeOfAshes, 'player.holyPower <= 1 and target.distance <= 10' , "target" },
    {spells.hammerOfWrath, 'player.holyPower <= 4 and player.hasTalent(2,3)' , "target" }, -- Generates 1 Holy Power.
    {spells.judgment, 'player.holyPower <= 4 and target.distance <= 30' , "target" }, -- 10 sec cd -- Generates 1 Holy Power
    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.distance <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.distance <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.consecration, 'player.holyPower <= 4 and player.hasTalent(4,2) and target.distance <= 10' }, -- Generates 1 Holy Power.
    {spells.crusaderStrike, 'player.holyPower <= 4 and target.distance <= 10'}, --Generates 1 Holy Power

    -- "Empyrean Power" 286393 -- buff -- Your next Divine Storm is free and deals 0 additional damage.
    -- "Blade of Wrath" 281178 -- buff -- Your next Blade of Justice deals 25% increased damage.
    --{{"macro"}, 'true' , "/startattack" },

}
,"paladin_retribution_bfa")
