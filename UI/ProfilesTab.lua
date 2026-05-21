-- UI/ProfilesTab.lua: Profiles tab — full implementation (Milestone 2)

local addon = telneUI

local LEFT_W = 240
local PAD    = 10
local ROW_H  = 44

local C = addon.C

local function Backdrop(edge)
    return {
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = edge or 1,
        insets = {left=1, right=1, top=1, bottom=1},
    }
end

-- Enable or disable a button and update its text colour accordingly.
local function SetBtnState(btn, enabled)
    btn:SetEnabled(enabled)
    if enabled then
        btn.label:SetTextColor(unpack(C.text))
    else
        btn.label:SetTextColor(unpack(C.textSub))
    end
end

-- ── Right-panel helpers ───────────────────────────────────────────────────────

local function ResetRightPanel(tab)
    tab.nameHeader:SetText("Select a profile")
    tab.metaText:SetText("")
    SetBtnState(tab.snapshotBtn,  false)
    SetBtnState(tab.importBtn,    false)
    SetBtnState(tab.exportBtn,    false)
    SetBtnState(tab.importStrBtn, false)
    SetBtnState(tab.deleteBtn,    false)
    tab.statusText:SetText("Ready")
    tab.progressBar:SetProgress(0)
    tab.progressBar:SetText("")
end

local function PopulateRightPanel(tab, name)
    local p = addon:GetProfile(name)
    if not p then ResetRightPanel(tab) return end

    tab.nameHeader:SetText(name)
    local meta = "By: " .. (p.createdBy or "?")
    local stamp = p.snapshotAt or p.createdAt
    if stamp then
        meta = meta .. "   |   " .. stamp
    end
    tab.metaText:SetText(meta)

    SetBtnState(tab.snapshotBtn, true)
    SetBtnState(tab.importBtn,   true)
    SetBtnState(tab.deleteBtn,   true)
    -- Export / ImportString unlocked in Milestone 8
    SetBtnState(tab.exportBtn,    false)
    SetBtnState(tab.importStrBtn, false)
end

-- ── Profile selection ─────────────────────────────────────────────────────────

function addon:SelectProfile(tab, name)
    addon:SetActiveProfile(name)
    addon:RefreshProfileList(tab)
    PopulateRightPanel(tab, name)
    addon:UpdateFooter()
end

-- ── List rendering ────────────────────────────────────────────────────────────

function addon:RefreshProfileList(tab)
    -- Hide all pooled rows first
    tab.profileRows = tab.profileRows or {}
    for _, row in ipairs(tab.profileRows) do
        row:Hide()
    end

    local profiles = addon:ListProfiles()
    tab.listPlaceholder:SetShown(#profiles == 0)

    local child    = tab.listScrollChild
    local active   = addon:GetActiveProfile()
    local rowY     = 0

    for i, name in ipairs(profiles) do
        -- Reuse pooled row frame or create a new one
        local row = tab.profileRows[i]
        if not row then
            row = CreateFrame("Button", nil, child, "BackdropTemplate")
            row:SetHeight(ROW_H)
            row:SetBackdrop(Backdrop(1))

            row.nameFt = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            row.nameFt:SetPoint("TOPLEFT",  row, "TOPLEFT",  8, -8)
            row.nameFt:SetPoint("TOPRIGHT", row, "TOPRIGHT", -8, -8)

            row.metaFt = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            row.metaFt:SetPoint("TOPLEFT", row.nameFt, "BOTTOMLEFT",  0, -3)
            row.metaFt:SetPoint("TOPRIGHT",row.nameFt, "BOTTOMRIGHT", 0, -3)

            tab.profileRows[i] = row
        end

        -- Position
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT",  child, "TOPLEFT",  0, -rowY)
        row:SetPoint("TOPRIGHT", child, "TOPRIGHT", 0, -rowY)
        row:Show()

        -- Content
        local p    = addon:GetProfile(name)
        local meta = p and ((p.createdBy or "?") .. "   " .. (p.snapshotAt or p.createdAt or "")) or ""
        row.nameFt:SetText(name)
        row.metaFt:SetText(meta)
        row.metaFt:SetTextColor(unpack(C.textSub))

        -- Selection highlight
        local sel = (name == active)
        row.nameFt:SetTextColor(sel and C.accent[1] or 1,
                                sel and C.accent[2] or 1,
                                sel and C.accent[3] or 1, 1)
        row:SetBackdropColor(sel and 0.05 or 0,
                             sel and 0.12 or 0,
                             sel and 0.25 or 0, sel and 1 or 0)
        row:SetBackdropBorderColor(sel and C.accent[1] or C.border[1],
                                   sel and C.accent[2] or C.border[2],
                                   sel and C.accent[3] or C.border[3], 1)

        -- Hover / click
        local rowName = name   -- capture for closure
        row:SetScript("OnClick", function()
            addon:SelectProfile(tab, rowName)
        end)
        row:SetScript("OnEnter", function(self)
            if rowName ~= addon:GetActiveProfile() then
                self:SetBackdropColor(0.08, 0.08, 0.14, 1)
                self:SetBackdropBorderColor(unpack(C.border))
            end
        end)
        row:SetScript("OnLeave", function(self)
            local s = (rowName == addon:GetActiveProfile())
            self:SetBackdropColor(s and 0.05 or 0, s and 0.12 or 0, s and 0.25 or 0, s and 1 or 0)
            self:SetBackdropBorderColor(s and C.accent[1] or C.border[1],
                                        s and C.accent[2] or C.border[2],
                                        s and C.accent[3] or C.border[3], 1)
        end)

        rowY = rowY + ROW_H
    end

    child:SetHeight(math.max(1, rowY))
end

-- ── Main builder ──────────────────────────────────────────────────────────────

function addon:BuildProfilesTab(parent)
    local tab = parent   -- alias so closures below are readable

    -- ── Left panel ────────────────────────────────────────────────────────────

    local leftPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT",    parent, "TOPLEFT",    PAD,  -PAD)
    leftPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PAD,   PAD + 36)
    leftPanel:SetWidth(LEFT_W)
    leftPanel:SetBackdrop(Backdrop(1))
    leftPanel:SetBackdropColor(0.082, 0.082, 0.082, 1)
    leftPanel:SetBackdropBorderColor(unpack(C.border))

    local listHeader = leftPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    listHeader:SetPoint("TOPLEFT", leftPanel, "TOPLEFT", 10, -10)
    listHeader:SetText("Profiles")
    listHeader:SetTextColor(unpack(C.accent))

    local div = leftPanel:CreateTexture(nil, "OVERLAY")
    div:SetHeight(1)
    div:SetPoint("TOPLEFT",  leftPanel, "TOPLEFT",   4, -28)
    div:SetPoint("TOPRIGHT", leftPanel, "TOPRIGHT",  -4, -28)
    div:SetColorTexture(unpack(C.border))

    -- Scrollable list
    local sf, child = addon:CreateScrollFrame(leftPanel, LEFT_W - 8, 0)
    sf:SetPoint("TOPLEFT",     leftPanel, "TOPLEFT",     4,  -32)
    sf:SetPoint("BOTTOMRIGHT", leftPanel, "BOTTOMRIGHT", -4,  4)
    tab.listScrollFrame = sf
    tab.listScrollChild = child

    -- Placeholder (hidden once profiles exist)
    local placeholder = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    placeholder:SetPoint("TOP", child, "TOP", 0, -30)
    placeholder:SetText("No profiles yet.\nClick '+ New' to create one.")
    placeholder:SetTextColor(unpack(C.textSub))
    placeholder:SetJustifyH("CENTER")
    tab.listPlaceholder = placeholder

    tab.profileRows = {}

    -- ── [+ New Profile] button ────────────────────────────────────────────────

    local newBtn = addon:CreateButton(parent, "+ New Profile", LEFT_W, 30)
    newBtn:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PAD, PAD)
    newBtn:SetScript("OnClick", function()
        addon:ShowInputDialog("New Profile", "Profile name...", function(name)
            name = name:match("^%s*(.-)%s*$")   -- trim
            if name == "" then return end
            if addon:GetProfile(name) then
                addon:ShowNotification("Profile \"" .. name .. "\" already exists.", "error")
                return
            end
            addon:CreateProfile(name)
            addon:SelectProfile(tab, name)
            addon:ShowNotification("Profile \"" .. name .. "\" created.", "success")
        end)
    end)
    tab.newBtn = newBtn

    -- ── Right panel ───────────────────────────────────────────────────────────

    local rightPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    rightPanel:SetPoint("TOPLEFT",     leftPanel, "TOPRIGHT",    PAD,  0)
    rightPanel:SetPoint("BOTTOMRIGHT", parent,    "BOTTOMRIGHT", -PAD, PAD)
    rightPanel:SetBackdrop(Backdrop(1))
    rightPanel:SetBackdropColor(0.082, 0.082, 0.082, 1)
    rightPanel:SetBackdropBorderColor(unpack(C.border))
    tab.rightPanel = rightPanel

    local nameHeader = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameHeader:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, -14)
    nameHeader:SetText("Select a profile")
    nameHeader:SetTextColor(unpack(C.text))
    tab.nameHeader = nameHeader

    local metaText = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    metaText:SetPoint("TOPLEFT", nameHeader, "BOTTOMLEFT", 0, -4)
    metaText:SetTextColor(unpack(C.textSub))
    metaText:SetText("")
    tab.metaText = metaText

    local divR = rightPanel:CreateTexture(nil, "OVERLAY")
    divR:SetHeight(1)
    divR:SetPoint("TOPLEFT",  rightPanel, "TOPLEFT",   8, -44)
    divR:SetPoint("TOPRIGHT", rightPanel, "TOPRIGHT",  -8, -44)
    divR:SetColorTexture(unpack(C.border))

    -- Action buttons
    local BTN_W, BTN_H, BTN_GAP = 200, 32, 8
    local btnY = -54

    local function ActionBtn(label)
        local b = addon:CreateButton(rightPanel, label, BTN_W, BTN_H)
        b:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, btnY)
        btnY = btnY - (BTN_H + BTN_GAP)
        SetBtnState(b, false)
        return b
    end

    tab.snapshotBtn  = ActionBtn("Snapshot All")
    tab.importBtn    = ActionBtn("Import All")
    tab.exportBtn    = ActionBtn("Export")
    tab.importStrBtn = ActionBtn("Import String")
    tab.deleteBtn    = ActionBtn("Delete")

    -- Delete wiring
    tab.deleteBtn:SetScript("OnClick", function()
        local active = addon:GetActiveProfile()
        if not active then return end
        addon:ShowConfirmDialog(
            "Delete Profile",
            "Delete \"" .. active .. "\"?\nThis cannot be undone.",
            function()
                addon:DeleteProfile(active)
                addon:RefreshProfileList(tab)
                ResetRightPanel(tab)
                addon:UpdateFooter()
                addon:ShowNotification("Profile deleted.", "success")
            end
        )
    end)

    -- Snapshot
    tab.snapshotBtn:SetScript("OnClick", function()
        local active = addon:GetActiveProfile()
        if not active then return end
        tab.statusText:SetText("Snapshotting...")
        tab.progressBar:SetProgress(0)
        tab.progressBar:SetText("0%")
        addon:SnapshotAll(active, function(pct)
            tab.progressBar:SetProgress(pct)
            tab.progressBar:SetText(math.floor(pct * 100) .. "%")
            if pct >= 1.0 then
                tab.statusText:SetText("Snapshot complete")
                tab.progressBar:SetText("Done")
                PopulateRightPanel(tab, active)
                addon:ShowNotification("Snapshot saved.", "success")
            end
        end)
    end)

    -- Import
    tab.importBtn:SetScript("OnClick", function()
        local active = addon:GetActiveProfile()
        if not active then return end
        local p = addon:GetProfile(active)
        if not p or not p.snapshotAt then
            addon:ShowNotification("No snapshot to import. Take a snapshot first.", "warning")
            return
        end
        addon:ShowConfirmDialog(
            "Import Profile",
            "Import \"" .. active .. "\" onto this character?\nThis will replace your current macros.",
            function()
                tab.statusText:SetText("Importing...")
                tab.progressBar:SetProgress(0)
                tab.progressBar:SetText("0%")
                addon:ImportAll(active, function(pct)
                    tab.progressBar:SetProgress(pct)
                    tab.progressBar:SetText(math.floor(pct * 100) .. "%")
                    if pct >= 1.0 then
                        tab.statusText:SetText("Import complete")
                        tab.progressBar:SetText("Done")
                        addon:ShowNotification("Profile imported.", "success")
                    end
                end)
            end
        )
    end)

    -- Progress bar
    local pbFrame, pbCtrl = addon:CreateProgressBar(rightPanel, 200)
    pbFrame:SetPoint("BOTTOMLEFT", rightPanel, "BOTTOMLEFT", 14, 46)
    tab.progressBar = pbCtrl

    local statusText = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusText:SetPoint("BOTTOMLEFT", rightPanel, "BOTTOMLEFT", 14, 30)
    statusText:SetTextColor(unpack(C.textSub))
    statusText:SetText("Ready")
    tab.statusText = statusText

    -- Populate on open (in case profiles already exist from a previous session)
    addon:RefreshProfileList(tab)
    local existing = addon:GetActiveProfile()
    if existing and addon:GetProfile(existing) then
        PopulateRightPanel(tab, existing)
    end
end
