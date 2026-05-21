-- Modules/Keybinds.lua: keybind snapshot and import — implemented in Milestone 4
-- API used: GetBindingKey, GetBindingAction, SetBinding, SaveBindings(2), GetNumBindings

local addon = telneUI
addon.Keybinds = addon.Keybinds or {}

-- Reads all keybind mappings into profile.keybinds.
function addon.Keybinds:Snapshot(profile)
    -- M4
    profile.keybinds = {}
end

-- Restores keybinds from profile.keybinds onto the current character.
-- Conflicts are unbound before applying; always saves as character-specific (owner=2).
function addon.Keybinds:Import(profile)
    -- M4
end
