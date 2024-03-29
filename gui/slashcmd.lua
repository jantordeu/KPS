--[[[
@module Slash Commands
@description
Slash Commands
]]--

SLASH_KPS1 = '/kps'
function SlashCmdList.KPS(cmd, editbox)
    local msg, args = cmd:match("^(%S*)%s*(.-)$");
    if msg == "toggle" or msg == "t" then
        kps.enabled = not kps.enabled
        kps.gui.updateToggleStates()
        collectgarbage()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg == "show" then
        kps.gui.show()
    elseif msg == "reset" then
        kps.resetPosition()
    elseif msg == "hide" then
        kps.gui.hide()
    elseif msg== "disable" or msg == "d" then
        kps.enabled = false
        kps.gui.updateToggleStates()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg== "enable" or msg == "e" then
        kps.enabled = true
        kps.gui.updateToggleStates()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg == "multitarget" or msg == "multi" or msg == "aoe" then
        kps.multiTarget = not kps.multiTarget
        kps.gui.updateToggleStates()
    elseif msg == "cooldowns" or msg == "cds" then
        kps.cooldowns = not kps.cooldowns
        kps.gui.updateToggleStates()
    elseif msg == "interrupt" or msg == "int" then
        kps.interrupt = not kps.interrupt
        kps.gui.updateToggleStates()
    elseif msg == "kick" then
        kps.kick()
    elseif msg == "defensive" or msg == "def" then
        kps.defensive = not kps.defensive
        kps.gui.updateToggleStates()
    elseif msg == "debug" then kps.debug = not kps.debug
        kps.write("Debug set to", tostring(kps.debug))
    elseif msg == "help" then
        kps.write("Slash Commands:")
        kps.write("/kps - Show enabled status.")
        kps.write("/kps reset - Reset Window Position.")
        kps.write("/kps enable/disable/toggle - Enable/Disable the addon.")
        kps.write("/kps cooldowns/cds - Toggle use of cooldowns.")
        kps.write("/kps pew - Spammable macro to do your best moves, if for some reason you don't want it fully automated.")
        kps.write("/kps interrupt/int - Toggle interrupting.")
        kps.write("/kps instances/instance/inst - List M+ instances.")
        kps.write("/kps kick - Interrupt current target, focus or mouseover if possible.")
        kps.write("/kps multitarget/multi/aoe - Toggle manual MultiTarget mode.")
        kps.write("/kps defensive/def - Toggle use of defensive cooldowns.")
        kps.write("/kps help - Show this help text.")
    elseif msg == "pew" then
        kps.combatStep()
    elseif msg == "instances" or msg == "inst" or msg == "instance" then
        local runHistory = C_MythicPlus.GetRunHistory(false, true);
        if #runHistory > 0 then
            local comparison = function(entry1, entry2)
                if ( entry1.level == entry2.level ) then
                    return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
                else
                    return entry1.level > entry2.level;
                end
            end
            table.sort(runHistory, comparison);
            for i = 1, #runHistory do
                local runInfo = runHistory[i];
                local name = C_ChallengeMode.GetMapUIInfo(runInfo.mapChallengeModeID);
                kps.write(string.format(WEEKLY_REWARDS_MYTHIC_RUN_INFO, runInfo.level, name))
            end
        else
            kps.write("No instances finished this week!")
        end
    else
        if kps.enabled then
            kps.write("KPS Enabled")
        else
            kps.write("KPS Disabled")
        end
    end
end

