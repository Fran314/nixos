#!/usr/bin/env bash

MUTE=$(pamixer --get-mute)
if [[ $MUTE == "true" ]]; then
	echo "muted"
else
	echo "unmuted"
fi
