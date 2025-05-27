#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

output_info() {
    VOLUME=$(./get-volume.sh)
    MUTE=$(./get-mute.sh)
    SINK=$(./get-sink.sh)

    echo "{ \"volume\": $VOLUME, \"mute\": \"$MUTE\", \"sink\": $SINK }"
}

output_info_on_newline() {
    while read -r UNUSED_LINE; do
        output_info
    done
}

# Output volume once when run for the initial value
output_info

# Listen to sink changes and output volume every sink update
pactl subscribe | stdbuf -o0 grep --line-buffered "sink" | output_info_on_newline
