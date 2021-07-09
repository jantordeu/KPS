--[[[
@module Mage Environment Functions and Variables
@description
Mage Environment Functions and Variables.
]]--

kps.env.mage = {}

local UnitAffectingCombat = UnitAffectingCombat
local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.mage.damageTarget()
    if UnitIsAttackable("target") then return "target"
    elseif UnitIsAttackable("targettarget") then return "targettarget"
    elseif UnitIsAttackable("focus") then return "focus"
    elseif UnitIsAttackable("focustarget") then return "focustarget"
    elseif UnitIsAttackable("mouseovertarget") then return "mouseovertarget"
    elseif UnitIsAttackable("mouseover") then return "mouseover"
    end
end

kps.env.mage.checkfireBlast = function()
	local charges = kps.spells.mage.fireBlast.charges
    return "fireBlast_charges:"..charges
end