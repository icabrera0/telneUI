-- Core.lua: addon init, SavedVariables, slash commands, utilities

local ADDON_NAME = "telneUI"
local ADDON_VERSION = "1.0.0"

telneUI = telneUI or {}
local addon = telneUI

local DEFAULTS = {
    version = 1,
    profiles = {},
    activeProfile = nil,
    settings = {
        autoBackup            = true,
        showMinimapButton     = true,
        confirmBeforeImport   = true,
        includeAddonSettings  = true,
        includeEditMode       = true,
        trackedAddonVars = {
            "ElvDB",
            "WeakAurasSaved",
            "Bartender4DB",
            "DBM_AllSavedOptions",
            "Details_DB",
        },
    },
    ui = {
        point = "CENTER",
        x     = 0,
        y     = 0,
    },
}

-- ── Event handling ──────────────────────────────────────────────────────────

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == ADDON_NAME then
            addon:Initialize()
        end
    elseif event == "PLAYER_LOGIN" then
        addon:OnPlayerLogin()
    end
end)

-- ── Initialization ──────────────────────────────────────────────────────────

function addon:Initialize()
    if not telneUISavedVars then
        telneUISavedVars = {}
    end

    -- Top-level defaults
    for k, v in pairs(DEFAULTS) do
        if telneUISavedVars[k] == nil then
            telneUISavedVars[k] = v
        end
    end

    -- settings sub-keys
    telneUISavedVars.settings = telneUISavedVars.settings or {}
    for k, v in pairs(DEFAULTS.settings) do
        if telneUISavedVars.settings[k] == nil then
            telneUISavedVars.settings[k] = v
        end
    end

    -- ui sub-keys
    telneUISavedVars.ui = telneUISavedVars.ui or {}
    for k, v in pairs(DEFAULTS.ui) do
        if telneUISavedVars.ui[k] == nil then
            telneUISavedVars.ui[k] = v
        end
    end

    self.db = telneUISavedVars

    print("|cff4FC3F7telneUI|r v" .. ADDON_VERSION .. " loaded — |cff4FC3F7/telneui|r to open")
end

function addon:OnPlayerLogin()
    -- minimap button wired in Milestone 8
end

-- ── Slash commands ──────────────────────────────────────────────────────────

SLASH_TELNEUI1 = "/telneui"
SLASH_TELNEUI2 = "/tui"

SlashCmdList["TELNEUI"] = function(msg)
    addon:ToggleMainFrame()
end

function addon:ToggleMainFrame()
    if addon.MainFrame then
        if addon.MainFrame:IsShown() then
            addon.MainFrame:Hide()
        else
            addon.MainFrame:Show()
        end
    else
        addon:BuildMainFrame()
        addon.MainFrame:Show()
    end
end

-- ── Utilities ───────────────────────────────────────────────────────────────

-- Deep-copies a table by value so we never hold references to foreign addon tables.
function addon:DeepCopy(orig)
    local t = type(orig)
    if t ~= "table" then return orig end
    local copy = {}
    for k, v in pairs(orig) do
        copy[addon:DeepCopy(k)] = addon:DeepCopy(v)
    end
    return copy
end

-- Returns "CharName-RealmName" for the logged-in character.
function addon:GetCharacterKey()
    return UnitName("player") .. "-" .. GetRealmName()
end

-- Returns a human-readable timestamp string.
function addon:GetTimestamp()
    return date("%Y-%m-%d %H:%M")
end
