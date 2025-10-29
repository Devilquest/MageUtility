# Mage Utility

A lightweight and intuitive addon for World of Warcraft Vanilla 1.12 that consolidates Mage teleports, portals, and mana gems into a single, efficient interface.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![WoW Version](https://img.shields.io/badge/wow-1.12.x-orange.svg)
![Class](https://img.shields.io/badge/class-Mage-69ccf0.svg)

## Features

- **Organized Interface**: All teleports, portals, and mana gems displayed in a clean, sectioned window
- **Rune Counter**: Real-time display of available teleportation and portal runes
- **Smart Behavior**: 
  - Window closes after casting teleports/portals
  - Window remains open when conjuring mana gems for quick successive casting
- **Dynamic Width**: Window automatically adjusts its width based on the number of spells available
- **Per-Character Settings**: Window position is saved individually for each character
- **Faction Detection**: Automatically displays only spells relevant to your faction (Alliance/Horde)
- **Spell Validation**: Buttons are automatically disabled if:
  - The spell is not learned
  - You have no reagents (shows "0" counter)

## Installation

### Method 1: Direct Download (Recommended)

1. Click the green **`<> Code`** button at the top of this page
2. Select **Download ZIP**
3. Extract the ZIP file
4. Rename the folder from `MageUtility-main` to `MageUtility` (if needed)
5. Move the `MageUtility` folder to `World of Warcraft/Interface/AddOns/`
6. Restart WoW or type `/reload` in-game

### Method 2: Git Clone

Navigate to your WoW installation folder's `Interface/AddOns/` directory and run:
```bash
git clone https://github.com/YourUsername/MageUtility.git
```

### Verification

After installation, your folder structure should look like this:
```
World of Warcraft/
└── Interface/
    └── AddOns/
        └── MageUtility/
            ├── MageUtility.toc
            ├── MageUtility.lua
            ├── Modules/
            │   ├── Portals.lua
            │   ├── Teleports.lua
            │   └── ManaGems.lua
            └── UI/
                └── MainFrame.lua
```

**Common Issues:**
- ❌ `AddOns/MageUtility-main/MageUtility/` (too nested)
- ✅ `AddOns/MageUtility/` (correct!)

## Usage

### Commands

- `/mage` or `/mu` - Toggle the Mage Utility window

**Tip:** Create a macro with `/mage` and drag it to your action bar for quick access!

### Interface Controls

The window displays three sections:

1. **Teleports** - Quick access to all learned teleportation spells
2. **Portals** - All portal spells with rune counter
3. **Mana Gems** - Conjure mana gems of all available types

**Button Interactions:**
- **Left Click**: Cast the spell
- **Hover**: Display original game tooltip with spell information
- **Drag Title Bar**: Move the window (position is saved per character)

Each button shows:
- Spell icon with the original game tooltip on hover
- Reagent counter (bottom-right corner) for teleports and portals
- Disabled state (grayed out) when spell is not learned or reagents are unavailable

## Default Spells

### Alliance
**Teleports & Portals:**
- [Teleport: Stormwind](https://www.wowhead.com/classic/spell=3561) / [Portal: Stormwind](https://www.wowhead.com/classic/spell=10059)
- [Teleport: Ironforge](https://www.wowhead.com/classic/spell=3562) / [Portal: Ironforge](https://www.wowhead.com/classic/spell=11416)
- [Teleport: Darnassus](https://www.wowhead.com/classic/spell=3565) / [Portal: Darnassus](https://www.wowhead.com/classic/spell=11419)

### Horde
**Teleports & Portals:**
- [Teleport: Orgrimmar](https://www.wowhead.com/classic/spell=3567) / [Portal: Orgrimmar](https://www.wowhead.com/classic/spell=11417)
- [Teleport: Thunder Bluff](https://www.wowhead.com/classic/spell=3566) / [Portal: Thunder Bluff](https://www.wowhead.com/classic/spell=11420)
- [Teleport: Undercity](https://www.wowhead.com/classic/spell=3563) / [Portal: Undercity](https://www.wowhead.com/classic/spell=11418)

### Mana Gems (Both Factions)
- [Mana Agate](https://www.wowhead.com/classic/spell=759) (Level 28)
- [Mana Jade](https://www.wowhead.com/classic/spell=3552) (Level 38)
- [Mana Citrine](https://www.wowhead.com/classic/spell=10053) (Level 48)
- [Mana Ruby](https://www.wowhead.com/classic/spell=10054) (Level 58)

## Customization

The addon is designed to be easily extensible. You can add new spells by editing the data files located in the `Modules/` directory.

### Adding a New Teleport
Edit `Modules/Teleports.lua`:
```lua
Alliance = {
    -- Existing teleports...
    {
        name = "Teleport: Moonglade",
        icon = "Interface\\Icons\\Spell_arcane_teleportmoonglade",
        reagent = MageUtility.Reagents.TELEPORT_RUNE  -- Recommended: use predefined constant
    }
}
```
**Alternative:** You can also define the reagent inline:
```lua
Alliance = {
    -- Existing teleports...
    {
        name = "Teleport: Moonglade",
        icon = "Interface\\Icons\\Spell_arcane_teleportmoonglade",
        reagent = {
            id = 17031,  -- Rune of Teleportation
            name = "Rune of Teleportation",
            count = 1
        }
    }
}
```

### Adding a New Portal
Edit `Modules/Portals.lua`:
```lua
Horde = {
    -- Existing portals...
    {
        name = "Portal: Silvermoon",
        icon = "Interface\\Icons\\Spell_arcane_portalsilvermoon",
        reagent = MageUtility.Reagents.PORTAL_RUNE  -- Recommended: use predefined constant
    }
}
```
**Alternative:** You can also define the reagent inline:
```lua
Horde = {
    -- Existing portals...
    {
        name = "Portal: Silvermoon",
        icon = "Interface\\Icons\\Spell_arcane_portalsilvermoon",
        reagent = {
            id = 17032,  -- Rune of Portals
            name = "Rune of Portals",
            count = 1
        }
    }
}
```

### Adding a New Mana Gem

Edit `Modules/ManaGems.lua`:
```lua
MageUtility.ManaGems.Data = {
    -- Existing gems...
    {
        name = "Conjure Mana Diamond",
        icon = "Interface\\Icons\\Inv_misc_gem_diamond_01"
        -- No reagent needed for conjuration spells
    }
}
```

**Predefined Reagents** (available in `MageUtility.lua`):
- `MageUtility.Reagents.TELEPORT_RUNE` - Rune of Teleportation (ID: 17031)
- `MageUtility.Reagents.PORTAL_RUNE` - Rune of Portals (ID: 17032)

Using predefined constants is recommended for consistency and easier maintenance.

**Field Explanations:**
- **name**: The exact spell name as shown in your spellbook (case-sensitive)
- **icon**: The game texture path for the spell icon
  - Look at existing examples in `Modules/` files for the correct format
  - Icon names can be found on [Wowhead Classic](https://www.wowhead.com/classic/) - check the spell's page and look for the icon file name
  - Common path format: `Interface\\Icons\\Spell_arcane_teleportironforge`
  - Use double backslashes `\\` in the path
  - Icon paths are not case-sensitive in Vanilla, but use the exact name from Wowhead for consistency
- **reagent** (optional):
  - **id**: The item ID from Wowhead (found in URL: `wowhead.com/classic/item=17031`)
  - **name**: The readable item name for tooltip display
  - **count**: How many reagents are consumed per spell cast

**Notes:**
- The spell name must exactly match the in-game spellbook name (including colons and capitalization).
- `icon` should use a valid texture path from the WoW client.
- Reagent info is optional for conjured or reagent-free spells (like mana gems).
- The window width automatically adjusts to accommodate additional spells in each section.

## Technical Details

- **Dynamic Width Calculation**: The window width is calculated based on the section with the most spells (formula: `max_buttons * 40 + padding`)
- **Per-Character Storage**: Uses `SavedVariablesPerCharacter` to store window position independently for each character
- **Efficient Bag Scanning**: Reagent counts are updated on `BAG_UPDATE` events to minimize performance impact
- **No Cooldown Tracking**: Simplified code as these spells have no cooldowns in Vanilla
- **Original Tooltips**: Displays the authentic in-game spell tooltips via spellbook lookup using `GetSpellID()`

## File Structure
```
MageUtility/
├── MageUtility.toc          # Addon manifest (defines load order)
├── MageUtility.lua           # Core initialization and utilities
├── Modules/
│   ├── Portals.lua          # Portal spell definitions
│   ├── Teleports.lua        # Teleport spell definitions
│   └── ManaGems.lua         # Mana gem spell definitions
└── UI/
    └── MainFrame.lua        # UI rendering and interaction logic
```

## Troubleshooting

**The window doesn't appear:**
- Check if the addon is enabled in the AddOns menu at character selection
- Try `/reload` to refresh the UI
- Verify the folder structure is correct: `Interface/AddOns/MageUtility/`

**Buttons are grayed out:**
- Make sure you've learned the spell from your class trainer
- Check if you have [Rune of Teleportation](https://www.wowhead.com/classic/item=17031) or [Rune of Portals](https://www.wowhead.com/classic/item=17032) in your bags
- Verify you're the correct level for the spell (see level requirements above)

**Window position resets:**
- The position is saved per character in `SavedVariables`
- Make sure you exit the game properly (not Alt+F4) to save settings
- The `/reload` command will reload but keep your saved position

**Reagent counter shows "0" but I have runes:**
- Try closing and reopening your bags to trigger a `BAG_UPDATE` event
- Type `/reload` to force a reagent count refresh

## Requirements

- **Game Version**: World of Warcraft 1.12.x (Vanilla)
- **Dependencies**: None (standalone addon)

## Known Limitations

- Only works with WoW Vanilla 1.12.x
- Spell names must match exactly as they appear in the spellbook
- Icons must use valid texture paths from the game client
- Does not support spell ranks or alternative versions

<br>

---

## Changelog

### v1.0.0
- Initial release
- Support for all Vanilla teleports and portals (Alliance & Horde)
- Mana gem conjuration interface
- Real-time reagent tracking
- Per-character saved window positions
- Dynamic window width adjustment

<br>

---
## :heart:Donations
**Donations are always greatly appreciated. Thank you for your support!**

<a href="https://www.buymeacoffee.com/devilquest" target="_blank"><img src="https://i.imgur.com/RHHFQWs.png" alt="Buy Me A Dinosaur"></a>