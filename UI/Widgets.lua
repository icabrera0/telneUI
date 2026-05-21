-- UI/Widgets.lua: reusable widget factory — must load before all other UI files

local addon = telneUI

-- Shared color palette (matches spec)
addon.C = {
    bg      = {0.102, 0.102, 0.102, 0.97},
    bgDark  = {0.071, 0.071, 0.071, 1.0},
    border  = {0.165, 0.165, 0.165, 1.0},
    accent  = {0.310, 0.765, 0.969, 1.0},
    accentDim = {0.310, 0.765, 0.969, 0.15},
    text    = {1.0,   1.0,   1.0,   1.0},
    textSub = {0.667, 0.667, 0.667, 1.0},
    btnBg   = {0.149, 0.149, 0.149, 1.0},
    tabBg   = {0.090, 0.090, 0.090, 1.0},
    success = {0.2,   0.8,   0.2,   1.0},
    error   = {0.9,   0.2,   0.2,   1.0},
    warning = {0.9,   0.7,   0.1,   1.0},
}

local C = addon.C

local function Backdrop(edgeSize)
    return {
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = edgeSize or 1,
        insets = {left=1, right=1, top=1, bottom=1},
    }
end

-- ── Button ───────────────────────────────────────────────────────────────────

-- Returns a styled dark button frame with hover glow.
function addon:CreateButton(parent, text, width, height)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 120, height or 26)
    btn:SetBackdrop(Backdrop(1))
    btn:SetBackdropColor(unpack(C.btnBg))
    btn:SetBackdropBorderColor(unpack(C.border))

    local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lbl:SetAllPoints()
    lbl:SetText(text or "")
    lbl:SetTextColor(unpack(C.text))
    btn.label = lbl

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(C.accentDim[1], C.accentDim[2], C.accentDim[3], 0.25)
        self:SetBackdropBorderColor(unpack(C.accent))
        lbl:SetTextColor(C.accent[1], C.accent[2], C.accent[3], 1)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(unpack(C.btnBg))
        self:SetBackdropBorderColor(unpack(C.border))
        lbl:SetTextColor(unpack(C.text))
    end)
    btn:SetScript("OnMouseDown", function(self)
        lbl:SetPoint("CENTER", self, "CENTER", 1, -1)
    end)
    btn:SetScript("OnMouseUp", function(self)
        lbl:SetPoint("CENTER", self, "CENTER", 0, 0)
    end)

    return btn
end

-- ── Label ────────────────────────────────────────────────────────────────────

-- Returns a FontString attached to a minimal Frame so it can be positioned.
function addon:CreateLabel(parent, text, size, color)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(200, size and (size + 4) or 16)
    local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetAllPoints()
    fs:SetFont("Fonts/FRIZQT__.TTF", size or 11, "")
    fs:SetText(text or "")
    if color then
        fs:SetTextColor(color[1], color[2], color[3], color[4] or 1)
    else
        fs:SetTextColor(unpack(C.text))
    end
    f.fs = fs
    return f
end

-- ── Scroll frame ─────────────────────────────────────────────────────────────

-- Returns scrollFrame, scrollChild.
-- Attach child content to scrollChild; it auto-expands vertically.
function addon:CreateScrollFrame(parent, width, height)
    local sf = CreateFrame("ScrollFrame", nil, parent)
    sf:SetSize(width or 200, height or 300)
    sf:EnableMouseWheel(true)

    -- Scroll child holds actual content
    local child = CreateFrame("Frame", nil, sf)
    child:SetSize(width or 200, 1)   -- height grows as rows are added
    sf:SetScrollChild(child)

    sf:SetScript("OnMouseWheel", function(self, delta)
        local cur  = self:GetVerticalScroll()
        local max  = self:GetVerticalScrollRange()
        local new  = math.max(0, math.min(cur - delta * 20, max))
        self:SetVerticalScroll(new)
    end)

    return sf, child
end

-- ── Divider ──────────────────────────────────────────────────────────────────

-- Returns a 1px horizontal line texture.
function addon:CreateDivider(parent, width)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(width or 200, 1)
    local t = f:CreateTexture(nil, "OVERLAY")
    t:SetAllPoints()
    t:SetColorTexture(unpack(C.border))
    return f
end

-- ── Progress bar ─────────────────────────────────────────────────────────────

-- Returns frame (outer) and a controller with :SetProgress(0–1) and :SetText(str).
function addon:CreateProgressBar(parent, width)
    local w = width or 200
    local outer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    outer:SetSize(w, 16)
    outer:SetBackdrop(Backdrop(1))
    outer:SetBackdropColor(0.08, 0.08, 0.08, 1)
    outer:SetBackdropBorderColor(unpack(C.border))

    local fill = outer:CreateTexture(nil, "OVERLAY")
    fill:SetHeight(12)
    fill:SetPoint("LEFT", outer, "LEFT", 2, 0)
    fill:SetWidth(0.01)
    fill:SetColorTexture(C.accent[1], C.accent[2], C.accent[3], 0.9)

    local label = outer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetAllPoints()
    label:SetText("")
    label:SetTextColor(unpack(C.text))

    local ctrl = {}
    function ctrl:SetProgress(pct)
        local clamped = math.max(0, math.min(pct or 0, 1))
        fill:SetWidth(math.max(0.01, clamped * (w - 4)))
    end
    function ctrl:SetText(str)
        label:SetText(str or "")
    end

    return outer, ctrl
end

-- ── Confirm dialog ───────────────────────────────────────────────────────────

-- Shows a modal-style confirm dialog.  onConfirm() called on "Yes", onCancel on "No"/close.
function addon:ShowConfirmDialog(title, message, onConfirm, onCancel)
    if _G["telneUIConfirmDialog"] then
        _G["telneUIConfirmDialog"]:Hide()
    end

    local f = CreateFrame("Frame", "telneUIConfirmDialog", UIParent, "BackdropTemplate")
    f:SetSize(400, 160)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(300)
    f:SetBackdrop(Backdrop(1))
    f:SetBackdropColor(unpack(C.bg))
    f:SetBackdropBorderColor(C.accent[1], C.accent[2], C.accent[3], 0.8)

    -- Title bar
    local hdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    hdr:SetPoint("TOP", f, "TOP", 0, -14)
    hdr:SetText(title or "Confirm")
    hdr:SetTextColor(unpack(C.accent))

    -- Divider under title
    local div = f:CreateTexture(nil, "OVERLAY")
    div:SetHeight(1)
    div:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -32)
    div:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -32)
    div:SetColorTexture(unpack(C.border))

    -- Message
    local msg = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    msg:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -46)
    msg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -46)
    msg:SetText(message or "")
    msg:SetTextColor(unpack(C.text))
    msg:SetJustifyH("CENTER")
    msg:SetWordWrap(true)

    -- Buttons
    local yes = addon:CreateButton(f, "Yes", 110, 28)
    yes:SetPoint("BOTTOMRIGHT", f, "BOTTOM", -8, 16)
    yes:SetScript("OnClick", function()
        f:Hide()
        if onConfirm then onConfirm() end
    end)

    local no = addon:CreateButton(f, "No", 110, 28)
    no:SetPoint("BOTTOMLEFT", f, "BOTTOM", 8, 16)
    no:SetScript("OnClick", function()
        f:Hide()
        if onCancel then onCancel() end
    end)

    f:Show()
    return f
end

-- ── Input dialog ─────────────────────────────────────────────────────────────

-- Shows a text-input dialog. onConfirm(text) called on OK/Enter.
function addon:ShowInputDialog(title, placeholder, onConfirm, onCancel)
    if _G["telneUIInputDialog"] then
        _G["telneUIInputDialog"]:Hide()
    end

    local f = CreateFrame("Frame", "telneUIInputDialog", UIParent, "BackdropTemplate")
    f:SetSize(380, 150)
    f:SetPoint("CENTER")
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(300)
    f:SetBackdrop(Backdrop(1))
    f:SetBackdropColor(unpack(C.bg))
    f:SetBackdropBorderColor(C.accent[1], C.accent[2], C.accent[3], 0.8)

    local hdr = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    hdr:SetPoint("TOP", f, "TOP", 0, -14)
    hdr:SetText(title or "Enter name")
    hdr:SetTextColor(unpack(C.accent))

    local div = f:CreateTexture(nil, "OVERLAY")
    div:SetHeight(1)
    div:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -32)
    div:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -32)
    div:SetColorTexture(unpack(C.border))

    -- EditBox
    local eb = CreateFrame("EditBox", nil, f, "BackdropTemplate")
    eb:SetSize(340, 28)
    eb:SetPoint("TOP", f, "TOP", 0, -50)
    eb:SetBackdrop(Backdrop(1))
    eb:SetBackdropColor(0.08, 0.08, 0.08, 1)
    eb:SetBackdropBorderColor(unpack(C.border))
    eb:SetFont("Fonts/FRIZQT__.TTF", 12, "")
    eb:SetTextColor(unpack(C.text))
    eb:SetTextInsets(8, 8, 0, 0)
    eb:SetAutoFocus(true)
    eb:SetMaxLetters(64)
    eb:SetText("")
    -- Placeholder hint (clear on focus)
    if placeholder then
        local hint = eb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hint:SetPoint("LEFT", eb, "LEFT", 8, 0)
        hint:SetText(placeholder)
        hint:SetTextColor(unpack(C.textSub))
        eb:SetScript("OnTextChanged", function(self)
            hint:SetShown(self:GetText() == "")
        end)
        eb:SetScript("OnEditFocusGained", function()
            hint:Hide()
        end)
        eb:SetScript("OnEditFocusLost", function(self)
            hint:SetShown(self:GetText() == "")
        end)
    end

    local confirm = function()
        local txt = eb:GetText()
        txt = txt and txt:match("^%s*(.-)%s*$")  -- trim whitespace
        if txt and txt ~= "" then
            f:Hide()
            if onConfirm then onConfirm(txt) end
        end
    end

    eb:SetScript("OnEnterPressed", confirm)
    eb:SetScript("OnEscapePressed", function()
        f:Hide()
        if onCancel then onCancel() end
    end)

    local ok = addon:CreateButton(f, "OK", 100, 28)
    ok:SetPoint("BOTTOMRIGHT", f, "BOTTOM", -8, 14)
    ok:SetScript("OnClick", confirm)

    local cancel = addon:CreateButton(f, "Cancel", 100, 28)
    cancel:SetPoint("BOTTOMLEFT", f, "BOTTOM", 8, 14)
    cancel:SetScript("OnClick", function()
        f:Hide()
        if onCancel then onCancel() end
    end)

    f:Show()
    eb:SetFocus()
    return f
end

-- ── Notification toast ───────────────────────────────────────────────────────

-- Shows a self-dismissing toast at the top of the screen.
-- type: "success" | "error" | "warning"
function addon:ShowNotification(message, notifType)
    local c = C.success
    local icon = "✓"
    if notifType == "error" then
        c = C.error
        icon = "✕"
    elseif notifType == "warning" then
        c = C.warning
        icon = "⚠"
    end

    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(340, 38)
    f:SetPoint("TOP", UIParent, "TOP", 0, -80)
    f:SetFrameStrata("TOOLTIP")
    f:SetFrameLevel(400)
    f:SetBackdrop(Backdrop(1))
    f:SetBackdropColor(c[1]*0.12, c[2]*0.12, c[3]*0.12, 0.95)
    f:SetBackdropBorderColor(c[1], c[2], c[3], 0.85)

    local iconFs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconFs:SetPoint("LEFT", f, "LEFT", 12, 0)
    iconFs:SetText("|cff" .. string.format("%02x%02x%02x", c[1]*255, c[2]*255, c[3]*255) .. icon .. "|r")

    local txt = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    txt:SetPoint("LEFT", iconFs, "RIGHT", 8, 0)
    txt:SetPoint("RIGHT", f, "RIGHT", -12, 0)
    txt:SetText(message)
    txt:SetTextColor(unpack(C.text))
    txt:SetJustifyH("LEFT")

    -- Fade out after 2.5s over 0.5s
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed > 2.5 then
            local alpha = 1 - ((elapsed - 2.5) / 0.5)
            if alpha <= 0 then
                self:SetScript("OnUpdate", nil)
                self:Hide()
            else
                self:SetAlpha(alpha)
            end
        end
    end)

    f:Show()
    return f
end
