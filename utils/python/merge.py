#!/usr/local/bin/fontforge -script

import sys
import re
import fontforge

if (len(sys.argv) < 3):
  print 'Usage: fontforge -script %s source-file1 source-file2 [source-file3 ...]' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])

FontName = (BaseFont.fontname,); FullName = (BaseFont.fullname,); FamilyName = (BaseFont.fullname,)
GlyphDifference = [(),]
FontNum = 2
while FontNum < len(sys.argv):
  glyphSuffix = "font%04d" % FontNum
  print 'Loading addend file %s...' % sys.argv[2]
  AddendFont = fontforge.open(sys.argv[2])
  FontName += (AddendFont.fontname,); FullName += (AddendFont.fullname,); FamilyName += (AddendFont.fullname,)
  GlyphDifference += [(),]
  for Glyph in AddendFont.glyphs():
    if Glyph.isWorthOutputting():
      GlyphName = Glyph.glyphname
      if Glyph.foreground != BaseFont[GlyphName].foreground:
        print "%s differs" % Glyph.glyphname
        BaseFont.createChar(-1,"%s.%s" % (GlyphName, glyphSuffix))
        AddendFont.selection.select(GlyphName)
        AddendFont.copy()
        BaseFont.selection.select("%s.%s" % (GlyphName, glyphSuffix))
        BaseFont.paste()
        GlyphDifference[FontNum-1] += (GlyphName,)
  AddendFont.close()
  FontNum += 1

fncnv = re.compile('\.sfd$')
BaseFont.save(fncnv.sub(".forTTC.sfd", sys.argv[1]))
FontNum = 2
while FontNum < len(sys.argv):
  for GlyphName in GlyphDifference[1]:
    print GlyphName
  FontNum += 1
