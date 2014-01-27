#!/usr/local/bin/fontforge -script

import sys
import psMat
import fontforge
from color import isJGlyphP, isJGlyph

if (len(sys.argv) < 3):
  print 'Usage: %s source-file target-file' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if isJGlyphP(glyph):
      glyph.unlinkRef()
    if isJGlyph(glyph):
      BaseFont.selection.select(("more",), glyph)

WidthE = BaseFont["ahiragana"].width
WidthV = BaseFont["ahiragana"].vwidth
      
print 'Rescaling...'
BaseFont.transform(psMat.scale(1.2))
BaseFont.transform(psMat.translate(0,-50))

WidthJ = BaseFont["ahiragana"].width
WidthA = BaseFont["A"].width

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if not isJGlyph(glyph):
      BaseFont.selection.select(("more",), glyph)

print 'Moving...'
BaseFont.transform(psMat.translate(float(WidthJ - WidthE) / 2.0, 0.0))
for glyph in BaseFont.selection.byGlyphs:
  if glyph.width >= WidthE:
    glyph.width = WidthJ
  else:
    glyph.width = WidthJ / 2
  glyph.vwidth = WidthV

print 'Saving target file %s...' % sys.argv[2]
BaseFont.save(sys.argv[2])
