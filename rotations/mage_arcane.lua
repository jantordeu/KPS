--[[[
@module Mage Arcane Rotation
@author kirk24788
@version 8.1.0
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","ARCANE",
{

    {{"nested"}, 'spells.arcanePower.cooldown <= 0 or player.arcaneCharges >= 4', {
        {spells.arcanePower },
        {spells.presenceOfMind },
        {spells.arcaneMissiles, 'player.hasBuff(spells.clearcasting)' },
        {spells.arcaneBlast},
    }},
    {{"nested"}, 'true', {
        {spells.evocation, 'player.mana < 0.2'},
        {spells.arcaneMissiles, 'player.hasBuff(spells.clearcasting) and player.mana < 0.95' },
        {spells.arcaneBarrage, 'player.mana < 0.5 and player.arcaneCharges >= 4' },
        {spells.arcaneBlast},
    }},
}
,"Easy Mode")
