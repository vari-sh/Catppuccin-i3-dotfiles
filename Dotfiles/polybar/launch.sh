#!/usr/bin/env bash

# Terminate already running polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar named "example" (or the name specified in your config.ini)
# In the Catppuccin theme, the bar is usually named "main" or "example"
# Check the config.ini file for the exact name, but you can try this generic command:
polybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar started..."