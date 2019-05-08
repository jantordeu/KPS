--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


kps.rotations.register("WARLOCK","AFFLICTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'not focus.isAttackable' , "/clearfocus" },
        
    {spells.summonDarkglare, 'not player.isMoving and target.hasMyDebuff(spells.corruption) and player.soulShards == 0 and spells.phantomSingularity.cooldown > 0'},

    { {"macro"}, "player.useTrinket(0)" , "/use 13"},
    { {"macro"}, "player.useTrinket(1)" , "/use 14"},
        -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" }, 

    -- Maintain Agony (on up to 3 targets, including Soul Effigy) at all times.
    {spells.agony, 'target.myDebuffDuration(spells.agony) < 5.4'},
    {spells.agony, 'focus.myDebuffDuration(spells.agony) < 5.4', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) < 5.4', 'mouseover'},
    -- Maintain Corruption (on up to 3 targets, including Soul Effigy) at all times and all bosses.
    {{"nested"}, 'player.hasTalent(2,2)', {
        {spells.corruption, 'not target.hasMyDebuff(spells.corruption)'},
        {spells.corruption, 'not focus.hasMyDebuff(spells.corruption)', 'focus'},
        {spells.corruption, 'not mouseover.hasMyDebuff(spells.corruption)', 'mouseover'},
    }},
    {{"nested"}, 'not player.hasTalent(2,2)', {
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) < 4.2'},
        {spells.corruption, 'focus.myDebuffDuration(spells.corruption) < 4.2', 'focus'},
        {spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) < 4.2', 'mouseover'},
    }},
    -- Maintain Siphon Life
    {{"nested"}, 'player.hasTalent(2,3)', {
        {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) < 4.5'},
        {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) < 4.5', 'focus'},
        {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) < 4.5', 'mouseover'},
    }},
 
    {spells.darkSoulMisery, 'player.soulShards >= 3'},   
    {spells.healthFunnel, 'player.hp > 0.90 and pet.hp < 0.55' , "pet" },
    {spells.seedOfCorruption, 'player.soulShards >= 3 and player.plateCount > 3'},    
    -- Cast Unstable Affliction if you reach 5 Soul Shards.
    {spells.unstableAffliction, 'player.soulShards >= 5'},
    -- Cast Haunt whenever available.
    {spells.haunt, 'player.hasTalent(6, 2)' },
    -- Cast Phantom Singularity whenever available
    {spells.phantomSingularity, 'player.hasTalent(4, 2)' },
    --  Apply one Unstable Affliction immediately before casting Deathbolt.
    {{spells.unstableAffliction,spells.deathbolt}, 'player.soulShards >= 1'},
    -- Cast Deathbolt whenever available. Apply one Unstable Affliction immediately before casting Deathbolt.
    {spells.deathbolt, 'spells.summonDarkglare.cooldown >= (30+player.gcd) or spells.summonDarkglare.cooldown >= 140'},
    -- Maintain 1 Unstable Affliction as often as possible for the damage increase.
    {spells.unstableAffliction, 'player.soulShards >= 1 and target.myDebuffDuration(spells.unstableAffliction) <= 1.4'},
    {spells.unstableAffliction, 'spells.summonDarkglare.cooldown <= player.soulShards*spells.unstableAffliction.castTime'},
    {spells.unstableAffliction, 'target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},
    {spells.unstableAffliction, 'spells.deathbolt.cooldown > player.timeToShard and target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},
    {spells.unstableAffliction, 'player.soulShards > 1 and target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},
    -- Cast Drain Life/Drain Soul as a filler. (Spell names don't matter!)
    {spells.drainLife, 'player.hp < 0.55' },
    {spells.shadowBolt},

}
,"Simcraft", {3,3,0,2,0,2,3})

