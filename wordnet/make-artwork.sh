#!/bin/bash

source define_colors.sh
source define_wordnet.sh
source define_wordnet_relations.sh

# args
if [ "-31" == "$1" ]; then
	wn31="31"
    selected_relations="${all_relations_wn31}"
	shift
else
    selected_relations="${all_relations}"
fi
whereto="$1"
shift

artworkdir="artwork"
htmldir="html"
imagesdir="images"

wherefrom=${artworkdir}
if [ -z "${whereto}" ]; then
	whereto="${htmldir}${wn31}/${imagesdir}"
fi
wherefrom=`readlink -m "${wherefrom}"`
whereto=`readlink -m "${whereto}"`

mkdir -p ${whereto}
rm "${whereto}"/*.png

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
svgs2pngs 30 "${wherefrom}/relations" "${whereto}" ${selected_relations}
svgs2pngs 24 "${wherefrom}"           "${whereto}" ${utils}
cp           splash.png               "${whereto}"

