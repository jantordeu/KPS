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

function Unit.isElite(self)
    if not Unit.exists(self) then return false end
    if string.find(UnitClassification(self.unit),"elite") then
        return true
    end
    return false
end


function Unit.isBoss(self)
    if not Unit.exists(self) then return false end
    if UnitEffectiveLevel(self.unit) == -1 then
        return true
    end
    return false
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