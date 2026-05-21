-- UI/MainFrame.lua: 700×500 dark panel, tab system, draggable, position-remembered

local addon = telneUI

local FRAME_W      = 700
local FRAME_H      = 500
local TITLE_H      = 32
local TAB_H        = 36
local FOOTER_H     = 26
local CONTENT_H    = FRAME_H - TITLE_H - TAB_H - FOOTER_H

local C = addon.C   -- color palette from Widgets.lua

local function Backdrop(edge)
    return {
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = edge or 1,
        insets = {left=1, right=1, top=1, bottom=1},
    }
end

-- ── Build ────────────────────────────────────────────────────────────────────

function addon:BuildMainFrame()
    local f = CreateFrame("Frame", "telneUIMainFrame", UIParent, "BackdropTemplate")
    f:SetSize(FRAME_W, FRAME_H)
    f:SetFrameStrata("DIALOG")
    f:SetFrameLevel(100)
    f:SetMovable(true)
    f:SetClampedToScreen(true)

    -- Restore saved position or center
    local ui = addon.db and addon.db.ui
    if ui and ui.point then
        f:SetPoint(ui.point, UIParent, ui.point, ui.x or 0, ui.y or 0)
    else
        f:SetPoint("CENTER")
    end

    f:SetBackdrop(Backdrop(1))
    f:SetBackdropColor(unpack(C.bg))
    f:SetBackdropBorderColor(unpack(C.border))

    -- ── Title bar ──────────────────────────────────────────────────────────

    local titleBar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    titleBar:SetPoint("TOPLEFT",  f, "TOPLEFT",  0,  0)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0,  0)
    titleBar:SetHeight(TITLE_H)
    titleBar:SetBackdrop(Backdrop(1))
    titleBar:SetBackdropColor(unpack(C.bgDark))
    titleBar:SetBackdropBorderColor(unpack(C.border))

    local titleTex = titleBar:CreateTexture(nil, "ARTWORK")
    titleTex:SetAllPoints()
    titleTex:SetColorTexture(0, 0, 0, 0)   -- transparent fill; colour comes from backdrop

    -- Accent line along the top edge
    local accentLine = titleBar:CreateTexture(nil, "OVERLAY")
    accentLine:SetHeight(2)
    accentLine:SetPoint("TOPLEFT",  titleBar, "TOPLEFT",  0, 0)
    accentLine:SetPoint("TOPRIGHT", titleBar, "TOPRIGHT", 0, 0)
    accentLine:SetColorTexture(C.accent[1], C.accent[2], C.accent[3], 0.9)

    local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("LEFT", titleBar, "LEFT", 12, 0)
    titleText:SetFont("Fonts/FRIZQT__.TTF", 13, "")
    titleText:SetText("|cff4FC3F7telneUI|r  ·  Profile Manager")

    local verText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    verText:SetPoint("RIGHT", titleBar, "RIGHT", -38, 0)
    verText:SetText("v1.0.0")
    verText:SetTextColor(unpack(C.textSub))

    -- Close button
    local closeBtn = CreateFrame("Button", nil, titleBar, "BackdropTemplate")
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -10, 0)
    closeBtn:SetBackdrop(Backdrop(1))
    closeBtn:SetBackdropColor(0.35, 0.08, 0.08, 0.9)
    closeBtn:SetBackdropBorderColor(0.6, 0.15, 0.15, 1)
    local closeX = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    closeX:SetAllPoints()
    closeX:SetText("✕")
    closeX:SetTextColor(1, 1, 1, 0.9)
    closeBtn:SetScript("OnClick",  function() f:Hide() end)
    closeBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.7, 0.1, 0.1, 1)
        self:SetBackdropBorderColor(1, 0.2, 0.2, 1)
    end)
    closeBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.35, 0.08, 0.08, 0.9)
        self:SetBackdropBorderColor(0.6, 0.15, 0.15, 1)
    end)

    -- Drag via title bar
    titleBar:EnableMouse(true)
    titleBar:SetScript("OnMouseDown", function(_, btn)
        if btn == "LeftButton" then f:StartMoving() end
    end)
    titleBar:SetScript("OnMouseUp", function()
        f:StopMovingOrSizing()
        -- Persist position so it survives /reload
        local point, _, _, x, y = f:GetPoint()
        if addon.db and addon.db.ui then
            addon.db.ui.point = point
            addon.db.ui.x     = x
            addon.db.ui.y     = y
        end
    end)

    -- ── Tab bar ────────────────────────────────────────────────────────────

    local tabBar = CreateFrame("Frame", nil, f, "BackdropTemplate")
    tabBar:SetPoint("TOPLEFT",  titleBar, "BOTTOMLEFT",  0, 0)
    tabBar:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
    tabBar:SetHeight(TAB_H)
    tabBar:SetBackdrop(Backdrop(1))
    tabBar:SetBackdropColor(unpack(C.tabBg))
    tabBar:SetBackdropBorderColor(unpack(C.border))

    -- ── Content area ───────────────────────────────────────────────────────

    local content = CreateFrame("Frame", nil, f)
    content:SetPoint("TOPLEFT",     tabBar, "BOTTOMLEFT",  0,  0)
    content:SetPoint("BOTTOMRIGHT", f,      "BOTTOMRIGHT", 0,  FOOTER_H)
    f.content = content

    -- ── Footer ─────────────────────────────────────────────────────────────

    local footer = CreateFrame("Frame", nil, f, "BackdropTemplate")
    footer:SetPoint("BOTTOMLEFT",  f, "BOTTOMLEFT",  0, 0)
    footer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    footer:SetHeight(FOOTER_H)
    footer:SetBackdrop(Backdrop(1))
    footer:SetBackdropColor(unpack(C.bgDark))
    footer:SetBackdropBorderColor(unpack(C.border))

    local fpProfile = footer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fpProfile:SetPoint("LEFT", footer, "LEFT", 12, 0)
    fpProfile:SetTextColor(unpack(C.textSub))
    f.footerProfile = fpProfile

    local fpChar = footer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fpChar:SetPoint("CENTER", footer, "CENTER", 0, 0)
    fpChar:SetTextColor(unpack(C.textSub))
    fpChar:SetText(addon:GetCharacterKey())

    local fpVer = footer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fpVer:SetPoint("RIGHT", footer, "RIGHT", -12, 0)
    fpVer:SetTextColor(unpack(C.textSub))
    fpVer:SetText("v1.0.0")

    -- ── Tabs ───────────────────────────────────────────────────────────────

    local TAB_DEFS = {"Profiles", "Addons", "Settings"}
    local tabW     = math.floor(FRAME_W / #TAB_DEFS)

    f.tabs      = {}
    f.tabFrames = {}

    for i, name in ipairs(TAB_DEFS) do
        -- Tab button
        local tab = CreateFrame("Button", nil, tabBar, "BackdropTemplate")
        tab:SetSize(tabW, TAB_H)
        tab:SetPoint("TOPLEFT", tabBar, "TOPLEFT", (i - 1) * tabW, 0)
        tab:SetBackdrop(Backdrop(1))
        tab:SetBackdropColor(unpack(C.tabBg))
        tab:SetBackdropBorderColor(unpack(C.border))

        local lbl = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetAllPoints()
        lbl:SetText(name)
        lbl:SetTextColor(unpack(C.textSub))
        tab.label = lbl

        -- Accent underline for selected tab
        local sel = tab:CreateTexture(nil, "OVERLAY")
        sel:SetHeight(2)
        sel:SetPoint("BOTTOMLEFT",  tab, "BOTTOMLEFT",  4, 0)
        sel:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -4, 0)
        sel:SetColorTexture(C.accent[1], C.accent[2], C.accent[3], 1)
        sel:Hide()
        tab.selLine = sel

        local idx = i
        tab:SetScript("OnClick", function() addon:SelectTab(idx) end)
        tab:SetScript("OnEnter", function(self)
            if f.activeTab ~= idx then
                self:SetBackdropColor(0.12, 0.12, 0.12, 1)
            end
        end)
        tab:SetScript("OnLeave", function(self)
            if f.activeTab ~= idx then
                self:SetBackdropColor(unpack(C.tabBg))
            end
        end)

        f.tabs[i] = tab

        -- Content frame for each tab
        local tf = CreateFrame("Frame", nil, content)
        tf:SetAllPoints(content)
        tf:Hide()
        f.tabFrames[i] = tf
    end

    -- ── Populate tab content ───────────────────────────────────────────────

    addon:BuildProfilesTab(f.tabFrames[1])
    addon:BuildAddonsTab(f.tabFrames[2])
    addon:BuildSettingsTab(f.tabFrames[3])

    -- Open on Profiles tab
    f.activeTab = 0
    addon:SelectTab(1)

    addon.MainFrame = f
    addon:UpdateFooter()
end

-- ── Tab switching ────────────────────────────────────────────────────────────

function addon:SelectTab(index)
    local f = addon.MainFrame
    if not f then return end

    for i, tab in ipairs(f.tabs) do
        local active = (i == index)
        tab:SetBackdropColor(active and 0.133 or C.tabBg[1],
                             active and 0.133 or C.tabBg[2],
                             active and 0.133 or C.tabBg[3], 1)
        tab.label:SetTextColor(active and 1 or C.textSub[1],
                               active and 1 or C.textSub[2],
                               active and 1 or C.textSub[3], 1)
        tab.selLine:SetShown(active)
        f.tabFrames[i]:SetShown(active)
    end
    f.activeTab = index
end

-- ── Footer update ────────────────────────────────────────────────────────────

function addon:UpdateFooter()
    local f = addon.MainFrame
    if not f then return end
    local active = addon.db and addon.db.activeProfile
    f.footerProfile:SetText(active and ("Profile: |cffffffff" .. active .. "|r") or "|cff888888No active profile|r")
end
