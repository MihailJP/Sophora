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

fontforge -lang=ff -c "Open(\"$1\");SelectWorthOutputting();Scale(130,0,0);Save(\"$2\")"
chkerr $?
exit 0
