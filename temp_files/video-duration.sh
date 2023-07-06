#!/bin/bash

if [ "$#" -ne "1" ]; then
	echo "Usage: $0 file"
	echo "  file  video file to get the duration for"
	exit 1
fi

# check file
if [ ! -f $1 ]; then
	echo "file $1 does not exist"
	exit 1
fi

IN=$1

DURATION=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $IN)
printf "%.*f\n" 0 "$DURATION"

exit 0
