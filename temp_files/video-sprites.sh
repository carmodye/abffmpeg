#!/bin/bash

# This script creates an animated gif from the first 10 seconds of a video.
# The animated gif is used for video previews.

if [ "$#" -ne "1" ]; then
	echo "Usage: $0 file"
	echo "  file  absolute path to video file to create animated gif for"
	exit 1
fi

# require absolute path
if [[ "$1" != /* ]]; then
	echo "$1 must be an absolute path"
	exit 1
fi

# check file
if [ ! -f "$1" ]; then
	echo "file $1 does not exist"
	exit 1
fi

IN=$1
DIR=$(dirname "$IN")
NAME=$(basename "$IN")

SPRITES=.sprites

if [ ! -d "$DIR/$SPRITES" ]; then
	mkdir "$DIR/$SPRITES"
fi

OUTNAME=${NAME%.*}.gif
OUT=$DIR/$SPRITES/$OUTNAME

# get input width and height
INFO=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${IN}")

# ffprobe outputs WIDTHxHEIGHT, we'll split at 'x'
IN_WIDTH=$(echo $INFO | sed 's/\(.*\)x\(.*\)/\1/')
IN_HEIGHT=$(echo $INFO | sed 's/\(.*\)x\(.*\)/\2/')

# we're scaling down by a factor of 10, and we want all the frames in the first 10 seconds
SCALE=10
TIME=10

# output width and height
OW=$(($IN_WIDTH / $SCALE))
OH=$(($IN_HEIGHT / $SCALE))

# make animated gif file
FILTER="fps=10,scale=${OW}:${OH}:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"
CMD="ffmpeg -y -v quiet -t ${TIME} -i \"${IN}\" -vf \"${FILTER}\" -loop 0 \"${OUT}\""
eval $CMD

echo $OUT
exit 0
