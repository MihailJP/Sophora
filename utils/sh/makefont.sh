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
	echo "Usage: sh $0 source-sfd target-ttf"
	exit 1
fi

echo $1| grep "HW" # returns 0 if found, 1 otherwise
HWFLAG=$?
if [[ $HWFLAG == 0 ]]; then
	fontforge -script $(cd $(dirname $0);pwd)/../pe/makefont.pe $1 tmp-$2
	chkerr $?
	$(cd $(dirname $0);pwd)/../perl/flagmono.pl tmp-$2 $2
	chkerr $?
	rm tmp-$2
	chkerr $?
else
	fontforge -script $(cd $(dirname $0);pwd)/../pe/makefont.pe $1 $2
	chkerr $?
fi
exit 0
