#!/bin/bash

# --- Catppuccin Mocha Palette ---
BG="1e1e2e66"
TEXT="cdd6f4ff"
MAUVE="cba6f7ff"
RED="f38ba8ff"
GREEN="a6e3a1ff"
SURFACE1="45475aff"
PEACH="fab387ff"

# Font definition
FONT="JetBrainsMono Nerd Font"

i3lock \
  --image="/usr/share/background/custom/tree_blurred.jpg" \
  --fill \
  --indicator \
  --radius=120 \
  --ring-width=10 \
  \
  --clock \
  --time-str="%H:%M:%S" \
  --time-font="$FONT" \
  --time-size=42 \
  --time-color="$TEXT" \
  --time-pos="x+w/2:y+h/2-170" \
  \
  --date-str="" \
  \
  --inside-color="$BG" \
  --ring-color="$SURFACE1" \
  --separator-color="00000000" \
  \
  --keyhl-color="$MAUVE" \
  --bshl-color="$RED" \
  \
  --verif-text="Verifying..." \
  --verif-font="$FONT" \
  --verif-color="$TEXT" \
  --insidever-color="$BG" \
  --ringver-color="$GREEN" \
  \
  --wrong-text="Failure!" \
  --wrong-font="$FONT" \
  --wrong-color="$RED" \
  --insidewrong-color="$BG" \
  --ringwrong-color="$RED" \
  \
  --greeter-text="Type Password..." \
  --greeter-font="$FONT" \
  --greeter-color="$TEXT" \
  --greeter-size=16 \
  --greeter-pos="x+w/2:y+h/2+170" \
  \
  --modif-color="$PEACH" \
  --layout-font="$FONT" \
  --layout-color="$TEXT" \
  --force-clock
