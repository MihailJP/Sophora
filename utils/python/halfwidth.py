#!/usr/local/bin/fontforge -script

import sys
import re
import fontforge

HackFlag = False
if (len(sys.argv) < 4):
  print 'Usage: fontforge -script %s base-sfd halfwidth-sfd target-file' % sys.argv[0]
  exit(1)
elif (len(sys.argv) > 4):
  HackFlag = boolean(sys.argv[4])

print "Reading source files..."
Base = fontforge.open(sys.argv[1])
HW = fontforge.open(sys.argv[2])
basewidth = HW["a"].width

ReferenceGlyph = ()
print "Checking for references..."
for Glyph in Base.glyphs():
  if Glyph.isWorthOutputting():
    for Ref in Glyph.references:
      ReferenceGlyph += (Glyph.glyphname,Ref[0])

print "Unlinking references..."
for Glyph in Base.glyphs():
  if Glyph.isWorthOutputting():
    Glyph.unlinkRef()

print "Adding glyph slots..."
Base.createChar(-1,"dotlessi.half")
Base.createChar(-1,"dotlessj.half")

print "Copying the halfwidth glyphs..."
for Glyph in HW.glyphs():
  if Glyph.isWorthOutputting():
    col = Glyph.color
    nom = Glyph.glyphname
    HW.selection.select(nom)
    HW.copy()
    Base.selection.select(nom)
    Base.paste()
    Base[nom].color = col

print "Changing the font information..."
p = re.compile('-Italic')
if HackFlag:
  Base.fullname = Base.familyname+" HW Hack "+p.sub(' Italic',Base.weight)
  Base.fontname = Base.familyname+"HWHack-"+Base.weight
  Base.familyname = Base.familyname+" HW Hack"
else:
  Base.fullname = Base.familyname+" HW "+p.sub(' Italic',Base.weight)
  Base.fontname = Base.familyname+"HW-"+Base.weight
  Base.familyname = Base.familyname+" HW"
Base.os2_winascent = Base.ascent * 1.25; Base.os2_winascent_add = 0
Base.os2_windescent = Base.descent * 2; Base.os2_windescent_add = 0
Base.os2_typoascent = Base.ascent * 1.25; Base.os2_typoascent_add = 0
Base.os2_typodescent = -Base.descent * 2; Base.os2_typodescent_add = 0
Base.os2_typolinegap = 0
#Base.hhea_ascent = Base.ascent * 1.25; Base.hhea_ascent_add = 0
#Base.hhea_descent = -Base.descent * 2; Base.hhea_descent_add = 0
Base.hhea_linegap = 0
Base["i"].addPosSub("Dotless forms-1", "dotlessi.half")
Base["j"].addPosSub("Dotless forms-1", "dotlessj.half")

print "Replacing with references..."
Base.selection.none()
for Glyph in ReferenceGlyph:
  Base.selection.select(("more",),Glyph)
Base.replaceWithReference()

print "Saving halfwidth SFD..."
Base.save(sys.argv[3])
