#!/usr/local/bin/fontforge -script

import sys
import re
import fontforge

if (len(sys.argv) < 4):
  print 'Usage: fontforge -script %s base-sfd halfwidth-sfd target-file' % sys.argv[0]
  quit(1)

print "Reading source files..."
Base = fontforge.open(sys.argv[1])
HW = fontforge.open(sys.argv[2])
basewidth = HW["space"].width

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

print "Hacking glyph width..."
Base.addLookup("[MONO] Width Hack", "gsub_multiple", (),
  (
    ("ccmp",
      (
        ("DFLT",("dflt",)),
        ("latn",("dflt","ROM ")),
        ("kana",("dflt",)),
        ("hani",("dflt",)),
        ("grek",("dflt",)),
        ("cyrl",("dflt","MKD ","SRB ")),
        ("hebr",("dflt",)),
        ("runr",("dflt",)),
        ("brai",("dflt",)),
      )
    ),
  )
)

GlyphCount = 0
for Glyph in Base.glyphs():
  if Glyph.isWorthOutputting():
    if Glyph.width != basewidth:
      if (Glyph.color != 0x00ff00) and (Glyph.color != 0x008000):
        if (GlyphCount % 256) == 0:
          Base.addLookupSubtable("[MONO] Width Hack","[MONO] Width Hack-"+str(GlyphCount / 256))
        Glyph.width = basewidth
        Glyph.addPosSub("[MONO] Width Hack-"+str(GlyphCount / 256), (Glyph.glyphname, "space"))
        GlyphCount+=1

print "Changing the font information..."
p = re.compile('-Italic')
Base.fullname = Base.familyname+" HW "+p.sub(' Italic',Base.weight)
Base.fontname = Base.familyname+"-HW-"+Base.weight
Base.familyname = Base.familyname+" HW"
Base.os2_winascent = Base.ascent; Base.os2_winascent_add = 0
Base.os2_windescent = Base.descent; Base.os2_windescent_add = 0
Base.os2_typoascent = Base.ascent; Base.os2_typoascent_add = 0
Base.os2_typodescent = -Base.descent; Base.os2_typodescent_add = 0
Base.os2_typolinegap = 0
Base.hhea_ascent = Base.ascent; Base.hhea_ascent_add = 0
Base.hhea_descent = -Base.descent; Base.hhea_descent_add = 0
Base.hhea_linegap = 0
Base["i"].addPosSub("Dotless forms-1", "dotlessi.half")
Base["j"].addPosSub("Dotless forms-1", "dotlessj.half")

print "Replacing with references..."
Base.selection.none()
for Glyph in Base.glyphs():
  if Glyph.isWorthOutputting():
    Base.selection.select(("more",),Glyph)
Base.replaceWithReference()

print "Saving halfwidth SFD..."
Base.save(sys.argv[3])
