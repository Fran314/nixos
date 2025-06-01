#!/usr/bin/env bash

date "+%A %d %B %Y %H %M %S" |
	sed 's/\(...\)\([a-zì]*\) \([0-9]*\) \(...\)\([a-z]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\)/{ "day-short": "\u\1", "day-remaining": "\2", "date": "\3", "month-short": "\u\4", "month-remaining": "\5", "year": "\6", "hours": "\7", "minutes": "\8", "seconds": "\9" }/'
