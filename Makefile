.SUFFIXES: .sfd .otf .ttf .7z

DIRS=srcgif
WEIGHTS=Light Book Medium Demi-Bold Bold
OTF=$(WEIGHTS:%=Sophora-%.otf) $(WEIGHTS:%=Sophora-P-%.otf)
TTF=$(OTF:.otf=.ttf)
TARGETS=$(OTF) $(TTF)
DOCS=readme.txt pua.txt
DISTFILE=Sophora-OTF.7z Sophora-TTF.7z
DISTDIR=$(DISTFILE:.7z=)

.PHONY: all clean $(DIRS) dist otf ttf
all: $(TARGETS)

otf: $(OTF)
ttf: $(TTF)

Sophora-Light.sfd: Sophora.sfd
	fontforge -lang=ff -c "Open(\"$<\");SelectWorthOutputting();Scale(130,0,0);Save(\"$*.tmp\")"
	cat $*.tmp \
		| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-500 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-1\" dx=0 dy=0 dh=-650 dv=0/" \
		| sed -e "s/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-500 dy=0 dh=-500 dv=0/Position2: \"\[MONO\] Diacritics width adjustment-2\" dx=-650 dy=0 dh=-650 dv=0/" \
		> $@

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

italic.sfd: Sophora.sfd italic.txt
	./utils/perl/fonthead.pl $^ > $@

.sfd.otf:
	fontforge -script ./utils/pe/makefont.pe $< $@
.sfd.ttf:
	fontforge -script ./utils/pe/makefont.pe $< $@

srcgif:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:%.otf=%.sfd) italic.sfd *~ *.bak *.tmp $(DISTFILE)
	-rm -rf $(DISTDIR)

Sophora-OTF.7z: $(OTF) $(DOCS)
	-rm -rf $*
	mkdir $*;cp $^ $*
	7za a -mx=9 $@ $*
Sophora-TTF.7z: $(TTF) $(DOCS)
	-rm -rf $*
	mkdir $*;cp $^ $*
	7za a -mx=9 $@ $*

dist: $(DISTFILE)
