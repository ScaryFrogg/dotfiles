#!/usr/bin/env bash

set -e

# Usage: ./install_nerd_font.sh "FiraCode"
FONT_NAME="$1"

if [ -z "$FONT_NAME" ]; then
    echo "Error: No font name provided."
    echo "Usage: $0 \"FiraCode\""
    exit 1
fi

# Remove spaces for GitHub release zip names
FONT_NAME_CLEAN=$(echo "$FONT_NAME" | tr -d ' ')

RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME_CLEAN}.zip"

INSTALL_DIR="$HOME/.local/share/fonts/NerdFonts"

echo "📥 Downloading $FONT_NAME Nerd Font..."
mkdir -p "$INSTALL_DIR"
cd /tmp

if ! curl -L --fail --progress-bar "$RELEASE_URL" -o "${FONT_NAME_CLEAN}.zip"; then
    echo "❌ Failed to download font. Check the font name."
    echo "Available fonts: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts"
    exit 1
fi

echo "📦 Extracting..."
unzip -q "${FONT_NAME_CLEAN}.zip" -d "$INSTALL_DIR"

echo "🧹 Cleaning up..."
rm "${FONT_NAME_CLEAN}.zip"

echo "🔄 Updating font cache..."
fc-cache -fv > /dev/null

echo "✅ $FONT_NAME Nerd Font installed successfully!"
