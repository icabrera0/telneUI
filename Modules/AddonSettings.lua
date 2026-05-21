-- Modules/AddonSettings.lua: addon state (M6) and SavedVariables deep copy (M7)
-- M6: enable/disable state via GetAddOnInfo, EnableAddOn, DisableAddOn
-- M7: deep copy of tracked addon global tables (ElvDB, WeakAurasSaved, etc.)

local addon = telneUI
addon.AddonSettings = addon.AddonSettings or {}

-- ── Addon state (M6) ─────────────────────────────────────────────────────────

-- Reads enabled/disabled state of all installed addons into profile.addons.
function addon.AddonSettings:SnapshotStates(profile)
    -- M6
    profile.addons = {}
end

-- Applies enable/disable states from profile.addons.
-- A /reload is required afterwards; caller is responsible for prompting.
function addon.AddonSettings:ImportStates(profile)
    -- M6
end

-- ── SavedVariables deep copy (M7) ────────────────────────────────────────────

-- Deep-copies the global tables listed in settings.trackedAddonVars into profile.addonSettings.
function addon.AddonSettings:DeepCopyAddonVars(profile)
    -- M7
    profile.addonSettings = {}
end

-- Overwrites the in-memory global tables from profile.addonSettings.
-- A /reload is required afterwards for the changes to be written to disk.
function addon.AddonSettings:RestoreAddonVars(profile)
    -- M7
end
