#!/bin/bash

#
# Copyright (c) 2023. Bernard Bou
#
export YELLOW='\u001b[33m'
export MAGENTA='\u001b[35m'
export Z='\u001b[0m'

source define_colors.sh

dirs=$@
if [ -z "${dirs}" ]; then
    dirs=$(find . -type d ! -path '**/.git/**')
fi

function tidyxml(){
	local f="$1"
	echo -e "${M}${f}${Z}"
	tidy -xml -errors -q "${f}"
}
for d in ${dirs}; do
	pushd ${d} > /dev/null
	echo -e "${Y}${d}${Z}"
	#find . -name "*.xml" -exec tidyxml {} \;
	#find . -name "*.xml" | xargs tidyxml
	
	while read f; do tidyxml "${f}"; done < <(find . -name "*.xml")
	popd > /dev/null
done

