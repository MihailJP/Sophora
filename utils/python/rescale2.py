#!/usr/bin/env fontforge

import sys
import psMat
import fontforge
from color import isJGlyphP, isJGlyph

if (len(sys.argv) < 3):
  print('Usage: %s source-file target-file' % sys.argv[0])
  quit(1)

print('Loading base file %s...' % sys.argv[1])
BaseFont = fontforge.open(sys.argv[1])

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if isJGlyphP(glyph):
      glyph.unlinkRef()
    if isJGlyph(glyph):
      BaseFont.selection.select(("more",), glyph)

print('Rescaling J...')
BaseFont.transform(psMat.scale(1.28206))
BaseFont.transform(psMat.translate(0,-120))

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if not isJGlyph(glyph):
      BaseFont.selection.select(("more",), glyph)

print('Rescaling E...')
BaseFont.transform(psMat.scale(1.28206))

print('Saving target file %s...' % sys.argv[2])
BaseFont.save(sys.argv[2])
