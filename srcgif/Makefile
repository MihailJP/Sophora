TARGETS=0001.sfd

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
