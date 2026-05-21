-- Modules/Chat.lua: chat window layout snapshot and import — implemented in Milestone 6
-- Captures: window count, names, positions, sizes, message filters, font settings

local addon = telneUI
addon.Chat = addon.Chat or {}

-- Reads all chat window layout data into profile.chat.
function addon.Chat:Snapshot(profile)
    -- M6
    profile.chat = { windows = {} }
end

-- Restores chat windows from profile.chat onto the current character.
function addon.Chat:Import(profile)
    -- M6
end
