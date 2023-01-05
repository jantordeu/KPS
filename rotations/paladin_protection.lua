--[[[
@module Paladin Protection Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

local AshenHallow = spells.ashenHallow.name
local DoorOfShadows = spells.doorOfShadows.name


kps.rotations.register("PALADIN","PROTECTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },

    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    
    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'mouseover.isHealable and mouseover.isDispellable("Poison")' , "mouseover" },
        {spells.cleanseToxins, 'mouseover.isHealable and mouseover.isDispellable("Disease")' , "mouseover" },
        {spells.cleanseToxins, 'player.isDispellable("Disease")' , "player" },
        {spells.cleanseToxins, 'player.isDispellable("Poison")' , "player" },
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.rebuke, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.blindingLight, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},

    {{"nested"}, 'player.hp < 0.70' ,{
        {spells.blessingOfProtection, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)' , "player" },
        {spells.divineShield, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)' , "player" },
        {spells.layOnHands, 'player.hp < 0.35 and not player.hasDebuff(spells.forbearance)', "player" },
        {spells.flashOfLight, 'player.hp < 0.65 and player.buffStacks(spells.selflessHealer) > 2' , "player" , "FLASH_PLAYER" },
        {spells.wordOfGlory, 'player.hp < 0.65' , "player" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 5' , "/use 14" },
    
    {kps.hekili({
        spells.cleanseToxins,
        spells.vanquishersHammer
    }), 'kps.multiTarget'},

--    {spells.ardentDefender, 'player.hpIncoming < 0.70 and target.isCasting' },
--    {spells.ardentDefender, 'player.hpIncoming < 0.50' },    
--    {spells.guardianOfAncientKings, 'player.hpIncoming < 0.40 and not player.hasBuff(spells.ardentDefender)' },

--    {spells.avengingWrath, 'player.hp < 0.70' },
--    {spells.shieldOfTheRighteous, 'player.hp < 0.90 and not player.hasBuff(spells.shieldOfTheRighteous)' , "target"},
--    {spells.wordOfGlory, 'player.hp < 0.70'},
--    {spells.layOnHands, 'player.hpIncoming < 0.35' },
--    {spells.divineShield, 'player.hpIncoming < 0.35' },
--    {spells.judgment, 'target.isAttackable' , "target" },
--    {spells.consecration, 'not player.isMoving and not player.hasBuff(spells.consecration) and target.distanceMax <= 5' , "player" , "consecration_player" },
--    {spells.hammerOfWrath, 'target.isAttackable' , "target" },
--    {spells.avengersShield, 'target.distanceMax <= 10' , "target" },
--    {spells.blessedHammer, 'target.distanceMax <= 10' , "target" , "blessedHammer" },
--    {spells.hammerOfTheRighteous, 'player.hasBuff(spells.consecration) and target.distanceMax <= 10', "target" , "hammerOfTheRighteous" },
--    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

 }
,"paladin_protection_hekili")
