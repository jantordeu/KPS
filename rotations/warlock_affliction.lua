--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 9.0.1
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


kps.rotations.register("WARLOCK","AFFLICTION",
{

    {{"macro"}, "player.hasBuff(spells.burningRush) and player.isNotMovingSince(0.25)", "/cancelaura " .. spells.burningRush.name },
    {{"macro"}, "player.hasBuff(spells.burningRush) and player.hp < 0.30", "/cancelaura " .. spells.burningRush.name },


    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not focus.exists and mouseover.isAttackable and mouseover.inCombat and not mouseover.isUnit("target")' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },

    { {"macro"}, "player.useTrinket(0)" , "/use 13"},
    { {"macro"}, "player.useTrinket(1)" , "/use 14"},
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.useItem(5512) and player.hp <= 0.70' ,"/use item:5512" },

    -- Maintain Agony (on up to 3 targets) at all times.
    {spells.agony, 'target.myDebuffDuration(spells.agony) < 7.2' , "target" },
    {spells.agony, 'focus.myDebuffDuration(spells.agony) < 7.2', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) < 7.2', 'mouseover'},
    -- Maintain Corruption (on up to 3 targets, including Soul Effigy) at all times and all bosses.
    {spells.corruption, 'not target.hasMyDebuff(spells.corruption)', "target" },
    {spells.corruption, 'not focus.hasMyDebuff(spells.corruption)', 'focus'},
    {spells.corruption, 'not mouseover.hasMyDebuff(spells.corruption)', 'mouseover'},
    {spells.seedOfCorruption, 'kps.multiTarget and not player.isMoving not target.hasMyDebuff(spells.seedOfCorruption)', "target" },

    -- Maintain 1 Unstable Affliction as often as possible for the damage increase.
    --{spells.unstableAffliction, 'not player.isMoving and target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},
    --{spells.unstableAffliction, 'not player.isMoving and player.soulShards >= 1 and target.myDebuffDuration(spells.unstableAffliction) <= 1.4', "target" },
    -- Maintain Siphon Life
    {{"nested"}, 'player.hasTalent(2,3)', {
        {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) < 5.4', "target" },
        {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) < 5.4', 'focus'},
        {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) < 5.4', 'mouseover'},
    }},

    -- Cast Phantom Singularity or Vile Taint whenever available
    {spells.phantomSingularity, 'player.hasTalent(4,2)' },
    {spells.vileTaint, 'player.hasTalent(4,3) and not player.isMoving' },
    -- Cast Haunt whenever available.
    {spells.haunt, 'player.hasTalent(6,2)' },
    
    {spells.maleficRapture, 'not player.isMoving and player.soulShards >= 5' },
    {spells.summonDarkglare, 'target.hasMyDebuff(spells.corruption)'},
    {spells.shadowEmbrace, 'true' , "target" },

    {spells.darkSoulMisery, 'player.soulShards >= 3'},
    -- Pet Health 
    {spells.healthFunnel, 'player.hp > 0.90 and pet.hp < 0.55' , "pet" },
    -- Cast Drain Life/Drain Soul as a filler.
    {spells.drainLife, 'player.hp < 0.55' },
    
    {spells.drainSoul, 'not player.isMoving and player.hasTalent(1,3)' , "target" },
    {spells.shadowBolt, 'not player.isMoving' , "target" },


}
,"Simcraft")

