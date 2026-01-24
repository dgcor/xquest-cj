package dgengine

import cenum.*
import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*

public type PaletteArray = Array<Color>

@Enum[public ColorFormat](
    RGB
    BGR
    RGBA
    BGRA
    ARGB
    ABGR
)

extend ColorFormat {
    public static func get(str: String): ColorFormat {
        match (str.toAsciiLower()) {
            case "bgr" => BGR
            case "rgba" => RGBA
            case "bgra" => BGRA
            case "argb" => ARGB
            case "abgr" => ABGR
            case _ => RGB
        }
    }
}

public class Palette <: Iterable<Color> & Resource {
    public let texture: Texture
    public let palette: PaletteArray

    public init() {
        // grayscale palette
        palette = PaletteArray(
            256,
            {
                index =>
                    let c = UInt8(index)
                    Color(c, c, c, 255)
            }
        )
        let width = UInt32(palette.size)
        texture = Texture(Vector2u(width, 1))
        texture.update(palette, Vector2u(width, 1), Vector2u())
    }

    /**
     * @throws Exception
     */
    public init(fileName: String, colorFormat: ColorFormat) {
        palette = PaletteArray(256, repeat: Color())

        let bytes = NumberVector<UInt8>(fileName, maxNumElements: 1024).data
        if (bytes.size < 768) {
            logger.warn("Invalid palette. using grayscale palette.")
            for (index in 0..palette.size) {
                let c = UInt8(index)
                palette[index] = Color(c, c, c, palette[index].a)
            }
        } else {
            let has4ByteColor = bytes.size == 1024
            var i = 0
            for (index in 0..palette.size) {
                var r = Box(bytes[i])
                i++
                var g = Box(bytes[i])
                i++
                var b = Box(bytes[i])
                i++
                var a: Box<UInt8> = Box(255)
                if (colorFormat >= ColorFormat.RGBA && has4ByteColor == true) {
                    a.value = bytes[i]
                    i++
                }
                if (colorFormat == ColorFormat.BGR || colorFormat == ColorFormat.BGRA) {
                    swap(r, b)
                } else if (colorFormat == ColorFormat.ARGB) {
                    if (has4ByteColor == true) {
                        swap(b, a)
                        swap(a, r)
                        swap(r, g)
                    }
                } else if (colorFormat == ColorFormat.ABGR) {
                    if (has4ByteColor == true) {
                        swap(a, r)
                        swap(b, g)
                    }
                }
                palette[index] = Color(r.value, g.value, b.value, a.value)
            }
        }
        try (img = SFMLImage(Vector2u(UInt32(palette.size), 1), palette)) {
            texture = Texture(img)
            return
        }
        throw Exception("Failed to initialize Palette")
    }

    /**
     * @throws Exception
     */
    public init(pal: Palette, trn: Array<Byte>, start: Int64, length: Int64) {
        palette = PaletteArray(256, repeat: Color())
        if (start + length <= trn.size) {
            for (index in 0..length) {
                palette[index] = pal[Int64(trn[start + index])]
            }
        }
        try (img = SFMLImage(Vector2u(UInt32(palette.size), 1), palette)) {
            texture = Texture(img)
            return
        }
        throw Exception("Failed to initialize Palette")
    }

    /**
     * @throws Exception
     */
    protected init(pal: PaletteArray) {
        palette = pal.clone()
        try (img = SFMLImage(Vector2u(UInt32(palette.size), 1), palette)) {
            texture = Texture(img)
            return
        }
        throw Exception("Failed to initialize Palette")
    }

    public func clone(): Palette {
        Palette(palette)
    }

    // Resource

    public func isClosed(): Bool {
        texture.isClosed()
    }

    public func close(): Unit {
        texture.close()
    }

    // Iterable

    public func iterator(): Iterator<Color> {
        palette.iterator()
    }

    // Palette

    public operator func [](index: Int64): Color {
        palette[index]
    }

    private func updateTexture(): Unit {
        texture.update(palette, Vector2u(UInt32(palette.size), 1), Vector2u())
    }

    public func shiftLeft(shift: Int64, startIdx: Int64, stopIdx: Int64): Bool {
        if (stopIdx <= palette.size && startIdx < stopIdx) {
            rotate(palette[startIdx..stopIdx], shift)
            updateTexture()
            return true
        }
        return false
    }

    public func shiftRight(shift: Int64, startIdx: Int64, stopIdx: Int64): Bool {
        if (stopIdx <= palette.size && startIdx < stopIdx) {
            rotate(palette[startIdx..stopIdx], -shift)
            updateTexture()
            return true
        }
        return false
    }

    public func replaceRange(srcPal: Palette, srcStartIdx: Int64, size: Int64, dstStartIdx: Int64): Bool {
        if (srcStartIdx + size <= srcPal.palette.size && dstStartIdx + size <= palette.size) {
            srcPal.palette.copyTo(palette, srcStartIdx, dstStartIdx, size)
            updateTexture()
            return true
        }
        return false
    }
}
