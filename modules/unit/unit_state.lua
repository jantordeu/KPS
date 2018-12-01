--[[
Unit State: Functions which handle unit state
]]--

local Unit = kps.Unit.prototype

--[[[
@function `<UNIT>.isPVP` - returns true if the given unit is in PVP.
]]--
function Unit.isPVP(self)
    return UnitIsPVP(self.unit) == 1
end

--[[[
@function `<UNIT>.isAttackable` - returns true if the given unit can be attacked by the player.
]]--
function Unit.isAttackable(self)
    if not Unit.exists(self) then return false end
    if (string.match(GetUnitName(self.unit), kps.locale["Dummy"])) then return true end
    if not UnitCanAttack("player", self.unit) then return false end -- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    if UnitIsFriend("player", self.unit) then return false end
    if not Unit.lineOfSight(self) then return false end
    if not kps.env.harmSpell.inRange(self.unit) then return false end
    if Unit.isPVP == true and Unit.immuneDamage == true then return false end --PVP
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
@function `<UNIT>.isDead` - returns true if the unit is dead.
]]--
function Unit.isDead(self)
    return UnitIsDeadOrGhost(self.unit)
end

--[[[
@function `<UNIT>.isDrinking` - returns true if the given unit is currently eating/drinking.
]]--
function Unit.isDrinking(self)
    -- doesn't matter which drinking buff we're using, all of them have the same name!
    return Unit.hasBuff(self)(kps.Spell.fromId(431))
end

--[[[
@function `<UNIT>.inVehicle` - returns true if the given unit is inside a vehicle.
]]--
function Unit.inVehicle(self)
    return UnitInVehicle(self.unit) == true -- UnitInVehicle - 1 if the unit is in a vehicle, otherwise nil
end

--[[[
@function `<UNIT>.isHealable` - returns true if the given unit is healable by the player.
]]--
function Unit.isHealable(self)
    if self.unit == "player" and not UnitIsDeadOrGhost("player") and not Unit.hasBuff(self)(kps.Spell.fromId(20711)) then return true end -- UnitIsDeadOrGhost(unit) Returns false for priests who are currently in [Spirit of Redemption] form
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not Unit.lineOfSight(self) then return false end
    --if Unit.immuneHeal(self) then return false end
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
@function `<UNIT>.isTankInRaid` - returns true if the given unit is a tank
]]--

function Unit.isTankInRaid(self)
    if UnitGroupRolesAssigned(self.unit) == "TANK" then return true end
    if kps["env"].focus.unit == self.unit then return true end
    return false
end

function Unit.isHealerInRaid(self)
    if UnitGroupRolesAssigned(self.unit) == "HEALER" then return true end
    return false
end

function Unit.isDamagerInRaid(self)
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


