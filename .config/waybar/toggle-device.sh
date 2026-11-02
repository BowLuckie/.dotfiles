#!/usr/bin/env bash

MAC="${TARGET_BT_MAC:-}"

if [[ -z "$MAC" ]]; then
    echo "Set TARGET_BT_MAC to your target bluetooth devices MAC address"
    exit 1
fi

if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$MAC"
else
    bluetoothctl connect "$MAC"
fi
