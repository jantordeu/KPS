--[[[
@module Warlock Environment Functions and Variables
@description
Warlock Environment Functions and Variables.
]]--

kps.env.warlock = {}


--kps.runOnClass("WARLOCK", function ( )
--    kps.gui.createToggle("conserve", "Interface\\Icons\\spell_Mage_Flameorb", "Conserve")
--end)

function kps.env.warlock.isHavocUnit(unit)
    if not UnitExists(unit) then  return false end
    if UnitIsUnit("target",unit) then return false end
    return true
end

local burningRushLastMovement = 0
function kps.env.warlock.deactivateBurningRushIfNotMoving(seconds)
    return function ()
        if not seconds then seconds = 0 end
        local player = kps.env.player
        if player.isMoving or not player.hasBuff(kps.spells.warlock.burningRush) then
            burningRushLastMovement = GetTime()
        else
            local nonMovingDuration = GetTime() - burningRushLastMovement
            if nonMovingDuration >= seconds then
                kps.runMacro("/cancelaura "..kps.spells.warlock.burningRush)
            end
        end
    end
end

-- Config FOCUS with MOUSEOVER
function kps.env.warlock.FocusMouseover()
    local mouseover = kps.env.mouseover
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and mouseover.isAttackable then
        if not mouseover.hasMyDebuff(kps.spells.warlock.agony) then
            kps.runMacro("/focus mouseover")
        else
            kps.runMacro("/focus mouseover")
        end
    end
    return nil, nil
end
