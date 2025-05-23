#!/bin/bash

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

echo $1| grep "SophoraP-"; PROPFLAG=$?
echo $1| grep "HW"; HWFLAG=$? # returns 0 if found, 1 otherwise

if [[ $HWFLAG == 0 ]]; then
	PROPFLAG=1
fi

$(cd $(dirname $0);pwd)/../pe/makefont.pe $1 _$2
chkerr $?
if [[ $PROPFLAG != 0 ]]; then
	#$(cd $(dirname $0);pwd)/../mensis/flagmono.pe $2
	$(cd $(dirname $0);pwd)/../perl/flagmono.pl _$2 $2
	ERRCODE=$?
	rm _$2
	chkerr $ERRCODE
else
	mv _$2 $2
fi
rm _$2.sfd
#$(cd $(dirname $0);pwd)/../mensis/vert.pe $2
#chkerr $?
exit 0
