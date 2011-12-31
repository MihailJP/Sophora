DIRS=srcgif
WEIGHTS=Light Book Medium Demi-Bold Bold
TARGETS=$(WEIGHTS:%=Sophora-%.otf) $(WEIGHTS:%=Sophora-P-%.otf)
DISTDIR=Sophora
DISTFILE=Sophora.7z
DOCS=readme.txt pua.txt

.PHONY: all clean $(DIRS) dist a

all: $(TARGETS)

.SUFFIXES: .sfd .ttf .otf
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

Sophora-P-Light.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Book.sfd: Sophora-Book.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Medium.sfd: Sophora-Medium.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Demi-Bold.sfd: Sophora-Demi-Bold.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Bold.sfd: Sophora-Bold.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@

.sfd.otf:
	fontforge -script ./utils/pe/makefont.pe $< $@

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:%.otf=%.sfd) *~ *.bak $(DISTFILE)
	-rm -rf $(DISTDIR)

dist: all
	-rm -rf $(DISTDIR)
	-mkdir $(DISTDIR)
	cp $(TARGETS) $(DOCS) $(DISTDIR)
	7za a -mx=9 $(DISTFILE) $(DISTDIR)
