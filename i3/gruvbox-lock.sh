#!/bin/bash

BG="$HOME/images/neckhurt.jpg"
TMP="/tmp/betterlockscreen-gruvbox-$$.png"

# Generate blurred background
if command -v magick >/dev/null 2>&1; then
    magick convert "$BG" -blur 0x7 "$TMP"
elif command -v convert >/dev/null 2>&1; then
    convert "$BG" -blur 0x7 "$TMP"
else
    cp "$BG" "$TMP"
fi

# Update betterlockscreen cache image
betterlockscreen -u "$TMP"

# Lock screen with betterlockscreen and pass i3lock-color options for Gruvbox theme
betterlockscreen -l -- \
  --clock \