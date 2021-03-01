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
