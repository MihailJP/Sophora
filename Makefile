#
# Makefile for Sophora
#

# Variants

.SUFFIXES: .sfd .otf .ttf .7z

DIRS=srcgif
WEIGHTS=Light Book Medium Demi-Bold Bold
OTF=$(WEIGHTS:%=Sophora-%.otf) $(WEIGHTS:%=SophoraP-%.otf) \
    $(WEIGHTS:%=Sophora-%-Italic.otf) $(WEIGHTS:%=SophoraP-%-Italic.otf) \
    $(WEIGHTS:%=SophoraHW-%.otf) $(WEIGHTS:%=SophoraHW-%-Italic.otf)
TTF=$(OTF:.otf=.ttf)
TARGETS=$(OTF) $(TTF)
DOCS=readme.txt pua.txt
DISTFILE=Sophora-OTF.7z Sophora-TTF.7z
DISTDIR=$(DISTFILE:.7z=)

# All targets

.PHONY: all clean $(DIRS) dist otf ttf
all: $(TARGETS)

otf: $(OTF)
ttf: $(TTF)

# Scaling

Sophora-Light.sfd: Sophora.sfd
	./utils/sh/scale.sh $< $@

# Weight variant

Sophora-Book.sfd: Sophora-Light.sfd
	./utils/pe/embolden.pe $< 15 Book $@
Sophora-Medium.sfd: Sophora-Light.sfd
	./utils/pe/embolden.pe $< 30 Medium $@
Sophora-Demi-Bold.sfd: Sophora-Light.sfd
	./utils/pe/embolden.pe $< 45 Demi-Bold $@
Sophora-Bold.sfd: Sophora-Light.sfd
	./utils/pe/embolden.pe $< 60 Bold $@

# Proportional variant

SophoraP-Light.sfd: Sophora-Light.sfd
	./utils/pe/proportional.pe $< $@
SophoraP-Book.sfd: Sophora-Book.sfd
	./utils/pe/proportional.pe $< $@
SophoraP-Medium.sfd: Sophora-Medium.sfd
	./utils/pe/proportional.pe $< $@
SophoraP-Demi-Bold.sfd: Sophora-Demi-Bold.sfd
	./utils/pe/proportional.pe $< $@
SophoraP-Bold.sfd: Sophora-Bold.sfd
	./utils/pe/proportional.pe $< $@

# Italic scaling

italic.sfd: Sophora.sfd italic.txt
	./utils/perl/fonthead.pl $^ > $@
italic-Light.sfd: italic.sfd
	./utils/sh/scale.sh $< $@

# Italic weight variant

italic-Book.sfd: italic-Light.sfd
	./utils/pe/embolden.pe $< 15 Book $@ Italic
italic-Medium.sfd: italic-Light.sfd
	./utils/pe/embolden.pe $< 30 Medium $@ Italic
italic-Demi-Bold.sfd: italic-Light.sfd
	./utils/pe/embolden.pe $< 45 Demi-Bold $@ Italic
italic-Bold.sfd: italic-Light.sfd
	./utils/pe/embolden.pe $< 60 Bold $@ Italic

# Italicize

Sophora-Light-Italic.sfd: Sophora-Light.sfd italic-Light.sfd
	./utils/pe/italicize.pe $^ $@
Sophora-Book-Italic.sfd: Sophora-Book.sfd italic-Book.sfd
	./utils/pe/italicize.pe $^ $@
Sophora-Medium-Italic.sfd: Sophora-Medium.sfd italic-Medium.sfd
	./utils/pe/italicize.pe $^ $@
Sophora-Demi-Bold-Italic.sfd: Sophora-Demi-Bold.sfd italic-Demi-Bold.sfd
	./utils/pe/italicize.pe $^ $@
Sophora-Bold-Italic.sfd: Sophora-Bold.sfd italic-Bold.sfd
	./utils/pe/italicize.pe $^ $@

# Proportional italic variant preparation

italic-P-Light.sfd: italic-Light.sfd
	./utils/pe/proportional.pe $< $@
italic-P-Book.sfd: italic-Book.sfd
	./utils/pe/proportional.pe $< $@
italic-P-Medium.sfd: italic-Medium.sfd
	./utils/pe/proportional.pe $< $@
italic-P-Demi-Bold.sfd: italic-Demi-Bold.sfd
	./utils/pe/proportional.pe $< $@
italic-P-Bold.sfd: italic-Bold.sfd
	./utils/pe/proportional.pe $< $@

# Proportional italic variant preparation

SophoraP-Light-Italic.sfd: SophoraP-Light.sfd italic-P-Light.sfd
	./utils/pe/italicize.pe $^ $@
SophoraP-Book-Italic.sfd: SophoraP-Book.sfd italic-P-Book.sfd
	./utils/pe/italicize.pe $^ $@
SophoraP-Medium-Italic.sfd: SophoraP-Medium.sfd italic-P-Medium.sfd
	./utils/pe/italicize.pe $^ $@
SophoraP-Demi-Bold-Italic.sfd: SophoraP-Demi-Bold.sfd italic-P-Demi-Bold.sfd
	./utils/pe/italicize.pe $^ $@
SophoraP-Bold-Italic.sfd: SophoraP-Bold.sfd italic-P-Bold.sfd
	./utils/pe/italicize.pe $^ $@

# Halfwidth variant preparation

halfwidth.sfd: Sophora-Light.sfd halfwidth.txt
	./utils/perl/fonthead.pl $^ > $@
halfwidth-Light.sfd: halfwidth.sfd
	./utils/python/scalehw.py $< $@

# Halfwidth weight variant

halfwidth-Book.sfd: halfwidth-Light.sfd
	./utils/pe/embolden.pe $< 15 Book $@
halfwidth-Medium.sfd: halfwidth-Light.sfd
	./utils/pe/embolden.pe $< 30 Medium $@
halfwidth-Demi-Bold.sfd: halfwidth-Light.sfd
	./utils/pe/embolden.pe $< 45 Demi-Bold $@
halfwidth-Bold.sfd: halfwidth-Light.sfd
	./utils/pe/embolden.pe $< 60 Bold $@

# Halfwidth weight variant composition

SophoraHW-Light.sfd: Sophora-Light.sfd halfwidth-Light.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Book.sfd: Sophora-Book.sfd halfwidth-Book.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Medium.sfd: Sophora-Medium.sfd halfwidth-Medium.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Demi-Bold.sfd: Sophora-Demi-Bold.sfd halfwidth-Demi-Bold.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Bold.sfd: Sophora-Bold.sfd halfwidth-Bold.sfd
	./utils/sh/rescalehw.sh $^ $@

# Halfwidth italic variant preparation

halfitalic.sfd: Sophora-Light.sfd halfitalic.txt
	./utils/perl/fonthead.pl $^ > $@
halfitalic-Light.sfd: halfitalic.sfd
	./utils/python/scalehw.py $< $@

# Halfwidth italic weight variant

halfitalic-Book.sfd: halfitalic-Light.sfd
	./utils/pe/embolden.pe $< 15 Book $@ Italic
halfitalic-Medium.sfd: halfitalic-Light.sfd
	./utils/pe/embolden.pe $< 30 Medium $@ Italic
halfitalic-Demi-Bold.sfd: halfitalic-Light.sfd
	./utils/pe/embolden.pe $< 45 Demi-Bold $@ Italic
halfitalic-Bold.sfd: halfitalic-Light.sfd
	./utils/pe/embolden.pe $< 60 Bold $@ Italic

# Italicize halfwidth variant preparation

halfwidth-Light-Italic.sfd: halfwidth-Light.sfd halfitalic-Light.sfd
	./utils/pe/italicize.pe $^ $@
halfwidth-Book-Italic.sfd: halfwidth-Book.sfd halfitalic-Book.sfd
	./utils/pe/italicize.pe $^ $@
halfwidth-Medium-Italic.sfd: halfwidth-Medium.sfd halfitalic-Medium.sfd
	./utils/pe/italicize.pe $^ $@
halfwidth-Demi-Bold-Italic.sfd: halfwidth-Demi-Bold.sfd halfitalic-Demi-Bold.sfd
	./utils/pe/italicize.pe $^ $@
halfwidth-Bold-Italic.sfd: halfwidth-Bold.sfd halfitalic-Bold.sfd
	./utils/pe/italicize.pe $^ $@

# Halfwidth italic variant composition

SophoraHW-Light-Italic.sfd: Sophora-Light-Italic.sfd halfwidth-Light-Italic.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Book-Italic.sfd: Sophora-Book-Italic.sfd halfwidth-Book-Italic.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Medium-Italic.sfd: Sophora-Medium-Italic.sfd halfwidth-Medium-Italic.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Demi-Bold-Italic.sfd: Sophora-Demi-Bold-Italic.sfd halfwidth-Demi-Bold-Italic.sfd
	./utils/sh/rescalehw.sh $^ $@
SophoraHW-Bold-Italic.sfd: Sophora-Bold-Italic.sfd halfwidth-Bold-Italic.sfd
	./utils/sh/rescalehw.sh $^ $@


# Build fonts

.sfd.otf:
	./utils/sh/makefont.sh $< $@
.sfd.ttf:
	./utils/sh/makefont.sh $< $@



# GIF to SFD

srcgif:
	cd $@;make

# Cleaning

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:%.otf=%.sfd) \
		italic.sfd italic-*.sfd \
		halfwidth.sfd halfwidth-*.sfd \
		halfitalic.sfd halfitalic-*.sfd \
		*~ *.bak *.tmp $(DISTFILE)
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
