--[[[
@module Deathknight Unholy Rotation
@author xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight

kps.rotations.register("DEATHKNIGHT","UNHOLY",
{
    -- Player Pet
    {spells.raiseDead, 'not player.hasPet'},

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.darkTransformation, 'player.hasPet'},
        {spells.soulReaper, 'target.debuffStacks(spells.festeringWound) >= 4'},
        {spells.apocalypse, 'target.debuffStacks(spells.festeringWound) = 8'},
        {spells.armyOfTheDead, 'player.runes > 4'},
        {spells.summonGargoyle, 'not player.hasTalent(7,1)'},
        { {"macro"}, 'kps.useBagItem', "/use 13" },
        { {"macro"}, 'kps.useBagItem', "/use 14" },
    }},

    -- Have Soul Reaper Buff
    {{"nested"}, 'player.hasBuff(spells.soulReaper)', {
        {spells.scourgeStrike},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.iceboundFortitude, 'player.hp < 0.3'},
        {spells.deathStrike, 'player.hp < 0.5 or player.hasBuff(spells.darkSuccor)'},
        {spells.antimagicShell, 'player.hp < 0.5 and (spells.mindFreeze).cooldown and target.isInterruptable'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.7', "/use Healthstone" },
        { {"macro"}, 'kps.defensive and player.hp < 0.6', "/cast Gift of the Naaru" },
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze, 'target.distance <= 15'},
        {spells.asphyxiate, 'not spells.strangulate.isRecastAt("target")'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.outbreak, 'not target.hasMyDebuff(spells.virulentPlague) or target.myDebuffDuration(spells.virulentPlague) <= 2'},
        { {"macro"}, 'player.hasPet', "/petassist"},
        {spells.festeringStrike, 'target.debuffStacks(spells.festeringWound) <= 4'},
        {spells.deathCoil, 'player.hasBuff(spells.suddenDoom) or player.runicPower > 35'},
        {spells.deathAndDecay, 'keys.shift'},
        {spells.scourgeStrike, 'target.debuffStacks(spells.festeringWound) >= 3'},
    }},

    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.outbreak, 'not target.hasMyDebuff(spells.virulentPlague) or target.myDebuffDuration(spells.virulentPlague) <= 2'},
        { {"macro"}, 'player.hasPet', "/petassist"},
        {spells.deathAndDecay, 'keys.shift'},
        {spells.festeringStrike, 'target.debuffStacks(spells.festeringWound) < 3'},
        {spells.deathCoil, 'player.hasBuff(spells.suddenDoom) or player.runicPower > 35'},
        {spells.scourgeStrike, 'target.debuffStacks(spells.festeringWound) >= 2'},
    }},
}
,"Unholy Pve")
