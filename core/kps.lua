
local LOG=kps.Logger(kps.LogLevel.INFO)

kps.castSequenceIndex = 1
kps.castSequence = nil
local castSequenceStartTime = 0
local castSequenceTarget = 0
local prioritySpell = nil
local priorityAction = nil
local priorityMacro = nil


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

local combatStarted = -1
kps.timeInCombat = 0

kps.combatStep = function ()
    -- Check for combat
    if not InCombatLockdown() and not kps.autoAttackEnabled then
        combatStarted = -1
        kps.timeInCombat = 0
        return
    end

    if combatStarted < 0 then combatStarted = time() end
    kps.timeInCombat = time() - combatStarted

    -- Check for rotation
    if not kps.rotations.getActive() then
        kps.write("KPS does not have a rotation for your class (", kps.classes.className() ,") or spec (", kps.classes.specName(), ")!")
        kps.enabled = false
    end

    local player = kps.env.player

    -- No combat if mounted (except if overriden by config), dead or drinking
    if (player.isMounted and not kps.config.dismountInCombat) or player.isDead or player.isDrinking then return end

    if kps.castSequence ~= nil then
        if kps.castSequence[kps.castSequenceIndex] ~= nil and (castSequenceStartTime + kps.maxCastSequenceLength > GetTime()) then
            local spell = kps.castSequence[kps.castSequenceIndex]()
            if spell.canBeCastAt(castSequenceTarget) and not player.isCasting then
                LOG.warn("Cast-Sequence: %s. %s", kps.castSequenceIndex, spell)
                kps.castSequenceIndex = kps.castSequenceIndex + 1
                return spell.cast(castSequenceTarget)
            end
        else
            kps.castSequenceIndex = 0
            kps.castSequence = nil
        end
    else
        local activeRotation = kps.rotations.getActive()
        if not activeRotation then return end
        activeRotation.checkTalents()
        local spell, target = activeRotation.getSpell()
        -- Spell Object
        if spell ~= nil and spell.cast ~= nil and not player.isCasting then
            if prioritySpell ~= nil then
                if prioritySpell.canBeCastAt("target") then
                    LOG.warn("Priority Spell %s was casted.", prioritySpell)
                    local a, b, c = prioritySpell.cast(target)
                    prioritySpell = nil
                    return a, b, c
                else
                    if prioritySpell.cooldown > 2 then prioritySpell = nil end
                    return spell.cast(target)
                end
            else
                LOG.debug("Casting %s for next cast.", spell.name)
                return spell.cast(target)
            end
        end
        -- Cast Sequence Table
        if type(spell) == "table" and spell.cast == nil then
            LOG.debug("Starting Cast-Sequence...")
            kps.castSequenceIndex = 1
            kps.castSequence = spell
            castSequenceStartTime = GetTime()
            castSequenceTarget = target
        end
        -- Macro !
        if type(spell) == "string" then
            return spell
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
                LOG.debug("Set %s for next cast.", spell.name)
            end
        end
        if stype == "item" then
            priorityAction = kps.useItem(id)
        end
        if stype == "macro" then
            local macroText = select(3, GetMacroInfo(id))
            priorityMacro = macroText
        end
    end
end)

kps.lastCastedSpell = nil
kps.lastSentSpell = nil
