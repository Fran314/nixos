#!/usr/bin/env bash

echo $1 \
    | sed 's/Soundcore Life Q30/Cuffie/' \
    | sed 's/Family 17h\/19h HD Audio Controller Speaker + Headphones/Main/' \
    | sed 's/Family 17h\/19h HD Audio Controller Speaker/Main/' \
    | sed 's/Echo Dot-31F/Dot/'
