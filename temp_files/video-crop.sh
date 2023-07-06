#!/bin/bash

# FIXME: document this script


# Join array elements using specified character
#
# usage: join_by - (a b c) # output is a-b-c
#
# param char character to use for joining
# param array array to join
# return string array elements joined with char
function join_by {
	local IFS="$1"
	shift
	echo "$*"
}

if [ "$#" -lt "2" ]; then
	echo "Usage: $(basename $0) file geometry [id] [url]"
	echo "  file      absolute path to video file to crop"
	echo "  geometry  how to crop the video file, e.g. 2x2"
	echo "  id        optional, db record id"
	echo "  url       optional, URL to POST when done"
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
BASENAME=$(basename "$IN")
NAME=${BASENAME%.*}
EXT=${IN##*.}

# check geometry, match INTxINT, e.g. 1x2, 10x2, etc.
re='^[1-9][0-9]*x[1-9][0-9]*$'
if [[ ! $2 =~ $re ]]; then
	echo "bad geometry format"
	exit 1
fi

GEO=$2
ROWS=${GEO%x*}
COLS=${GEO#*x}

# input width and height
INFO=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$IN")

# ffprobe outputs WIDTHxHEIGHT, we'll split at 'x'
IN_WIDTH=${INFO%x*}
IN_HEIGHT=${INFO##*x}

# output width and height
OW=$(($IN_WIDTH / $COLS))
OH=$(($IN_HEIGHT / $ROWS))

# create temporary output dir
OUTDIR=${DIR}/.${NAME}
if [ ! -d "$OUTDIR" ]; then
	mkdir "$OUTDIR"
fi

# the command to crop in one go looks like:
#
# ffmpeg -y -v quiet -i vw-1x2.mp4 \
#   -filter_complex "[0:v]crop=1920:1080:0:0[o1];[0:v]crop=1920:1080:1920:0[o2]" \
#   -map [o1] out1.mp4 \
#   -map [o2] out2.mp4
# the filter_complex argument specifies what part to crop, and gives each part an id
# the map args map the ids to file names
#
# build the filter and map arrays, based on geometry
FILTER=()
MAP=()
INDEX=1
for ((r = 0; r < $ROWS; r++)); do
	for ((c = 0; c < $COLS; c++)); do
        LEFT=$(($OW * $c))
        TOP=$(($OH * $r))
		FILTER+=("[0:v]crop=${OW}:${OH}:${LEFT}:${TOP}[o${INDEX}]")
		OUT="${OUTDIR}/${NAME}-${INDEX}.${EXT}"
		MAP+=("-map \[o${INDEX}] \"${OUT}\"")
		INDEX=$((INDEX + 1))
	done
done

# FILTER elements must be joined with ';', MAP can just be printed out
CMD="ffmpeg -y -v quiet -i \"$IN\" -filter_complex \"$(join_by ';' "${FILTER[@]}")\" ${MAP[@]}"
eval $CMD

# move cropped parts to .parts dir
PARTSDIR=${DIR}/.parts
if [ ! -d "$PARTSDIR" ]; then
	mkdir "$PARTSDIR"
fi
mv -f "$OUTDIR"/* "$PARTSDIR"
rmdir "$OUTDIR"

if [[ ! -z $3 ]] && [[ ! -z $4 ]]; then
	CMD="curl --data \"id=$3\" $4"
	eval $CMD
fi

exit 0
