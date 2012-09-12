def isJGlyphP(glyph):
  return (glyph.color == 0xd4d400)

def isJGlyph(glyph):
  return (glyph.color == 0xff8000) or (glyph.color == 0x00d4d4) or (glyph.color == 0x00d400) or isJGlyphP(glyph)
