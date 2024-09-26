#!/bin/bash

cd "$(dirname "$0")"

DISPLAY_TIME=2

DEVICES=($(bluetoothctl info | grep -oP "Device \K(..:..:..:..:..:..)"))

if [[ ${#DEVICES[@]} -gt 0 ]]
then
	NUMBER=$(($(date '+%s') / $DISPLAY_TIME % ${#DEVICES[@]}))
	DEVICE=$(bluetoothctl info ${DEVICES[$NUMBER]} | grep -oP "Name: \K(.*)")

    NAME=$(./parse-name-aliases.sh "$DEVICE")
    ICON=$(./parse-name-icons.sh "$NAME")
    echo "{ \"status\": \"connected\", \"device\": \"$NAME\", \"icon\": \"$ICON\" }"
else
    echo "{ \"status\": \"disconnected\", \"device\": \"\", \"icon\": \"\" }"
fi
