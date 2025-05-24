#!/usr/bin/env bash

cd "$(dirname "$0")"

output_info_on_newline() {
    while read -r XMONAD_INFO
    do
        CURRENT_WS=$(sed 's/.*"\(.*\)"/\1/' <<< $XMONAD_INFO)
        ./get-workspaces-info.py $CURRENT_WS
    done
}

# Listen to sink changes and output volume every sink update
xprop -spy -root _XMONAD_LOG | output_info_on_newline
