#!/bin/bash

#
# Copyright (c) 2023. Bernard Bou
#

source define_colors.sh
source define_wordnet_relations.sh

# sources
wherefrom="xml"
if [ "-31" == "$1" ]; then
	wn31="31"
	shift
fi

# output
whereto="$1"
if [ -z "${whereto}" ]; then
	whereto="html${wn31}"
fi

# input
in="${all_relations_wn31}"
if [ -z "${wn31}" ]; then
	in="${in} ${role}"
fi

# xslt
xsl="relation2html.xsl"
xsl_index="relations2html.xsl"
xsl_selector="relations2selector.xsl"
xsl_toc="relations2toc.xsl"

# dirs
wherefrom=`readlink -m "${wherefrom}"`
whereto=`readlink -m "${whereto}"`
mkdir -p "${whereto}"

# merge all *.xml files into all.xml
echo '<?xml version="1.0" encoding="UTF-8"?>' > ${wherefrom}/all.xml 
echo '<relations>' >> ${wherefrom}/all.xml
for i in $in; do
  xml="${i}.xml"
  if [ ! -e ${wherefrom}/${xml} ]; then
    continue
  fi
	grep -v '<\?xml.*'  ${wherefrom}/${xml}
done >> ${wherefrom}/all.xml 
echo '</relations>' >> ${wherefrom}/all.xml

# transform all *.xml files into *.html
for i in $in all; do
  xml="${i}.xml"
  if [ ! -e ${wherefrom}/${xml} ]; then
    continue
  fi
	outfile=${i}.html
	echo -e "${M}XST ${xml} to ${outfile}${Z}"
	if ! ./xsl-transform.sh ${wherefrom}/${xml} ${whereto}/${outfile} ${xsl} html; then
		echo -e "${R}XST ${xml}${Z}"
	fi
done

# index.html
echo -e "${M}XST all.xml to index.html${Z}"
if ! ./xsl-transform.sh ${wherefrom}/all.xml ${whereto}/index.html ${xsl_index} html; then
	echo -e "${R}XST ${xml}${Z}"
fi

# selector.html
echo -e "${M}XST all.xml to selector.html${Z}"
if ! ./xsl-transform.sh ${wherefrom}/all.xml ${whereto}/selector.html ${xsl_selector} html; then
	echo -e "${R}XST ${xml}${Z}"
fi
echo -e "${M}XST all.xml to toc.html${Z}"
if ! ./xsl-transform.sh ${wherefrom}/all.xml ${whereto}/toc.html ${xsl_toc} html; then
	echo -e "${R}XST ${xml}${Z}"
fi

# specific
sed "s/relations.js/relations_visibility.js/g" ${whereto}/index.html > ${whereto}/index_web.html
sed "s/relations.js/relations_display.js/g" ${whereto}/index.html > ${whereto}/index_javafx.html
sed "s/relations.js/relations_display_block.js/g" ${whereto}/index.html > ${whereto}/index_android.html
# rm ${whereto}/index.html

#cp index*.html ${whereto}
cp relations.css ${whereto}
cp relations_visibility.js ${whereto}
cp relations_display.js ${whereto}
cp relations_display_block.js ${whereto}
cp main.html ${whereto}
cp index-css.html ${whereto}
cp index-frames.html ${whereto}
cp index-iframes.html ${whereto}
cp splash.png ${whereto}/images/
