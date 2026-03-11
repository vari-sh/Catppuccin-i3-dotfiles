#!/bin/bash

# Check if picom is running
if pgrep -x "picom" > /dev/null
then
    # If running, kill it
    killall picom
    notify-send "Picom" "Compositor OFF\n󰾆 Performance Mode"
else
    # If not running, start it in background with your config
    # Replace the path if your config is in a different place
    env LIBGL_ALWAYS_SOFTWARE=0 picom --config ~/.config/picom/picom.conf -b
    notify-send "Picom" "Compositor ON\n󰄬 Appearance Mode"
fi