TARGETS=0001.sfd 0002.sfd 0003.sfd 0004.sfd 0005.sfd 0006.sfd 0007.sfd \
        0008.sfd 0009.sfd 0010.sfd

.PHONY: all clean utils

all: $(TARGETS)

.SUFFIXES: .gif .sfd
.gif.sfd:
	-mkdir $*
	TARGETPATH=`cygpath -w \`pwd\``; ../utils/hsp/decomp.exe $$TARGETPATH\\$<
	cd $*;k=0;for i in `ls -1 *.bmp`; do \
	echo -n "[$${k}]";potrace -s $$i; k=`expr $$k + 1`; \
	done;echo ""; \
	cd ..; ../utils/pe/import.pe $* $$k

clean:
	-rm -rf $(TARGETS) $(TARGETS:.sfd=)
