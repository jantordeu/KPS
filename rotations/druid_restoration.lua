--[[[
@module Druid Restoration Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        {spells.innervate, 'player.mana < 0.5'},
        {spells.tranquility, 'not player.isMoving and heal.averageHealthRaid < 0.7'},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.renewal, 'player.hp < 0.2'},
        {spells.ironbark, 'player.hp < 0.4'},
        {spells.barkskin, 'player.hp < 0.6'},
    }},

    {spells.lifebloom, 'heal.defaultTank.myBuffDuration(spells.lifebloom) < 3', kps.heal.defaultTank},
    {spells.efflorescence , 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},


    -- Clearcast on Tanks or lowest raid target
    {{"nested"}, 'player.hasBuff(spells.clearcasting)', {
        {spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
        {spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        {spells.regrowth, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
    }},


    -- Have Soul Of The Forest Buff
    --{{"nested"}, 'player.hasBuff(spells.soulOfTheForest)', {
        --{spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
        --{spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        --{spells.regrowth, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
    --}},

    {spells.wildGrowth, 'heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    -- Use Swiftmend on priority or highly injured targets on cooldown.
    -- These players will require a Rejuvenation, Regrowth, Wild Growth HoT on them that will be consumed
    {spells.swiftmend, 'heal.defaultTank.hp < 0.6', kps.heal.defaultTank},
    {spells.swiftmend, 'heal.lowestInRaid.hp < 0.6', kps.heal.lowestInRaid},
    {spells.swiftmend, 'heal.defaultTarget.hp < 0.6', kps.heal.defaultTarget},
    -- Regrowth Initial heal has a 40% increased chance for a critical effect if the target is already affected by Regrowth
    {spells.regrowth, 'heal.defaultTank.hp < 0.7', kps.heal.defaultTank},
    {spells.regrowth, 'heal.lowestInRaid.hp < 0.7', kps.heal.lowestInRaid},
    {spells.regrowth, 'heal.defaultTarget.hp < 0.7', kps.heal.defaultTarget},


    {spells.rejuvenation, 'heal.defaultTank.myBuffDuration(spells.rejuvenation) < 3 and heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.rejuvenation, 'heal.defaultTarget.buffDuration(spells.rejuvenation) < 3 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'heal.lowestInRaid.myBuffDuration(spells.rejuvenation) < 3 and heal.lowestInRaid.hp < 1', kps.heal.lowestInRaid},

    -- Attack Target if possible
    {{"nested"}, 'target.isAttackable', {
        {spells.moonfire, 'not target.hasMyDebuff(spells.moonfire) or target.myDebuffDuration(spells.moonfire) <= 3'},
        {spells.sunfire, 'not target.hasMyDebuff(spells.sunfire) or target.myDebuffDuration(spells.sunfire) <= 3'},
        {spells.wrath},
    }},
}
,"Icy Veins")
