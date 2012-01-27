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
GlyphDifference = [(),]; GlyphCode = [(),]
FontNum = 2
while FontNum < len(sys.argv):
  glyphSuffix = "font%04d" % FontNum
  print 'Loading addend file %s...' % sys.argv[FontNum]
  AddendFont = fontforge.open(sys.argv[FontNum])
  FontName += (AddendFont.fontname,); FullName += (AddendFont.fullname,); FamilyName += (AddendFont.fullname,)
  GlyphDifference += [(),]; GlyphCode += [(),]
  for Glyph in AddendFont.glyphs():
    if Glyph.isWorthOutputting():
      GlyphName = Glyph.glyphname; GlyphDiffers = False
      try:
        GlyphDiffers = ((Glyph.foreground != BaseFont[GlyphName].foreground) or (Glyph.width != BaseFont[GlyphName].width))
      except TypeError, inst:
        r = re.compile("No such glyph")
        if r.match(str(inst)):
          print "%s is a new glyph" % Glyph.glyphname
          GlyphDiffers = True
        else:
          raise
      else:
        if GlyphDiffers:
          print "%s differs" % Glyph.glyphname
      if GlyphDiffers:
        BaseFont.createChar(-1,"%s.%s" % (GlyphName, glyphSuffix))
        AddendFont.selection.select(GlyphName)
        AddendFont.copy()
        BaseFont.selection.select("%s.%s" % (GlyphName, glyphSuffix))
        BaseFont.paste()
        GlyphDifference[FontNum-1] += (GlyphName,)
        GlyphCode[FontNum-1] += (Glyph.unicode,)
  AddendFont.close()
  FontNum += 1

fncnv = re.compile('\.sfd$')
BaseFile = fncnv.sub(".forTTC.sfd", sys.argv[1])
print "Saving into %s..." % BaseFile
BaseFont.save(BaseFile)

reFontName = re.compile('^FontName: ')
reFullName = re.compile('^FullName: ')
reFamilyName = re.compile('^FamilyName: ')
reSChar = re.compile('^StartChar: ')
reEncoding = re.compile('^Encoding: ')
reEncodingBMP = re.compile('^Encoding: UnicodeBmp')
reEncodingFull = re.compile('^Encoding: UnicodeFull')
reSpace = re.compile(' ')

FontNum = 2
while FontNum < len(sys.argv):
  TargetFile = fncnv.sub(".forTTC.sfd", sys.argv[FontNum])
  print "Converting into %s..." % TargetFile
  target = open(TargetFile, 'w')
  
  reSChar1 = {}; reSChar2 = {};
  for GlyphName in GlyphDifference[FontNum-1]:
    reSChar1[GlyphName] = re.compile('^StartChar: %s$' % GlyphName)
    reSChar2[GlyphName] = re.compile('^StartChar: %s\.font%04d' % (GlyphName, FontNum))
  PreviousSwapType = 0; PreviousGlyph = 0
  for line in open(BaseFile, 'r'):
    if reFontName.match(line):
      target.write("Fontname: %s\n" % FontName[FontNum-1])
    elif reFullName.match(line):
      target.write("FullName: %s\n" % FullName[FontNum-1])
    elif reFamilyName.match(line):
      target.write("FamilyName: %s\n" % FamilyName[FontNum-1])
    elif reSChar.match(line):
      GlyphSwapFlag = 0; PreviousGlyph = 0
      for GlyphName in GlyphDifference[FontNum-1]:
        if reSChar1[GlyphName].match(line):
          GlyphSwapFlag = 1; PreviousSwapType = 1; break
        elif reSChar2[GlyphName].match(line):
          GlyphSwapFlag = 2; PreviousSwapType = 2; break
        PreviousGlyph += 1
      if GlyphSwapFlag == 1:
        target.write("StartChar: %s.font0001\n" % GlyphName)
      elif GlyphSwapFlag == 2:
        target.write("StartChar: %s\n" % GlyphName)
      else:
        target.write(line)
    elif reEncoding.match(line):
      if PreviousSwapType == 1:
        sp = reSpace.split(line)
        target.write("Encoding: %d %d %d\n" % (int(sp[1]), -1, int(sp[3])))
      elif PreviousSwapType == 2:
        sp = reSpace.split(line)
        target.write("Encoding: %d %d %d\n" % (int(sp[1]), GlyphCode[FontNum-1][PreviousGlyph], int(sp[3])))
      elif reEncodingBMP.match(line):
        target.write("Encoding: Custom\n")
      elif reEncodingFull.match(line):
        target.write("Encoding: Custom\n")
      else:
        target.write(line)
      PreviousSwapType = 0; PreviousGlyph = 0
    else:
      target.write(line)
  target.close()
  FontNum += 1
