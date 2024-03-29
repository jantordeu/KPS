--[[[
@module Priest Environment Functions and Variables
@description
Priest Environment Functions and Variables.
]]--

kps.env.priest = {}

local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local UnitChannelInfo = UnitChannelInfo

--------------------------------------------------------------------------------------------
------------------------------- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

local function PlayerHasTalent(row,talent)
    local _, talentRowSelected =  GetTalentTierInfo(row,1)
    if talent == talentRowSelected then return true end
    return false
end

function kps.env.priest.damageTarget()
    if UnitIsAttackable("target") then return "target"
    elseif UnitIsAttackable("mouseover") then return "mouseover"
    elseif UnitIsAttackable("mouseovertarget") then return "mouseovertarget"
    elseif UnitIsAttackable("targettarget") then return "targettarget"
    elseif UnitIsAttackable("focus") then return "focus"
    elseif UnitIsAttackable("focustarget") then return "focustarget"
    end
end

--------------------------------------------------------------------------------------------
------------------------------- MESSAGE ON SCREEN
--------------------------------------------------------------------------------------------

local function holyWordSanctifyOnScreen()
    if kps.spells.priest.holyWordSanctify.cooldown < 5 and kps.timers.check("holyWordSanctify") < 2 then
        kps.timers.create("holyWordSanctify", 10 )
        kps.utils.createMessage("holyWordSanctify Ready")
    end
end

local function flashConcentrationOnScreen()
    local spell = kps.spells.priest.flashConcentration
    if kps["env"].player.buffDuration(spell) < 5 and kps.timers.check("flashConcentration") < 2 then
        kps.timers.create("flashConcentration", 10 )
        kps.utils.createMessage("flashConcentration REFRESH")
    end
end

kps.env.priest.holyWordSanctifyMessage = function()
    return holyWordSanctifyOnScreen()
end

kps.env.priest.flashConcentrationMessage = function()
    return flashConcentrationOnScreen()
end


-- SendChatMessage("msg" [, "chatType" [, languageIndex [, "channel"]]])
-- Sends a chat message of the specified in 'msg' (ex. "Hey!"), to the system specified in 'chatType' ("SAY", "WHISPER", "EMOTE", "CHANNEL", "PARTY", "INSTANCE_CHAT", "GUILD", "OFFICER", "YELL", "RAID", "RAID_WARNING", "AFK", "DND"),
-- in the language specified in 'languageID', to the player or channel specified in 'channel'(ex. "1", "Bob").


--kps.events.register("UNIT_SPELLCAST_START", function(unitID,lineID,spellID)
--    if unitID == "player" and spellID ~= nil then
--    end
--end)

--kps.events.register("UNIT_SPELLCAST_CHANNEL_START", function(unitID,lineID,spellID)
--    if unitID == "player" and spellID ~= nil then
--        if spellID == 64843 then SendChatMessage("Casting DIVINE HYMN" , "RAID" ) end
--    end
--end)
