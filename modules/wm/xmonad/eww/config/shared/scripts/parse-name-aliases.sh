#!/usr/bin/env bash

echo "$1" |
	sed 's/Soundcore Life Q30/Cuffie/' |
	sed 's/Family 17h\/19h\/1ah HD Audio Controller Speaker + Headphones/Main/' |
	sed 's/Family 17h\/19h\/1ah HD Audio Controller Speaker/Main/' |
	sed 's/Renoir Radeon High Definition Audio Controller HDMI \/ DisplayPort 2 Output/HDMI/' |
	sed 's/Renoir Radeon High Definition Audio Controller HDMI \/ DisplayPort 1 Output/HDMI/' |
	sed 's/Echo Dot-31F/Dot/'
