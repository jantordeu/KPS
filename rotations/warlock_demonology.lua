--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

local opener = {
    spells.doom,
    spells.handOfGuldan,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.implosion,
    spells.grimoireFelguard,
    spells.summonVilefiend,
    spells.callDreadstalkers,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.shadowBolt,
    spells.handOfGuldan,
    spells.handOfGuldan,
    spells.demonicStrength,
    spells.summonDemonicTyrant
}

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","DEMONOLOGY", "demoOpener", "Interface\\Icons\\achievement_boss_lichking", "Opener")
end)


kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    {"/cancelaura " .. spells.burningRush, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)"},

    {opener, "kps.demoOpener and kps.timeInCombat < 15 and kps.env.boss1.exists"},

    {spells.summonDemonicTyrant, 'kps.lastCastedSpell == spells.summonVilefiend.name'},

    {{"nested"}, 'player.isMoving ', {
        {spells.demonbolt, 'player.hasBuff(spells.demonicCore)'},
        {spells.doom, 'target.myDebuffDuration(spells.doom)<=4'},
        {spells.doom, 'focus.myDebuffDuration(spells.doom)<=4', 'focus'},
    }},

    {{"nested"}, 'spells.summonDemonicTyrant.cooldown <= 5', {
        {spells.summonVilefiend},
        {spells.callDreadstalkers},
        {spells.summonDemonicTyrant, 'spells.summonVilefiend.cooldown >= 35 and spells.callDreadstalkers.cooldown >= 9'},
    }},

    {{"nested"}, 'kps.cooldowns and player.hasBuff(spells.demonicPower)', {
        { {"macro"}, "player.useTrinket(0)" , "/use 13"},
        { {"macro"}, "player.useTrinket(1)" , "/use 14"},
    }},

    {spells.doom, 'target.guessedTimeToDieT23 > 30 and target.myDebuffDuration(spells.doom) <= 12'},
    {spells.doom, 'focus.guessedTimeToDieT23 > 30 and focus.myDebuffDuration(spells.doom) <= 12', 'focus'},
    {spells.doom, 'mouseover.guessedTimeToDieT23 > 30 and mouseover.isEnemy and mouseover.myDebuffDuration(spells.doom) <= 12', 'mouseover'},
    {spells.implosion, 'player.wildImps >= 3'},
    {spells.grimoireFelguard, "kps.cooldowns"},
    {spells.summonVilefiend, 'spells.summonDemonicTyrant.cooldown >= 50'},
    {spells.bilescourgeBombers, 'keys.shift' },
    {spells.demonicStrength},
    {spells.callDreadstalkers, 'spells.summonDemonicTyrant.cooldown >= 21'},
    {spells.handOfGuldan, 'player.soulShards >= 4'},
    {spells.demonbolt, "player.buffStacks(spells.demonicCore)>=2"},
    {spells.handOfGuldan, 'player.soulShards >= 3'},
    {spells.shadowBolt},
}
,"IcyVeins", {3,3,0,3,0,3,3})

