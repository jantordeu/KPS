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
------------------------------- TEST FUNCTIONS
--------------------------------------------------------------------------------------------

function kps.env.priest.booltest()
    if kps.multiTarget then return true end
    return false
end
function kps.env.priest.boolval(arg)
    if arg == true then return true end
    return false
end
function kps.env.priest.strtest()
    if kps.multiTarget then return "a" end
    return "b"
end
function kps.env.priest.strval(arg)
    if arg == true then return "a" end
    return "b"
end

--kps.rotations.register("PRIEST","SHADOW",{

--{spells.mindFlay, env.booltest }, -- true/false
--{spells.mindFlay, env.booltest() }, -- always false
--{spells.mindFlay, 'env.booltest' }, -- nil value
--{spells.mindFlay, 'env.booltest()' }, -- nil value
--{spells.mindFlay, 'booltest()' }, -- true/false
--{spells.mindFlay, 'booltest' }, -- always true

--{spells.mindFlay, env.boolval(kps.multiTarget) }, -- always false
--{spells.mindFlay, 'env.boolval(kps.multiTarget)' }, -- nil value
--{spells.mindFlay, 'boolval(kps.multiTarget)' }, -- always true

--{spells.mindFlay, env.strtest == "a" }, -- always false
--{spells.mindFlay, env.strtest() == "a" }, -- always false
--{spells.mindFlay, 'env.strtest == "a"' }, -- nil value
--{spells.mindFlay, 'env.strtest() == "a"' }, -- nil value
--{spells.mindFlay, 'strtest() == "a"' }, -- true/false
--{spells.mindFlay, 'strtest == "a"' }, -- always false

--{spells.mindFlay, env.strval(kps.multiTarget) == "a" }, -- always false
--{spells.mindFlay, 'env.strval(kps.multiTarget) == "a"' }, -- nil value
--{spells.mindFlay, strval(kps.multiTarget) == "a" }, -- nil value
--{spells.mindFlay, 'strval(kps.multiTarget) == "a"' }, -- true/false

--},"TEST Priest")

--------------------------------------------------------------------------------------------
------------------------------- LOCAL FUNCTIONS
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

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    --if UnitIsEnemy("player",unit) == false then return false end
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
    elseif UnitIsAttackable("targettarget") then return "targettarget"
    elseif UnitIsAttackable("focus") then return "focus"
    elseif UnitIsAttackable("focustarget") then return "focustarget"
    elseif UnitIsAttackable("mouseovertarget") then return "mouseovertarget"
    elseif UnitIsAttackable("mouseover") then return "mouseover"
    else return kps.env.heal.enemyLowest -- kps.env.heal.enemyTarget
    end
end

--------------------------------------------------------------------------------------------
------------------------------- SHADOW PRIEST
--------------------------------------------------------------------------------------------

local MindFlay = kps.spells.priest.mindFlay.name
local VoidForm = kps.spells.priest.voidForm.name
local ShadowWordPain = kps.spells.priest.shadowWordPain.name
local VampiricTouch = kps.spells.priest.vampiricTouch.name

-- Config FOCUS with MOUSEOVER
function kps.env.priest.FocusMouseoverShadow()
    local mouseover = kps.env.mouseover
    local focus = kps.env.focus
    if not focus.exists and not UnitIsUnit("target","mouseover") and mouseover.isAttackable and mouseover.inCombat then
        if not mouseover.hasMyDebuff(kps.spells.priest.vampiricTouch) then
            --kps.runMacro("/focus mouseover")
            return true
        elseif not mouseover.hasMyDebuff(kps.spells.priest.shadowWordPain) then
            --kps.runMacro("/focus mouseover")
            return true
        else
            --kps.runMacro("/focus mouseover")
            return true
        end
    elseif focus.exists and not UnitIsUnit("target","mouseover") and not UnitIsUnit("focus","mouseover") and focus.myDebuffDuration(kps.spells.priest.shadowWordPain) > 4.8 and focus.myDebuffDuration(kps.spells.priest.vampiricTouch) > 6.3 then
        if not mouseover.hasMyDebuff(kps.spells.priest.vampiricTouch) and mouseover.isAttackable and mouseover.inCombat then
            --kps.runMacro("/focus mouseover")
            return true
        elseif not mouseover.hasMyDebuff(kps.spells.priest.shadowWordPain) and mouseover.isAttackable and mouseover.inCombat then
            --kps.runMacro("/focus mouseover")
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------------------
------------------------------- AVOID OVERHEALING
--------------------------------------------------------------------------------------------

local UnitCastingInfo = UnitCastingInfo
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("unit")
-- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo(self.unit)

local overHealTableUpdate = function()
    -- kps.defensive in case I want to heal with mouseover (e.g. debuff absorb heal)
    local overHealTable = { {kps.spells.priest.flashHeal.name, 0.855 , kps.defensive}, {kps.spells.priest.heal.name, 0.955 , kps.defensive}, {kps.spells.priest.prayerOfHealing.name, 3 , kps.defensive} }
    return  overHealTable
end

local ShouldInterruptCasting = function (interruptTable, countLossInRange)
    if kps.lastTargetGUID == nil then return false end
    local spellCasting, _, _, _, endTime, _, _, _, _ = UnitCastingInfo("player")
    if spellCasting == nil then return false end
    if endTime == nil then return false end
    local target = kps.lastTarget
    local targetHealth = UnitHealth(target) / UnitHealthMax(target)
    if type(targetHealth) ~= "number" then return false end

    for key, healSpellTable in pairs(interruptTable) do
        local breakpoint = healSpellTable[2]
        local spellName = healSpellTable[1]
        if spellName == spellCasting then
            if spellName == kps.spells.priest.prayerOfHealing.name and healSpellTable[3] == true and countLossInRange < breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName.."|".." countLossInRange: "..countLossInRange, 0, 0.5, 0.8)
            elseif spellName == kps.spells.priest.flashHeal.name and healSpellTable[3] == true and targetHealth > breakpoint  then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName.."|"..target.." health: "..targetHealth, 0, 0.5, 0.8)
            elseif spellName == kps.spells.priest.heal.name and healSpellTable[3] == true and targetHealth > breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName.."|"..target.." health: "..targetHealth, 0, 0.5, 0.8)
            end
        end
    end
    return nil, nil
end

kps.env.priest.ShouldInterruptCasting = function()
    local countLossInRange = kps["env"].heal.countLossInRange(0.85)
    local interruptTable = overHealTableUpdate()
    return ShouldInterruptCasting(interruptTable, countLossInRange)
end

-- usage in Rotation -- env.FindUnitWithNoRenew,
local ArenaRBGFriends = { "player", "raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10", "party1", "party2", "party3", "party4"}
kps.env.priest.FindUnitWithNoRenew = function()
    local renewUnit = nil
    local buff = kps.spells.priest.renew
    for i=1,#ArenaRBGFriends do
        local unit = ArenaRBGFriends[i]
        if UnitExists(unit) and not UnitBuff(unit,buff.name) then
            renewUnit = unit
        end
    end
    if renewUnit == nil then return nil, nil end
    return buff, renewUnit
end

local LifeSwapList = {"player", "raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10", "party1", "party2", "party3", "party4"}
kps.env.priest.HighestInRaidStatus = function()
    local swapUnit = nil
    local highestHP = 0
    for i=1,#LifeSwapList do
        local unit = LifeSwapList[i]
        local unitHP = UnitHealth(unit) / UnitHealthMax(unit)
        if UnitExists(unit) then
            if unitHP > highestHP then
                highestHP = unitHP
                swapUnit = unit
            end
        end
    end
    return swapUnit
end

--------------------------------------------------------------------------------------------
------------------------------- MESSAGE ON SCREEN
--------------------------------------------------------------------------------------------

local function holyWordSanctifyOnScreen()
    if kps.spells.priest.holyWordSanctify.cooldown < kps["env"].player.gcd and kps.timers.check("holyWordSanctify") < 1 then
        kps.timers.create("holyWordSanctify", 10 )
        kps.utils.createMessage("holyWordSanctify Ready")
    end
end

kps.env.priest.holyWordSanctifyMessage = function()
    return holyWordSanctifyOnScreen()
end

local function haloOnScreen()
    if kps.spells.priest.halo.cooldown < kps["env"].player.gcd  and kps.timers.check("halo") < 1 then
        kps.timers.create("halo", 10 )
        kps.utils.createMessage("halo Ready")
    end
end

kps.env.priest.haloMessage = function()
    return haloOnScreen()
end

kps.env.priest.buff = function()
    local buff = kps.spells.priest.atonement
    --return kps["env"].player.myBuffDuration(buff)
    return kps["env"].player.hasMyBuff(buff)
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
