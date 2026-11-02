#!/usr/bin/env bash
export HYPRLAND_INSTANCE_SIGNATURE=$(
    hyprctl instances | awk '/^instance / { sub(/:$/, "", $2); print $2 }'
)
