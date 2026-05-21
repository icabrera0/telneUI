-- UI/ProfilesTab.lua: Profiles tab layout (M1: skeleton only; wired in M2)

local addon = telneUI

local LEFT_W  = 240
local PAD     = 10

local C = addon.C

local function Backdrop(edge)
    return {
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = edge or 1,
        insets = {left=1, right=1, top=1, bottom=1},
    }
end

function addon:BuildProfilesTab(parent)
    -- ── Left panel: profile list ───────────────────────────────────────────

    local leftPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    leftPanel:SetPoint("TOPLEFT",    parent, "TOPLEFT",    PAD,    -PAD)
    leftPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PAD,     PAD + 36)
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
    div:SetPoint("TOPLEFT",  leftPanel, "TOPLEFT",  4, -28)
    div:SetPoint("TOPRIGHT", leftPanel, "TOPRIGHT", -4, -28)
    div:SetColorTexture(unpack(C.border))

    -- Scroll area for profile rows (populated in M2)
    local sf, child = addon:CreateScrollFrame(leftPanel, LEFT_W - 8, 0)
    sf:SetPoint("TOPLEFT",    leftPanel, "TOPLEFT",    4,  -32)
    sf:SetPoint("BOTTOMRIGHT",leftPanel, "BOTTOMRIGHT",-4,  4)
    parent.listScrollFrame = sf
    parent.listScrollChild = child

    -- Placeholder text (removed in M2 when list is populated)
    local placeholder = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    placeholder:SetPoint("CENTER", child, "CENTER", 0, 0)
    placeholder:SetText("No profiles yet.\nCreate one to get started.")
    placeholder:SetTextColor(unpack(C.textSub))
    placeholder:SetJustifyH("CENTER")
    parent.listPlaceholder = placeholder

    -- [+ New Profile] button at the bottom of the left column
    local newBtn = addon:CreateButton(parent, "+ New Profile", LEFT_W, 30)
    newBtn:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", PAD, PAD)
    newBtn:SetScript("OnClick", function()
        -- wired in M2
        addon:ShowNotification("Profile creation available in Milestone 2", "warning")
    end)
    parent.newBtn = newBtn

    -- ── Right panel: actions ───────────────────────────────────────────────

    local rightPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    rightPanel:SetPoint("TOPLEFT",     leftPanel, "TOPRIGHT",    PAD,  0)
    rightPanel:SetPoint("BOTTOMRIGHT", parent,    "BOTTOMRIGHT", -PAD, PAD)
    rightPanel:SetBackdrop(Backdrop(1))
    rightPanel:SetBackdropColor(0.082, 0.082, 0.082, 1)
    rightPanel:SetBackdropBorderColor(unpack(C.border))
    parent.rightPanel = rightPanel

    -- Profile name header
    local nameHeader = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameHeader:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, -14)
    nameHeader:SetText("Select a profile")
    nameHeader:SetTextColor(unpack(C.text))
    parent.nameHeader = nameHeader

    -- Metadata (character, date)
    local metaText = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    metaText:SetPoint("TOPLEFT", nameHeader, "BOTTOMLEFT", 0, -4)
    metaText:SetTextColor(unpack(C.textSub))
    metaText:SetText("")
    parent.metaText = metaText

    local divR = rightPanel:CreateTexture(nil, "OVERLAY")
    divR:SetHeight(1)
    divR:SetPoint("TOPLEFT",  rightPanel, "TOPLEFT",  8, -44)
    divR:SetPoint("TOPRIGHT", rightPanel, "TOPRIGHT", -8, -44)
    divR:SetColorTexture(unpack(C.border))

    -- Action buttons (greyed out until a profile is selected in M2)
    local BTN_W, BTN_H, BTN_GAP = 200, 32, 8
    local btnY = -54

    local function ActionBtn(label)
        local b = addon:CreateButton(rightPanel, label, BTN_W, BTN_H)
        b:SetPoint("TOPLEFT", rightPanel, "TOPLEFT", 14, btnY)
        btnY = btnY - (BTN_H + BTN_GAP)
        b:SetEnabled(false)  -- enabled in M2
        b.label:SetTextColor(unpack(C.textSub))
        return b
    end

    parent.snapshotBtn = ActionBtn("🔷 Snapshot All")
    parent.importBtn   = ActionBtn("🟢 Import All")
    parent.exportBtn   = ActionBtn("📤 Export")
    parent.importStrBtn= ActionBtn("📥 Import String")
    parent.deleteBtn   = ActionBtn("🗑 Delete")

    -- Progress bar
    local pbFrame, pbCtrl = addon:CreateProgressBar(rightPanel, 200)
    pbFrame:SetPoint("BOTTOMLEFT", rightPanel, "BOTTOMLEFT", 14, 46)
    parent.progressBar  = pbCtrl

    local statusText = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusText:SetPoint("BOTTOMLEFT", rightPanel, "BOTTOMLEFT", 14, 30)
    statusText:SetTextColor(unpack(C.textSub))
    statusText:SetText("Ready")
    parent.statusText = statusText
end
