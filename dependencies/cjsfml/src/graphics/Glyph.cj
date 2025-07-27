package cjsfml.graphics

@C
public struct Glyph {
    public var advance: Float32 = 0.0
    public var bounds: FloatRect = FloatRect()
    public var textureRect: IntRect = IntRect()
}
