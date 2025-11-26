### Linux Game Helper (linuxgh)

**Linux Game Helper** (`linuxgh`) is a lightweight utility for running Windows trainers and other `.exe` tools inside the same Proton/Wine prefix as your Steam or Lutris games.

---

## Quick Start

1. **Install:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

2. **Configure Steam game:**
   - Right-click game → Properties → Launch Options:
   ```bash
   linuxgh init %command%
   ```

3. **Launch your game, then run:**
   ```bash
   linuxgh
   ```
   Or search for **"Linux Game Helper"** in your applications menu.
4. **Configure Lutris game:**
- Right-click the game > Configure > System Options > Click on "Advanced" Toggle > Game Execution
- Set the Command prefix as (`linuxgh init`)
- (Optional but Recommended)  Add environment variable ‘SteamAppId’ with the gameID. Use steamdb.info to find game.
---

## Features

- ✅ **Works with Steam Proton, Lutris Proton, and Lutris Wine**
- ✅ **Simple Steam integration** via launch options
- ✅ **Per-game trainer management** – save and auto-launch trainers
- ✅ **Run any executable** in the game's Wine/Proton prefix
- ✅ **Lightweight** – no external dependencies beyond Python 3 and zenity
- ✅ **GUI dialogs** via zenity (with terminal fallback)
- ✅ **Application menu integration** with desktop icon
- ✅ **No root required** for normal usage

---

## How It Works

`linuxgh` hooks into your game launch process to capture the Proton/Wine environment (executable path, prefix location, environment variables). When you run the GUI launcher, it detects the running game and lets you:

- **Launch a saved trainer** for that game
- **Browse and run any `.exe`** in the same prefix (Cheat Engine, debuggers, etc.)

All trainer paths are saved per-game in `~/.config/linuxgh/trainer_config.ini` for quick access next time.

---

## Requirements

- **Linux** (any distribution)
- **Python 3** (usually pre-installed)
- **zenity** (for GUI dialogs, I believe this comes installed on many systems by default)
  - Debian/Ubuntu: `sudo apt install zenity`
  - Fedora: `sudo dnf install zenity`
  - Arch: `sudo pacman -S zenity`
  - If not installed, falls back to terminal prompts
- **Steam** and/or **Lutris** for running games
- **Proton/Wine** environment

---

## Installation

### 1. Download or clone this repository

```bash
git clone https://github.com/yourusername/linux-game-helper.git
cd linux-game-helper
```

Your directory should contain:
- `linuxgh` – main Python script
- `install.sh` – installation script
- `uninstall.sh` – uninstallation script
- `linuxgh.png` – application icon

### 2. Make scripts executable

```bash
chmod +x install.sh uninstall.sh
```

### 3. Run the installer

```bash
./install.sh
```

The installer will:
- Install `linuxgh` to `/usr/local/bin/`
- Create config directory at `~/.config/linuxgh/`
- Install the icon to `/usr/share/pixmaps/`
- Create a desktop entry for the application menu
- Update desktop and icon caches

### 4. Verify installation

```bash
which linuxgh
# Should output: /usr/local/bin/linuxgh

linuxgh ls
# Should output nothing (no games running yet)
```

---

## Usage

### Steam Setup

For each game where you want to use trainers:

1. **Right-click the game** in your Steam library
2. Select **Properties…**
3. In the **Launch Options** field, enter:
   ```bash
   linuxgh init %command%
   ```
4. Click **OK** or close the properties window

This tells Steam to wrap the game launch with `linuxgh`, which captures the Proton/Wine context.

---

### Running Trainers

#### Method 1: Application Menu (Recommended)

1. **Start your game** from Steam or Lutris (with launch options configured)
2. Once the game is running, open your **application menu**
3. Search for **"Linux Game Helper"** or **"Game"**
4. Click the **Linux Game Helper** icon
5. Choose **Trainer** or **OtherExe**

#### Method 2: Terminal

1. **Start your game** from Steam
2. Open a terminal and run:
   ```bash
   linuxgh
   ```
3. Choose **Trainer** or **OtherExe** in the dialog

#### Method 3: Keyboard Shortcut

1. Set up a custom keyboard shortcut in your desktop environment
2. Command: `linuxgh`
3. Example: `Super+T` to launch trainers

---

### Trainer vs OtherExe

When you run `linuxgh`, you'll see two options:

#### **Trainer**
- For game trainers you use regularly
- First time: Browse and select your trainer `.exe`
- Path is **saved** to `~/.config/linuxgh/trainer_config.ini`
- Next time: Trainer launches immediately without browsing
- One trainer per game (can be changed by reselecting)

#### **OtherExe**
- For one-time executables (Cheat Engine, tools, etc.)
- Browse and select any `.exe` each time
- Path is **not saved**
- Useful for testing or occasional use

---

## Configuration

### Config File Location

```
~/.config/linuxgh/trainer_config.ini
```

### Format

```ini
[Game Trainer Locations]
123456 - = "/path/to/SomeGame/trainer.exe"
654321 - = "/path/to/AnotherGame/trainer.exe"
```

- `123456` is the Steam App ID
- You can manually edit this file to change trainer paths
- Paths should be absolute (full path from root)

---

## Command-Line Interface

`linuxgh` supports both GUI and CLI modes:

### Initialize (Steam hook)

```bash
linuxgh init %command%
```

Used in Steam launch options. Captures game context and runs the game.

### List running games

```bash
linuxgh ls
```

Shows App IDs of games currently running with `linuxgh` context:

```
123456
654321
```

### Run command in game context

```bash
linuxgh run <appid> <command>
```

Example:

```bash
linuxgh run 123456 "/path/to/trainer.exe"
```

Runs the specified command in the Proton/Wine prefix of the game with App ID `123456`.

### GUI launcher (no arguments)

```bash
linuxgh
```

Opens the GUI dialog to select Trainer or OtherExe for the currently running game.

---

## Troubleshooting

### "No game context found"

**Problem:** The GUI says no game is detected.

**Solution:**
- Make sure you added `linuxgh init %command%` to the game's Steam launch options
- Restart the game from Steam
- Then run `linuxgh`
- Do the same steps for lutris without %command% and include the environment variable

**Verify:**
```bash
linuxgh ls
```
Should show the App ID of your running game.

---

### Trainer doesn't launch

**Problem:** Selected a trainer but nothing happens.

**Solution:**
- Check the config file: `~/.config/linuxgh/trainer_config.ini`
- Make sure the path is correct and the `.exe` still exists
- Try reselecting the trainer:
  1. Run `linuxgh`
  2. Choose **Trainer**
  3. Browse to the correct `.exe` again

---

### zenity not found

**Problem:** Dialogs don't appear, or you see terminal prompts instead.

**Solution:** Install zenity:

- **Debian/Ubuntu:**
  ```bash
  sudo apt install zenity
  ```

- **Fedora:**
  ```bash
  sudo dnf install zenity
  ```

- **Arch:**
  ```bash
  sudo pacman -S zenity
  ```

- **openSUSE:**
  ```bash
  sudo zypper install zenity
  ```

After installing, `linuxgh` will automatically use GUI dialogs.

---

### Icon doesn't appear in menu

**Problem:** Application menu doesn't show the Linux Game Helper icon.

**Solution:**
- Make sure `linuxgh.png` was in the directory when you ran `install.sh`
- Manually update the desktop database:
  ```bash
  update-desktop-database ~/.local/share/applications
  ```
- Log out and log back in
- Check if the desktop file exists:
  ```bash
  cat ~/.local/share/applications/linuxgh.desktop
  ```

---

### Multiple games running

**Problem:** You have multiple games running and `linuxgh` picks the wrong one.

**Current behavior:** `linuxgh` automatically selects the first detected game.

**Workaround:**
- Close other games before launching trainers
- Or use the CLI:
  ```bash
  linuxgh ls  # See all running game IDs
  linuxgh run <appid> "/path/to/trainer.exe"
  ```

**Future enhancement:** Multi-game selection dialog (Maybe).

---

## Uninstallation

### 1. Run the uninstall script

```bash
cd /path/to/linux-game-helper
./uninstall.sh
```

The script will:
- Remove `/usr/local/bin/linuxgh`
- Remove the icon from `/usr/share/pixmaps/`
- Remove the desktop entry
- Ask if you want to remove `~/.config/linuxgh/` (your trainer configs)

### 2. Remove Steam launch options

For each game you configured:
1. Right-click game → Properties
2. Clear the Launch Options field (remove `linuxgh init %command%`)

---

## Advanced Usage

### Custom config location

Edit the `linuxgh` script and change this line:

```python
config_dir = Path.home() / ".config" / "linuxgh"
```

To your preferred location.

---

### Running with Lutris

`linuxgh` automatically detects Lutris Wine and Lutris Proton runners.

**Setup:**
1. In Lutris, right-click your game → **Configure**
2. Go to **System options** tab
3. In **Command prefix**, add:
   ```bash
   linuxgh init
   ```
4. In **Environment variables**, add:
   ```bash
    SteamAppID       Value
   ```
5. Save and launch the game
6. Run `linuxgh` as normal

---

### Debugging

Enable verbose output by running:

```bash
linuxgh ls
```

Check the runtime directory:

```bash
ls -la $XDG_RUNTIME_DIR/linuxgh/
```

Each running game should have a directory with:
- `exe` – Proton/Wine executable path
- `pfx` – Wine prefix path
- `env` – Environment variables

---

## File Locations

| Item | Location |
|------|----------|
| Main script | `/usr/local/bin/linuxgh` |
| Config file | `~/.config/linuxgh/trainer_config.ini` |
| Desktop entry | `~/.local/share/applications/linuxgh.desktop` |
| Icon | `/usr/share/pixmaps/linuxgh.png` |
| Runtime data | `$XDG_RUNTIME_DIR/linuxgh/<appid>/` |

---

## FAQ

### Does this work with non-Steam games?

Yes, if you run them through Lutris with Wine or Proton.

### Can I use this with native Linux games?

No, `linuxgh` is specifically for running Windows executables in Wine/Proton prefixes.

### Does this require Steam to be running?

Yes, for Steam games. The game must be launched through Steam with the modified launch options.

### Can I run multiple trainers at once?

Yes, but only one trainer can be saved per game. For additional executables, use the **OtherExe** option.

### Is this safe?

`linuxgh` itself is safe – it's just a Python script that wraps Proton/Wine commands. However, **trainers and cheats** may:
- Trigger anti-cheat systems (use offline or in single-player only)
- Contain malware (only download trainers from trusted sources)
- Violate game terms of service

**Use at your own risk.**

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## License

[Choose your license – MIT, GPL, etc.]

---

## Credits

- Inspired by [protonhax](https://github.com/Will40/protonhax) This is not an endorsement or promotion from them.
- Built for the Linux gaming community

---
