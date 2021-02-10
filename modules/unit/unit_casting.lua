--[[
Unit Casting: Functions which handle unit casts
]]--

local Unit = kps.Unit.prototype


--[[[
@function `<UNIT>.castTimeLeft` - returns the casting time left for this unit or 0 if it is not casting
]]--
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("unit")
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo("unit")
function Unit.castTimeLeft(self)
    local name,_,_,_,endTime,_,_,_,_= UnitCastingInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000)
end

--[[[
@function `<UNIT>.channelTimeLeft` - returns the channeling time left for this unit or 0 if it is not channeling
]]--
function Unit.channelTimeLeft(self)
    local name,_,_,_,endTime,_,_ = UnitChannelInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000)
end

--[[[
@function `<UNIT>.isCasting` - returns true if the unit is casting (or channeling) a spell
]]--
local function isClippingSpell(spellname)
    for _,spell in pairs(kps.spells.clippingSpell) do
        if spell.name == spellname and spell.cooldown == 0 then return true end
    end
    return false
end

function Unit.isCastingClippingSpell(self)
    local name,_,_,_,endTime,_,_,_,_= UnitCastingInfo(self.unit)
    if endTime == nil then 
        local name,_,_,_,endTime,_,_ = UnitChannelInfo(self.unit)
        if endTime == nil then return false end
        if isClippingSpell(name) then return true end
    end
    if isClippingSpell(name) then return true end
    return false
end

function Unit.isCasting(self)
    --if Unit.isCastingClippingSpell(self) then return false end
    if Unit.castTimeLeft(self) > kps.latency or Unit.channelTimeLeft(self) > kps.latency then return true end
    return false
end

--[[[
@function `<UNIT>.isCastingSpell(<SPELL>)` - returns true if the unit is casting (or channeling) the given <SPELL> (`target.isCastingSpell(spells.immolate)`)
]]--
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("unit")
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo("unit")
local isCastingSpell = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local name,_,_,_,endTime,_,_,_,_= UnitCastingInfo(unit)
            if endTime == nil then 
                local name,_,_,_,endTime,_,_ = UnitChannelInfo(unit)
                if endTime == nil then return false end
                if tostring(spell.name) == tostring(name) then return true end
            end
            if tostring(spell.name) == tostring(name) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isCastingSpell(self)
    return isCastingSpell[self.unit]
end

--[[[
@function `<UNIT>.isInterruptable` - returns true if the unit is currently casting (or channeling) a spell which can be interrupted.
]]--
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("unit")
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo("unit")
function Unit.isInterruptable(self)
    if UnitCanAttack("player", self.unit) == false then return false end
    --if UnitIsEnemy("player",self.unit) == false then return false end
    local targetSpell, _, _, _, _, _, _, spellInterruptable,_ = UnitCastingInfo(self.unit)
    local targetChannel, _, _, _, _, _, channelInterruptable = UnitChannelInfo(self.unit)
    -- TODO: Blacklisted spells?
    if targetSpell and spellInterruptable == false then return true
    elseif targetChannel and channelInterruptable == false then return true
    end
    return false
end