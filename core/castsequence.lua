--[[[
@module CastSequence
@description
Handles CastSequence Progression and the last casted Spell Name.
]]--

--[[
local debug = function (key)
    kps.events.register(key, function (unit, lineId, spellId)
        if unit == "player" then
            local spellName = select(1, GetSpellInfo(spellId))
            if spellName == nil then spellName = "nil" end
            if lineId == nil then lineId = "nil" end
            kps.write(GetTime() .. " Event " .. key .. " " .. spellName .. "(" .. spellId .. ")" .. "(line ID: " .. lineId .. ")")
        end
    end)
end
debug("UNIT_SPELLCAST_START")
debug("UNIT_SPELLCAST_CHANNEL_START")
debug("UNIT_SPELLCAST_CHANNEL_STOP")
debug("UNIT_SPELLCAST_FAILED")
debug("UNIT_SPELLCAST_FAILED_QUIET")
debug("UNIT_SPELLCAST_INTERRUPTED")
debug("UNIT_SPELLCAST_SENT")
debug("UNIT_SPELLCAST_STOP")
debug("UNIT_SPELLCAST_SUCCEEDED")
--]]

--[[
CastSequence Event Order:

 * Channel:
   * UNIT_SPELLCAST_CHANNEL_START(unit, nil, spellId) - Instantly on start
   * UNIT_SPELLCAST_SUCCEEDED(unit, lineId, spellId) - Directly after UNIT_SPELLCAST_CHANNEL_START
   * UNIT_SPELLCAST_CHANNEL_STOP(unit, nil, spellId) - Once cast is finished/aborted

 * Instant:
   * UNIT_SPELLCAST_SUCCEEDED(unit, lineId, spellId) - Instantly and only this event

 * Cast
   * UNIT_SPELLCAST_START(unit, lineId, spellId) - Instantly on cast start
   * UNIT_SPELLCAST_SUCCEEDED(unit, lineId, spellId) - Once the cast has finished
   * UNIT_SPELLCAST_STOP(unit, lineId, spellId) - directly after UNIT_SPELLCAST_SUCCEEDED or UNIT_SPELLCAST_INTERRUPTED ()

]]
local channeling = false
local casting = false

kps.events.register("UNIT_SPELLCAST_CHANNEL_START", function (unit, arg2, spellId)
    if unit == "player" then
        channeling = true
    end
end)
kps.events.register("UNIT_SPELLCAST_CHANNEL_STOP", function (unit, arg2, spellId)
    if unit == "player" then
        channeling = false
    end
end)
kps.events.register("UNIT_SPELLCAST_START", function (unit, lineId, spellId)
    if unit == "player" and kps.castSequence ~= nil then
        local spellName = select(1, GetSpellInfo(spellId))
        local spellWhichShouldBeCasted = kps.castSequence[kps.castSequenceIndex]().name
        if spellName == spellWhichShouldBeCasted then
            casting = true
            kps.castSequenceIndex = kps.castSequenceIndex + 1
        end
    end
end)
kps.events.register("UNIT_SPELLCAST_STOP", function (unit, lineId, spellId)
    if unit == "player" then
        casting = false
    end
end)
kps.events.register("UNIT_SPELLCAST_INTERRUPTED", function (unit, lineId, spellId)
    if unit == "player" then
        if casting then
            kps.castSequenceIndex = kps.castSequenceIndex - 1
            casting = false
        end
    end
end)

kps.events.register("UNIT_SPELLCAST_SUCCEEDED", function(unit, lineId, spellId)
    if unit == "player" then
        kps.lastCastedSpell = select(1, GetSpellInfo(spellId))
        if kps.castSequence ~= nil then
            if channeling then
                local spellWhichShouldBeCasted = kps.castSequence[kps.castSequenceIndex]().name
                if  spellWhichShouldBeCasted == kps.lastCastedSpell then
                    kps.write("Cast-Sequence Channeling " .. kps.castSequenceIndex .. "/" .. #(kps.castSequence) .. ": " ..kps.lastCastedSpell)
                    kps.castSequenceIndex = kps.castSequenceIndex + 1
                end
            elseif casting then
                kps.write("Cast-Sequence Cast " .. kps.castSequenceIndex .. "/" .. #(kps.castSequence) .. ": " ..kps.lastCastedSpell)
            else
                local spellWhichShouldBeCasted = kps.castSequence[kps.castSequenceIndex]().name
                if  spellWhichShouldBeCasted == kps.lastCastedSpell then
                    kps.write("Cast-Sequence Instant " .. kps.castSequenceIndex .. "/" .. #(kps.castSequence) .. ": " ..kps.lastCastedSpell)
                    kps.castSequenceIndex = kps.castSequenceIndex + 1
                end
            end
        end
    end
end)


local handleSpellStartEvent = function (unit, lineId, spellId)
    if unit == "player" then
        local spellName = select(1, GetSpellInfo(spellId))
        if kps.castSequence ~= nil then
            local spellWhichShouldBeCasted = kps.castSequence[kps.castSequenceIndex]().name
            if spellWhichShouldBeCasted == spellName then
                kps.write("Cast-Sequence Started " .. kps.castSequenceIndex .. "/" .. #(kps.castSequence) .. ": " ..spellName)
                kps.castSequenceIndex = kps.castSequenceIndex + 1
            end
        end
    end
end
--kps.events.register("UNIT_SPELLCAST_START", handleSpellStartEvent)
--kps.events.register("UNIT_SPELLCAST_CHANNEL_START", handleSpellStartEvent)


