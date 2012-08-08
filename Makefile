#
# Makefile for Sophora
#

# Variants

.SUFFIXES: .sfd .otf .ttf .ttc .7z

DIRS=srcgif
WEIGHTS=Light Book Medium Demi-Bold Bold
VARIANTS=Sophora SophoraP SophoraHW
OTF=$(WEIGHTS:%=Sophora-%.otf) $(WEIGHTS:%=SophoraP-%.otf) \
    $(WEIGHTS:%=Sophora-%-Italic.otf) $(WEIGHTS:%=SophoraP-%-Italic.otf) \
    $(WEIGHTS:%=SophoraHW-%.otf) $(WEIGHTS:%=SophoraHW-%-Italic.otf)
TTF=$(OTF:.otf=.ttf)
PRETTF=$(OTF:.otf=.forTTC.sfd) $(OTF:.otf=.forTTC.ttf)
TTC=$(WEIGHTS:%=Sophora-%.ttc) $(WEIGHTS:%=Sophora-%-Italic.ttc)
TARGETS=$(OTF) $(TTF) $(TTC)
DOCS=readme.txt pua.txt history.txt
DISTFILE=Sophora-OTF.7z Sophora-TTF.7z Sophora.7z
DISTDIR=$(DISTFILE:.7z=)

# All targets

.PHONY: all clean $(DIRS) dist otf ttf
all: $(TARGETS)

otf: $(OTF)
ttf: $(TTF)
ttc: $(TTC)

# Scaling

Sophora-Light.tmp.sfd: Sophora.sfd
	./utils/sh/scale.sh $< $@

# Weight variant

Sophora-Book.tmp.sfd: Sophora-Light.tmp.sfd
	./utils/pe/embolden.pe $< 15 Book $@
Sophora-Medium.tmp.sfd: Sophora-Light.tmp.sfd
	./utils/pe/embolden.pe $< 30 Medium $@
Sophora-Demi-Bold.tmp.sfd: Sophora-Light.tmp.sfd
	./utils/pe/embolden.pe $< 45 Demi-Bold $@
Sophora-Bold.tmp.sfd: Sophora-Light.tmp.sfd
	./utils/pe/embolden.pe $< 60 Bold $@

Sophora-Light.tmp3.sfd: Sophora.sfd
	./utils/python/debolden.py $< $@

# Rescaling

Sophora-Light.tmp2.sfd: Sophora-Light.tmp.sfd
	./utils/python/rescale.py $< $@
Sophora-Book.tmp2.sfd: Sophora-Book.tmp.sfd
	./utils/python/rescale.py $< $@
Sophora-Medium.tmp2.sfd: Sophora-Medium.tmp.sfd
	./utils/python/rescale.py $< $@
Sophora-Demi-Bold.tmp2.sfd: Sophora-Demi-Bold.tmp.sfd
	./utils/python/rescale.py $< $@
Sophora-Bold.tmp2.sfd: Sophora-Bold.tmp.sfd
	./utils/python/rescale.py $< $@
Sophora-Light.tmp4.sfd: Sophora-Light.tmp3.sfd
	./utils/python/rescale.py $< $@

# Overlay

Sophora-Light.sfd: Sophora-Light.tmp2.sfd Sophora-Light.tmp4.sfd
	./utils/python/overlay.py $^ $@
Sophora-Book.sfd: Sophora-Book.tmp2.sfd Sophora-Light.tmp2.sfd
	./utils/python/overlay.py $^ $@
Sophora-Medium.sfd: Sophora-Medium.tmp2.sfd Sophora-Book.tmp2.sfd
	./utils/python/overlay.py $^ $@
Sophora-Demi-Bold.sfd: Sophora-Demi-Bold.tmp2.sfd Sophora-Medium.tmp2.sfd
	./utils/python/overlay.py $^ $@
Sophora-Bold.sfd: Sophora-Bold.tmp2.sfd Sophora-Demi-Bold.tmp2.sfd
	./utils/python/overlay.py $^ $@

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
italic.tmp.sfd: italic.sfd
	./utils/python/sparse.py $< $@
italic-Light.sfd: italic.tmp.sfd
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
halfwidth.tmp.sfd: italic.sfd
	./utils/python/sparse.py $< $@
halfwidth-Light.sfd: halfwidth.tmp.sfd
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
halfitalic.tmp.sfd: italic.sfd
	./utils/python/sparse.py $< $@
halfitalic-Light.sfd: halfitalic.tmp.sfd
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


# TTC preparation

Sophora-Light.forTTC.sfd: $(VARIANTS:%=%-Light.sfd)
	./utils/python/merge.py $^
Sophora-Book.forTTC.sfd: $(VARIANTS:%=%-Book.sfd)
	./utils/python/merge.py $^
Sophora-Medium.forTTC.sfd: $(VARIANTS:%=%-Medium.sfd)
	./utils/python/merge.py $^
Sophora-Demi-Bold.forTTC.sfd: $(VARIANTS:%=%-Demi-Bold.sfd)
	./utils/python/merge.py $^
Sophora-Bold.forTTC.sfd: $(VARIANTS:%=%-Bold.sfd)
	./utils/python/merge.py $^
SophoraP-Light.forTTC.sfd: Sophora-Light.forTTC.sfd
SophoraP-Book.forTTC.sfd: Sophora-Book.forTTC.sfd
SophoraP-Medium.forTTC.sfd: Sophora-Medium.forTTC.sfd
SophoraP-Demi-Bold.forTTC.sfd: Sophora-Demi-Bold.forTTC.sfd
SophoraP-Bold.forTTC.sfd: Sophora-Bold.forTTC.sfd
SophoraHW-Light.forTTC.sfd: Sophora-Light.forTTC.sfd
SophoraHW-Book.forTTC.sfd: Sophora-Book.forTTC.sfd
SophoraHW-Medium.forTTC.sfd: Sophora-Medium.forTTC.sfd
SophoraHW-Demi-Bold.forTTC.sfd: Sophora-Demi-Bold.forTTC.sfd
SophoraHW-Bold.forTTC.sfd: Sophora-Bold.forTTC.sfd

Sophora-Light-Italic.forTTC.sfd: $(VARIANTS:%=%-Light-Italic.sfd)
	./utils/python/merge.py $^
Sophora-Book-Italic.forTTC.sfd: $(VARIANTS:%=%-Book-Italic.sfd)
	./utils/python/merge.py $^
Sophora-Medium-Italic.forTTC.sfd: $(VARIANTS:%=%-Medium-Italic.sfd)
	./utils/python/merge.py $^
Sophora-Demi-Bold-Italic.forTTC.sfd: $(VARIANTS:%=%-Demi-Bold-Italic.sfd)
	./utils/python/merge.py $^
Sophora-Bold-Italic.forTTC.sfd: $(VARIANTS:%=%-Bold-Italic.sfd)
	./utils/python/merge.py $^
SophoraP-Light-Italic.forTTC.sfd: Sophora-Light-Italic.forTTC.sfd
SophoraP-Book-Italic.forTTC.sfd: Sophora-Book-Italic.forTTC.sfd
SophoraP-Medium-Italic.forTTC.sfd: Sophora-Medium-Italic.forTTC.sfd
SophoraP-Demi-Bold-Italic.forTTC.sfd: Sophora-Demi-Bold-Italic.forTTC.sfd
SophoraP-Bold-Italic.forTTC.sfd: Sophora-Bold-Italic.forTTC.sfd
SophoraHW-Light-Italic.forTTC.sfd: Sophora-Light-Italic.forTTC.sfd
SophoraHW-Book-Italic.forTTC.sfd: Sophora-Book-Italic.forTTC.sfd
SophoraHW-Medium-Italic.forTTC.sfd: Sophora-Medium-Italic.forTTC.sfd
SophoraHW-Demi-Bold-Italic.forTTC.sfd: Sophora-Demi-Bold-Italic.forTTC.sfd
SophoraHW-Bold-Italic.forTTC.sfd: Sophora-Bold-Italic.forTTC.sfd

# Build TTC
Sophora-Light.ttc: $(VARIANTS:%=%-Light.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Book.ttc: $(VARIANTS:%=%-Book.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Medium.ttc: $(VARIANTS:%=%-Medium.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Demi-Bold.ttc: $(VARIANTS:%=%-Demi-Bold.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Bold.ttc: $(VARIANTS:%=%-Bold.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Light-Italic.ttc: $(VARIANTS:%=%-Light-Italic.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Book-Italic.ttc: $(VARIANTS:%=%-Book-Italic.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Medium-Italic.ttc: $(VARIANTS:%=%-Medium-Italic.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Demi-Bold-Italic.ttc: $(VARIANTS:%=%-Demi-Bold-Italic.forTTC.ttf)
	UniteTTC $@ $^
Sophora-Bold-Italic.ttc: $(VARIANTS:%=%-Bold-Italic.forTTC.ttf)
	UniteTTC $@ $^


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
		$(TARGETS:%.otf=%.tmp.sfd) \
		$(TARGETS:%.otf=%.tmp2.sfd) \
		Sophora-Light.tmp3.sfd \
		Sophora-Light.tmp4.sfd \
		italic.sfd italic.tmp.sfd italic-*.sfd \
		halfwidth.sfd halfwidth.tmp.sfd halfwidth-*.sfd \
		halfitalic.sfd halfitalic.tmp.sfd halfitalic-*.sfd \
		$(PRETTF) \
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
Sophora.7z: $(TTC) $(DOCS)
	-rm -rf $*
	mkdir $*;cp $^ $*
	7za a -mx=9 $@ $*

#dist: $(DISTFILE)
dist: Sophora.7z
