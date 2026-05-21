-- Modules/Macros.lua: macro snapshot and import — implemented in Milestone 3
-- API used: GetNumMacros, GetMacroInfo, GetMacroBody, CreateMacro, EditMacro, DeleteMacro

local addon = telneUI
addon.Macros = addon.Macros or {}

-- Reads all general and character macros into profile.macros.
function addon.Macros:Snapshot(profile)
    -- M3
    profile.macros = { general = {}, character = {} }
end

-- Restores macros from profile.macros onto the current character.
function addon.Macros:Import(profile)
    -- M3
end
