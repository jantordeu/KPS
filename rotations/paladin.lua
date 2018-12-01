--[[[
@module Paladin Environment Functions and Variables
@description
Paladin Environment Functions and Variables.
]]--

kps.env.paladin = {}

local UnitAffectingCombat = UnitAffectingCombat
local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    --if UnitIsEnemy("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.paladin.FocusMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        kps.runMacro("/focus mouseover")
    end
    return nil, nil
end

function kps.env.paladin.countFriend()
    if not IsInRaid() then return 2 end
    return 4
end

