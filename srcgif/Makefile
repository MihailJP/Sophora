TARGETS=0001.sfd 0002.sfd 0003.sfd 0004.sfd 0005.sfd 0006.sfd 0007.sfd \
        0008.sfd 0009.sfd 0010.sfd 0011.sfd 0012.sfd 0013.sfd 0014.sfd \
        0015.sfd 0016.sfd 0017.sfd 0018.sfd 0019.sfd 0020.sfd 0021.sfd \
        0022.sfd 0023.sfd 0024.sfd 0025.sfd 0026.sfd 0027.sfd 0028.sfd \
        0029.sfd          0031.sfd 0032.sfd 0033.sfd 0034.sfd 0035.sfd \
        0036.sfd 0037.sfd 0038.sfd 0039.sfd 0040.sfd 0041.sfd 0042.sfd \
        0043.sfd 0044.sfd 0045.sfd 0046.sfd 0047.sfd 0048.sfd 0049.sfd \
        0050.sfd 0051.sfd 0052.sfd 0053.sfd 0054.sfd 0055.sfd 0056.sfd \
        0057.sfd 0058.sfd                   0061.sfd 0062.sfd

.PHONY: all clean utils

all: $(TARGETS)

.SUFFIXES: .gif .sfd
.gif.sfd:
	-mkdir $*
	../utils/perl/decomp.pl $<
	cd $*;k=0;for i in `ls -1 *.bmp`; do \
	echo -n "[$${k}]";potrace -s $$i; k=`expr $$k + 1`; \
	done;echo ""; \
	cd ..; fontforge -script ../utils/pe/import.pe $* $$k

clean:
	-rm -rf $(TARGETS) $(TARGETS:.sfd=)
