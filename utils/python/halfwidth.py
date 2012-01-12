#!/usr/local/bin/fontforge -script

import sys
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
Base.addLookupSubtable("[MONO] Width Hack","[MONO] Width Hack-1")
for Glyph in Base.glyphs():
  if Glyph.isWorthOutputting():
    if Glyph.width != basewidth:
      if (Glyph.color != 0x00ff00) and (Glyph.color != 0x008000):
        Glyph.width = basewidth
        Glyph.addPosSub("[MONO] Width Hack-1", (Glyph.glyphname, "space"))

print "Changing the font information..."
Base.fullname = Base.familyname+" HW "+Base.weight
Base.fontname = Base.familyname+"-HW-"+Base.weight
Base.familyname = Base.familyname+" HW"
Base.os2_winascent = Base.ascent
Base.os2_windescent = Base.descent
Base.os2_winascent_add = 0
Base.os2_windescent_add = 0
Base["i"].addPosSub("Dotless forms-1", "dotlessi.half")
Base["j"].addPosSub("Dotless forms-1", "dotlessj.half")

print "Saving halfwidth SFD..."
Base.save(sys.argv[3])
