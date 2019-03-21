
local LOG=kps.Logger(kps.LogLevel.INFO)

local castSequenceIndex = 1
local castSequence = nil
local castSequenceStartTime = 0
local castSequenceTarget = 0
local prioritySpell = nil
local priorityAction = nil
local priorityMacro = nil
local castSequenceMessage = nil


kps.runMacro = function(macroText)
    RunMacroText(macroText)
end

kps.stopCasting = function()
    SpellStopCasting()
end

function kps.write(...)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000KPS: " .. strjoin(" ", tostringall(...))); -- color orange
end

kps.useItem = function(itemId)
    return function ()
        return true
    end
end

local function handlePriorityActions()
    if priorityMacro ~= nil then
        priorityMacro = nil
    elseif priorityAction ~= nil then
        priorityAction = nil
    elseif prioritySpell ~= nil then
        if prioritySpell.canBeCastAt("target") and prioritySpell.cooldown < 2 then
            prioritySpell.cast()
            LOG.warn("Priority Spell %s was casted.", prioritySpell)
            prioritySpell = nil
        else
            if prioritySpell.cooldown > 2 then prioritySpell = nil end
        end
    else
        return false
    end
    return true
end

kps.combatStep = function ()
    -- Check for rotation
    if not kps.rotations.getActive() then
        kps.write("KPS does not have a rotation for your class (", kps.classes.className() ,") or spec (", kps.classes.specName(), ")!")
        kps.enabled = false
    end
    
    -- Check for combat
    if not InCombatLockdown() or not kps.autoAttackEnabled then return end

    local player = kps.env.player

    -- No combat if mounted (except if overriden by config), dead or drinking
    if (player.isMounted and not kps.config.dismountInCombat) or player.isDead or player.isDrinking then return end

    if castSequence ~= nil then
        if castSequence[castSequenceIndex] ~= nil and (castSequenceStartTime + kps.maxCastSequenceLength > GetTime()) then
            local spell = castSequence[castSequenceIndex]()
            if spell.canBeCastAt(castSequenceTarget) and not player.isCasting then
                LOG.warn("Cast-Sequence: %s. %s", castSequenceIndex, spell)
                castSequenceIndex = castSequenceIndex + 1
                --spell.cast(castSequenceTarget,castSequenceMessage)
            end
        else
            castSequenceIndex = nil
            castSequence = nil
        end
    else
        local activeRotation = kps.rotations.getActive()
        if not activeRotation then return end
        activeRotation.checkTalents()
        local spell, target, message = activeRotation.getSpell()
        if player.pause then return end

        if spell ~= nil and spell.cast ~= nil and not player.isCasting then
            if prioritySpell ~= nil then
                if prioritySpell.canBeCastAt("target") and prioritySpell.cooldown < 2 then
                    --prioritySpell.cast()
                    local name = prioritySpell.name
                    local needsSelect = prioritySpell.needsSelect
            		LOG.warn("Priority Spell %s was casted.", prioritySpell)
            		prioritySpell = nil
                    return name, "target", needsSelect
                else
                    if prioritySpell.cooldown > 2 then prioritySpell = nil end
                    -- spell.cast(target,message)
                    return spell.name, target, spell.needsSelect
                end
            elseif spell.name == nil then
                LOG.debug("Starting Cast-Sequence...")
                castSequenceIndex = 1
                castSequence = spell
                castSequenceStartTime = GetTime()
                castSequenceTarget = target
                castSequenceMessage = message
            else
                LOG.debug("Casting %s for next cast.", spell.name)
                --spell.cast(target,message)
                return spell.name, target, spell.needsSelect
            end
        end
    end
end

hooksecurefunc("UseAction", function(...)
    if kps.enabled and (select(3, ...) ~= nil) and InCombatLockdown() == true  then
        -- actionType, id, subType = GetActionInfo(slot)
        local stype,id,_ = GetActionInfo(select(1, ...))
        if stype == "spell" then
            local spell = kps.Spell.fromId(id)
            if prioritySpell == nil and spell.isPrioritySpell then
                prioritySpell = spell
                LOG.warn("Set %s for next cast.", spell.name)
            end
        end
        if stype == "item" then
            kps.useItem(id)
        end
        if stype == "macro" then
            local macroText = select(3, GetMacroInfo(id))
        end
    end
end)
