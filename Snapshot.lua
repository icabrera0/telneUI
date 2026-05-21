-- Snapshot.lua: reads current character state into the named profile.
-- Each milestone adds a step. callback(0..1) reports progress to the UI.

local addon = telneUI

-- Steps execute in order. Add new modules here as milestones are completed.
local STEPS = {
    { fn = function(p) addon.Macros:Snapshot(p)   end },  -- M3
    -- M4: { fn = function(p) addon.Keybinds:Snapshot(p) end },
    -- M5: { fn = function(p) addon.Frames:Snapshot(p)   end },
    -- M6: { fn = function(p) addon.Chat:Snapshot(p)     end },
    -- M6: { fn = function(p) addon.EditMode:Snapshot(p) end },
    -- M7: { fn = function(p) addon.AddonSettings:SnapshotStates(p)  end },
    -- M7: { fn = function(p) addon.AddonSettings:DeepCopyAddonVars(p) end },
}

function addon:SnapshotAll(name, callback)
    if not addon.db or not addon.db.profiles then return end
    local p = addon.db.profiles[name]
    if not p then return end

    local total = #STEPS
    for i, step in ipairs(STEPS) do
        step.fn(p)
        if callback then callback(i / total) end
    end

    p.snapshotAt = addon:GetTimestamp()
    p.snapshotBy = addon:GetCharacterKey()
end
