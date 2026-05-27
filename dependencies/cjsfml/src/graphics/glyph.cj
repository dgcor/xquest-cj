package cjsfml.graphics

/**
 * Structure describing a glyph.
 *
 * A glyph is the visual representation of a character.
 *
 * The `Glyph` structure provides the information needed
 * to handle the glyph:
 * - its coordinates in the font's texture
 * - its bounding rectangle
 * - the offset to apply to get the starting position of the next glyph
 *
 * @see `Font`
 */
@C
public struct Glyph {
    public var advance: Float32 = 0.0 // Offset to move horizontally to the next character
    public var bounds: FloatRect = FloatRect() // Bounding rectangle of the glyph, in coordinates relative to the baseline
    public var textureRect: IntRect = IntRect() // Texture coordinates of the glyph inside the font's texture
}
