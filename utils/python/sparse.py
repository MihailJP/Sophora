#!/usr/local/bin/fontforge -script

import sys
import psMat
import fontforge

if (len(sys.argv) < 3):
  print 'Usage: fontforge -script %s source-file target-file' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    BaseFont.selection.select(("more",), glyph)

print 'Rescaling...'
for glyph in BaseFont.selection.byGlyphs:
  origWidth = glyph.width
  glyph.transform(psMat.translate(float(origWidth) * 0.1, 0.0), ("partialRefs",))
  glyph.width = origWidth * 1.2

print 'Saving target file %s...' % sys.argv[2]
BaseFont.save(sys.argv[2])
