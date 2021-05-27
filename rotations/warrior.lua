--[[[
@module Warrior Environment Functions and Variables
@description
Warrior Environment Functions and Variables.
]]--

kps.env.warrior = {}

local UnitAffectingCombat = UnitAffectingCombat
local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

