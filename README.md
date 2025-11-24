Linux-Game-Helper

Linux-Game-Helper is a small utility that uses `protonhax` to run Windows executables (trainers or other tools) inside Steam’s Proton environment.

This Python application simplifies the process of running external tools (like game trainers or other executables) with your Proton-enabled Steam games. It automatically detects the running game using `protonhax`, and provides a user-friendly GUI to either:

- Launch a **pre-configured trainer** for the current game, or  
- Select and run a **different executable (OtherExe)** on the fly  

All of this happens without needing to open a terminal window.

Many Linux users are not comfortable with the terminal, so this tool is designed to make running executables inside Steam’s Proton instance as simple and user-friendly as possible.



Features

- ✅ Automatically detects the currently running game via `protonhax ls`
- ✅ Offers a **Trainer / OtherExe** choice when a game is detected
- ✅ For **Trainer**:
  - Looks up a saved trainer path for the current GameID
  - Prompts to select a trainer if none is configured
  - Saves trainer paths per game in a simple config file
- ✅ For **OtherExe**:
  - Lets you select any `.exe` (or other file) and runs it under the same Proton instance
  - **Does not** save this path to the config (one-off run)
- ✅ Runs via `nohup protonhax run ... >/dev/null 2>&1 &` (no terminal window)
- ✅ GUI only appears when user input is required (no noisy popups in normal use)



How It Works

1. On start, the script runs:

   protonhax ls

   and parses the output to find the current Steam **GameID**.

2. If no GameID is found, a GUI message is shown:

   > Protonhax GameID Not Found Running

3. If a GameID is found, a dialog appears:

   - **Trainer** → Use the configured trainer for this GameID (or ask you to pick one and save it).
   - **OtherExe** → Let you pick any executable and run it without saving to config.

4. For configured trainers, the tool stores mappings in a config file next to the script, for example:

   [Game Trainer Locations]
   3489700 - = "/home/youruser/Applications/Games/Steam/common/StellarBlade/SBTrainer.exe"

5. When launching, it uses:

   nohup protonhax run <GameID> "/path/to/exe" >/dev/null 2>&1 &

   so it runs in the background with no open terminal.



Dependencies

System Requirements

- A Linux distribution with:
  - **Python 3** (most distros include this by default)
  - A working Steam + Proton setup
  - The `protonhax` tool installed and configured

Required Tools

1. **Python 3**

   Check if Python 3 is installed:

   python3 --version

2. **protonhax**

   Linux-Game-Helper relies on `protonhax` to:

   - Detect which Proton game is currently running (`protonhax ls`)
   - Run the trainer/other executable in that same Proton context (`protonhax run`)

   Install and configure `protonhax` according to its documentation.

3. **wxPython** (for the GUI)

   The GUI is built with **wxPython**. You can install it via your distro or `pip`.

   **Ubuntu / Debian:**

   sudo apt update
   sudo apt install python3-wxgtk4.0

   **Arch / Manjaro:**

   sudo pacman -S python-wxpython

   **Fedora:**

   sudo dnf install python3-wxpython4

   **Via pip (any distro):**

   pip install wxPython



<h1>Installation</h1>

1. **Clone the repository:**

   git clone https://github.com/<yourusername>/Linux-Game-Helper.git
   cd Linux-Game-Helper

2. **Ensure dependencies are installed:**

   - `python3`
   - `protonhax`
   - `wxPython`

3. **(Optional) Make the script executable:**

   If your main script is named `trainer.py` (or similar):

   chmod +x trainer.py



Usage

1. Make sure your Proton game is **running** (started from Steam).

2. Run Linux-Game-Helper from a terminal or a launcher:

   ./trainer.py

   or:

   python3 trainer.py

3. The program will:

   - Call `protonhax ls` to detect the active GameID.
   - If no game is detected, show:

     > Protonhax GameID Not Found Running

   - If a game is detected, show a dialog:

     - **Trainer**  
       - If a trainer is configured for this GameID and the file exists → it will be launched immediately.  
       - If no trainer is configured, you’ll be asked to browse for the trainer executable. Once selected, it is saved in the config and used automatically next time.

     - **OtherExe**  
       - You’ll be asked to select *any* executable.  
       - It will be launched under the current Proton instance.  
       - This path is **not** saved to the config (one-time run).



Configuration File

The script stores trainer paths per game in a config file located in the same directory as the script, typically called:

trainer_config.ini

Example structure:

[Game Trainer Locations]
3489700 - = "/home/youruser/Applications/Games/Steam/common/StellarBlade/SBTrainer.exe"

- The key is `<GameID> -`
- The value is the quoted absolute path to the trainer executable.

You generally don’t need to edit this file manually—the GUI will update it when you select trainers—but you *can* tweak it if you know what you’re doing.



Notes & Limitations

- This tool depends on `protonhax` being correctly installed and able to detect your running Proton games.
- The program only shows a GUI when:
  - No game is detected.
  - A trainer is not configured or the path is invalid.
  - You need to choose between **Trainer** and **OtherExe**.
- All launches are done in the background with `nohup` and output redirected to `/dev/null`, so you won’t see a console window.



Roadmap / Ideas

- Support for multiple trainers per game.
- Optional CLI flags to bypass the GUI and run specific modes directly.
- Export/import of trainer configurations between machines.



License

Add your chosen license here (e.g., MIT, GPL-3.0, etc.):

MIT License
...



Contributions

Pull requests and suggestions are welcome. If you have ideas to improve detection, add more integrations, or enhance the UI, feel free to open an issue or pull request.
