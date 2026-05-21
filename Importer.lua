-- Importer.lua: applies a stored profile to the current character
-- Always auto-backs up current state before importing (Milestone 8).

local addon = telneUI

-- Imports profile[name] onto the current character.
-- callback(progress 0–1) is called as each module completes.
function addon:ImportAll(name, callback)
    -- M3+: each module will be wired here
    if not addon.db or not addon.db.profiles then return end
    local p = addon.db.profiles[name]
    if not p then
        addon:ShowNotification("Profile not found: " .. tostring(name), "error")
        return
    end

    if callback then callback(1.0) end
end
