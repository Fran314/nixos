#!/usr/bin/env python

import sys

def log2(bytes):
    val = 1
    exp = 0
    while(val < bytes):
        val *= 2
        exp += 1
    return exp

def rebased_log2(bytes):
    return max(0, log2(bytes) - 7)

def pretty_bytes(bytes):
    if bytes < 1000:
        return f'{bytes} B'
    elif bytes < 1000 * 100:
        return f'{round(bytes / 1000, 1)} KB'
    elif bytes < 1000 * 1000:
        return f'{int(bytes / 1000)} KB'
    elif bytes < 1000 * 1000 * 100:
        return f'{round(bytes / (1000 * 1000), 1)} MB'
    elif bytes < 1000 * 1000 * 1000:
        return f'{int(bytes / (1000 * 1000))} MB'
    elif bytes < 1000 * 1000 * 1000 * 100:
        return f'{round(bytes / (1000 * 1000 * 1000), 1)} GB'
    elif bytes < 1000 * 1000 * 1000 * 1000:
        return f'{int(bytes / (1000 * 1000 * 1000))} GB'
    else:
        return f'{bytes} B'

bytes = int(sys.argv[1])
print(f'{{ "val": "{pretty_bytes(bytes)}", "pseudolog": "{rebased_log2(bytes)}" }}')
