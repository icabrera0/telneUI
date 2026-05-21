# telneUI — Development Progress

_Updated each session. Read this at the start of every new conversation to know exactly where to pick up._

---

## Current Status

**Milestone 1 — COMPLETE** (2025-05-21)

All scaffold files created. Addon is ready for in-game testing.

---

## Next Session: Start Milestone 2

**Prompt to use:**
> "telneUI — starting Milestone 2"

**What Milestone 2 builds:**
- ProfileManager.lua: CreateProfile, DeleteProfile, ListProfiles, SetActiveProfile, GetActiveProfile
- UI/ProfilesTab.lua: scrollable profile list with row selection, [+ New] input dialog, [Delete] confirm dialog, metadata display in right panel
- Footer updates when active profile changes

**Files to modify:**
- `ProfileManager.lua` (replace stubs with full implementation)
- `UI/ProfilesTab.lua` (replace skeleton with functional list)

---

## Milestone Completion Log

### ✅ Milestone 1 — Folder Structure, Scaffold & Dark UI Shell
**Date:** 2026-05-21
**Status:** Complete — interface version fixed for WoW Midnight (120005)

**Files created:**
| File | Status |
|------|--------|
| `.gitignore` | ✅ |
| `.claude/CLAUDE.md` | ✅ |
| `README.md` | ✅ |
| `CHANGELOG.md` | ✅ |
| `.luacheckrc` | ✅ |
| `telneUI.toc` | ✅ |
| `Core.lua` | ✅ |
| `UI/Widgets.lua` | ✅ |
| `UI/MainFrame.lua` | ✅ |
| `UI/ProfilesTab.lua` | ✅ layout only |
| `UI/AddonsTab.lua` | ✅ layout only |
| `UI/SettingsTab.lua` | ✅ layout only |
| `ProfileManager.lua` | ✅ stubs |
| `Snapshot.lua` | ✅ stubs |
| `Importer.lua` | ✅ stubs |
| `Modules/Macros.lua` | ✅ stubs |
| `Modules/Keybinds.lua` | ✅ stubs |
| `Modules/Chat.lua` | ✅ stubs |
| `Modules/Frames.lua` | ✅ stubs |
| `Modules/EditMode.lua` | ✅ stubs |
| `Modules/AddonSettings.lua` | ✅ stubs |
| `.github/workflows/release.yml` | ✅ |
| `spec.md` | ✅ |
| `progress.md` | ✅ |

**In-game test checklist (do before starting M2):**
- [ ] Addon loads with zero Lua errors
- [ ] `/telneui` opens dark styled panel
- [ ] All 3 tabs switch correctly (Profiles / Addons / Settings)
- [ ] Panel is draggable by title bar
- [ ] Close button works
- [ ] `/reload` — panel remembers last position

---

### 🔲 Milestone 2 — Profile Manager
Full profile CRUD. Profiles persist account-wide.

### 🔲 Milestone 3 — Macro Snapshot & Import
General + character macros, overwrite on re-import, limit warnings.

### 🔲 Milestone 4 — Keybind Snapshot & Import
All bindings, conflict resolution, always character-specific (SaveBindings(2)).

### 🔲 Milestone 5 — Frame Position Snapshot & Import
Resolution-independent (xPct/yPct), 10 native + 3 addon frames tracked.

### 🔲 Milestone 6 — Chat, EditMode & Addon States
Chat window layout + EditMode serialization + addon enable/disable diff view.

### 🔲 Milestone 7 — Addon SavedVariables Deep Copy
ElvDB, WeakAurasSaved, Bartender4DB, DBM_AllSavedOptions, Details_DB.
Editable tracked vars list in Settings tab.

### 🔲 Milestone 8 — One-Click Flow, Export String & Polish
LibDeflate export strings, minimap button, auto-backup, CI release zip.

---

## Architecture Quick Reference

```
telneUI (global table, never write globals beyond this)
  └─ .db = telneUISavedVars (all persistent state here)
       ├─ .profiles["Name"] = { macros, keybinds, chat, frames, editMode, addonSettings }
       ├─ .activeProfile = "Name"
       ├─ .settings = { autoBackup, showMinimapButton, ... }
       └─ .ui = { point, x, y }   ← panel position memory

Load order: Core → ProfileManager → Snapshot → Importer
            → Widgets → MainFrame → *Tab files
            → Modules/*
```

## Key Design Rules (never break)
1. Only files in `telneUI.toc` are loaded by WoW
2. Deep copy all foreign addon tables — never hold references
3. Frame positions stored as xPct/yPct (% of screen), not pixels
4. Addon enable/disable changes always require /reload
5. All SavedVariables writes go through `telneUISavedVars` only
