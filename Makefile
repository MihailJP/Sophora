DIRS=utils srcgif
TARGETS=Sophora-Light.otf Sophora-Book.otf Sophora-Medium.otf Sophora-Demi-Bold.otf Sophora-Bold.otf

.PHONY: all clean $(DIRS)

all: $(TARGETS)

.SUFFIXES: .sfd .otf
Sophora-Light.sfd: Sophora.sfd
	fontforge -lang=ff -c "Open(\"$<\");SelectWorthOutputting();Scale(130,0,0);Save(\"$@\")"

Sophora-Book.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 15 Book $@

Sophora-Medium.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 30 Medium $@

Sophora-Demi-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 45 Demi-Bold $@

Sophora-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 60 Bold $@

.sfd.otf:
	fontforge -script ./utils/pe/makefont.pe $< $@

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:.otf=.sfd) *~ *.bak
