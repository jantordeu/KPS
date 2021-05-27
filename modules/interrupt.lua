
local kickOrder = {
    kps.Unit.new("target"),
    kps.Unit.new("focus"),
    kps.Unit.new("mouseover"),
    kps.Unit.new("targettarget"),
    kps.Unit.new("focustarget")
}

local counterspell = kps.Spell.fromId(2139)
local mindFreeze = kps.Spell.fromId(47528)
local spellLock = kps.Spell.fromId(19647)
local kick = kps.Spell.fromId(1766)
local windShear = kps.Spell.fromId(57994)
local disrupt = kps.Spell.fromId(183752)
local rebuke = kps.Spell.fromId(96231)

kps.kickSpell = function()
    local _,_,classId = UnitClass("player")
    if classId == 1 then -- Warrior
        return nil
    elseif classId == 2 then -- Paladin
        return rebuke
    elseif classId == 3 then -- Hunter
        return nil
    elseif classId == 4 then -- Rogue
        return kick
    elseif classId == 5 then -- Priest
        return nil
    elseif classId == 6 then -- Deathknight
        return mindFreeze
    elseif classId == 7 then -- Shaman
        return windShear
    elseif classId == 8 then -- Mage
        return counterspell
    elseif classId == 9 then -- Warlock
        return spellLock
    elseif classId == 10 then -- Monk
        return nil
    elseif classId == 11 then -- Druid
        return nil
    elseif classId == 12 then -- Demonhunter
        return disrupt
    end
    return playerSpells[classId]
end

kps.kick = function()
    local interruptSpell = kps.kickSpell()
    if interruptSpell ~= nil then
        for idx, unit in ipairs(kickOrder) do
            if unit.isInterruptable and interruptSpell.canBeCastAt(unit.unit) then
                kps.write("KICK ", unit.unit)
                kps.prioritySpell(interruptSpell, unit.unit)
                return
            end
        end
    end
end

