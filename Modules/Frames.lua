-- Modules/Frames.lua: frame position snapshot and import — implemented in Milestone 5
-- Positions stored as xPct/yPct (% of screen) for resolution independence.
-- API used: frame:GetPoint, frame:SetPoint, GetScreenWidth, GetScreenHeight, _G[name]

local addon = telneUI
addon.Frames = addon.Frames or {}

-- Frames tracked by name (native WoW + common addon frames)
addon.Frames.TRACKED = {
    -- Native
    "MinimapCluster", "PlayerFrame", "TargetFrame", "PartyFrame",
    "MainMenuBar", "MultiBarLeft", "MultiBarRight", "ChatFrame1",
    "ObjectiveTrackerFrame", "MicroButtonAndBagsBar",
    -- Common addons (present only if the addon is loaded)
    "ElvUIParent", "BT4BarMain", "WeakAurasAnchor",
}

-- Reads positions of all tracked frames into profile.frames.
function addon.Frames:Snapshot(profile)
    -- M5
    profile.frames = {}
end

-- Repositions frames using stored percentage offsets.
-- Skips frames that no longer exist; logs a warning for each.
function addon.Frames:Import(profile)
    -- M5
end
