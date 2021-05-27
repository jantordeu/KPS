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

local UnitAffectingCombat = UnitAffectingCombat
local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.mage.damageTarget()
    if UnitIsAttackable("target") then return "target"
    elseif UnitIsAttackable("targettarget") then return "targettarget"
    elseif UnitIsAttackable("focus") then return "focus"
    elseif UnitIsAttackable("focustarget") then return "focustarget"
    elseif UnitIsAttackable("mouseovertarget") then return "mouseovertarget"
    elseif UnitIsAttackable("mouseover") then return "mouseover"
    end
end

kps.env.mage.checkfireBlast = function()
	local charges = kps.spells.mage.fireBlast.charges
    return "fireBlast_charges:"..charges
end