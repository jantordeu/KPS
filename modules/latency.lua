--[[
Latency Calculation
]]--

kps.latency = 0
local GetNetStats = GetNetStats
local lastCastChangeTime, sendTime, latency
local lagWorld = select(4,GetNetStats())/1000.0
local lagHome = select(4,GetNetStats())/1000.0

-- "CURRENT_SPELL_CAST_CHANGED" -- Fired when the spell being cast is changed.
kps.events.register("CURRENT_SPELL_CAST_CHANGED", function(...)
	lastCastChangeTime = GetTime()
end)

-- "UNIT_SPELLCAST_SENT" unit, target, castGUID, spellID
kps.events.register("UNIT_SPELLCAST_SENT", function(...)
	local unitID = select(1,...)
	if unitID ~= "player" then return end
	sendTime = lastCastChangeTime
	lastCastChangeTime = nil
end)

-- UNIT_SPELLCAST_SUCCEEDED: unitTarget, castGUID, spellID
kps.events.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
	local unitID = select(1,...)
	if unitID ~= "player" then return end
	sendTime = nil
end)

-- UNIT_SPELLCAST_START: unitTarget, castGUID, spellID
-- Fired when a unit begins casting a non-instant cast spell, including party/raid members or the player.
kps.events.register("UNIT_SPELLCAST_START", function(...)
	local unitID = select(1,...)
	if unitID ~= "player" then return end
	if sendTime == nil then latency = lagWorld
	else
	latency = GetTime() - sendTime
	end
	kps.latency = math.max(latency,lagWorld)
end)






--[[
/dump GetCVar("SpellQueueWindow") 400 ms latency default
this is poop if expect your spells to go off when intended in some cases.
if your latency to the server is 100 ms you can reduce the spell Q latency to whatever you like by the following command line.
/console SpellQueueWindow 100
This will change your spell Q latency to 100ms
but say for example you have a 100ms connection latency then maybe its a good idea to stay above your latency 
]]