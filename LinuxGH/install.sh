#!/bin/bash

# Linux Game Helper Install Script

set -e

echo "==================================="
echo "Linux Game Helper - Install Script"
echo "==================================="
echo ""

# Check if NOT running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs sudo privileges to install to /usr/local/bin"
    echo "Restarting with sudo..."
    echo ""
    exec sudo "$0" "$@"
fi


ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)


INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="linuxgh"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Check if linuxgh script exists in current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -f "$SCRIPT_DIR/linuxgh" ]; then
    echo "ERROR: linuxgh script not found in $SCRIPT_DIR"
    echo "Please run this install script from the directory containing the linuxgh script."
    exit 1
fi


echo "Installing linuxgh to $SCRIPT_PATH"
cp "$SCRIPT_DIR/linuxgh" "$SCRIPT_PATH"
chmod 755 "$SCRIPT_PATH"

# Create config directory for the actual user (not root)
CONFIG_DIR="$ACTUAL_HOME/.config/linuxgh"
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating config directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    chown "$ACTUAL_USER:$ACTUAL_USER" "$CONFIG_DIR"
fi

# Install icon if it exists
ICON_INSTALLED=false
if [ -f "$SCRIPT_DIR/linuxgh.png" ]; then
    echo "Installing icon to /usr/share/pixmaps/linuxgh.png"
    cp "$SCRIPT_DIR/linuxgh.png" /usr/share/pixmaps/linuxgh.png
    chmod 644 /usr/share/pixmaps/linuxgh.png
    ICON_INSTALLED=true
else
    echo "No icon file found (linuxgh.png), using default icon"
fi

# Create .desktop file
DESKTOP_DIR="$ACTUAL_HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/linuxgh.desktop"

echo "Creating desktop entry: $DESKTOP_FILE"
mkdir -p "$DESKTOP_DIR"


if [ "$ICON_INSTALLED" = true ]; then
    ICON_PATH="linuxgh"
else
    ICON_PATH="applications-games"
fi

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Linux Game Helper
Comment=Launch trainers and executables in Proton/Wine game prefixes
Exec=linuxgh
Icon=$ICON_PATH
Terminal=false
Categories=Game;Utility;
Keywords=steam;proton;wine;trainer;game;
StartupNotify=true
EOF


chown "$ACTUAL_USER:$ACTUAL_USER" "$DESKTOP_FILE"
chmod 644 "$DESKTOP_FILE"


if command -v update-desktop-database &> /dev/null; then
    echo "Updating desktop database..."
    sudo -u "$ACTUAL_USER" update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi


if command -v gtk-update-icon-cache &> /dev/null && [ "$ICON_INSTALLED" = true ]; then
    echo "Updating icon cache..."
    gtk-update-icon-cache -f -t /usr/share/pixmaps 2>/dev/null || true
fi

echo ""
echo "Installation complete!"
echo ""

if [ "$ICON_INSTALLED" = true ]; then
    echo "✓ Icon installed"
fi

echo "==================================="
echo "Usage Instructions:"
echo "==================================="
echo ""
echo "1. Add to Steam game launch options:"
echo "   linuxgh init %command%"
echo ""
echo "2. Start your game from Steam"
echo ""
echo "3. Run the trainer launcher:"
echo "   - From terminal: linuxgh"
echo "   - From applications menu: Search for 'Linux Game Helper'"
echo "   - Or create a keyboard shortcut to run: linuxgh"
echo ""
echo "Configuration file location:"
echo "   $CONFIG_DIR/trainer_config.ini"
echo ""
echo "Desktop entry location:"
echo "   $DESKTOP_FILE"
echo ""
echo "Note: The command 'linuxgh' can be run without sudo"
echo "==================================="
