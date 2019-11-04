--[[[
@module Mage Environment Functions and Variables
@description
Mage Environment Functions and Variables.
]]--

kps.env.mage = {}

local burnPhase = false
function kps.env.mage.burnPhase()
    if burnPhase then
        burnPhase = kps.env.player.mana > 0.2
    else
        -- start if arcane power is ready or we have 4 arcane charges
        burnPhase = kps.spells.mage.arcanePower.cooldown <= 0 or kps.env.player.arcaneCharges >= 4
    end
    return burnPhase
end

local incantersFlowDirection = 0
local incantersFlowLastStacks = 0
function kps.env.mage.incantersFlowDirection()
    local stack = select(4, UnitBuff("player", GetSpellInfo(116267)))
    if stack < incantersFlowLastStacks then
        incantersFlowDirection = -1
        incantersFlowLastStacks = stack
    elseif stack > incantersFlowLastStacks then
        incantersFlowDirection = 1
        incantersFlowLastStacks = stack
    end
    return encantersFlowDirection
end

local pyroChain = false
local pyroChainEnd = 0
function kps.env.mage.pyroChain()
    if not pyroChain then
        return false
    else
        -- actions=stop_pyro_chain,if=prev_off_gcd.combustion
        pyroChain = kps.env.player.mana > 0.35
    end
    return pyroChain
end
function kps.env.mage.pyroChainDuration()
    local duration = pyroChainEnd - GetTime()
    if duration < 0 then return 0 else return duration end
end


--------------------------------------------------------------------------------------------
------------------------------- MAGE
--------------------------------------------------------------------------------------------

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

local UnitHasBuff = function(unit,spellName)
    local auraName,count,debuffType,duration,endTime,caster,isStealable,spellid,isBossDebuff,value
    local i = 1
    auraName,_,count,debuffType,duration,endTime,caster,isStealable,_,spellid,_,isBossDebuff,_,_,value1,value2,value3 = UnitBuff(unit,i)
    while auraName do
        if auraName == spellName then
            return true
        end
        i = i + 1
        auraName,_,count,debuffType,duration,endTime,caster,isStealable,_,spellid,_,isBossDebuff,_,_,value1,value2,value3 = UnitBuff(unit,i)
    end
    return false
end


local auraTable = {kps.Spell.fromId(642), kps.Spell.fromId(47585), kps.Spell.fromId(20066)}

local function UnitHasAura(unit)
    for _,aura in ipairs(auraTable)  do -- #auraTable
        if UnitHasBuff(unit,aura.name) then return true end
        if UnitHasDebuff(unit,aura.name) then return true end
    end
    return false
end

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.mage.IsAttackable(unit)
    if UnitIsAttackable(unit) and not UnitHasAura(unit) then return true end
    return false
end

