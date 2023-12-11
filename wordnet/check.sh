#!/bin/bash

thisdir="`dirname $(readlink -m $0)`"
thisdir="$(readlink -m ${thisdir})"
artworkdir="artwork"
htmldir="html"
imagesdir="images"

source define_colors.sh
source define_wordnet.sh
source define_wordnet_relations.sh

all="${all_wordnet} ${all_relations}"

# extract source references from html files
findsrc(){
  local d="$1"
  if [ -z "${d}" ]; then
  	d=.
  fi
  find ${d} -name '*.html' -exec grep 'src=' {} \; | sed "s/['\"]/\"/g" | grep -Po 'src="\K[^"]*' | LC_COLLATE=C sort -u
}

filterpng() {
    for i in $@; do
        [[ "$i" =~ .*\.png$ ]] && echo "$(basename $i)"
    done
}

findfileswithsrc(){
  local d="$1"
  if [ -z "${d}" ]; then
  	d=.
  fi
  find ${d} -name '*.xsl' -path '*/src/main/*' -exec grep -l 'src=' {} \;
}

function check() {
    options=-Ho
    options=-q

    op="$1"
    shift
    scope="$2"
    shift
    if [ -z "${scope}" ]; then
      scope="${htmldir}"
    fi

    case "${op}" in

    "-refs_have_svgs"|"-rs"|"-1")
        echo -e "${C}whether refs in this script have a matching svg in ${artworkdir}${Z}"
        for i in ${all}; do
            echo -en "${Y}${i}${Z} "
            f="${i}.svg"
            if [ -e "${artworkdir}/${f}" -o -e "${artworkdir}/relations/${f}" ]; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${f} in ${artworkdir}${Z}"
            fi
        done
        ;;
        
    "-ref_has_png"|"-rp"|"-2")
        echo -e "${C}whether refs in this script match png in <${scope}>${Z}"
        for i in ${all}; do
            echo -en "${Y}${i}${Z} "
            if grep -R ${options} "${i}.png" "${scope}"; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${i}.png in <${scope}>${Z}"
            fi
        done
        ;;
                
    "-svg_has_png"|"-ss"|"-3")
        echo -e "${C}whether svgs match pngs in <${scope}>${Z}"
        for f in "${artworkdir}"/*.svg "${artworkdir}"/relations/*.svg; do
            i="$(basename ${f})"
            i=${i%.svg}
            echo -en "${Y}${i}${Z} "
            if grep -R ${options} "${i}.png" "${scope}"; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${i}.png in <${scope}>${Z}"
            fi
        done
        ;;

    "-html_has_svg"|"-hs"|"-4")
        echo -e "${C}whether html src tags in <${scope}> match svgs in <"${artworkdir}">${Z}"
        l=$(filterpng $(findsrc "${scope}"))
        for i in ${l}; do
            b=${i%.png}
            echo -en "${Y}${b}${Z} "
            f="${b}.svg"
            if [ -e "${artworkdir}/${f}" -o -e "${artworkdir}/relations/${f}" ]; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${f} in ${artworkdir}${Z}"
            fi
        done
        ;;
        
    *)
        echo "Invalid option"
        ;;    
    esac
}

check $@

