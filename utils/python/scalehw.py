#!/usr/local/bin/fontforge -script

import sys
import fontforge
import psMat

if (len(sys.argv) < 3):
  print 'Usage: %s source-file target-file' % sys.argv[0]
  quit(1)

Font = fontforge.open(sys.argv[1])

for Glyph in Font.glyphs():
  if Glyph.isWorthOutputting():
    print Glyph.glyphname
    Glyph.transform(psMat.scale(1.0,1.3))
    Glyph.stroke("eliptical",8,2,0,"round","round",("removeinternal",))

Font.save(sys.argv[2])
