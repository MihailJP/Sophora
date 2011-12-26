DIRS=utils srcgif
TARGETS=Sophora-Light.otf Sophora-Medium.otf Sophora-Bold.otf

.PHONY: all clean $(DIRS)

all: $(TARGETS)

.SUFFIXES: .sfd .otf
Sophora.scaled.sfd: Sophora.sfd
	fontforge -lang=ff -c "Open(\"$<\");SelectWorthOutputting();Scale(130,0,0);Save(\"$@\")"

Sophora-Light.otf: Sophora.scaled.sfd
	fontforge -script ./utils/pe/makefont.pe $< $@

Sophora-Medium.otf: Sophora.scaled.sfd
	fontforge -script ./utils/pe/embolden.pe $< 20 Medium $*.sfd
	fontforge -script ./utils/pe/makefont.pe $*.sfd $@

Sophora-Bold.otf: Sophora.scaled.sfd
	fontforge -script ./utils/pe/embolden.pe $< 40 Bold $*.sfd
	fontforge -script ./utils/pe/makefont.pe $*.sfd $@

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:.otf=.sfd) Sophora.scaled.sfd
