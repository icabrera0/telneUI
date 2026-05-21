-- ProfileManager.lua: profile CRUD — Milestone 2

local addon = telneUI

-- Creates a new empty profile skeleton under the given name.
-- Snapshot.lua fills it with real data later.
function addon:CreateProfile(name)
    if not addon.db then return end
    addon.db.profiles = addon.db.profiles or {}
    addon.db.profiles[name] = {
        createdBy     = addon:GetCharacterKey(),
        createdAt     = addon:GetTimestamp(),
        addons        = {},
        macros        = { general = {}, character = {} },
        keybinds      = {},
        chat          = { windows = {} },
        frames        = {},
        editMode      = {},
        addonSettings = {},
    }
end

-- Permanently removes the named profile.
-- Also clears activeProfile if it pointed to the deleted profile.
function addon:DeleteProfile(name)
    if not addon.db or not addon.db.profiles then return end
    addon.db.profiles[name] = nil
    if addon.db.activeProfile == name then
        addon.db.activeProfile = nil
    end
end

-- Returns an ordered list of profile names, newest-first (by createdAt string).
-- createdAt uses "YYYY-MM-DD HH:MM" format so lexicographic sort = chronological.
function addon:ListProfiles()
    if not addon.db or not addon.db.profiles then return {} end
    local list = {}
    for name, p in pairs(addon.db.profiles) do
        list[#list + 1] = { name = name, time = p.createdAt or "" }
    end
    table.sort(list, function(a, b) return a.time > b.time end)
    local names = {}
    for _, v in ipairs(list) do
        names[#names + 1] = v.name
    end
    return names
end

-- Sets the active profile (persisted in SavedVariables).
function addon:SetActiveProfile(name)
    if addon.db then
        addon.db.activeProfile = name
    end
end

-- Returns the name of the currently active profile, or nil.
function addon:GetActiveProfile()
    return addon.db and addon.db.activeProfile
end

-- Returns the full profile table for the given name, or nil.
function addon:GetProfile(name)
    return addon.db and addon.db.profiles and addon.db.profiles[name]
end
