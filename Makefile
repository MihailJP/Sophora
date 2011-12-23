DIRS=utils srcgif
TARGETS=Sophora.otf

.PHONY: all clean $(DIRS)

all: $(TARGETS)

.SUFFIXES: .sfd .otf
.sfd.otf:
	fontforge -lang=ff -c "Open(\"$*.sfd\");SelectWorthOutputting();Scale(130,0,0);Save(\"$*.scaled.sfd\")"
	fontforge -script ./utils/pe/makefont.pe $*.scaled.sfd $*.otf

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:.otf=.scaled.sfd)
