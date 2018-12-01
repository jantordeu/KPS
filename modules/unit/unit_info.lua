--[[
Unit Info: Functions which handle unit information
]]--

local Unit = kps.Unit.prototype



--[[[
@function `<UNIT>.name` - returns the unit name
]]--
function Unit.name(self)
    return UnitName(self.unit)
end

--[[[
@function `<UNIT>.guid` - returns the unit guid
]]--
function Unit.guid(self)
    return UnitGUID(self.unit)
end

--[[[
@function `<UNIT>.npcId` - returns the unit id (as seen on wowhead)
]]--
function Unit.npcId(self)
    local guid = UnitGUID(self.unit)
    local type, zero, serverId, instanceId, zoneUid, npcId, spawn_uid = strsplit("-",guid);
    return npcId
end

--[[[
@function `<UNIT>.level` - returns the unit level
]]--
function Unit.level(self)
    return UnitLevel(self.unit)
end

--[[[
@function `<UNIT>.isRaidBoss` - returns true if the unit is a raid boss
]]--
function Unit.isRaidBoss(self)
    if not Unit.exists(self) then return false end
    if UnitLevel(self.unit) == -1 and UnitPlayerControlled(self.unit) == false then
        return true
    end
    return false
end

--[[[
@function `<UNIT>.isElite` - returns true if the unit is a elite mob
]]--
-- "worldboss", "rareelite", "elite", "rare", "normal"
function Unit.isElite(self)
    if not Unit.exists(self) then return false end
    if UnitClassification(self.unit) == "elite" then
        return true
    end
    return false
end

--[[[
@function `<UNIT>.isFriend` - returns true if the unit is a friend unit
]]--

function Unit.isFriend(self)
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    return true
end

--[[[
@function `<UNIT>.isClassDistance` - returns true if the unit is a class distance
]]--

local damageDistance = {
        ["WARRIOR"] = false,
        ["PALADIN"] = false,
        ["ROGUE"] = false,
        ["DEATHKNIGHT"] = false,
        ["MONK"] = false,
        ["DEMONHUNTER"] = false,
        ["HUNTER"] = true,
        ["PRIEST"] = true,
        ["SHAMAN"] = true,
        ["MAGE"] = true,
        ["WARLOCK"] = true,
        ["MAGE"] = true,
}

function Unit.isClassDistance(self)
    local _, classFile, classID = UnitClass(self.unit)
    if damageDistance[classFile] == true then return true end
    return false
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

function Unit.plateTable(self)
    return activeUnitPlates
end

--[[[
@function `<UNIT>.plateCount` - e.g. 'player.plateCount' returns namePlates count in combat (actives enemies)
]]--
function Unit.plateCount(self)
    local plateCount = 0
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitAffectingCombat(nameplate) then plateCount = plateCount + 1 end
    end
    return plateCount
end

--[[[
@function `<UNIT>.plateCountDebuff` - e.g. 'player.plateCountDebuff(spells.shadowWordPain)' returns namePlates count with specified debuff in combat (actives enemies)
]]--

local UnitHasDebuff = function(unit,spellName)
    local auraName,count,debuffType,duration,endTime,caster,isStealable,spellid,isBossDebuff,value
    local i = 1
    auraName,_,count,debuffType,duration,endTime,caster,isStealable,_,spellid,_,isBossDebuff,_,_,value1,value2,value3 = UnitDebuff(unit,i)
    while auraName do
        if auraName == spellName then
            return true
        end
        i = i + 1
        auraName,_,count,debuffType,duration,endTime,caster,isStealable,_,spellid,_,isBossDebuff,_,_,value1,value2,value3 = UnitDebuff(unit,i)
    end
    return false
end

local PlateHasDebuff = function(spell)
    local plateCount = 0
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitAffectingCombat(nameplate) and UnitHasDebuff(nameplate,spell.name) then plateCount = plateCount + 1 end
    end
    return plateCount
end

function Unit.plateCountDebuff(spell)
    return PlateHasDebuff
end

--[[[
@function `<UNIT>.isTarget` - returns true if the unit is targeted by an enemy nameplate
]]--
function Unit.isTarget(self)
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitExists(nameplate.."target") then
            local target = nameplate.."target"
            if UnitIsUnit(target,self.unit) then return true end
        end
    end
    return false
end

--[[[
@function `<UNIT>.isTargetCount` - returns the number of enemies targeting player.
]]--

function Unit.isTargetCount(self)
    local plateCount = 0
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitExists(nameplate.."target") then
            local target = nameplate.."target"
            if UnitIsUnit(target,self.unit) then plateCount = plateCount + 1 end
        end
    end
    return plateCount
end
