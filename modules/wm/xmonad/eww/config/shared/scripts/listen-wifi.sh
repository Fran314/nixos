#!/usr/bin/env bash

cd "$(dirname "$0")"

PERIOD=2

RX=$(cat /sys/class/net/wlp4s0/statistics/rx_bytes)
TX=$(cat /sys/class/net/wlp4s0/statistics/tx_bytes)
LASTID=""
SHOULD_EXPAND="false"

while true
do
    NEWRX=$(cat /sys/class/net/wlp4s0/statistics/rx_bytes)
    NEWTX=$(cat /sys/class/net/wlp4s0/statistics/tx_bytes)
    DIFFRX=$(( ($NEWRX - $RX) / $PERIOD))
    DIFFTX=$(( ($NEWTX - $TX) / $PERIOD))

    # CONNECTION=$(nmcli | grep -oP "wlp4s0: collegato to \K(.*)")
    CONNECTION=$(nmcli | grep -oP "wlp4s0: connected to \K(.*)")
    if [[ $CONNECTION != $LASTID ]]
    then
        SHOULD_EXPAND="true"
    else
        SHOULD_EXPAND="false"
    fi
    LASTID=$CONNECTION

    # VPN_STATUS=$(mullvad status | grep -oP "(Disconnected|in \K.*)")
    # echo "{ \"connection\": \"$CONNECTION\", \"rx\": $(./format-bytes.py $DIFFRX), \"tx\": $(./format-bytes.py $DIFFTX), \"should_expand\": \"$SHOULD_EXPAND\", \"vpn\": \"$VPN_STATUS\"}"

    echo "{ \"connection\": \"$CONNECTION\", \"rx\": $(./format-bytes.py $DIFFRX), \"tx\": $(./format-bytes.py $DIFFTX), \"should-expand\": \"$SHOULD_EXPAND\", \"vpn\": \"Disconnected\"}"

    RX=$NEWRX
    TX=$NEWTX

    sleep $PERIOD
done
