package xquest

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import dgengine.*
import endian.*
import std.io.{ByteBuffer, SeekPosition}

// GFX image format
//
// UInt16       The image width
// UInt16       The image height
// UInt8        The image pixels

class GFXImageContainer <: LazyImageContainer {
    init(fileData: Array<Byte>) {
        super(fileData)

        if (fileData.size < 6) {
            return
        }

        let fileStream = LittleEndianReader(ByteBuffer(fileData))

        var frameStartOffset = 0u32

        while (Int64(frameStartOffset) < fileStream.length) {
            var width = UInt32(fileStream.read<UInt16>() ?? 0)
            let height = UInt32(fileStream.read<UInt16>() ?? 0)
            width = (((width - 1) / 4) + 1) * 4
            let frameSize = width * height + 4

            if (Int64(frameStartOffset) + Int64(frameSize) > fileStream.length) {
                break
            }

            let frameEndOffset = frameStartOffset + frameSize

            m_frameOffsets.add((frameStartOffset, frameEndOffset))

            frameStartOffset = frameEndOffset
            fileStream.seek(Begin(Int64(frameEndOffset)))
        }
    }

    public func decode(frameData: Array<Byte>, palette: ?PaletteArray): SFMLImage {
        if (frameData.size == 0) {
            return SFMLImage(Vector2u())
        }

        let fileStream = LittleEndianReader(ByteBuffer(frameData))

        var frameWidth = UInt32(fileStream.read<UInt16>() ?? 0)
        let frameHeight = UInt32(fileStream.read<UInt16>() ?? 0)
        frameWidth = (((frameWidth - 1) / 4) + 1) * 4
        let frameSize = Int64(frameWidth) * Int64(frameHeight) + 4

        if (frameSize > fileStream.length) {
            return SFMLImage(Vector2u())
        }

        let img = SFMLImage(Vector2u(frameWidth, frameHeight), Color.TRANSPARENT)

        for (j in 0..frameHeight) {
            for (i in 0..frameWidth) {
                let palIdx = fileStream.read<UInt8>() ?? 0
                var color = Color.TRANSPARENT
                if (palIdx > 0) {
                    color = ImageContainer.getColor(palIdx, palette)
                }
                img.setPixel(Vector2u(i, j), color)
            }
        }
        return img
    }
}
