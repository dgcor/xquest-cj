package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*

public struct ImageInfo {
    public ImageInfo(
        public var offset!: Vector2f = Vector2f(),
        public var absoluteOffset!: Bool = false,
        public var blendMode!: BlendModeType = BlendAlpha,
        public var nextIndex!: Int32 = -1
    ) {}
}

public interface ImageContainer {
    mut prop blendMode: BlendModeType

    func get(index: UInt32, palette: ?PaletteArray): ?(SFMLImage, ImageInfo)

    func getImageSize(index: UInt32): Vector2u {
        match (get(index, None)) {
            case Some((img, _)) => img.size
            case None => Vector2u()
        }
    }

    prop size: UInt32

    // Returns number of directions. default should be 1
    prop directions: UInt32

    static func getColor(palIdx: UInt8, palette: ?PaletteArray): Color {
        match (palette) {
            case Some(palette) => palette[Int64(palIdx)]
            case None => Color(palIdx, 0, 0, 255)
        }
    }
}
