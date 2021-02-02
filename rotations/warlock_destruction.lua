--[[[
@module Warlock Destruction Rotation
@author Kirk24788
@version 8.3.0
]]--

local spells = kps.spells.warlock
local env = kps.env.warlock

--[[
Suggested Talents:
Level 15: Eradication
Level 30: Internal combustion
Level 45: Burning Rush
Level 60: Cataclysm
Level 75: Demonic Circle
Level 90: Roaring Blaze
Level 100: Channel Demonfire
]]--


kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","DESTRUCTION", "curseOfTongues", "Interface\\Icons\\spell_shadow_curseoftounges", "Curse of Tounges")
    kps.gui.addCustomToggle("WARLOCK","DESTRUCTION", "curseOfWeakness", "Interface\\Icons\\warlock_curse_weakness", "Curse of Weakness")
    kps.gui.addCustomToggle("WARLOCK","DESTRUCTION", "fear", "Interface\\Icons\\spell_shadow_possession", "Fear")
    --kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


local havocMouseover = {spells.havoc, 'player.soulFragments >= 30 and isHavocUnit("mouseover") and keys.ctrl', "mouseover" }
local havocFocus = {spells.havoc, 'player.soulFragments >= 30 and isHavocUnit("focus")', "focus" }



function immolate(target, time, unstableAfflictionTime, siphonLifeTime)
    return {spells.immolate, target..'.myDebuffDuration(spells.immolate) <= ' .. time .. 'and not spells.immolate.isRecastAt("'.. target .. '")', target}
end


local singleTarget = {
    -- Avoid Cap
    {spells.chaosBolt, 'player.soulFragments >= 43'},
    {spells.chaosBolt, 'focus.hasMyDebuff(spells.havoc) or mouseover.hasMyDebuff(spells.havoc)'},
    immolate('target', 5.0),
    immolate('focus', 5.0),

    {{"nested"}, 'player.infernalDuration > 4', {
        { spells.darkSoulInstability, 'player.infernalDuration > 18' },
        { spells.chaosBolt },
    }},

    {{"nested"}, 'kps.cooldowns and ((IsInRaid() and kps.env.boss1.exists) or not IsInRaid())', {
        { spells.summonInfernal, 'keys.shift and spells.darkSoulInstability.cooldown < 8'},
    }},

    -- Cast Conflagrate to generate Soul Shards.
    {spells.conflagrate},
    -- Cast Incinerate to generate Soul Shards.
    {spells.incinerate},
}


local multiTarget = {
    -- Avoid Cap
    {spells.chaosBolt, 'player.soulFragments >= 48'},
    {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 5.0 and not spells.immolate.isRecastAt("target")'},
    immolate('target', 5.0),
    immolate('focus', 5.0),
    -- Avoid Cap
    {spells.chaosBolt, 'focus.hasMyDebuff(spells.havoc) or mouseover.hasMyDebuff(spells.havoc)'},
    {spells.channelDemonfire},
    -- Cast Cataclysm when available.
    {spells.rainOfFire, 'keys.shift'},

    -- Cast Conflagrate to generate Soul Shards.
    {spells.conflagrate},
    -- Cast Incinerate to generate Soul Shards.
    {spells.incinerate},
}

local rotation = {
    -- Curses, if enabled
    {spells.curseOfTongues, 'kps.curseOfTongues and not target.hasDebuff(spells.curseOfTongues)'},
    {spells.curseOfWeakness, 'kps.curseOfWeakness and not target.hasDebuff(spells.curseOfWeakness)'},

    -- Fear
    {{"nested"}, 'kps.fear', {
        {spells.fear, 'not mouseover.hasDebuff(spells.fear) and keys.ctrl', "mouseover" },
        {spells.fear, 'not focus.hasDebuff(spells.fear)', "focus" },
    }},

    {{"nested"}, 'not target.hasMyDebuff(spells.fear)', {
        -- trinkets
        {{"nested"}, useCooldowns, {
            { {"macro"}, "player.useTrinket(0)" , "/use 13"},
            { {"macro"}, "player.useTrinket(1)" , "/use 14"},
        }},

        {spells.soulRot, useCooldowns},


        -- Havoc
        {{"nested"}, 'focus.hasMyDebuff(spells.havoc) or mouseover.hasMyDebuff(spells.havoc)', {
            {spells.conflagrate, 'spells.conflagrate.charges > 0 and player.soulFragments <= 44'},
            {spells.chaosBolt},
            immolate('target', 5.0),
        }},
        -- Rain of Fire!
        {{"nested"}, 'keys.shift', {
            {spells.summonInfernal},
            {spells.rainOfFire, 'not spells.rainOfFire.lastCasted(6.5)'},
        }},
        -- Avoid Cap
        {{"nested"}, 'player.soulFragments >= 44', {
            {spells.conflagrate, 'not player.hasBuff(spells.backdraft)'},
            {spells.chaosBolt},
        }},
        -- Trigger Havoc (if neither doing aoe or fear)
        {{"nested"}, 'not keys.shift and not kps.fear', {
            {spells.havoc, 'player.soulFragments >= 30 and isHavocUnit("mouseover") and keys.ctrl', "mouseover" },
            {spells.havoc, 'player.soulFragments >= 30 and isHavocUnit("focus")', "focus" },
        }},
        {{"nested"}, 'not spells.havoc.lastCasted(12.0)', {
            {spells.channelDemonfire, 'not player.isMoving'},
            immolate('target', 5.0),
            immolate('focus', 5.0),
        }},

        -- Dont waste Conflagrate
        {spells.conflagrate, 'spells.conflagrate.charges > 1 and not player.hasBuff(spells.backdraft) and player.soulFragments <= 44'},
        -- Cast Incinerate to generate Soul Shards.
        {spells.incinerate},
    }},
}
kps.rotations.register("WARLOCK","DESTRUCTION",
{
    {"/cancelaura " .. spells.burningRush, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)"},

    {{"nested"}, 'player.hasDebuff(kps.spells.mplus.quake)',
        { kps.stopCasting, "player.castTimeLeft >= player.debuffDuration(kps.spells.mplus.quake)" },
        { kps.stopCasting, "player.channelTimeLeft >= player.debuffDuration(kps.spells.mplus.quake) and player.debuffDuration(kps.spells.mplus.quake) < 0.3" },
    },

    {{"nested"}, 'not player.hasDebuff(kps.spells.mplus.quake)', rotation},
}
,"Destruction 9.0.1 M+", {0,0,0,0,0,2,0})
