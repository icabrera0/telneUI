-- UI/AddonsTab.lua: Addons tab layout (M1: skeleton only; wired in M6)

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

function addon:BuildAddonsTab(parent)
    local PAD = 10
    local COL_W = math.floor((parent:GetWidth() - PAD * 3) / 2)

    -- ── Column headers ─────────────────────────────────────────────────────

    local hdrLeft = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    hdrLeft:SetPoint("TOPLEFT", parent, "TOPLEFT", PAD, -PAD)
    hdrLeft:SetSize(COL_W, 30)
    hdrLeft:SetBackdrop(Backdrop(1))
    hdrLeft:SetBackdropColor(0.082, 0.082, 0.082, 1)
    hdrLeft:SetBackdropBorderColor(unpack(C.border))

    local lblLeft = hdrLeft:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lblLeft:SetAllPoints()
    lblLeft:SetText("Current Character")
    lblLeft:SetTextColor(unpack(C.accent))
    lblLeft:SetJustifyH("CENTER")

    local hdrRight = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    hdrRight:SetPoint("TOPLEFT", hdrLeft, "TOPRIGHT", PAD, 0)
    hdrRight:SetSize(COL_W, 30)
    hdrRight:SetBackdrop(Backdrop(1))
    hdrRight:SetBackdropColor(0.082, 0.082, 0.082, 1)
    hdrRight:SetBackdropBorderColor(unpack(C.border))

    local lblRight = hdrRight:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lblRight:SetAllPoints()
    lblRight:SetText("Selected Profile")
    lblRight:SetTextColor(unpack(C.accent))
    lblRight:SetJustifyH("CENTER")

    -- ── Two-column scroll area ─────────────────────────────────────────────

    local colLeft = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    colLeft:SetPoint("TOPLEFT",    hdrLeft,  "BOTTOMLEFT",  0,  -4)
    colLeft:SetPoint("BOTTOMLEFT",  parent,  "BOTTOMLEFT", PAD,  PAD + 44)
    colLeft:SetWidth(COL_W)
    colLeft:SetBackdrop(Backdrop(1))
    colLeft:SetBackdropColor(0.082, 0.082, 0.082, 1)
    colLeft:SetBackdropBorderColor(unpack(C.border))

    local phLeft = colLeft:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    phLeft:SetPoint("CENTER", colLeft, "CENTER", 0, 0)
    phLeft:SetText("Addon list available\nin Milestone 6")
    phLeft:SetTextColor(unpack(C.textSub))
    phLeft:SetJustifyH("CENTER")

    local colRight = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    colRight:SetPoint("TOPLEFT",     hdrRight, "BOTTOMLEFT",  0, -4)
    colRight:SetPoint("BOTTOMRIGHT", parent,   "BOTTOMRIGHT", -PAD, PAD + 44)
    colRight:SetBackdrop(Backdrop(1))
    colRight:SetBackdropColor(0.082, 0.082, 0.082, 1)
    colRight:SetBackdropBorderColor(unpack(C.border))

    local phRight = colRight:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    phRight:SetPoint("CENTER", colRight, "CENTER", 0, 0)
    phRight:SetText("Select a profile on\nthe Profiles tab first")
    phRight:SetTextColor(unpack(C.textSub))
    phRight:SetJustifyH("CENTER")

    -- ── Legend strip ───────────────────────────────────────────────────────

    local legend = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    legend:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PAD + 4, PAD + 26)
    legend:SetText(
        "|cff33cc33■|r will enable   " ..
        "|cffcc3333■|r will disable  " ..
        "|cff888888■|r no change"
    )
    legend:SetTextColor(1, 1, 1, 1)

    -- ── Apply button ───────────────────────────────────────────────────────

    local applyBtn = addon:CreateButton(parent, "Apply Addon States", 180, 28)
    applyBtn:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -PAD, PAD)
    applyBtn:SetEnabled(false)  -- enabled in M6
    applyBtn.label:SetTextColor(unpack(C.textSub))
    parent.applyBtn = applyBtn
end
