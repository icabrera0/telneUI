-- Modules/EditMode.lua: EditMode layout snapshot and import — implemented in Milestone 6
-- Captures the active EditModeManagerFrame layout by name and serializes its state.

local addon = telneUI
addon.EditMode = addon.EditMode or {}

-- Reads the current EditMode layout into profile.editMode.
function addon.EditMode:Snapshot(profile)
    -- M6
    profile.editMode = {}
end

-- Restores EditMode layout from profile.editMode onto the current character.
function addon.EditMode:Import(profile)
    -- M6
end
