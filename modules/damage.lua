--[[[
@module Damage/Raid Status
]]--

local _raidTarget = {}
_raidTarget[1] = {}
_raidTarget[2] = {}
local raidTarget = _raidTarget[1]

local _raidTargetIdx = 1
local raidTargetSize = 0
local raidType = nil

local raidEnemyTargets = {}
local groupEnemyTargets = {}

local moduleLoaded = false
local function updateRaidStatus()
    if _raidTargetIdx == 1 then _raidTargetIdx = 2 else _raidTargetIdx = 1 end
    table.wipe(_raidTarget[_raidTargetIdx])
    local newRaidStatusSize = 0
    local damageTargets = nil

    if IsInRaid() then
        damageTargets = raidEnemyTargets
        newRaidStatusSize = GetNumGroupMembers()
        raidType = "raid"
    else
        damageTargets = groupEnemyTargets
        newRaidStatusSize = GetNumSubgroupMembers() + 1
        raidType = "group"
    end
    for i=1,newRaidStatusSize do
        if damageTargets[i].exists then 
            _raidTarget[_raidTargetIdx][damageTargets[i].guid] = damageTargets[i]
        end
    end
    raidTarget = _raidTarget[_raidTargetIdx]
    raidTargetSize = newRaidStatusSize
end

local function loadOnDemand()
    if not moduleLoaded then
        groupEnemyTargets[1] = kps["env"].target
        for i=2,5 do
            groupEnemyTargets[i] = kps.Unit.new("party"..(i-1).."target")
            kps.env["party"..(i-1).."target"] = groupEnemyTargets[i]
        end
        for i=1,40 do
            raidEnemyTargets[i] = kps.Unit.new("raid"..(i).."target")
            kps.env["raid"..(i).."target"] = raidEnemyTargets[i]
        end

        kps.events.registerOnUpdate(updateRaidStatus)
        moduleLoaded = true
    end
end

-- PLAYER_TARGET_CHANGED
-- RAID_TARGET_UPDATE


kps.RaidTarget = {}
kps.RaidTarget.prototype = {}
kps.RaidTarget.metatable = {}

function kps.RaidTarget.new(call_members)
    local inst = {}
    setmetatable(inst, kps.RaidTarget.metatable)
    inst.call_members = call_members
    return inst
end

kps.RaidTarget.metatable.__index = function (table, key)
    local fn = kps.RaidTarget.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    loadOnDemand()
    if table.call_members then
        return fn(table)
    else
        return fn
    end
end


--[[[
@function `damage.count` - return the size of the current raidtarget group
]]--
function kps.RaidTarget.prototype.count(self)
    return raidTargetSize
end

--[[[
@function `damage.enemyTarget` - Returns the enemy target for all raid members
]]--
kps.RaidTarget.prototype.enemyTarget = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].target
    for guid, unit in pairs(raidTarget) do
        if unit.isAttackable then
            return unit
        end
    end
    return lowestUnit
end)


--[[[
@function `damage.enemyLowest` - Returns the lowest Health enemy target for all raid members
]]--
kps.RaidTarget.prototype.enemyLowest = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].target
    local lowestHp = 2
    for guid, unit in pairs(raidTarget) do
        if unit.isAttackable and unit.hp < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end)

--[[[
@function `damage.enemyCasting` - Returns the casting enemy target for all raid members
]]--
kps.RaidTarget.prototype.enemyCasting = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].target
    local lowestHp = 2
    for guid, unit in pairs(raidTarget) do
        if unit.isAttackable and unit.isCasting then
            return unit
        end
    end
    return lowestUnit
end)

--------------------------------------------------------------------------------------------
------------------------------- TRICKY
--------------------------------------------------------------------------------------------

-- Here comes the tricky part - use an instance of RaidStatus which calls it's members
-- for 'kps.env.heal' - so we can write 'heal.defaultTarget.hp < xxx' in our rotations
kps.env.damage = kps.RaidTarget.new(true)
-- And use another instance of RaidStatus which returns the functions so we can write
-- kps.heal.defaultTarget as a target for our rotation tables.
kps.damage = kps.RaidTarget.new(false)



function kpstarget()
    --print(kps["env"].damage.enemyTarget,kps["env"].damage.count)
    for name, player in pairs(raidTarget) do
        print("|cffffffffName: ",name,"|Unit: ",player.unit,"|Name: ",player.name)
    end
end
