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

echo $1| grep "forTTC"; TTCFLAG=$?
echo $1| grep "SophoraP-"; PROPFLAG=$?
echo $1| grep "HW" # returns 0 if found, 1 otherwise
HWFLAG=$?
if [[ ( $TTCFLAG == 0 ) && ( $PROFLAG != 0 ) ]]; then
	HWFLAG=0
fi
if [[ $HWFLAG == 0 ]]; then
	$(cd $(dirname $0);pwd)/../pe/makefont.pe $1 $2
	chkerr $?
	$(cd $(dirname $0);pwd)/../pe/hwhack.pe $2
	chkerr $?
else
	$(cd $(dirname $0);pwd)/../pe/makefont.pe $1 $2
	chkerr $?
fi
exit 0
