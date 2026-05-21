# telneUI — Development Progress

_Updated each session. Read this at the start of every new conversation to know exactly where to pick up._

---

## Current Status

**Milestone 3 — COMPLETE** (2026-05-21)

Macro snapshot and import fully implemented. [Snapshot All] and [Import All] buttons live.

---

## Next Session: Start Milestone 4

**Prompt to use:**
> "telneUI — starting Milestone 4"

**What Milestone 4 builds:**
- `Modules/Keybinds.lua`: `Snapshot(profile)` uses `GetBindingKey(action)` / iterates all bindings with `GetBinding(i)` (returns action, key1, key2); `Import(profile)` calls `SetBinding(key, action)` then `SaveBindings(2)` (2 = character-specific)
- `Snapshot.lua`: add Keybinds step to STEPS array (uncomment M4 line)
- `Importer.lua`: add Keybinds step to STEPS array (uncomment M4 line)

**Key WoW API:**
- `GetNumBindings()` → total number of binding slots
- `GetBinding(index)` → action, key1, key2
- `SetBinding(key, action)` → sets one binding; pass nil action to clear
- `SaveBindings(2)` → saves character-specific bindings (must call after all SetBinding calls)
- `GetCurrentBindingSet()` → 1=account, 2=character

**Files to modify:**
- `Modules/Keybinds.lua`
- `Snapshot.lua` (uncomment M4 step)
- `Importer.lua` (uncomment M4 step)

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

### ✅ Milestone 2 — Profile Manager
**Date:** 2026-05-21
**Status:** Complete

**Files modified:**
| File | Status |
|------|--------|
| `ProfileManager.lua` | ✅ CreateProfile, DeleteProfile, ListProfiles, SetActiveProfile, GetActiveProfile, GetProfile |
| `UI/ProfilesTab.lua` | ✅ Scrollable list, row pool reuse, [+ New] dialog, [Delete] confirm, right-panel metadata, SetBtnState, footer sync |

### ✅ Milestone 3 — Macro Snapshot & Import
**Date:** 2026-05-21
**Status:** Complete

**Files modified:**
| File | Status |
|------|--------|
| `Modules/Macros.lua` | ✅ Snapshot (slots 1-120 general, 121-138 character), Import (delete+recreate), limit warnings |
| `Snapshot.lua` | ✅ SnapshotAll with extensible STEPS array, sets snapshotAt/snapshotBy |
| `Importer.lua` | ✅ ImportAll with extensible STEPS array |
| `UI/ProfilesTab.lua` | ✅ [Snapshot All] and [Import All] wired with progress bar, empty-snapshot guard on import |

**In-game test checklist:**
- [ ] Create a profile, take snapshot — snapshotAt updates in right panel
- [ ] Import to another character — macros match source
- [ ] Import with >120 general or >18 character macros — warning notification
- [ ] Import on profile with no snapshot — "No snapshot to import" warning

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
