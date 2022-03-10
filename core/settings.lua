--[[[
@module Settings
@description
Saves and restores KPS Settings.
]]--

local settings = {
    "enabled","multiTarget","cooldowns","interrupt","defensive","autoTurn"
}
local settingsLoaded = false

kps.load_settings = function()
    local KPS_SETTINGS = KM.settings("KPS")
    for k,v in pairs(settings) do
        kps[v] = KPS_SETTINGS[v]
    end
    settingsLoaded = true
    kps.gui.updateToggleStates()
end
kps.load_settings()


kps.events.registerOnUpdate(function ()
    if settingsLoaded then
        local KPS_SETTINGS = KM.settings("KPS")
        for k,v in pairs(settings) do
            KPS_SETTINGS[v] = kps[v]
        end
    end
end)
