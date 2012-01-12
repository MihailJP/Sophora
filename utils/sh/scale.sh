#!/bin/sh

function chkerr {
	if [[ $1 != 0 ]]
	then
		echo "The child process terminated abnormally with error code $1."
		exit 2
	fi
}


if [[ $# < 2 ]]
then
	echo "Usage: sh $0 source-sfd target-sfd"
	exit 1
fi

target=${2%.*}
fontforge -lang=ff -c "Open(\"$1\");SelectWorthOutputting();Scale(130,0,0);Save(\"${target}.tmp\")"
chkerr $?
cat ${target}.tmp \
	| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-500 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-650 dv=0/" \
	| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-500 dy=0 dh=-500 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-650 dy=0 dh=-650 dv=0/" \
	> $2
chkerr $?
exit 0
