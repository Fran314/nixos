#!/bin/bash

BARS=$(nmcli -f IN-USE,BARS dev wifi | sed -n 's/\*\s*\(.*\)\s/\1/p')

if [[ $BARS == "____" ]]; then
    echo "0"
elif [[ $BARS == "▂___" ]]; then
    echo "1"
elif [[ $BARS == "▂▄__" ]]; then
    echo "2"
elif [[ $BARS == "▂▄▆_" ]]; then
    echo "3"
else
    # NOTE: this causes the script to output a signal strength of 4 even when
    # the value of BARS is "". This is intended behaviour to avoid weird
    # results when using this script to decide which wifi icon should be
    # displayed (it might be the case that the wifi just connected but we
    # didn't update the bars just yet so it would show an empty wifi signal,
    # which might be scary. I'd rather show full strength by default and then
    # adjust to the correct number of bars
    echo "4"
fi
