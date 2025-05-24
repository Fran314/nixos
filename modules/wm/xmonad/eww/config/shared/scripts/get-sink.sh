#!/usr/bin/env bash


SINK_NAME=$(pamixer --get-default-sink | grep -oP '".*" "\K.*(?=")')
SINK_DISPLAY_NAME=$(./parse-name-aliases.sh "$SINK_NAME")
if [[ ${#SINK_DISPLAY_NAME} -gt 15 ]]; then

    # The only purpose of xargs here is to trim the cut string to avoid
    # weird whitespaces
    SINK_DISPLAY_NAME="$(cut -c 1-15 <<< $SINK_DISPLAY_NAME | xargs)..."
fi
ICON=$(./parse-name-icons.sh "$SINK_DISPLAY_NAME")
echo "{ \"name\": \"$SINK_DISPLAY_NAME\", \"icon\": \"$ICON\" }"
