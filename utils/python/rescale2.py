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
    if glyph.color == 0xd4d400:
      glyph.unlinkRef()
    if (glyph.color == 0xff8000) or (glyph.color == 0x00d4d4) or (glyph.color == 0xd4d400):
      BaseFont.selection.select(("more",), glyph)

print 'Rescaling J...'
BaseFont.transform(psMat.scale(1.28206))
BaseFont.transform(psMat.translate(0,-120))

BaseFont.selection.none()
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if glyph.color == 0xd4d400:
      glyph.unlinkRef()
    if (glyph.color == 0xff8000) or (glyph.color == 0x00d4d4) or (glyph.color == 0xd4d400):
      pass
    else:
      BaseFont.selection.select(("more",), glyph)

print 'Rescaling E...'
BaseFont.transform(psMat.scale(1.28206))

print 'Saving target file %s...' % sys.argv[2]
BaseFont.save(sys.argv[2])
