#!/usr/bin/env bash
for m in $(hyprctl monitors -j | jq -r '.[].name'); do
    sed "s/REPLACE_OUTPUT/$m/" ~/.config/waybar/config.jsonc > "/tmp/waybar-$m.jsonc"
    waybar -c "/tmp/waybar-$m.jsonc" &
done
