DIRS=utils srcgif
TARGETS=Sophora.otf

.PHONY: all clean $(DIRS)

all: $(TARGETS)

.SUFFIXES: .sfd .otf
.sfd.otf:
	./utils/pe/makefont.pe $*.sfd $*.otf

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
