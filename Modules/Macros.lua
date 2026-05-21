-- Modules/Macros.lua: macro snapshot and import
-- Only character-specific macros (slots GEN_MAX+1..GEN_MAX+CHAR_MAX) are managed.
-- General macros (slots 1..GEN_MAX) are account-wide and left untouched.
--
-- WoW Midnight combines general + character macros into a single GEN_MAX (120) cap.
-- Character macro creation fails whenever numGlobal >= GEN_MAX.

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
    local charStored = profile.macros.character or {}
    if #charStored == 0 then return end

    local numGlobal, numChar = GetNumMacros()

    -- Combined cap: cannot create any macro (even character) when general pool is full.
    -- Abort BEFORE deleting anything so the user keeps their existing macros.
    if numGlobal >= GEN_MAX then
        addon:ShowNotification(
            "Macro import skipped: general macros full (" .. numGlobal .. "/" .. GEN_MAX ..
            "). Free up a general macro slot first.", "warning")
        return
    end

    -- Delete current character macros now that we know creation will succeed.
    for i = GEN_MAX + numChar, GEN_MAX + 1, -1 do
        local name = GetMacroInfo(i)
        if name and name ~= "" then DeleteMacro(i) end
    end

    -- Recreate; use pcall so a surprise failure never leaves a silent partial state.
    local created = 0
    for _, m in ipairs(charStored) do
        if created >= CHAR_MAX then break end
        local ok = pcall(CreateMacro, m.name, m.icon, m.body, 1)
        if not ok then
            addon:ShowNotification(
                "Macro import stopped at " .. created .. "/" .. #charStored ..
                " (slot limit reached).", "warning")
            break
        end
        created = created + 1
    end

    local skipped = #charStored - created
    if skipped > 0 and created == CHAR_MAX then
        addon:ShowNotification(skipped .. " macro(s) skipped (character macro limit).", "warning")
    end
end
