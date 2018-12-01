--[[[
@module Mage Environment Functions and Variables
@description
Mage Environment Functions and Variables.
]]--

kps.env.mage = {}

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

local burnPhase = false
function kps.env.mage.burnPhase()
    if not burnPhase then
        -- At the start of the fight and whenever Evocation Icon Evocation is about to come off cooldown, you need to start the Burn Phase
        -- and burn your Mana. Before doing so, make sure that you have 3 charges of Arcane Missiles and 4 stacks of Arcane Charge.
        burnPhase = kps.env.player.timeInCombat < 5 or kps.spells.mage.evocation.cooldown < 2
    else
        burnPhase = kps.env.player.mana > 0.35
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
        -- Combustion sequence initialization
        -- This sequence lists the requirements for preparing a Combustion combo with each talent choice
        -- Meteor Combustion:
        --    actions.init_combust=start_pyro_chain,if=talent.meteor.enabled&cooldown.meteor.up&((cooldown.combustion.remains<gcd.max*3&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion without 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion with 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight)
        -- Unglyphed Combustions between Prismatic Crystals:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!glyph.combustion.enabled&cooldown.prismatic_crystal.remains>20&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Kindling or Level 90 Combustion:
        --    actions.init_combust+=/start_pyro_chain,if=!talent.prismatic_crystal.enabled&!talent.meteor.enabled&((cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))

        --TODO: Implement pyroChain sequence
        -- pyroChainStart = GetTime()
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

function kps.env.mage.IsAttackable(unit) -- {spells.frostbolt, 'IsAttackable("target")' , "target" },
    if UnitIsAttackable(unit) and not UnitHasAura(unit) then return true end
    return false
end

function kps.env.mage.FocusMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        kps.runMacro("/focus mouseover")
    end
    return nil, nil
end


