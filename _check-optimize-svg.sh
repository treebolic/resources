#!/bin/bash

#
# Copyright (c) 2023. Bernard Bou
#
export YELLOW='\u001b[33m'
export MAGENTA='\u001b[35m'
export Z='\u001b[0m'

dirs=$@
if [ -z "${dirs}" ]; then
    dirs=$(find . -type d ! -path '**/.git/**')
fi

function tidysvg(){
	local f="$1"
	echo -e "${M}${f}${Z}"
	svgo "${f}"
}

for d in ${dirs}; do
	pushd ${d} > /dev/null
	echo -e "${Y}${d}${Z}"
	#find . -name "*.svg" -exec tidysvg {} \;
	#find . -name "*." | xargs tidysvg
	while read f; do tidysvg "${f}"; done < <(find . -name "*.svg")
	popd > /dev/null
done

