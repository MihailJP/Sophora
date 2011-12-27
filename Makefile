DIRS=utils srcgif
TARGETS=Sophora-ExtraLight.otf Sophora-Light.otf Sophora-Book.otf Sophora-Medium.otf Sophora-Demi-Bold.otf Sophora-Bold.otf
DISTDIR=Sophora
DISTFILE=Sophora.7z
DOCS=readme.txt pua.txt

.PHONY: all clean $(DIRS) dist

all: $(TARGETS)

.SUFFIXES: .sfd .otf
Sophora-ExtraLight.sfd: Sophora.sfd
	fontforge -lang=ff -c "Open(\"$<\");SelectWorthOutputting();Scale(130,0,0);Save(\"$@\")"

Sophora-Light.sfd: Sophora-ExtraLight.sfd
	fontforge -script ./utils/pe/embolden.pe $< 8 Light $@

Sophora-Book.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 15 Book $@

Sophora-Medium.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 30 Medium $@

Sophora-Demi-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 45 Demi-Bold $@

Sophora-Bold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 60 Bold $@

Sophora-ExtraBold.sfd: Sophora-Light.sfd
	fontforge -script ./utils/pe/embolden.pe $< 75 ExtraBold $@

.sfd.otf:
	fontforge -script ./utils/pe/makefont.pe $< $@

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(TARGETS:.otf=.sfd) *~ *.bak $(DISTFILE)
	-rm -rf $(DISTDIR)

dist: all
	-rm -rf $(DISTDIR)
	-mkdir $(DISTDIR)
	cp $(TARGETS) $(DOCS) $(DISTDIR)
	7za a -mx=9 $(DISTFILE) $(DISTDIR)
