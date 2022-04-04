--[[
Player State: Functions which handle player state
]]--

local Player = kps.Player.prototype

local movementStarted = nil
local movementStopped = 0

kps.events.register("PLAYER_STARTED_MOVING", function ()
    movementStarted = GetTime()
    movementStopped = nil
end)
kps.events.register("PLAYER_STOPPED_MOVING", function ()
    movementStarted = nil
    movementStopped = GetTime()
end)

--[[[
@function `<PLAYER>.isMoving` - returns true if the player is currently moving - oppposed to the `<UNIT>.isMoving` this one is more reliable.
]]--
function Player.isMoving(self)
    return movementStopped == nil
end

--[[[
@function `<PLAYER>.isMovingSince(<SECONDS>)` - returns true if the player is currently moving - oppposed to the `<UNIT>.isMoving` this one is more reliable.
]]--
function Player.isMovingSince(self)
    return function (seconds)
        if movementStarted ~= nil then
            return GetTime()-movementStarted > seconds
        end
        return false
    end
end

--[[[
@function `<PLAYER>.isNotMovingSince(<SECONDS>)` - returns true if the player is currently not moving for the given amount of seconds.
]]--
function Player.isNotMovingSince(self)
    return function (seconds)
        if movementStopped ~= nil then
            return GetTime()-movementStopped > seconds
        end
        return false
    end
end

-------------------
---- NAMEPLATES----
-------------------

local activeUnitPlates = {}
local UnitExists = UnitExists

local function AddNameplate(unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    local nameplatename = nameplate:GetName()
    if UnitCanAttack("player",unitID) then
        activeUnitPlates[unitID] = nameplatename
    end
end

local function RemoveNameplate(unitID)
    activeUnitPlates[unitID] = nil
end

kps.events.register("NAME_PLATE_UNIT_ADDED", function(unitID)
    --unitID returns nameplate1, nameplate2 ...
    AddNameplate(unitID)
end)

kps.events.register("NAME_PLATE_UNIT_REMOVED", function(unitID)
    --unitID returns nameplate1, nameplate2 ...
    RemoveNameplate(unitID)
end)

function Player.plateTable(self)
    return activeUnitPlates
end

--[[[
@function `<PLAYER>.plateCount` - e.g. 'player.plateCount' returns namePlates count in combat (actives enemies)
]]--
-- UnitIsPlayer("unit") --  Returns true if the specified unit is a player character, false otherwise.
function Player.plateCount(self)
    local plateCount = 0
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitAffectingCombat(nameplate) and not UnitIsPlayer(nameplate) then plateCount = plateCount + 1 end
    end
    return plateCount
end

--[[[
@function `<PLAYER>.isTarget` - returns true if the unit is targeted by an enemy nameplate
]]--
function Player.isTarget(self)
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitExists(nameplate.."target") then
            local target = nameplate.."target"
            if UnitIsUnit(target,self.unit) then return true end
        end
    end
    return false
end