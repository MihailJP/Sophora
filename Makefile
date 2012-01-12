#
# Makefile for Sophora
#

.SUFFIXES: .sfd .otf .ttf .7z

DIRS=srcgif
WEIGHTS=Light Book Medium Demi-Bold Bold
OTF=$(WEIGHTS:%=Sophora-%.otf) $(WEIGHTS:%=Sophora-P-%.otf) \
    $(WEIGHTS:%=Sophora-%-Italic.otf) $(WEIGHTS:%=Sophora-P-%-Italic.otf)
TTF=$(OTF:.otf=.ttf)
TARGETS=$(OTF) $(TTF)
DOCS=readme.txt pua.txt
DISTFILE=Sophora-OTF.7z Sophora-TTF.7z
DISTDIR=$(DISTFILE:.7z=)

.PHONY: all clean $(DIRS) dist otf ttf
all: $(TARGETS)

otf: $(OTF)
ttf: $(TTF)

# Scaling

Sophora-Light.sfd: Sophora.sfd
	sh ./utils/sh/scale.sh $< $@

# Weight variant

Sophora-Book.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 15 Book $@
Sophora-Medium.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 30 Medium $@
Sophora-Demi-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 45 Demi-Bold $@
Sophora-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 60 Bold $@

# Proportional variant

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

# Italic scaling

italic.sfd: Sophora.sfd italic.txt
	./utils/perl/fonthead.pl $^ > $@
italic-Light.sfd: italic.sfd
	sh ./utils/sh/scale.sh $< $@

# Italic weight variant

italic-Book.sfd: italic-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 15 Book $@ Italic
italic-Medium.sfd: italic-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 30 Medium $@ Italic
italic-Demi-Bold.sfd: italic-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 45 Demi-Bold $@ Italic
italic-Bold.sfd: italic-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 60 Bold $@ Italic

# Italicize

Sophora-Light-Italic.sfd: Sophora-Light.sfd italic-Light.sfd
	fontforge -script ./utils/pe/italicize.pe $^ $@
Sophora-Book-Italic.sfd: Sophora-Book.sfd italic-Book.sfd
	fontforge -script ./utils/pe/italicize.pe $^ $@
Sophora-Medium-Italic.sfd: Sophora-Medium.sfd italic-Medium.sfd
	fontforge -script ./utils/pe/italicize.pe $^ $@
Sophora-Demi-Bold-Italic.sfd: Sophora-Demi-Bold.sfd italic-Demi-Bold.sfd
	fontforge -script ./utils/pe/italicize.pe $^ $@
Sophora-Bold-Italic.sfd: Sophora-Bold.sfd italic-Bold.sfd
	fontforge -script ./utils/pe/italicize.pe $^ $@

# Proportional italic variant

Sophora-P-Light-Italic.sfd: Sophora-Light-Italic.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Book-Italic.sfd: Sophora-Book-Italic.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Medium-Italic.sfd: Sophora-Medium-Italic.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Demi-Bold-Italic.sfd: Sophora-Demi-Bold-Italic.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@
Sophora-P-Bold.sfd-Italic: Sophora-Bold-Italic.sfd
	fontforge -script ./utils/pe/proportional.pe $< $@

# Build fonts

.sfd.otf:
	fontforge -script ./utils/pe/makefont.pe $< $@
.sfd.ttf:
	fontforge -script ./utils/pe/makefont.pe $< $@

# GIF to SFD

srcgif:
	cd $@;make

# Cleaning

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:%.otf=%.sfd) italic.sfd *~ *.bak *.tmp $(DISTFILE)
	-rm -rf $(DISTDIR)

# Distribution

Sophora-OTF.7z: $(OTF) $(DOCS)
	-rm -rf $*
	mkdir $*;cp $^ $*
	7za a -mx=9 $@ $*
Sophora-TTF.7z: $(TTF) $(DOCS)
	-rm -rf $*
	mkdir $*;cp $^ $*
	7za a -mx=9 $@ $*

dist: $(DISTFILE)
