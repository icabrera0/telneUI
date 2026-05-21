-- UI/SettingsTab.lua: Settings tab layout (M1: skeleton only; wired in M7/M8)

local addon = telneUI

local C = addon.C

local function Backdrop(edge)
    return {
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = edge or 1,
        insets = {left=1, right=1, top=1, bottom=1},
    }
end

-- Helper: section header with divider
local function SectionHeader(parent, text, yOffset)
    local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lbl:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    lbl:SetText(text)
    lbl:SetTextColor(C.accent[1], C.accent[2], C.accent[3], 1)

    local div = parent:CreateTexture(nil, "OVERLAY")
    div:SetHeight(1)
    div:SetPoint("TOPLEFT",  lbl,    "BOTTOMLEFT",  0, -4)
    div:SetPoint("TOPRIGHT", parent, "TOPRIGHT",  -14, yOffset - 20)
    div:SetColorTexture(unpack(C.border))

    return lbl, div
end

-- Helper: placeholder toggle row
local function PlaceholderRow(parent, text, yOffset)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(300, 22)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)

    local check = row:CreateTexture(nil, "OVERLAY")
    check:SetSize(14, 14)
    check:SetPoint("LEFT", row, "LEFT", 0, 0)
    check:SetColorTexture(0.15, 0.15, 0.15, 1)

    local checkBorder = row:CreateTexture(nil, "BORDER")
    checkBorder:SetSize(14, 14)
    checkBorder:SetPoint("LEFT", row, "LEFT", 0, 0)
    checkBorder:SetColorTexture(unpack(C.border))

    local lbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("LEFT", check, "RIGHT", 8, 0)
    lbl:SetText(text)
    lbl:SetTextColor(unpack(C.textSub))

    return row
end

function addon:BuildSettingsTab(parent)
    local PAD = 10

    -- Outer card
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetPoint("TOPLEFT",     parent, "TOPLEFT",     PAD, -PAD)
    card:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PAD,  PAD + 40)
    card:SetBackdrop(Backdrop(1))
    card:SetBackdropColor(0.082, 0.082, 0.082, 1)
    card:SetBackdropBorderColor(unpack(C.border))

    local y = -14

    -- ── General section ────────────────────────────────────────────────────
    SectionHeader(card, "General", y)
    y = y - 24

    PlaceholderRow(card, "Auto-backup before import",          y)  y = y - 24
    PlaceholderRow(card, "Show minimap button",                y)  y = y - 24
    PlaceholderRow(card, "Confirm before import",              y)  y = y - 24

    y = y - 10

    -- ── Snapshot section ───────────────────────────────────────────────────
    SectionHeader(card, "Snapshot Options", y)
    y = y - 24

    PlaceholderRow(card, "Include addon SavedVariables",       y)  y = y - 24
    PlaceholderRow(card, "Include EditMode layout",            y)  y = y - 24

    y = y - 10

    -- ── Tracked addon vars section ─────────────────────────────────────────
    SectionHeader(card, "Tracked Addon SavedVariables", y)
    y = y - 24

    local trackedNote = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    trackedNote:SetPoint("TOPLEFT", card, "TOPLEFT", 14, y)
    trackedNote:SetText("Editable list available in Milestone 7")
    trackedNote:SetTextColor(unpack(C.textSub))
    y = y - 20

    -- Default var list (display only for M1)
    local defaults = {"ElvDB", "WeakAurasSaved", "Bartender4DB", "DBM_AllSavedOptions", "Details_DB"}
    for _, varName in ipairs(defaults) do
        local tag = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tag:SetPoint("TOPLEFT", card, "TOPLEFT", 22, y)
        tag:SetText("· " .. varName)
        tag:SetTextColor(0.5, 0.7, 0.9, 1)
        y = y - 18
    end

    -- ── Bottom buttons ─────────────────────────────────────────────────────

    local resetBtn = addon:CreateButton(parent, "Reset to Defaults", 160, 28)
    resetBtn:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PAD, PAD)
    resetBtn:SetEnabled(false)  -- wired in M7
    resetBtn.label:SetTextColor(unpack(C.textSub))
    parent.resetBtn = resetBtn
end
