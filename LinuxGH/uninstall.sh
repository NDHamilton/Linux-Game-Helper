#!/bin/bash

# Linux Game Helper Uninstall Script

set -e

echo "======================================"
echo "Linux Game Helper - Uninstall Script"
echo "======================================"
echo ""

# Check if NOT running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs sudo privileges to remove from /usr/local/bin"
    echo "Restarting with sudo..."
    echo ""
    exec sudo "$0" "$@"
fi

# Get the actual user (not root) who invoked sudo
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="linuxgh"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
CONFIG_DIR="$ACTUAL_HOME/.config/linuxgh"
DESKTOP_FILE="$ACTUAL_HOME/.local/share/applications/linuxgh.desktop"

# Remove the script
if [ -f "$SCRIPT_PATH" ]; then
    echo "Removing $SCRIPT_PATH"
    rm "$SCRIPT_PATH"
    echo "✓ Script removed"
else
    echo "Script not found at $SCRIPT_PATH"
fi

echo ""

# Remove icon files
ICON_REMOVED=false
if [ -f "/usr/share/pixmaps/linuxgh.png" ]; then
    echo "Removing icon: /usr/share/pixmaps/linuxgh.png"
    rm /usr/share/pixmaps/linuxgh.png
    ICON_REMOVED=true
fi

if [ -f "/usr/share/pixmaps/linuxgh.svg" ]; then
    echo "Removing icon: /usr/share/pixmaps/linuxgh.svg"
    rm /usr/share/pixmaps/linuxgh.svg
    ICON_REMOVED=true
fi

if [ "$ICON_REMOVED" = true ]; then
    echo "✓ Icon removed"
    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache -f -t /usr/share/pixmaps 2>/dev/null || true
    fi
fi

echo ""

# Remove desktop file
if [ -f "$DESKTOP_FILE" ]; then
    echo "Removing desktop entry: $DESKTOP_FILE"
    rm "$DESKTOP_FILE"
    echo "✓ Desktop entry removed"

    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        DESKTOP_DIR="$ACTUAL_HOME/.local/share/applications"
        sudo -u "$ACTUAL_USER" update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
    fi
else
    echo "Desktop entry not found"
fi

echo ""


if [ -d "$CONFIG_DIR" ]; then
    echo "Configuration directory found: $CONFIG_DIR"
    if sudo -u "$ACTUAL_USER" bash -c 'read -p "Do you want to remove the configuration directory? (y/N): " -n 1 -r; echo ""; [[ $REPLY =~ ^[Yy]$ ]]'; then
        rm -rf "$CONFIG_DIR"
        echo "✓ Configuration directory removed"
    else
        echo "Configuration directory kept"
    fi
else
    echo "No configuration directory found"
fi

echo ""
echo "======================================"
echo "Uninstall complete!"
echo "======================================"
echo ""
echo "Don't forget to remove the launch options from your Steam games:"
echo "   linuxgh init %command%"
echo ""
