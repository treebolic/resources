#!/bin/bash

# args
if [ "-31" == "$1" ]; then
	wn31="31"
	shift
fi
whereto="$1"
shift

thisdir=$(dirname $(readlink -m $0))
htmldir="html"

whereto=../../swing-wordnet/src/main/resources/treebolic/wordnet/browser
whereto=$(readlink -m "${whereto}")


function copy() {
    local from="$1"
    local to="$2"
    echo "-> ${to}"
    mkdir -p "${to}"
    cp -pR "${from}/" -T "${to}"
    # "${from}" and "${to}" have identical contents, but not necessarily identical basenames
}

copy "${htmldir}" "${whereto}/doc" 
copy "${htmldir}" "/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNetLib/src/main/assets/reference"
#copy "${htmldir}" "/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNet/src/main/assets/reference"
#copy "${htmldir}" "/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNetForGoogle/src/main/assets/reference"
#copy "${htmldir}" "/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNetForAmazon/src/main/assets/reference"

