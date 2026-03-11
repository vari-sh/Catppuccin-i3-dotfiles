#!/bin/bash

# Opzioni
lock="  Lock"
logout="󰗽  Logout"
reboot="  Reboot"
shutdown="  Shutdown"

# Metti tutto in una variabile
options="$lock\n$logout\n$reboot\n$shutdown"

# Apri Rofi
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Power" -config ~/.config/rofi/config.rasi)

# Esegui il comando in base alla scelta
case "$selected_option" in
    "$lock")
        betterlockscreen -l blur
        ;;
    "$logout")
        i3-msg exit
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac