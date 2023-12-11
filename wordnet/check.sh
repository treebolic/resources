#!/bin/bash

source define_colors.sh

thisdir="`dirname $(readlink -m $0)`"
thisdir="$(readlink -m ${thisdir})"
artworkdir="artwork"
htmldir="html"
imagesdir="images"

# general
objects="sense synset word pos"
labels="root category words relations"
features="feature_symmetric pos_n  pos_v pos_a pos_s pos_r"

# relations
hierarchy="hypernym hyponym hypernym_instance hyponym_instance holonym meronym holonym_member meronym_member holonym_part meronym_part holonym_substance meronym_substance"
lex="antonym"
verb="causes caused entails entailed verbgroup participle"
adj="similar attribute"
adv="adjderived"
deriv="derivation"
morph="role_bodypart role_bymeansof role_destination role_event role_instrument role_location role_material role_property role_result role_state role_undergoer role_uses role_vehicle"
misc="also pertainym"
domain="domain hasdomain domain_topic hasdomain_topic domain_region hasdomain_region domain_usage hasdomain_usage"

obsoleted="synonym other domain_term has_domain_term"
obsoleted2="pos.n pos.v pos.a pos.s pos.r reflexive semantic lexical"

all="${objects} ${labels} ${features} ${hierarchy} ${lex} ${verb} ${adj} ${adv} ${deriv} ${morph} ${misc} ${domain}"

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
        echo -e "${C}whether refs in this script have a matching svg in <"${artworkdir}"${Z}"
        for i in ${all}; do
            echo -en "${Y}${i}${Z} "
            f="${i}.svg"
            if [ -e "${artworkdir}/${f}" -o -e "${artworkdir}/relations/${f}" ]; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${f}${Z}"
            fi
        done
        ;;
        
    "-ref_has_png"|"-rp"|"-2")
        echo -e "${C}whether refs in this script match png in <"${scope}">${Z}"
        for i in ${all}; do
            echo -en "${Y}${i}${Z} "
            if grep -R ${options} "${i}.png" "${scope}"; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${i}${Z}"
            fi
        done
        ;;
                
    "-svg_has_png"|"-ss"|"-3")
        echo -e "${C}whether svgs match pngs in <"${scope}">${Z}"
        for f in "${artworkdir}"/*.svg "${artworkdir}"/relations/*.svg; do
            i="$(basename ${f})"
            i=${i%.svg}
            echo -en "${Y}${i}${Z} "
            if grep -R ${options} "${i}.png" "${scope}"; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${i} in "${scope}"${Z}"
            fi
        done
        ;;

    "-html_has_svg"|"-hs"|"-4")
        echo -e "${C}whether html src tags in <"${scope}"> match svgs in <"${artworkdir}">${Z}"
        l=$(filterpng $(findsrc "${scope}"))
        for i in ${l}; do
            b=${i%.png}
            echo -en "${Y}${b}${Z} "
            f="${b}.svg"
            if [ -e "${artworkdir}/${f}" -o -e "${artworkdir}/relations/${f}" ]; then
                echo -e "${G}found${Z}"
            else
                echo -e "${R}not found ${f} in ${1}${Z}"
            fi
        done
        ;;
        
    *)
        echo "Invalid option"
        ;;    
    esac
}

check $@

