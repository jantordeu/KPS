--[[[
@module Warlock Environment Functions and Variables
@description
Warlock Environment Functions and Variables.
]]--

kps.env.warlock = {}


--kps.runOnClass("WARLOCK", function ( )
--    kps.gui.createToggle("conserve", "Interface\\Icons\\spell_Mage_Flameorb", "Conserve")
--end)

function kps.env.warlock.isHavocUnit(unit)
    if not UnitExists(unit) then  return false end
    if UnitIsUnit("target",unit) then return false end
    return true
end

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.warlock.FocusMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        kps.runMacro("/focus mouseover")
    end
end
