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
    --if UnitIsEnemy("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.warrior.FocusMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        kps.runMacro("/focus mouseover")
    end
    return nil, nil
end

local function heroicLeapOnScreen()
    if kps.spells.warrior.heroicLeap.cooldown < kps.gcd and kps.spells.warrior.heroicLeap.charges > 0 and kps.timers.check("heroicLeap") == 0 then
        kps.timers.create("heroicLeap", 10 )
        kps.utils.createMessage("heroicLeap Ready")
    end
end

kps.env.warrior.ScreenMessage = function()
    return heroicLeapOnScreen()
end



