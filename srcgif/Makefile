SOURCES=`ls -1 *.gif`
TARGETS=`ls -1 *.gif|sed -e 's/\.gif/\.sfd/g'`
DIRS=`ls -1 *.gif|sed -e 's/\.gif//g'`

.PHONY: all clean utils

all: $(TARGETS)

.SUFFIXES: .gif .sfd
.gif.sfd:
	-mkdir $*
	TARGETPATH=`cygpath -w \`pwd\``; ../utils/perl/decomp.pl $$TARGETPATH\\$<
	cd $*;k=0;for i in `ls -1 *.bmp`; do \
	echo -n "[$${k}]";potrace -s $$i; k=`expr $$k + 1`; \
	done;echo ""; \
	cd ..; fontforge -script ../utils/pe/import.pe $* $$k

clean:
	-rm -rf $(TARGETS) $(DIRS)
