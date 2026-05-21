-- Importer.lua: applies a stored profile to the current character.
-- Each milestone adds a step. callback(0..1) reports progress to the UI.

local addon = telneUI

-- Steps execute in order. Mirror the order in Snapshot.lua.
local STEPS = {
    { fn = function(p) addon.Macros:Import(p)   end },  -- M3
    -- M4: { fn = function(p) addon.Keybinds:Import(p) end },
    -- M5: { fn = function(p) addon.Frames:Import(p)   end },
    -- M6: { fn = function(p) addon.Chat:Import(p)     end },
    -- M6: { fn = function(p) addon.EditMode:Import(p) end },
    -- M7: { fn = function(p) addon.AddonSettings:ImportStates(p)     end },
    -- M7: { fn = function(p) addon.AddonSettings:RestoreAddonVars(p) end },
}

function addon:ImportAll(name, callback)
    if not addon.db or not addon.db.profiles then return end
    local p = addon.db.profiles[name]
    if not p then
        addon:ShowNotification("Profile not found: " .. tostring(name), "error")
        return
    end

    local total = #STEPS
    for i, step in ipairs(STEPS) do
        step.fn(p)
        if callback then callback(i / total) end
    end
end
