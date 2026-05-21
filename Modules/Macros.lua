-- Modules/Macros.lua: macro snapshot and import
-- Only character-specific macros (slots GEN_MAX+1..GEN_MAX+CHAR_MAX) are managed.
-- General macros (slots 1..GEN_MAX) are account-wide and left untouched.

local addon = telneUI
addon.Macros = addon.Macros or {}

local GEN_MAX  = MAX_ACCOUNT_MACROS   or 120
local CHAR_MAX = MAX_CHARACTER_MACROS or 18

function addon.Macros:Snapshot(profile)
    profile.macros = { character = {} }

    for i = GEN_MAX + 1, GEN_MAX + CHAR_MAX do
        local name, icon, body = GetMacroInfo(i)
        if name and name ~= "" then
            profile.macros.character[#profile.macros.character + 1] = { name=name, icon=icon, body=body }
        end
    end
end

function addon.Macros:Import(profile)
    if not profile.macros then return end

    -- Delete existing character macros (reverse so index shifts don't matter)
    for i = GEN_MAX + CHAR_MAX, GEN_MAX + 1, -1 do
        local name = GetMacroInfo(i)
        if name and name ~= "" then DeleteMacro(i) end
    end

    local charStored = profile.macros.character or {}
    local count = 0
    for _, m in ipairs(charStored) do
        if count >= CHAR_MAX then
            addon:ShowNotification(
                "Macro limit: " .. (#charStored - count) .. " character macro(s) skipped.", "warning")
            break
        end
        CreateMacro(m.name, m.icon, m.body, 1)
        count = count + 1
    end
end
