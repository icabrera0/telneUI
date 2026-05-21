-- Modules/Macros.lua: macro snapshot and import
-- API: GetMacroInfo(index), CreateMacro(name,icon,body,perChar), DeleteMacro(index)
-- Global macro slots: 1..MAX_ACCOUNT_MACROS (120)
-- Character macro slots: MAX_ACCOUNT_MACROS+1 .. MAX_ACCOUNT_MACROS+MAX_CHARACTER_MACROS (121..138)

local addon = telneUI
addon.Macros = addon.Macros or {}

local GEN_MAX  = MAX_ACCOUNT_MACROS   or 120
local CHAR_MAX = MAX_CHARACTER_MACROS or 18

-- Reads all non-empty macro slots into profile.macros.
function addon.Macros:Snapshot(profile)
    profile.macros = { general = {}, character = {} }

    for i = 1, GEN_MAX do
        local name, icon, body = GetMacroInfo(i)
        if name and name ~= "" then
            profile.macros.general[#profile.macros.general + 1] = { name=name, icon=icon, body=body }
        end
    end

    for i = GEN_MAX + 1, GEN_MAX + CHAR_MAX do
        local name, icon, body = GetMacroInfo(i)
        if name and name ~= "" then
            profile.macros.character[#profile.macros.character + 1] = { name=name, icon=icon, body=body }
        end
    end
end

-- Replaces all current macros with those stored in profile.macros.
-- Warns if the profile exceeds slot limits (120 global / 18 character).
function addon.Macros:Import(profile)
    if not profile.macros then return end

    -- Delete existing (reverse iteration so index shifts don't matter)
    for i = GEN_MAX, 1, -1 do
        local name = GetMacroInfo(i)
        if name and name ~= "" then DeleteMacro(i) end
    end
    for i = GEN_MAX + CHAR_MAX, GEN_MAX + 1, -1 do
        local name = GetMacroInfo(i)
        if name and name ~= "" then DeleteMacro(i) end
    end

    -- Recreate general macros
    local genStored = profile.macros.general or {}
    for idx, m in ipairs(genStored) do
        if idx > GEN_MAX then
            addon:ShowNotification("Macro limit: " .. (#genStored - GEN_MAX) .. " general macro(s) skipped.", "warning")
            break
        end
        CreateMacro(m.name, m.icon, m.body, nil)
    end

    -- Recreate character macros
    local charStored = profile.macros.character or {}
    for idx, m in ipairs(charStored) do
        if idx > CHAR_MAX then
            addon:ShowNotification("Macro limit: " .. (#charStored - CHAR_MAX) .. " character macro(s) skipped.", "warning")
            break
        end
        CreateMacro(m.name, m.icon, m.body, 1)
    end
end
