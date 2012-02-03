#!/usr/local/bin/fontforge -script

import sys
import re
import fontforge

if (len(sys.argv) < 3):
  print 'Usage: fontforge -script %s source-file1 source-file2 [source-file3 ...]' % sys.argv[0]
  quit(1)

print 'Loading base file %s...' % sys.argv[1]
BaseFont = fontforge.open(sys.argv[1])

FontName = (BaseFont.fontname,); FullName = (BaseFont.fullname,); FamilyName = (BaseFont.familyname,)
GlyphDifference = [(),]; GlyphCode = [(),]
FontPanose = (BaseFont.os2_panose,)
FontMetrics = ((BaseFont.os2_typoascent, BaseFont.os2_typoascent_add,
                BaseFont.os2_typodescent, BaseFont.os2_typodescent_add,
                BaseFont.os2_typolinegap,
                BaseFont.os2_winascent, BaseFont.os2_winascent_add,
                BaseFont.os2_windescent, BaseFont.os2_windescent_add,
                BaseFont.hhea_ascent, BaseFont.hhea_ascent_add,
                BaseFont.hhea_descent, BaseFont.hhea_descent_add,
                BaseFont.hhea_linegap),)
FontNum = 2
while FontNum < len(sys.argv):
  glyphSuffix = "font%04d" % FontNum
  print 'Loading addend file %s...' % sys.argv[FontNum]
  AddendFont = fontforge.open(sys.argv[FontNum])
  FontName += (AddendFont.fontname,); FullName += (AddendFont.fullname,); FamilyName += (AddendFont.familyname,)
  GlyphDifference += [(),]; GlyphCode += [(),]
  FontPanose += (AddendFont.os2_panose,)
  FontMetrics = ((AddendFont.os2_typoascent, AddendFont.os2_typoascent_add,
                  AddendFont.os2_typodescent, AddendFont.os2_typodescent_add,
                  AddendFont.os2_typolinegap,
                  AddendFont.os2_winascent, AddendFont.os2_winascent_add,
                  AddendFont.os2_windescent, AddendFont.os2_windescent_add,
                  AddendFont.hhea_ascent, AddendFont.hhea_ascent_add,
                  AddendFont.hhea_descent, AddendFont.hhea_descent_add,
                  AddendFont.hhea_linegap),)
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
        GlyphRef = AddendFont[GlyphName].references
        AddendFont.unlinkReferences()
        AddendFont.copy()
        BaseFont.selection.select("%s.%s" % (GlyphName, glyphSuffix))
        BaseFont.paste()
        for RefGlyph in GlyphRef:
           BaseFont.selection.select(RefGlyph[0], ("more",))
        BaseFont.replaceWithReference()
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
rePanose = re.compile('^Panose: ')
reEncodingBMP = re.compile('^Encoding: UnicodeBmp')
reEncodingFull = re.compile('^Encoding: UnicodeFull')
reSpace = re.compile(' ')
MetricName = ('OS2TypoAscent', 'OS2TypoAOffset', 'OS2TypoDescent', 'OS2TypoDOffset', 'OS2TypoLinegap',
              'OS2WinAscent', 'OS2WinAOffset', 'OS2WinDescent', 'OS2WinDOffset',
              'HheadAscent', 'HheadAOffset', 'HheadDescent', 'HheadDOffset', 'LineGap')
reMetrics = (); i=0
for nom in MetricName:
  reMetrics += (re.compile('^'+MetricName[i]+': '),)
  i+=1

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
    elif rePanose.match(line):
      target.write("Panose: %d %d %d %d %d %d %d %d %d %d\n" %
      (FontPanose[FontNum-1][0], FontPanose[FontNum-1][1], FontPanose[FontNum-1][2], 
      FontPanose[FontNum-1][3], FontPanose[FontNum-1][4], FontPanose[FontNum-1][5], 
      FontPanose[FontNum-1][6], FontPanose[FontNum-1][7], FontPanose[FontNum-1][8], 
      FontPanose[FontNum-1][9]) )
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
      thruput=True; i=0
      for reg in reMetrics:
        if reg.match(line):
          target.write('%s: %d' % MetricName[i], FontMetrics[i])
          thruput=False
        i+=1
      if thruput:
        target.write(line)
  target.close()
  FontNum += 1
