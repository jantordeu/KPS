--[[[
@module Heal/Raid Status
Helper functions for Raiders in Groups or Raids mainly aimed for healing rotations, but might be useful
for some DPS Rotations too.
]]--

local _raidStatus = {}
_raidStatus[1] = {}
_raidStatus[2] = {}
local raidStatus = _raidStatus[1]
local _raidStatusIdx = 1
local raidStatusSize = 0
local raidType = nil

local raidHealTargets = {}
local groupHealTargets = {}

local moduleLoaded = false
local function updateRaidStatus()
    if _raidStatusIdx == 1 then _raidStatusIdx = 2 else _raidStatusIdx = 1 end
    table.wipe(_raidStatus[_raidStatusIdx])
    local newRaidStatusSize = 0
    local healTargets = nil
    local unit = nil

    if IsInRaid() then
        healTargets = raidHealTargets
        newRaidStatusSize = GetNumGroupMembers()
        raidType = "raid"
    else
        healTargets = groupHealTargets
        newRaidStatusSize = GetNumSubgroupMembers() + 1
        raidType = "group"
    end
    for i=1,newRaidStatusSize do
        if healTargets[i].name ~= nil then
            _raidStatus[_raidStatusIdx][healTargets[i].name] = healTargets[i]
        end
    end
    raidStatus = _raidStatus[_raidStatusIdx]
    raidStatusSize = newRaidStatusSize
end

local function loadOnDemand()
    if not moduleLoaded then
        groupHealTargets[1] = kps.Unit.new("player")
        for i=2,5 do
            groupHealTargets[i] = kps.Unit.new("party"..(i-1))
            kps.env["party"..(i-1)] = groupHealTargets[i]
        end
        for i=1,40 do
            raidHealTargets[i] = kps.Unit.new("raid"..(i))
            kps.env["raid"..(i)] = raidHealTargets[i]
        end

        kps.events.registerOnUpdate(updateRaidStatus)
        moduleLoaded = true
    end
end


kps.RaidStatus = {}
kps.RaidStatus.prototype = {}
kps.RaidStatus.metatable = {}

function kps.RaidStatus.new(call_members)
    local inst = {}
    setmetatable(inst, kps.RaidStatus.metatable)
    inst.call_members = call_members
    return inst
end

kps.RaidStatus.metatable.__index = function (table, key)
    local fn = kps.RaidStatus.prototype[key]
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
@function `heal.count` - return the size of the current group
]]--
function kps.RaidStatus.prototype.count(self)
    return raidStatusSize
end

--[[[
@function `heal.type` - return the group type - either 'group' or 'raid'
]]--
function kps.RaidStatus.prototype.type(self)
    return raidType
end

local _tanksInRaid = {}
_tanksInRaid[1] = {}
_tanksInRaid[2] = {}
local _tanksInRaidIdx = 1

local tanksInRaid = kps.utils.cachedValue(function()
    if _tanksInRaidIdx == 1 then _tanksInRaidIdx = 2 else _tanksInRaidIdx = 1 end
    table.wipe(_tanksInRaid[_tanksInRaidIdx])
    for name,player in pairs(raidStatus) do
        if UnitGroupRolesAssigned(player.unit) == "TANK"
            or player.guid == kps["env"].focus.guid 
            or player.guid == kps["env"].targettarget.guid 
            or player.guid == kps["env"].target.guid then
            table.insert(_tanksInRaid[_tanksInRaidIdx], player)
        end
    end
    return _tanksInRaid[_tanksInRaidIdx]
end)

--[[[
@function `heal.lowestTankInRaid` - Returns the lowest tank in the raid - a tank is either:
    * any group member that has the Group Role `TANK`
    * is `focus` target
    * `targettarget` if neither Group Role nor `focus` are set
    * `player` if neither Group Role nor `focus` are set
]]--
kps.RaidStatus.prototype.lowestTankInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for name,unit in pairs(tanksInRaid()) do
        if unit.isHealable and unit.hp < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end)

--[[[
@function `heal.lowestInRaid` - Returns the lowest unit in the raid
]]--
kps.RaidStatus.prototype.lowestInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hp < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end)

--[[[
@function `heal.defaultTarget` - Returns the default healing target based on these rules:
    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid which is below 50% hp incoming
    * lowest raid member
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTarget`!
]]--
kps.RaidStatus.prototype.defaultTarget = kps.utils.cachedValue(function()
    -- If we're below 30% - always heal us first!
    if kps.env.player.hp < 0.70 then return kps["env"].player end
    -- If the focus target is below 50% - take it (must be some reason there is a focus after all...)
    -- focus.isFriend coz isHealable (e.g. UnitInRange) is only available for members of the player's group.
    if kps["env"].focus.isFriend and kps["env"].focus.hp < 0.70 then return kps["env"].focus end
    -- MAYBE we also focused an enemy so we can heal it's target...
    if kps["env"].focustarget.isFriend and kps["env"].focustarget.hp < 0.70 then return kps["env"].focustarget end
    -- Now do the same for target...
    if kps["env"].target.isFriend and kps["env"].target.hp < 0.70 then return kps["env"].target end
    if kps["env"].targettarget.isFriend and kps["env"].targettarget.hp < 0.70 then return kps["env"].targettarget end
    -- Nothing selected - get lowest raid member
    return kps.RaidStatus.prototype.lowestInRaid()
end)

--[[[
@function `heal.defaultTank` - Returns the default tank based on these rules:
    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTank`!
]]--
kps.RaidStatus.prototype.defaultTank = kps.utils.cachedValue(function()
    -- If we're below 30% - always heal us first!
    -- if kps.env.player.hp < 0.50 then return kps["env"].player end
    -- If the focus target is below 50% - take it (must be some reason there is a focus after all...) 
    -- focus.isFriend coz isHealable (e.g. UnitInRange) is only available for members of the player's group.
    if kps["env"].focus.isFriend and kps["env"].focus.hp < 0.70 then return kps["env"].focus end
    -- MAYBE we also focused an enemy so we can heal it's target...
    if kps["env"].focustarget.isFriend and kps["env"].focustarget.hp < 0.70 then return kps["env"].focustarget end
    -- Now do the same for target...
    if kps["env"].target.isFriend and kps["env"].target.hp < 0.70 then return kps["env"].target end
    if kps["env"].targettarget.isFriend and kps["env"].targettarget.hp < 0.70 then return kps["env"].targettarget end
    -- Nothing selected - get lowest Tank if it is NOT the player and lower than 50%
    return kps.RaidStatus.prototype.lowestTankInRaid()
end)

--[[[
@function `heal.averageHealthRaid` - Returns the average hp incoming for all raid members
]]--
kps.RaidStatus.prototype.averageHealthRaid = kps.utils.cachedValue(function()
    local hpIncTotal = 0
    local hpIncCount = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable then
            hpIncTotal = hpIncTotal + unit.hp
            hpIncCount = hpIncCount + 1
        end
    end
    return hpIncTotal / hpIncCount
end)

--[[[
@function `heal.lossHealthRaid` - Returns the loss Health for all raid members
]]--
kps.RaidStatus.prototype.lossHealthRaid = kps.utils.cachedValue(function()
    local hpTotal = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable then
            -- UnitHealthMax - UnitHealth
            local hpLoss = unit.hpMax - unit.hpTotal 
            hpTotal = hpTotal + hpLoss
        end
    end
    return hpTotal
end)

--[[[
@function `heal.incomingHealthRaid` - Returns the incoming Health for all raid members
]]--

kps.RaidStatus.prototype.incomingHealthRaid = kps.utils.cachedValue(function()
    local hpIncTotal = 0
    for name,player in pairs(raidStatus) do
        if player.isHealable then
            local hpInc = UnitGetIncomingHeals(player.unit)
            if not hpInc then hpInc = 0 end
            hpIncTotal = hpIncTotal + hpInc
        end
    end
    return hpIncTotal
end)

--[[[
@function `heal.countInRange` - Returns the count for all raid members in range
]]--

kps.RaidStatus.prototype.countInRange = kps.utils.cachedValue(function()
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable then
            count = count + 1
        end
    end
    return count
end)

--[[[
@function `heal.countLossInRange(<PCT>)` - Returns the count for all raid members below threshold health e.g. heal.countLossInRange(0.90)
]]--

local countInRange = function(health)
    if health == nil then health = 2 end
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hp < health then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossInRange = kps.utils.cachedValue(function()
    return countInRange
end)

--[[[
@function `heal.countLossInDistance(<PCT>)` - Returns the count for all raid members below threshold health (default countInRange) in a distance (default 10 yards) e.g. heal.countLossInRange(0.90)
]]--

local countInDistance = function(health)
    if health == nil then health = 2 end
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hp < health and unit.distanceMax <= 10 then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossInDistance = kps.utils.cachedValue(function()
    return countInDistance
end)


--------------------------------------------------------------------------------------------
------------------------------- RAID TANK
--------------------------------------------------------------------------------------------

--[[[
@function `heal.aggroTankTarget` - Returns the tank with highest aggro on the current target (*not* the unit with the highest aggro!). If there is no tank in the target thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankTarget`!
]]--

local function aggroTankOfUnit(targetUnit)
    local allTanks = tanksInRaid()
    local highestThreat = 0
    local aggroTank = nil

    for _, possibleTank in pairs(allTanks) do
        local unitThreat = UnitThreatSituation(possibleTank.unit, targetUnit)
        if unitThreat and unitThreat > highestThreat then
            highestThreat = unitThreat
            aggroTank = possibleTank
        end
    end

    -- Nobody is tanking 'targetUnit' - return any tank...return 'defaultTank'
    if aggroTank == nil then
        return kps.RaidStatus.prototype.defaultTank()
    end
    return aggroTank
end

kps.RaidStatus.prototype.aggroTankTarget = kps.utils.cachedValue(function()
    return aggroTankOfUnit("target")
end)

--[[[
@function `heal.aggroTankFocus` - Returns the tank with highest aggro on the current focus (*not* the unit with the highest aggro!). If there is no tank in the focus thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankFocus`!
]]--

kps.RaidStatus.prototype.aggroTankFocus = kps.utils.cachedValue(function()
    return aggroTankOfUnit("focus")
end)

--[[[
@function `heal.aggroTank` - Returns the tank or unit if overnuked with highest aggro and lowest health Without otherunit specified.
]]--
local tsort = table.sort
kps.RaidStatus.prototype.aggroTank = kps.utils.cachedValue(function()
    local TankUnit = tanksInRaid()
    for name, player in pairs(raidStatus) do
        local unitThreat = UnitThreatSituation(player.unit)
        if unitThreat == 1 and player.isHealable then
            TankUnit[#TankUnit+1] = player
        elseif unitThreat == 3 and player.isHealable then
            TankUnit[#TankUnit+1] = player
        end
    end
    tsort(TankUnit, function(a,b) return a.hp < b.hp end)
    local myTank = TankUnit[1]
    if myTank == nil then myTank = kps["env"].player end
    return myTank
end)

--------------------------------------------------------------------------------------------
------------------------------- RAID DEBUFF
--------------------------------------------------------------------------------------------

--[[[
@function `heal.hasDebuffDispellable` - Returns the raid unit with dispellable debuff e.g. kps.heal.hasDebuffDispellable("Magic")
]]--

local dispelRaidDebuff = function (dispelType)
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable(dispelType) then lowestUnit = unit break end
    end
    return lowestUnit
end

kps.RaidStatus.prototype.hasDebuffDispellable = kps.utils.cachedValue(function()
    return dispelRaidDebuff
end)

--[[[
@function `heal.isMagicDispellable` - Returns the raid unit with magic debuff to dispel e.g. {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
]]--

kps.RaidStatus.prototype.isMagicDispellable = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Magic") then lowestUnit = unit break end
    end
    return lowestUnit
end)

--[[[
@function `heal.isDiseaseDispellable` - Returns the raid unit with disease debuff to dispel
]]--

kps.RaidStatus.prototype.isDiseaseDispellable = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Disease") then lowestUnit = unit break end
    end
    return lowestUnit
end)

--[[[
@function `heal.isPoisonDispellable` - Returns the raid unit with poison debuff to dispel
]]--

kps.RaidStatus.prototype.isPoisonDispellable = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Poison") then lowestUnit = unit break end
    end
    return lowestUnit
end)

--[[[
@function `heal.isCurseDispellable` - Returns the raid unit with curse debuff to dispel
]]--

kps.RaidStatus.prototype.isCurseDispellable = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Curse") then lowestUnit = unit break end
    end
    return lowestUnit
end)

--------------------------------------------------------------------------------------------
------------------------------- RAID DEBUFF UNIT
--------------------------------------------------------------------------------------------

--[[[
@function `heal.hasRaidDebuff(<SPELL>)` - Returns the UNIT TABLE with lowest health with Debuff on raid
]]--

local unitHasRaidDebuff = function(spell)
    local lowestUnit = kps["env"].player
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hasDebuff(spell) then
        lowestUnit = unit
        end
    end
    return lowestUnit
end

kps.RaidStatus.prototype.hasRaidDebuff = kps.utils.cachedValue(function()
    return unitHasRaidDebuff
end)


--------------------------------------------------------------------------------------------
------------------------------- RAID BUFF UNIT
--------------------------------------------------------------------------------------------

--[[[
@function `heal.hasBuffCount(<BUFF>)` - Returns the count for a specific Buff on raid e.g. heal.hasBuffCount(spells.atonement) > 3
]]--

local countUnitBuff = function(spell)
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hasMyBuff(spell) then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.hasBuffCount = kps.utils.cachedValue(function()
    return countUnitBuff
end)

--[[[
@function `heal.countLossAtonementInRange(<PCT>)` - Returns the count for a specific Buff on raid e.g. with a pct loss health e.g. heal.countLossAtonementInRange(0.80) > 3
]]--

local countUnitAtonementLoss = function(health)
    local spell = kps.spells.priest.atonement
    local count = 0
    if health == nil then health = 2 end
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hp < health and unit.hasMyBuff(spell) then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossAtonementInRange = kps.utils.cachedValue(function()
    return countUnitAtonementLoss
end)

--[[[
@function `heal.countLossBuffInRange(<PCT>)` - Returns the count for a specific Buff on raid e.g. with a pct loss health e.g. heal.countLossBuffInRange(spells.glimmerOfLight,0.80) > 3
]]--


local countUnitBuffLoss = function(spell,health)
    local count = 0
    if health == nil then health = 2 end
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hp < health and unit.hasMyBuff(spell) then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossBuffInRange = kps.utils.cachedValue(function(health)
    return countUnitBuffLoss
end)

--[[[
@function `lowestInRaidBuff(<SPELL>)` - Returns the UNIT TABLE with lowest health WITHOUT Buff on raid e.g. heal.lowestInRaidBuff(spells.atonement) < 0.80
]]--

local lowestInRaidBuff = function(spell)
   local lowestUnit = kps["env"].player
   local lowestHp = 2
   for name, unit in pairs(raidStatus) do
       if unit.isHealable and unit.hp < lowestHp and not unit.hasMyBuff(spell) then
           lowestUnit = unit
           lowestHp = lowestUnit.hp
       end
   end
   return lowestUnit
end

kps.RaidStatus.prototype.lowestInRaidGlimmer = kps.utils.cachedValue(function()
   return lowestInRaidBuff(kps.spells.paladin.glimmerOfLight)
end)

kps.RaidStatus.prototype.lowestInRaidAtonement = kps.utils.cachedValue(function()
   return lowestInRaidBuff(kps.spells.priest.atonement)
end)

--------------------------------------------------------------------------------------------
------------------------------- TRICKY
--------------------------------------------------------------------------------------------

-- Here comes the tricky part - use an instance of RaidStatus which calls it's members
-- for 'kps.env.heal' - so we can write 'heal.defaultTarget.hp < xxx' in our rotations
kps.env.heal = kps.RaidStatus.new(true)
-- And use another instance of RaidStatus which returns the functions so we can write
-- kps.heal.defaultTarget as a target for our rotation tables.
kps.heal = kps.RaidStatus.new(false)

--------------------------------------------------------------------------------------------
------------------------------- TEST
--------------------------------------------------------------------------------------------

function kpstest()

--for name, player in pairs(raidStatus) do
--print("|cffffffffName: ",name,"Unit: ",player.unit,"Guid: ",player.guid)
--print("|cffff8000isHealable: ",player.isHealable,"|hp: ",player.hp,"|hpInc: ",player.hpIncoming)
--print("|cff1eff00HEAL: ",player.incomingHeal)
--print("|cFFFF0000DMG: ",player.incomingDamage)
--end

--print("|cff1eff00HealTank:|cffffffff", kps["env"].heal.lowestTankInRaid.incomingHeal)
--print("|cFFFF0000DamageTank:|cffffffff", kps["env"].heal.lowestTankInRaid.incomingDamage)
print("|cffff8000TANK:|cffffffff", kps["env"].heal.lowestTankInRaid.name,"|",kps["env"].heal.lowestTankInRaid.hp)
print("|cff1eff00LOWEST|cffffffff", kps["env"].heal.lowestInRaid.name,"|",kps["env"].heal.lowestInRaid.hp)
print("|cffff8000countRange:|cffffffff",kps["env"].heal.countInRange)
print("|cffff8000countLossRange:|cffffffff",kps["env"].heal.countLossInRange(0.80))
print("|cffff8000countLossAtonementInRange:|cffffffff", kps["env"].heal.countLossAtonementInRange(0.80))
print("|cffff8000plateCount:|cffffffff", kps["env"].player.plateCount)
print("|cffff8000", "---------------------------------")


function GetSpellIDList()
    local list = {}

    local configID = C_ClassTalents.GetActiveConfigID()
    if configID == nil then return end

    local configInfo = C_Traits.GetConfigInfo(configID)
    if configInfo == nil then return end

    for _, treeID in ipairs(configInfo.treeIDs) do -- in the context of talent trees, there is only 1 treeID
        local nodes = C_Traits.GetTreeNodes(treeID)
        for i, nodeID in ipairs(nodes) do
            local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
            for _, entryID in ipairs(nodeInfo.entryIDs) do -- each node can have multiple entries (e.g. choice nodes have 2)
                local entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                if entryInfo and entryInfo.definitionID then
                    local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                    if definitionInfo.spellID then
                        table.insert(list, definitionInfo.spellID)
                    end
                end
            end
        end
    end
    return list
end

-- Checks if a spellID is a learned talent. it's recommended to use IsPlayerSpell instead.
local function isKnown(spellID)
	return IsPlayerSpell(spellID)
end

--print("|cffff8000name:|cffffffff", kps["env"].target.name == "Olimphy" )
--print("|cffff8000Incorrect", kps["env"].target.incorrectTarget)
--print("|cffff8000lineOfSight", kps["env"].target.lineOfSight)
--print("|cffff8000isInRaid", kps["env"].target.isInRaid)

--print("|cffff8000hasBuff", "|cffffffff", kps["env"].heal.hasBuff(kps.spells.priest.flashConcentration))
--print("|cffff8000hasNotBuff", "|cffffffff", kps["env"].heal.hasNotBuff(kps.spells.priest.flashConcentration))

--print("|cffff8000durationdebuff:|cffffffff", kps["env"].target.myDebuffDuration(kps.spells.priest.vampiricTouch))
--print("|cffff8000recast:|cffffffff", kps.spells.priest.vampiricTouch.isRecastAt("target"))
--print("|cffff8000lastcast:|cffffffff", kps.spells.priest.vampiricTouch.lastCasted(2))

--print("|cffff8000GCDhaste:|cffffffff", kps["env"].player.gcd)
--local _, gcd = GetSpellCooldown(61304)
--print("|cffff8000GCD :|cffffffff", gcd )
--print("|cffff8000Latency :|cffffffff", kps["env"].kps.latency )

--print("|cffff8000cooldownTotal:|cffffffff", kps.spells.priest.mindFlay.cooldownTotal)
--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.mindFlay.cooldown)
--print("|cffff8000distanceMax:|cffffffff", kps["env"].target.distanceMax )
--print("|cffff8000distanceMin:|cffffffff", kps["env"].target.distanceMin )
--print("|cffff8000isClassName:|cffffffff", kps["env"].target.isClassName("priest") )
--print("|cffff8000lastCastedSpell:|cffffffff", kps.lastCastedSpell,"|cffff8000lastCast:|cffffffff", kps.lastCast )
--print("|cffff8000lastInterruptSpell:|cffffffff", kps.lastInterruptSpell )

--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.voidBolt.cooldown)
--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.voidEruption.cooldown)


--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.powerWordRadiance.cooldown)
--print("|cffff8000cooldownTotal:|cffffffff", kps.spells.priest.powerWordRadiance.cooldownTotal)
--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.holyNova.cooldown)
--print("|cffff8000cooldownTotal:|cffffffff", kps.spells.priest.holyNova.cooldownTotal)

--print("|cffff8000cooldownTotal:|cffffffff", kps.spells.priest.mindFlay.cooldownTotal)
--print("|cffff8000cooldown:|cffffffff", kps.spells.priest.mindFlay.cooldown)


--print("|cffff8000PVP:|cffffffff", kps["env"].player.isPVP)
--print("|cffff8000GCD:|cffffffff", kps["env"].player.gcd)
--print("|cffff8000Equipped:|cffffffff", IsEquippedItem(173249))

--print("|cffff8000useTrinket:|cffffffff", kps["env"].player.useItem(173944))
--print("|cffff8000useTrinket:|cffffffff", GetItemSpell(173944))
--print("|cffff8000useTrinket:|cffffffff", kps["env"].player.useTrinket(0))

--print("|cffff8000useItem:|cffffffff", kps["env"].player.useItem(168654))
--print("|cffff8000usePierre:|cffffffff", kps["env"].player.useItem(5512))

--print("|cffff8000useWrist:|cffffffff", kps["env"].player.useItem(168989))
--print("|cffff8000useWrist:|cffffffff", GetItemSpell(168989))

--print("|cffff8000lastSentSpell:|cffffffff",  kps.lastSentSpell)
--print("|cffff8000lastCastedSpell:|cffffffff", kps.lastCastedSpell)

--print("|cffff8000countCharge:|cffffffff", kps.spells.mage.fireBlast.charges)
--print("|cffff8000countCharge:|cffffffff", kps.spells.priest.mindBlast.charges)
--print("|cffff8000countCharge:|cffffffff", kps.spells.priest.powerWordRadiance.charges)
--print("|cffff8000countCharge:|cffffffff", kps.spells.priest.surgeOfLight.charges)
--print("|cffff8000countStacks:|cffffffff", kps["env"].player.buffStacks(kps.spells.priest.surgeOfLight))

-- CR_CRIT_SPELL = 11;
-- CR_HASTE_SPELL = 20;

--bonusCRIT = GetCombatRatingBonus(11)
--bonusHASTE = GetCombatRatingBonus(20)
--print("crit:",bonusCRIT,"haste:", bonusHASTE)

--local spellHastePercent = UnitSpellHaste("player")
--local critChancePercent = GetCritChance()
--print("crit:", critChancePercent,"haste:", spellHastePercent)

--print("|cffff8000isRaidBoss:|cffffffff", kps["env"].target.isRaidBoss)
--print("|cffff8000isRaidTank:|cffffffff",kps["env"].target.isRaidTank)
--print("|cffff8000immuneDamage:|cffffffff", kps["env"].target.immuneDamage,"|cffff8000isAttackable:|cffffffff",kps["env"].target.isAttackable)
--print("|cffff8000isAttackable:|cffffffff",kps["env"].target.isAttackable)
--print("|cffff8000isElite:|cffffffff", kps["env"].target.isElite)
--print("|cffff8000DurationMax:|cffffffff", kps["env"].target.myDebuffDurationMax(kps.spells.priest.shadowWordPain))
--print("|cffff8000timeInCombat:|cffffffff", kps["env"].player.timeInCombat)

--print("|cffff8000countCharge:|cffffffff", kps.spells.priest.powerWordRadiance.charges)
--print("|cffff8000cooldownCharge:|cffffffff", kps.spells.priest.powerWordRadiance.cooldownCharges)
--print("|cffff8000cooldownSpell:|cffffffff", kps.spells.priest.powerWordRadiance.cooldown)
--print("|cffff8000countCharge:|cffffffff", kps.spells.priest.mindBlast.charges)


--print("|cffff8000buffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.warrior.ignorePain))
--print("|cffff8000buffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.azerite.theWellOfExistence))
--print("|cffff8000buffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.priest.masteryEchoOfLight))

--local debuff = kps.spells.mage.conflagration
--print("|cffff8000Debuff:|cffffffff", kps["env"].target.hasMyDebuff(debuff))

--print("|cffff8000plateCountvampiricTouch:|cffffffff", kps["env"].player.plateCountDebuff(kps.spells.priest.vampiricTouch))
--print("|cffff8000plateCountshadowWordPain:|cffffffff", kps["env"].player.plateCountDebuff(kps.spells.priest.shadowWordPain))
--local plateTable = kps["env"].player.plateTable
--for unitID,name in pairs(plateTable) do
--    print("unitID",unitID,"name",name)
--end

--local mindFlay =  kps.spells.priest.mindFlay
--print("left:",mindFlay.castTimeLeft("player"),"cd:",mindFlay.cooldown, "cdtotal:",mindFlay.cooldownTotal)
--local mindSear =  kps.spells.priest.mindSear
--print("left:",mindSear.castTimeLeft("player"),"cd:",mindSear.cooldown, "cdtotal:",mindSear.cooldownTotal)
--local mindBlast =  kps.spells.priest.mindBlast
--print("left:",mindBlast.castTimeLeft("player"),"cd:",mindBlast.cooldown, "cdtotal:",mindBlast.cooldownTotal)


--local voidEruption = kps.spells.priest.voidEruption
--local voidBolt = kps.spells.priest.voidBolt
--print("voidEruptionusable:", voidEruption.isUsable)
--print("voidBoltusable:", voidBolt.isUsable)
--print("voidBoltusable:", voidBolt.isUsable)
--print("voidBoltCooldown:", voidBolt.cooldown)

--print("|cffff8000averageHeal:|cffffffff", kps["env"].heal.averageHealthRaid)
--print("|cffff8000lossHealth:|cffffffff", kps["env"].heal.lossHealthRaid)
--print("|cffff8000atonementHealth:|cffffffff", kps["env"].heal.atonementHealthRaid)

--print("|cffff8000Icicles:|cffffffff", kps["env"].player.buffStacks(kps.spells.mage.icicles))
--print("|cffff8000isUsable:|cffffffff", kps.spells.mage.glacialSpike.isUsable)

--local atonement = kps.spells.priest.atonement 
--print("|cffff8000BuffCount:|cffffffff", kps["env"].heal.hasBuffCount(atonement))

--local aura = kps.spells.priest.powerWordShield
--print("myBuffDuration:",kps["env"].player.myBuffDuration(aura))
--print("hasBuff:",kps["env"].player.hasBuff(aura))

--local spell = kps.Spell.fromId(2061)
--local spellname = spell.name
--local spelltable = GetSpellPowerCost(spellname)[1] 
--for i,j in pairs(spelltable) do
--print(i," - ",j)
--end

--print("|cffff8000isStealable:|cffffffff", kps["env"].target.isStealable)
--print("|cffff8000isBuffDispellable:|cffffffff", kps["env"].target.isBuffDispellable)
--print("|cffff8000isDispellable:|cffffffff", kps["env"].player.isDispellable("Magic"))
--print("|cffff8000hasBossDebuff:|cffffffff", kps["env"].player.hasBossDebuff)

--for _,unit in ipairs(tanksInRaid()) do
--print("TANKS",unit.name)
--end
--

--print("|cffff8000hasRoleInRaidTANK:|cffffffff", kps["env"].heal.lowestInRaid.hasRoleInRaid("TANK"))
--print("|cffff8000hasRoleInRaidHEALER:|cffffffff", kps["env"].heal.lowestInRaid.hasRoleInRaid("HEALER"))
--print("|cffff8000isRaidTank:|cffffffff", kps["env"].heal.lowestInRaid.isRaidTank)

--print("|cffff8000BuffValue:|cffffffff", kps["env"].player.buffDuration(kps.spells.priest.masteryEchoOfLight))
--print("|cffff8000BuffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.priest.masteryEchoOfLight))

--print("|cffff8000TRINKET_0:|cffffffff", kps["env"].player.useTrinket(0))
--print("|cffff8000TRINKET_1:|cffffffff", kps["env"].player.useTrinket(1))

--local auraName, caster
--local i = 1
--local spellname = kps.spells.priest.atonement
--auraName, _, count, debuffType, duration, expirationTime, caster, isStealable, _, spellId, _, isBossDebuff, _, _, _, _, _, _ = UnitBuff("player",i)
--while auraName do
--   if auraName == spellname.name then print(auraName, caster) end
--   i = i + 1
--   auraName, _, count, debuffType, duration, expirationTime, caster, isStealable, _, spellId, _, isBossDebuff, _, _, _, _, _, _ = UnitBuff("player",i)
--end


end

--[[
|cffe5cc80 = beige (artifact)
|cffff8000 = orange (legendary)
|cffa335ee = purple (epic)
|cff0070dd = blue (rare)
|cff1eff00 = green (uncommon)
|cffffffff = white (normal)
|cff9d9d9d = gray (crappy)
|cFFFFff00 = yellow
|cFFFF0000 = red
]]