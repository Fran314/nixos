#!/usr/bin/env python

import sys
import os

aliases = [
    [lambda n: n.endswith("Mozilla Firefox"),                               "firefox"        ],
    [lambda n: n.endswith("Mozilla Firefox Private Browsing"),              "firefox-private"],
    [lambda n: n == "Spotify",                                              "spotify"        ],
    [lambda n: n == "GNU Image Manipulation Program" or n.endswith("GIMP"), "gimp"           ],
    [lambda n: n.endswith("Inkscape"),                                      "inkscape"       ],
    [lambda n: n == "Alacritty",                                            "terminal"       ]
]

def get_process_type(name):
    for [check, alias] in aliases:
        if check(name):
            return alias
    return "unknown"

def get_most_relevant_process(processes):
    for [_, alias] in aliases:
        if alias in processes:
            return alias
    return "unknown"

current = sys.argv[1]
maxws = (int(current) - 1) if current.isnumeric() else -1
data = os.popen("wmctrl -l").readlines()
workspaces = [[] for _ in range(11)]
for line in data:
    split_line = line.split()
    pos = int(split_line[1])
    name = ' '.join(split_line[3:])
    if(pos <= 8):
        maxws = max(pos, maxws)
    workspaces[pos].append(name)

numbws = ["" for _ in range(maxws + 1)]
icons = ["" for _ in range(maxws + 1)]
for i in range(maxws + 1):
    state = "visible"
    if str(i+1) == current:
        state = "current"
    elif len(workspaces[i]) > 0:
        state = "active"
    icon = get_most_relevant_process([get_process_type(window) for window in workspaces[i]])

    numbws[i] = f'{{ "id": "{i+1}", "state": "{state}", "icon": "{icon}" }}'

dashboard_state = "visible"
if current == "dashboard":
    dashboard_state = "current"

scratchpad_state = "invisible"
if current == "scratchpad":
    scratchpad_state = "current"
elif len(workspaces[10]) > 0:
    scratchpad_state = "visible"

print(f'{{ "numbered-ws": [ {", ".join(numbws)} ], "dashboard": "{dashboard_state}", "scratchpad": "{scratchpad_state}", "current": "{current}" }}')
