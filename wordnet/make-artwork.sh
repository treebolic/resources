#!/bin/bash

# args
if [ "-31" == "$1" ]; then
	wn31="31"
	shift
fi
whereto="$1"
shift

thisdir="`dirname $(readlink -m $0)`"
thisdir="$(readlink -m ${thisdir})"
artworkdir="artwork"
htmldir="html"
imagesdir="images"

wherefrom=${artworkdir}
if [ -z "${whereto}" ]; then
	whereto="${htmldir}${wn31}/${imagesdir}"
fi
wherefrom=`readlink -m "${wherefrom}"`
whereto=`readlink -m "${whereto}"`

source define_colors.sh
source define_wordnet.sh
source define_wordnet_relations.sh

all="${all_wordnet} ${all_relations}"

mkdir -p ${whereto}

utils="menu"

function svgs2pngs(){
	local r=$1
	shift
	local from="$1"
	shift
	local to="$1"
	shift
	local list="$@"
	local aspect=h
	for e in ${list}; do
		png=${e}.png
		svg=${from}/${e}.svg
		echo -e "${M}${e}${Z} -> ${to}/${png}"
		$INKSCAPE --export-type="png" --export-filename="${to}/${png}" -${aspect} ${r} ${svg} > /dev/null # 2> /dev/null
	done
}

svgs2pngs 30 "${wherefrom}"           "${whereto}" ${all_wordnet}
svgs2pngs 30 "${wherefrom}/relations" "${whereto}" ${all_relations}
svgs2pngs 24 "${wherefrom}"           "${whereto}" ${utils}
