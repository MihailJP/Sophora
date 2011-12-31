DIRS=utils srcgif
TARGETS=Sophora-Light.ttc Sophora-Book.ttc Sophora-Medium.ttc \
        Sophora-Demi-Bold.ttc Sophora-Bold.ttc
SOURCES=$(TARGETS:%.ttc=%.sfd) \
        $(TARGETS:Sophora-%.ttc=Sophora-P-%.sfd)
DISTDIR=Sophora
DISTFILE=Sophora.7z
DOCS=readme.txt pua.txt

.PHONY: all clean $(DIRS) dist a

all: $(TARGETS)

.SUFFIXES: .sfd .ttc
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

Sophora-Light.ttc: Sophora-Light.sfd Sophora-P-Light.sfd
	fontforge -script ./utils/python/makettc.py $@ $^
Sophora-Book.ttc: Sophora-Book.sfd Sophora-P-Book.sfd
	fontforge -script ./utils/python/makettc.py $@ $^
Sophora-Medium.ttc: Sophora-Medium.sfd Sophora-P-Medium.sfd
	fontforge -script ./utils/python/makettc.py $@ $^
Sophora-Demi-Bold.ttc: Sophora-Demi-Bold.sfd Sophora-P-Demi-Bold.sfd
	fontforge -script ./utils/python/makettc.py $@ $^
Sophora-Bold.ttc: Sophora-Bold.sfd Sophora-P-Bold.sfd
	fontforge -script ./utils/python/makettc.py $@ $^

srcgif: utils
	cd $@;make

utils:
	cd $@;make

clean:
	-for i in $(DIRS); do cd $$i;make clean;cd ..;done
	-rm $(TARGETS) $(SOURCES) *~ *.bak $(DISTFILE)
	-rm -rf $(DISTDIR)

dist: all
	-rm -rf $(DISTDIR)
	-mkdir $(DISTDIR)
	cp $(TARGETS) $(DOCS) $(DISTDIR)
	7za a -mx=9 $(DISTFILE) $(DISTDIR)
