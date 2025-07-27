package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public struct TextureInfo {
    public TextureInfo(
        public var texture: Texture,
        public var textureRect!: IntRect = IntRect(),
        public var palette!: ?Palette = None,
        public var offset!: Vector2f = Vector2f(),
        public var absoluteOffset!: Bool = false,
        public var blendMode!: BlendModeType = BlendAlpha,
        public var nextIndex!: Int32 = -1
    ) {}
}

public enum TextureInfoVar {
    | TextureInfoSingle(TextureInfo)
    | TextureInfoMulti(ArrayList<TextureInfo>)
}
