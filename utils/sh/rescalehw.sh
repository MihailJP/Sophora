#!/bin/bash

function chkerr {
	if [[ $1 != 0 ]]
	then
		echo "The child process terminated abnormally with error code $1."
		exit 2
	fi
}


if [[ $# < 3 ]]
then
	echo "Usage: sh $0 base-sfd halfwidth-sfd target-file"
	exit 1
fi

target=${3%.*}
fontforge -script $(cd $(dirname $0);pwd)/../python/halfwidth.py $1 $2 $target.tmp
chkerr $?
cat ${target}.tmp \
	| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-650 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-325 dv=0/" \
	| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-650 dy=0 dh=-650 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-325 dy=0 dh=-325 dv=0/" \
	> $3
chkerr $?
exit 0
