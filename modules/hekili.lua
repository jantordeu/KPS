--[[[
@module Hekili
Uses the Hekili AddOn to determine the compat rotation. You must specificy a blacklist of Spell ID's
which will be ignored by the rotation.
]]--

local hekiliSpells = {}

local hekiliCalc = function (id, blacklist)
    local spell_id, err = Hekili_GetRecommendedAbility("Primary", id)

    if spell_id ~= nil and spell_id > 0 then
        for _, blacklisted_id in pairs(blacklist) do
            if blacklisted_id == spell_id then
                return nil
            end
        end
        if hekiliSpells[spell_id] == nil then
            hekiliSpells[spell_id] = kps.Spell.fromId(spell_id)
        end
        return hekiliSpells[spell_id]
    end

    return nil
end

kps.hekili = function(blacklist)
    return function ()
        local i = 1
        while i <= 3 do
            local spell = hekiliCalc(i, blacklist)
            if spell ~= nil then
                return spell
            end
           i = i + 1
        end
        return nil
    end
end
