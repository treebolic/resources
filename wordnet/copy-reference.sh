#!/bin/bash

source define_colors.sh

function confirm()
{
	local title="$1"
	local message="$2"
	local proceed="$3"

	echo -e "${title}"
	echo -en "${message} "
	read -n 1 -r
	echo -e "${Z}"
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		return 2
	fi
	echo -e "${proceed}"
	return 0
}

function copy() {
    local from="$1"
    local to="$2"
    to=$(readlink -m "${to}")
    echo -e "-> ${M}${to}${Z}"
    if confirm "Remove target dir" "Are you sure you want to remove '${R}${to}${Z}' ?" "Removing '${G}${to}${Z}'"; then
        rm -fR "${to}"
    fi
    mkdir -p "${to}"
    cp -pR "${from}/" -T "${to}"
    # "${from}" and "${to}" have identical contents, but not necessarily identical basenames
}

function clean_frames(){
    rm "${whereto}/index-iframes-css.html"
    rm "${whereto}/index-iframes.html"
    rm "${whereto}/index-frames.html"
    rm "${whereto}/main.html"
    rm "${whereto}/images/splash.png"
}

function clean_js(){
    rm "${whereto}/relations.js"
    rm "${whereto}/relations_visibility.js"
    rm "${whereto}/index.html"
    rm "${whereto}/index_visibility.html"
    rm "${whereto}/selector.html"
}

# treebolic swing
echo -e "${Y}treebolic swing${Z}"
srcdir="html31"
whereto="../../swing-wordnet/src/main/resources/treebolic/wordnet/browser/doc"
copy "${srcdir}" "${whereto}"
clean_frames                                # won"t work
clean_js                                    # not used
rm "${whereto}/index_visibility.html"       # not used

# treebolic android
echo -e "${Y}treebolic android${Z}"
srcdir="html31"
whereto="/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNetLib/src/main/assets/reference"
copy "${srcdir}" "${whereto}"
clean_frames                                # obsolete
rm "${whereto}/index_visibility.html"       # not used
rm "${whereto}/relations_visibility.js"     # not used

# semantikos android
echo -e "${Y}semantikos android${Z}"
srcdir="html31"
whereto="/opt/devel/android-sqlunet-as/semantikos/common/reference/wordnet/relations/html31"
copy "${srcdir}" "${whereto}"
clean_frames                                # obsolete
rm "${whereto}/index_visibility.html"       # not used
rm "${whereto}/relations_visibility.js"     # not used

# semantikos android
echo -e "${Y}semantikos android${Z}"
srcdir="html"
whereto="/opt/devel/android-sqlunet-as/semantikos/common/reference/wordnet/relations/html"
copy "${srcdir}" "${whereto}"
clean_frames                                # obsolete
rm "${whereto}/index_visibility.html"       # not used
rm "${whereto}/relations_visibility.js"     # not used

