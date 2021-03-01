--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "curseOfTongues", "Interface\\Icons\\spell_shadow_curseoftounges", "Curse of Tounges")
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "curseOfWeakness", "Interface\\Icons\\warlock_curse_weakness", "Curse of Weakness")
    --kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


local hasMaxDotsOnTarget = 'target.hasMyDebuff(spells.agony) and target.hasMyDebuff(spells.corruption) and target.hasMyDebuff(spells.unstableAffliction) and spells.phantomSingularity.cooldown > 0 and (not player.hasTalent(2, 3) or target.hasMyDebuff(spells.siphonLife))'

local openingSequence = {
    {spells.haunt},
    {spells.agony, 'not target.hasMyDebuff(spells.agony)'},
    {spells.unstableAffliction, 'not target.hasMyDebuff(spells.unstableAffliction) and not spells.unstableAffliction.isRecastAt("target")'},
    {spells.corruption, 'not target.hasMyDebuff(spells.corruption)'},
    {spells.siphonLife, 'not target.hasMyDebuff(spells.siphonLife)'},
    {spells.phantomSingularity },
    {spells.darkSoulMisery},
    {spells.summonDarkglare},
    {spells.maleficRapture, 'player.soulShards > 0'},
}

function dots(target, agonyTime, corruptionTime, unstableAfflictionTime, siphonLifeTime)
    local _dots = {}
    if agonyTime > 0 then
        table.insert(_dots, {spells.agony,
            target..'.myDebuffDuration(spells.agony) <= '..agonyTime..' and not spells.agony.isRecastAt("'..target..'")',
        target})
    end
    if corruptionTime > 0 then
        table.insert(_dots, {{"nested"}, 'player.hasTalent(2, 2)', {
            {spells.corruption, 'not '..target..'.hasMyDebuff(spells.corruption)'..' and not spells.corruption.isRecastAt("'..target..'")', target},
        }})
        table.insert(_dots, {{"nested"}, 'not player.hasTalent(2, 2)', {
            {spells.corruption, target..'.myDebuffDuration(spells.corruption) <= '..corruptionTime..' and not spells.corruption.isRecastAt("'..target..'")', target},
        }})
    end
    if unstableAfflictionTime > 0 then
        table.insert(_dots, {spells.unstableAffliction, target..'.myDebuffDuration(spells.unstableAffliction) <= '..unstableAfflictionTime..' and not spells.unstableAffliction.isRecastAt("'..target..'") and not spells.unstableAffliction.lastCasted(2.0)', target})
    end
    if siphonLifeTime > 0 then
        table.insert(_dots, {spells.siphonLife, target..'.myDebuffDuration(spells.siphonLife) <= '..siphonLifeTime..' and not spells.siphonLife.isRecastAt("'..target..'")', target})
    end
    return {{"nested"}, target..'.isAttackable', _dots}
end


local useCooldowns = "kps.cooldowns and ((IsInRaid() and kps.env.boss1.exists) or not IsInRaid())"
local regularRotation = {
    {spells.drainLife, 'player.buffStacks(spells.inevitableDemise) >= 50 and not spells.drainLife.lastCasted(15)'},
    {spells.shadowBolt, 'player.hasBuff(spells.nightfall) and player.buffDuration(spells.nightfall) < 2.0'},

    -- Opening Sequence, only if using cooldowns and only if we are at the start of a raid fight
    {{"nested"}, useCooldowns, {
        {{"nested"}, "IsInRaid() and kps.timeInCombat < 40", openingSequence},
    }},

    -- Curses, if enabled
    {spells.curseOfTongues, 'kps.curseOfTongues and not target.hasDebuff(spells.curseOfTongues)'},
    {spells.curseOfWeakness, 'kps.curseOfWeakness and not target.hasDebuff(spells.curseOfWeakness)'},

    -- Trinket CD's
    {{"nested"}, useCooldowns, {
        { {"macro"}, "player.useTrinket(0)" , "/use 13"},
        { {"macro"}, "player.useTrinket(1)" , "/use 14"},
    }},

    {spells.haunt},


    {spells.maleficRapture, 'player.soulShards > 4'},

    -- First-Level CD's
    {{"nested"}, useCooldowns, {
        {spells.summonDarkglare, hasMaxDotsOnTarget},
        {spells.phantomSingularity, 'kps.timeInCombat > 40 and spells.summonDarkglare.cooldown >= 45 or spells.summonDarkglare.cooldown < 8'},
    }},


    -- DoTs at target
    dots('target', 7.4, 4.2, 6.3, 4.5),

    -- Second Level CD's
    {{"nested"}, useCooldowns, {
        {spells.phantomSingularity, 'kps.timeInCombat < 40'},
        {spells.darkSoulMisery, useCooldowns},
        {spells.soulRot, useCooldowns},
    }},

    -- DoT's at focus
    dots('focus', 7.4, 4.2, 0.0, 4.5),
    -- DoT's at mouseover
    dots('mouseover', 5.4, 4.2, 0.0, 4.5),

    {spells.shadowBolt, 'player.hasBuff(spells.nightfall)'},


    {spells.maleficRapture, 'player.soulShards > 0'},

    -- Fillers
    {{"nested"}, 'not player.hasTalent(1, 3)', {
        {spells.shadowBolt},
    }},
    {{"nested"}, 'player.hasTalent(1, 3)', {
        {spells.drainSoul},
    }},
}

local movingRotation = {
    {spells.shadowBolt, 'player.hasBuff(spells.nightfall)'},
    dots('target', 18, 16, 0, 14),
    dots('focus', 18, 16, 0, 14),
}





kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Take care of burning rush...
    {"/cancelaura " .. spells.burningRush, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)"},

    {{"nested"}, 'player.isMoving', movingRotation},
    {{"nested"}, 'not player.isMoving', regularRotation},
}
,"Loox", {0,3,0,2,0,2,3})



kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Take care of burning rush...
    {"/cancelaura " .. spells.burningRush, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)"},

    {kps.hekili({
    })}
}
,"Hekili")

