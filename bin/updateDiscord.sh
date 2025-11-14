#!/usr/bin/env bash
set -euo pipefail

TMPDIR="$(mktemp -d)"
DEB_PATH="$TMPDIR/discord.deb"
DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=deb"

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

echo "Using temp dir: $TMPDIR"
echo "Downloading Discord (.deb) with curl..."
curl -L --fail -o "$DEB_PATH" "$DOWNLOAD_URL"

if ! command -v sudo >/dev/null 2>&1; then
    echo "Warning: sudo not found. Attempting to run dpkg as current user (likely to fail)." >&2
fi

echo "Installing Discord (.deb)..."
if sudo dpkg -i "$DEB_PATH"; then
    echo "dpkg install completed."
else
    echo "dpkg reported issues; attempting to fix dependencies..."
    sudo apt-get update -y
    sudo apt-get install -f -y
fi

echo "Cleaning up downloaded file..."
rm -f "$DEB_PATH"

if command -v discord >/dev/null 2>&1; then
    echo "Starting Discord (detached)..."
    setsid discord >/dev/null 2>&1 &
    disown || true
    echo "Discord started."
else
    echo "Warning: 'discord' executable not found in PATH after installation." >&2
fi

echo "Done."
