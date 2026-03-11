#!/bin/bash

CACHE="/tmp/ip_data.json"
API="http://ip-api.com/json"

# --- FUNCTIONS ---

get_icon() {
    # Check if a VPN interface (containing tun, wg, or tap anywhere in the name) exists
    if ip link | grep -qE '^[0-9]+: .*(tun|wg|tap)'; then
        echo "󰌾" # Padlock icon for VPN
    else
        echo "󰩠" # Standard IP icon
    fi
}

fetch_data() {
    # 2s timeout to avoid freezing the bar during network transitions
    DATA=$(curl -s --connect-timeout 2 "$API")
    ICON=$(get_icon)
    
    # Polybar color tags to keep the icon Sky Blue (#89dceb)
    COLOR_ICON="%{F#89dceb}"
    COLOR_RESET="%{F-}"
    
    # Check if the JSON is valid (contains a closing brace)
    if [[ "$DATA" == *"}"* ]]; then
        # Save to cache
        echo "$DATA" > "$CACHE"
        # Extract IP
        IP=$(echo "$DATA" | jq -r '.query')
        
        # Print colored icon and the IP for Polybar
        echo "${COLOR_ICON}${ICON}${COLOR_RESET} $IP"
    else
        # If curl fails or no internet, print Offline
        echo "${COLOR_ICON}${ICON}${COLOR_RESET} Offline"
    fi
}

handle_click_left() {
    if [ -f "$CACHE" ]; then
        IP=$(jq -r '.query' "$CACHE")
        # Check if IP is valid and not null
        if [ "$IP" != "null" ]; then
            echo -n "$IP" | xclip -selection clipboard
            notify-send -u normal -t 1000 "󰩠 IP Copied" "$IP"
        fi
    fi
    # Force an immediate visual refresh
    fetch_data
}

handle_click_right() {
    if [ -f "$CACHE" ]; then
        IP=$(jq -r '.query' "$CACHE")
        ISP=$(jq -r '.isp' "$CACHE")
        COUNTRY=$(jq -r '.country' "$CACHE")
        CITY=$(jq -r '.city' "$CACHE")
        
        notify-send -u normal "IP Status 🌍" "<b>IP:</b> $IP\n<b>Country:</b> $COUNTRY\n<b>City:</b> $CITY\n<b>ISP:</b> $ISP"
    else
        notify-send -u critical "IP Status" "Currently Offline"
    fi
}

# --- SIGNAL HANDLING (Polybar Clicks) ---
trap 'handle_click_left' USR1
trap 'handle_click_right' USR2

# --- MAIN LOOP (Events + 5min Timer) ---

# 1. Initial fetch on startup
fetch_data

# 2. Infinite Loop logic:
while true; do
    # Wait for a kernel event on FD 3 OR timeout after 5 minutes (300s)
    # -t 300: Acts as the polling timer
    read -r -t 300 line <&3
    
    # Check exit code of 'read':
    # 0 = Event detected (Network changed)
    # >0 = Timeout or other interruption
    if [ $? -eq 0 ]; then
        # Network change detected: sleep briefly to let the connection stabilize
        sleep 1
    fi
    
    # Perform the API request and update the bar
    fetch_data
    
done 3< <(ip monitor address | grep --line-buffered "inet ")