#!/usr/local/bin/fontforge

import sys
import fontforge

if (len(sys.argv) < 3):
  print 'Usage: fontforge -script %s target-ttc source-files' % sys.argv[0]
  quit(1)

MainFont = fontforge.open(sys.argv[2])
OtherFonts = None
if (len(sys.argv) > 4):
  OtherFonts = [None] * (len(sys.argv)-3)
  for fontnum in range(3, len(sys.argv)):
    OtherFonts[fontnum-3] = fontforge.open(sys.argv[fontnum])
  AllFonts = [MainFont] + OtherFonts
elif (len(sys.argv) == 4):
  OtherFonts = fontforge.open(sys.argv[3])
  AllFonts = [MainFont, OtherFonts]
else:
  AllFonts = [MainFont]

for font in AllFonts:
  print font
  try:
    font.em = 2048
  except TypeError:
    try:
      font.em = 2048L
    except TypeError:
      print "Unknown value type!!"
      raise
  font.selection.none()
  for glyph in font.glyphs():
    if glyph.isWorthOutputting():
      font.selection.select(("more",None),glyph)
  font.addExtrema()
  font.simplify()
  font.round()
  font.autoHint()

MainFont.generateTtc(sys.argv[1], OtherFonts, flags=(), ttcflags=('merge'))
