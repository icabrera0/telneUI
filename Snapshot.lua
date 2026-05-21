-- Snapshot.lua: reads full character state into a named profile
-- Module call order (Milestone 8 final): Addons → Macros → Keybinds → Chat → Frames → EditMode → AddonVars

local addon = telneUI

-- Snapshots the current character state into profile[name].
-- callback(progress 0–1) is called as each module completes.
function addon:SnapshotAll(name, callback)
    -- M3+: each module will be wired here
    -- For now, just ensure the profile entry exists
    if not addon.db or not addon.db.profiles then return end

    addon.db.profiles[name] = addon.db.profiles[name] or {}
    local p = addon.db.profiles[name]
    p.snapshotAt = addon:GetTimestamp()
    p.snapshotBy = addon:GetCharacterKey()

    if callback then callback(1.0) end
end
