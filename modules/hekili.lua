--[[[
@module Hekili
Uses the Hekili AddOn to determine the compat rotation. You must specify a blacklist of Spell ID's
which will be ignored by the rotation.
]]--

local hekiliSpells = {}

local hekiliCalc = function (display, entry, blacklist)
    local spell_id, err = Hekili_GetRecommendedAbility(display, entry)

    if spell_id ~= nil then
        if  spell_id > 0 then
            -- Some kind of spell
            if hekiliSpells[spell_id] == nil then
                hekiliSpells[spell_id] = kps.Spell.fromId(spell_id)
            end
            local spell = hekiliSpells[spell_id]
            for _, blacklisted_spell in pairs(blacklist) do
                if blacklisted_spell.name == spell.name then
                    return nil
                end
            end
            return spell
        else
            -- Item or Potion or whatever
            local id, name, key, itemId = Hekili:GetAbilityInfo(spell_id)
            if itemId ~= nil then
                -- Check all slots for item id
                local slot = 1
                while slot < 15 do
                    local slotItemId,_ = GetInventoryItemID("player", slot)
                    if slotItemId == itemId then
                        return "/use "..slot
                    end
                    slot = slot + 1
                end
            end
        end
    end

    return nil
end

kps.hekili = function(blacklist, display)
    if blacklist == nil then
        blacklist = {}
    end
    if display == nil then
        display = "Primary"
    end
    return function ()
        local i = 1
        while i <= 3 do
            local spell, condition, target = hekiliCalc(display, i, blacklist)
            if spell ~= nil then
                return spell
            end
           i = i + 1
        end
        return nil
    end
end
