--[[
Unit State: Functions which handle unit state
]]--

local Unit = kps.Unit.prototype

--[[[
@function `<UNIT>.isPVP` - returns true if the given unit is in PVP.
]]--
function Unit.isPVP(self)
    return UnitIsPVP(self.unit)
end

--[[[
@function `<UNIT>.isAttackable` - returns true if the given unit can be attacked by the player.
]]--
function Unit.isAttackable(self)
    if Unit.isControlled(self) and IsInGroup() and not UnitIsPVP("player") then return false end
    if not Unit.exists(self) then return false end
    if (string.match(GetUnitName(self.unit), kps.locale["Dummy"])) then return true end
    if not UnitCanAttack("player", self.unit) then return false end -- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    if UnitIsFriend("player", self.unit) then return false end
    if not Unit.lineOfSight(self) then return false end
    if Unit.immuneDamage(self) then return false end
    if not kps.env.harmSpell.inRange(self.unit) then return false end
    return true
end

--[[[
@function `<UNIT>.inCombat` - returns true if the given unit is in Combat.
]]--
function Unit.inCombat(self)
    return UnitAffectingCombat(self.unit)
end

--[[[
@function `<UNIT>.isMoving` - returns true if the given unit is currently moving.
]]--
function Unit.isMoving(self)
    return select(1,GetUnitSpeed(self.unit)) > 0
end

--[[[
@function `<UNIT>.isMovingTimer(<SECONDS>)` - returns true if the player is falling longer than n seconds.
]]--

local IsMovingSince = setmetatable({}, {
    __index = function(t, unit)
        local val = function (delay)
            if delay == nil then delay = 1 end
            local unitIsMoving = select(1,GetUnitSpeed(unit)) > 0
            if not unitIsMoving and kps.timers.check("Moving") > 0 then kps.timers.reset("Moving") end
            if unitIsMoving then
                if kps.timers.check("Moving") == 0 then kps.timers.create("Moving", delay * 2 ) end
            end
            if unitIsMoving and kps.timers.check("Moving") > 0 and kps.timers.check("Moving") < delay then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isMovingTimer(self)
    return IsMovingSince[self.unit]
end

--[[[
@function `<UNIT>.isDead` - returns true if the unit is dead.
]]--
function Unit.isDead(self)
    return UnitIsDeadOrGhost(self.unit)
end

--[[[
@function `<UNIT>.isDrinking` - returns true if the given unit is currently eating/drinking.
]]--
function Unit.isDrinking(self)
    return Unit.hasBuff(self)(kps.Spell.fromId(431)) -- doesn't matter which drinking buff we're using, all of them have the same name!
end

--[[[
@function `<UNIT>.inVehicle` - returns true if the given unit is inside a vehicle.
]]--
function Unit.inVehicle(self)
    return UnitInVehicle(self.unit) == true -- UnitInVehicle - 1 if the unit is in a vehicle, otherwise nil
end

--[[[
@function `<UNIT>.isFriend` - returns true if the unit is a friend unit
]]--

function Unit.isFriend(self)
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if Unit.isDead(self) then return false end
    if not Unit.lineOfSight(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    return true
end

--[[[
@function `<UNIT>.isHealable` - returns true if the given unit is healable by the player.
]]--
function Unit.isHealable(self)
    if UnitIsUnit("player",self.unit) and not UnitIsDeadOrGhost("player")then return true end
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not Unit.lineOfSight(self) then return false end
    if Unit.immuneHeal(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    local inRange,_ = UnitInRange(self.unit)
    if not inRange then return false end -- UnitInRange return FALSE when not in a party/raid reason why to be true for player alone
    return true
end

--[[[
@function `<UNIT>.hasPet` - returns true if the given unit has a pet.
]]--
function Unit.hasPet(self)
    if self.unit == nil then return false end
    if UnitExists(self.unit.."pet")==false then return false end
    if UnitIsVisible(self.unit.."pet")==false then return false end
    if UnitIsDeadOrGhost(self.unit.."pet")==true then return false end
    return true
end

--[[[
@function `<UNIT>.isUnit(<UNIT-STRING>)` - returns true if the given unit is otherunit. heal.lowestInRaid.isUnit("player")
]]--
local isUnit = setmetatable({}, {
    __index = function(t, unit)
        local val = function (otherunit)
            if UnitIsUnit(unit,otherunit) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isUnit(self)
    return isUnit[self.unit]
end

--[[[
@function `<UNIT>.hasAttackableTarget` - returns true if the given unit has attackable target
]]--
function Unit.hasAttackableTarget(self)
    local unit = self.unit
    local unitTarget = unit.."target"
    if UnitExists(unitTarget) and UnitCanAttack("player",unitTarget) then return true end
    return false
end 

--[[[
@function `<UNIT>.isRaidTank` - returns true if the given unit is a tank
]]--

function Unit.isRaidTank(self)
    if UnitGroupRolesAssigned(self.unit) == "TANK" then return true end
    if kps["env"].focus.guid == self.guid then return true end
    return false
end

function Unit.isRaidHealer(self)
    if UnitGroupRolesAssigned(self.unit) == "HEALER" then return true end
    return false
end

function Unit.isRaidDamager(self)
    if UnitGroupRolesAssigned(self.unit) == "DAMAGER" then return true end
    return false
end 

--[[[
@function `<UNIT>.hasRoleInRaid(<STRING>)` - returns true if the given unit has role TANK, HEALER, DAMAGER, NONE
]]--
local hasRoleInRaid = setmetatable({}, {
    __index = function(t, unit)
        local val = function (role)
            if UnitGroupRolesAssigned(unit) == role then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.hasRoleInRaid(self)
    return hasRoleInRaid[self.unit]
end


