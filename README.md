# telneUI

A personal World of Warcraft addon that snapshots your entire UI setup — macros, keybinds, chat windows, frame positions, EditMode layout, and addon configurations — into named profiles, then restores them on any character with a single import.

## Features
- **One-click snapshot** of your full UI state (macros, keybinds, chat, frames, EditMode, addon configs)
- **Cross-character import** — restore any profile on any character
- **Addon state sync** — enable/disable addon lists per profile
- **Addon config deep copy** — mirrors ElvUI, WeakAuras, Bartender4, DBM, Details, and more
- **Export strings** — share profiles across PCs without copying WTF folders
- **Dark themed UI** — styled like ElvUI

## Installation
1. Download the latest release zip from [Releases](../../releases)
2. Extract `telneUI/` into `World of Warcraft/_retail_/Interface/AddOns/`
3. Launch WoW — type `/telneui` to open

## Usage

### Snapshot (Character A)
1. `/telneui` → Profiles tab
2. Click **Snapshot All**
3. Name your profile → Confirm

### Import (Character B)
1. Log in as Character B
2. `/telneui` → Profiles tab → select your profile
3. Click **Import All** → Confirm
4. Click **Reload Now** when prompted

## Commands
| Command | Action |
|---------|--------|
| `/telneui` | Open/close main panel |
| `/tui` | Alias for /telneui |

## Requirements
- Retail WoW (Interface 110100 / The War Within 11.1.0+)
- No dependencies for core features
- LibDeflate (bundled) for export strings only

## Development
See `spec.md` for the full project specification and milestone breakdown.
See `progress.md` for current development status.
