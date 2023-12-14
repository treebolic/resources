#!/bin/bash

srcdir="html"

source define_colors.sh

function copy() {
    local from="$1"
    local to="$2"
    to=$(readlink -m "${to}")
    echo -e "-> ${M}${to}${Z}"
    mkdir -p "${to}"
    cp -pR "${from}/" -T "${to}"
    # "${from}" and "${to}" have identical contents, but not necessarily identical basenames
}

# treebolic swing
echo -e "${Y}treebolic swing${Z}"
whereto="../../swing-wordnet/src/main/resources/treebolic/wordnet/browser/doc"
copy "${srcdir}" "${whereto}"
rm "${whereto}/index-css.html" # won't work
rm "${whereto}/index-iframes.html" # won't work
rm "${whereto}/index_android.html" # won't work
rm "${whereto}/selector.html" # not used
rm "${whereto}/relations_display.js" # not used
rm "${whereto}/relations_display_block.js" # not used
# index.html with relations.js
mv "${whereto}/relations_visibility.js" "${whereto}/relations.js"
# index_web.html with relations_visibility.js

# treebolic android
echo -e "${Y}treebolic android${Z}"
whereto="/opt/devel/android-treebolic-as/TreebolicWordNet/treebolicWordNetLib/src/main/assets/reference"
copy "${srcdir}" "${whereto}"
rm "${whereto}/index-css.html"
rm "${whereto}/index-iframes.html"
rm "${whereto}/index-frames.html"
mv "${whereto}/index.html" "${whereto}/index_web.html"
mv "${whereto}/index_android.html" "${whereto}/index.html"
rm "${whereto}/relations_visibility.js"
mv "${whereto}/relations_display_block.js" "${whereto}/relations.js"
