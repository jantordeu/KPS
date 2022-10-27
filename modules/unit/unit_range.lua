--[[
Unit Range: Functions which handle unit ranges
]]--

local Unit = kps.Unit.prototype

local rc = LibStub("LibRangeCheck-2.0")

--[[[
@function `<UNIT>.distance` - returns the approximated distance to the given unit (same as `<UNIT.distanceMax`).
]]--
function Unit.distance(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end

--[[[
@function `<UNIT>.distanceMin` - returns the min. approximated distance to the given unit.
]]--
function Unit.distanceMin(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if minRange == nil then return 99 end
    return minRange
end

--[[[
@function `<UNIT>.distanceMax` - returns the max. approximated distance to the given unit.
]]--
function Unit.distanceMax(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end

--[[[
@function `<UNIT>.lineOfSight` - returns false during 2 seconds if unit is out of line sight either returns true
]]--
local CHECK_INTERVAL = 2
local GetTime = GetTime
local unitExclude = {}
local unitBadTarget = {}

kps.events.register("UI_ERROR_MESSAGE", function (arg1, arg2)
    if arg1 == 53 and arg2 == SPELL_FAILED_LINE_OF_SIGHT then
        if kps.lastTargetGUID == nil then kps.lastTargetGUID = UnitGUID("target") end
        unitExclude[kps.lastTargetGUID] = GetTime()
    end
    if arg1 == 53 and arg2 == SPELL_FAILED_BAD_TARGETS then
        if kps.lastTargetGUID == nil then kps.lastTargetGUID = UnitGUID("target") end
        unitBadTarget[kps.lastTargetGUID] = GetTime()
    end
end)

local unitLineOfSigh = function(unitguid)
    if unitExclude[unitguid] == nil then return true end
    if (GetTime() - unitExclude[unitguid]) >= CHECK_INTERVAL then return true end
    if not UnitAffectingCombat("player") then unitExclude = {} end
    return false
end

function Unit.lineOfSight(self)
    return unitLineOfSigh(self.guid)
end

--[[[
@function `<UNIT>.incorrectTarget` - returns true during Combat if attackable target is BAD_TARGETS either returns false
]]--

local unitIncorrectTarget = function(unitguid)
    if unitBadTarget[unitguid] == nil then return false end
    if not UnitAffectingCombat("player") then unitBadTarget = {} end
    return true
end

function Unit.incorrectTarget(self)
    return unitIncorrectTarget(self.guid)
end