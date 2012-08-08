#!/usr/local/bin/fontforge -script

import sys
import psMat
import fontforge
from math import hypot

def fixContour(glyph):
  newLayer = fontforge.layer()
  for contour in glyph.foreground.__iter__():
    newContour = fontforge.contour()
    tmpContour = fontforge.contour()
    lastX = None; lastY = None
    firstX = None; firstY = None
    for point in contour.__iter__():
      if (lastX is None) or (lastY is None):
        lastX = point.x; lastY = point.y
        firstX = point.x; firstY = point.y
        newContour += point
      else:
        tmpContour += point
        if point.on_curve:
          if hypot(point.x - lastX, point.y - lastY) > 3.0:
            newContour += tmpContour
          tmpContour = fontforge.contour()
          lastX = point.x; lastY = point.y
    if hypot(firstX - lastX, firstY - lastY) > 3.0:
      newContour += tmpContour
    newContour.closed = True
    newLayer += newContour
  glyph.foreground = newLayer

if (len(sys.argv) < 3):
  print 'Usage: fontforge -script %s source-file target-file' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])

for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if glyph.color == 0xd4d400:
      glyph.unlinkRef()

print 'Changing weight...'
for glyph in BaseFont.glyphs():
  if glyph.isWorthOutputting():
    if (glyph.color == 0xff8000) or (glyph.color == 0x00d4d4) or (glyph.color == 0xd4d400):
      glyph.transform(psMat.scale(2.0))
      glyph.stroke("circular", 10, "butt", "miter", ("removeexternal", "cleanup"))
      fixContour(glyph)
      glyph.transform(psMat.scale(0.5))

print 'Saving target file %s...' % sys.argv[2]
BaseFont.save(sys.argv[2])
