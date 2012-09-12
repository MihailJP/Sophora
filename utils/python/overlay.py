#!/usr/local/bin/fontforge -script

import sys
import fontforge
from color import isJGlyphP, isJGlyph

if (len(sys.argv) < 4):
  print 'Usage: fontforge -script %s base-file overlay-file target-file' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])
print 'Loading overlay file %s...' % sys.argv[2]
OvlFont = fontforge.open(sys.argv[2])


for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if isJGlyphP(glyph):
      glyph.unlinkRef()

BaseFont.selection.none(); OvlFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if isJGlyph(glyph):
      OvlFont.selection.select(("more",), glyph.glyphname)
      BaseFont.selection.select(("more",), glyph)
print 'Overlaying...'
OvlFont.copy()
BaseFont.paste()

print 'Saving target file %s...' % sys.argv[3]
BaseFont.save(sys.argv[3])
