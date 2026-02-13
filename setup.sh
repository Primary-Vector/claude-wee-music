#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUSIC_DIR="$SCRIPT_DIR/Nintendo Wii Music Collection"
ZIP_URL="https://archive.org/compress/nintendo-wii-music-collection"
ZIP_FILE="$SCRIPT_DIR/nintendo-wii-music-collection.zip"

if [ -d "$MUSIC_DIR" ] && ls "$MUSIC_DIR"/*.mp3 &>/dev/null; then
    echo "Music collection already exists at: $MUSIC_DIR"
    echo "$(ls "$MUSIC_DIR"/*.mp3 | wc -l | tr -d ' ') mp3 files found. You're good to go!"
    exit 0
fi

echo "Downloading Music Collection from archive.org..."
curl -L -o "$ZIP_FILE" "$ZIP_URL"

echo "Extracting..."
unzip -o "$ZIP_FILE" -d "$SCRIPT_DIR"

echo "Cleaning up..."
rm -f "$ZIP_FILE"
# Remove archive.org metadata junk
rm -f "$SCRIPT_DIR"/nintendo-wii-music-collection_*.xml \
      "$SCRIPT_DIR"/nintendo-wii-music-collection_*.sqlite \
      "$SCRIPT_DIR"/nintendo-wii-music-collection_*.torrent \
      "$SCRIPT_DIR"/__ia_thumb.jpg

if [ -d "$MUSIC_DIR" ] && ls "$MUSIC_DIR"/*.mp3 &>/dev/null; then
    echo "Done! $(ls "$MUSIC_DIR"/*.mp3 | wc -l | tr -d ' ') mp3 files ready."
else
    echo "Error: extraction didn't produce expected music directory."
    echo "Check if the zip structure has changed."
    exit 1
fi
