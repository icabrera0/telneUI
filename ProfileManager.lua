-- ProfileManager.lua: profile CRUD — implemented in Milestone 2

local addon = telneUI

-- Creates a new empty profile under the given name.
-- Populated with full data by Snapshot.lua.
function addon:CreateProfile(name)
    -- M2
end

-- Deletes the named profile. No-op if it doesn't exist.
function addon:DeleteProfile(name)
    -- M2
end

-- Returns an ordered list of profile names (newest first).
function addon:ListProfiles()
    -- M2
    return {}
end

-- Sets the active profile by name (stored in db.activeProfile).
function addon:SetActiveProfile(name)
    -- M2
    if addon.db then
        addon.db.activeProfile = name
    end
end

-- Returns the name of the currently active profile, or nil.
function addon:GetActiveProfile()
    return addon.db and addon.db.activeProfile
end

-- Returns the profile table for the given name, or nil.
function addon:GetProfile(name)
    -- M2
    return addon.db and addon.db.profiles and addon.db.profiles[name]
end
