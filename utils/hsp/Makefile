HSPCMP = "/cygdrive/c/Program Files/hsp321/chspcomp.exe"
EXE    = decomp.exe

.PHONY: all clean

all: $(EXE)

.SUFFIXES: .exe .hsp
.hsp.exe:
	TARGETPATH=`cygpath -w \`pwd\``; $(HSPCMP) /m $$TARGETPATH\\$<

clean:
	-rm $(EXE)
