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

function kps.env.mage.damageTarget()
    if UnitIsAttackable("target") then return "target"
    elseif UnitIsAttackable("targettarget") then return "targettarget"
    elseif UnitIsAttackable("focus") then return "focus"
    elseif UnitIsAttackable("focustarget") then return "focustarget"
    elseif UnitIsAttackable("mouseovertarget") then return "mouseovertarget"
    elseif UnitIsAttackable("mouseover") then return "mouseover"
    else return kps.env.heal.enemyLowest -- kps.env.heal.enemyTarget
    end
end

-- Config FOCUS with MOUSEOVER
function kps.env.mage.FocusMouseoverFire()
    local mouseover = kps.env.mouseover
    local focus = kps.env.focus
    if not focus.exists and not UnitIsUnit("target","mouseover") and mouseover.isAttackable and mouseover.inCombat then
        if not mouseover.hasMyDebuff(kps.spells.mage.ignite) then
            --kps.runMacro("/focus mouseover")
            return true
        elseif not mouseover.hasMyDebuff(kps.spells.mage.conflagration) then
            --kps.runMacro("/focus mouseover")
            return true
        else
            --kps.runMacro("/focus mouseover")
            return true
        end
    elseif focus.exists and not UnitIsUnit("target","mouseover") and not UnitIsUnit("focus","mouseover") and focus.myDebuffDuration(kps.spells.mage.ignite) > 2 and focus.myDebuffDuration(kps.spells.mage.conflagration) > 2 then
        if not mouseover.hasMyDebuff(kps.spells.mage.conflagration) and mouseover.isAttackable and mouseover.inCombat then
            --kps.runMacro("/focus mouseover")
            return true
        elseif not mouseover.hasMyDebuff(kps.spells.mage.ignite) and mouseover.isAttackable and mouseover.inCombat then
            --kps.runMacro("/focus mouseover")
            return true
        end
    end
    return false
end


