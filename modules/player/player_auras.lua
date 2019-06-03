--[[
Player Auras: Functions which handle player auras
]]--


local Player = kps.Player.prototype
--[[[
@function `player.isMounted` - returns true if the player is mounted (exception: Nagrand Mounts do not count as mounted since you can cast while riding)
]]--
function Player.isMounted(self)
    return IsMounted() and not Player.hasBuff(self)(kps.spells.mount.frostwolfWarWolf) and not Player.hasBuff(self)(kps.spells.mount.telaariTalbuk)
end

--[[[
@function `player.isFalling` - returns true if the player is currently falling.
]]--
function Player.isFalling(self)
    return IsFalling()
end

--[[[
@function `player.IsFallingSince(<seconds>)` - returns true if the player is falling longer than n seconds.
]]--

local IsFallingSince = function(delay)
    if delay == nil then delay = 1 end
    if not IsFalling() and kps.timers.check("Falling") > 0 then kps.timers.reset("Falling") end
    if IsFalling() then
        if kps.timers.check("Falling") == 0 then kps.timers.create("Falling", delay * 2 ) end
    end
    if IsFalling() and kps.timers.check("Falling") > 0 and kps.timers.check("Falling") < delay then return true end
    return false
end

function Player.IsFallingSince(self)
    return IsFallingSince
end

--[[[
@function `player.isSwimming` - returns true if the player is currently swimming.
]]--
function Player.isSwimming(self)
    return IsSwimming()
end

--[[[
@function `player.timeToShard` - returns average time to the next soul shard.
]]--

local agonyCount = function()
    local count = 0
    -- A dot tracker would be better, but this should do for now...
    if kps.env.target.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.focus.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.mouseover.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.boss1.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.boss2.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.boss3.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    if kps.env.boss4.hasMyDebuff(kps.spells.warlock.agony) then count = count + 1 end
    return count
end

function Player.timeToShard(self)
    local activeAgonies = agonyCount()
    if activeAgonies == 0 then return 999999 end
    local tickTime = kps.spells.warlock.agony.tickTime
    local average = 1.0 / (0.184 * math.pow(activeAgonies, -2.0/3.0)) * tickTime / activeAgonies
    if kps.env.player.hasTalent(7,2) then average = average / 1.15 end
    return average
end

--[[[
@function `player.isInRaid` - returns true if the player is currently in Raid.
]]--
function Player.isInRaid(self)
    return IsInRaid()
end


--[[[
@function `player.isInGroup` - returns true if the player is currently in Group.
]]--
function Player.isInGroup(self)
    return IsInGroup()
end

--[[[
@function `player.isControlled` - Checks whether you are controlled over your character (you are feared, etc).
]]--

function kps.Player.prototype.isControlled(self)
    if kps.timers.check("LossOfControl") > 0 then return true end
    return false
end

--[[[
@function `player.isRoot` - Checks whether you are controlled over your character (you are feared, etc).
]]--

function kps.Player.prototype.isRoot(self)
    if kps.timers.check("Root") > 0 then return true end
    return false
end

--[[[
@function `player.isStun` - Checks whether you are controlled over your character (you are feared, etc).
]]--

function kps.Player.prototype.isStun(self)
    if kps.timers.check("Stun") > 0 then return true end
    return false
end

--[[[
@function `player.isStun` - Checks whether you are controlled over your character (you are feared, etc).
]]--

function kps.Player.prototype.isInterrupt(self)
    if kps.timers.check("Interrupt") > 0 then return true end
    return false
end


-- locType, spellID, text, iconTexture, startTime, timeRemaining, duration, lockoutSchool, priority, displayType = C_LossOfControl.GetEventInfo(eventIndex)
-- eventIndex Number - index of the loss-of-control effect currently affecting your character to return information about, ascending from 1. 
-- locType = { "STUN_MECHANIC", "STUN", "PACIFYSILENCE", "SILENCE", "FEAR", "CHARM", "PACIFY", "CONFUSE", "POSSESS", "SCHOOL_INTERRUPT", "DISARM", "ROOT" }

lossOfControlType = { ["STUN_MECHANIC"]=false, ["STUN"]=false, ["PACIFYSILENCE"]=true, ["SILENCE"]=true, ["FEAR"]=true, ["CHARM"]=true, ["PACIFY"]=true, ["CONFUSE"]=true, ["POSSESS"]=true, ["SCHOOL_INTERRUPT"]=false, ["DISARM"]=false, ["ROOT"]=false }

kps.events.register("LOSS_OF_CONTROL_UPDATE", function ()
    local i = C_LossOfControl.GetNumEvents()
    local locType, spellID, _, _, _, _, duration,lockoutSchool,_,_ = C_LossOfControl.GetEventInfo(i)
    if spellID and duration then
        if duration > 0 then
            if string.find(locType,"INTERRUPT") ~= nil then
                if kps.timers.check("Interrupt") == 0 then kps.timers.create("Interrupt",duration) end
            end
            if string.find(locType,"STUN") ~= nil then
                if kps.timers.check("Stun") == 0 then kps.timers.create("Stun",duration) end
            end
            if locType == "ROOT" then
                if kps.timers.check("Root") == 0 then kps.timers.create("Root",duration) end
            end
            if lossOfControlType[loctype] == true then
                if kps.timers.check("LossOfControl") == 0 then kps.timers.create("LossOfControl",duration) end
            end
        end 
    end
end)

kps.events.register("LOSS_OF_CONTROL_ADDED", function ()
    local i = C_LossOfControl.GetNumEvents()
    while i > 0 do
        local locType, spellID, _, _, _, _, duration,lockoutSchool,_,_ = C_LossOfControl.GetEventInfo(i)
        if spellID and duration then
            if duration > 0 then
                if string.find(locType,"INTERRUPT") ~= nil then
                    if kps.timers.check("Interrupt") == 0 then kps.timers.create("Interrupt",duration) end
                end
                if string.find(locType,"STUN") ~= nil then
                    if kps.timers.check("Stun") == 0 then kps.timers.create("Stun",duration) end
                end
                if locType == "ROOT" then
                    if kps.timers.check("Root") == 0 then kps.timers.create("Root",duration) end
                end
                if lossOfControlType[loctype] == true then
                    if kps.timers.check("LossOfControl") == 0 then kps.timers.create("LossOfControl",duration) end
                end
            end
        end
        i = i - 1
    end
end)

--[[[
@function `player.timeInCombat` - returns number of seconds in combat
]]--
local combatEnterTime = 0
function kps.Player.prototype.timeInCombat(self)
    if combatEnterTime == 0 then return 0 end
    return GetTime() - combatEnterTime
end

-- Combat Timer
--/script print(kps.env.player.timeInCombat)
kps.events.register("PLAYER_REGEN_DISABLED", function()
    combatEnterTime = GetTime()
end)
kps.events.register("PLAYER_ENTER_COMBAT", function()
    if combatEnterTime == 0 then combatEnterTime = GetTime() end
end)
kps.events.register("PLAYER_LEAVE_COMBAT", function()
    if not InCombatLockdown() then combatEnterTime = 0 end
end)
kps.events.register("PLAYER_REGEN_ENABLED", function()
    combatEnterTime = 0
    collectgarbage("collect")
end)


--[[[
@function `player.hasTalent(<ROW>,<TALENT>)` - returns true if the player has the selected talent (row: 1-7, talent: 1-3).
]]--
local function hasTalent(row, talent)
    local _, talentRowSelected =  GetTalentTierInfo(row,1)
    return talent == talentRowSelected
end
function Player.hasTalent(self)
    return hasTalent
end

--[[[
@function `player.hasGlyph(<GLYPH>)` - returns true if the player has the given gylph - glyphs can be accessed via the spells (e.g.: `player.hasGlyph(spells.glyphOfDeathGrip)`).
]]--
local function hasGlyph(glyph)
    for index = 1, NUM_GLYPH_SLOTS do
        local enabled, glyphType, glyphTooltipIndex, glyphSpell, icon = GetGlyphSocketInfo(index, talentGroup)
        -- talentGroup - Which set of glyphs to query, if the player has Dual Talent Specialization enabled (number)
        -- 1 Primary Talents -- 2 Secondary Talents -- nil Currently active talents
        if glyphSpell == glyph.id then return true end
    end
    return false
end
function Player.hasGlyph(self)
    return hasGlyph
end

--[[[
@function `player.useItem(<ITEMID>)` - returns true if the player has the given item and cooldown == 0
]]--
local itemCooldown = function(item)
    if item == nil then return 999 end
    local start,duration,enable = GetItemCooldown(item) -- GetItemCooldown(ItemID) you MUST pass in the itemID.
    local usable = select(1,IsUsableItem(item))
    local itemName,_ = GetItemSpell(item) -- Useful for determining whether an item is usable.
    if not usable then return 999 end
    if not itemName then return 999 end
    if enable == 0 then return 999 end
    local cd = start+duration-GetTime()
    if cd < 0 then return 0 end
    return cd
end

local useItem = function(item)
    local cd = itemCooldown(item)
    if cd == 0 then return true end
    return false
end

function Player.useItem(self)
    return useItem
end


--[[[
@function `player.useTrinket(<SLOT>)` - returns true if the player has the given trinket and cooldown == 0
]]--
-- For trinket's. Pass 0 or 1 for the slot.
-- { "macro", player.useTrinket(0) , "/use 13"},
-- { "macro", player.useTrinket(1) , "/use 14"},
local useTrinket = function(trinketNum)
    -- The index actually starts at 0
    local slotName = "Trinket"..(trinketNum).."Slot" -- "Trinket0Slot" "Trinket1Slot"
    -- Get the slot ID
    local slotId = select(1,GetInventorySlotInfo(slotName)) -- "Trinket0Slot" est 13 "Trinket1Slot" est 14
    -- get the Trinket ID
    local trinketId = GetInventoryItemID("player", slotId)
    if not trinketId then return false end
    -- Check if it's on cooldown
    local trinketCd = itemCooldown(trinketId)
    if trinketCd > 0 then return false end
    -- Check if it's usable
    local trinketUsable = GetItemSpell(trinketId)
    if not trinketUsable then return false end
    return true
end

function Player.useTrinket(self)
    return useTrinket
end

--[[[
@function `player.hasTrinket(<SLOT>)` - returns true if the player has the given trinket ID e.g. 'player.hasTrinket(1) == 147007 and player.useTrinket(1)'
]]--

local hasTrinket = function(trinketNum)
    local slotName = "Trinket"..(trinketNum).."Slot"
    local slotId = select(1,GetInventorySlotInfo(slotName))
    local trinketId = GetInventoryItemID("player", slotId)
    if not trinketId then return 0 end
    return trinketId
end

function Player.hasTrinket(self)
    return hasTrinket
end