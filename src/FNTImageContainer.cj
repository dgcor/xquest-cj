package XQuest

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import dgengine.*
import endian.*
import std.io.{ByteBuffer, SeekPosition}

// FNT image format
//
// UInt8        The ASCII character index
// UInt16       The image width
// UInt16       The image height
// UInt8        The image pixels

class FNTImageContainer <: LazyImageContainer {
    init(fileData: Array<Byte>) {
        super(fileData)

        if (fileData.size < 6) {
            return
        }

        let fileStream = LittleEndianReader(ByteBuffer(fileData))

        var frameStartOffset = 0u32

        while (Int64(frameStartOffset) < fileStream.length) {
            fileStream.seek(Current(1)) // font char
            let width = UInt32(fileStream.read<UInt16>() ?? 0)
            let height = UInt32(fileStream.read<UInt16>() ?? 0)
            let frameSize = width * height + 5

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
            return SFMLImage(0, 0)
        }

        let fileStream = LittleEndianReader(ByteBuffer(frameData))

        fileStream.seek(Current(1)) // font char
        let frameWidth = UInt32(fileStream.read<UInt16>() ?? 0)
        let frameHeight = UInt32(fileStream.read<UInt16>() ?? 0)
        let frameSize = Int64(frameWidth) * Int64(frameHeight) + 5

        if (frameSize > fileStream.length) {
            return SFMLImage(0, 0)
        }

        let img = SFMLImage(frameWidth, frameHeight, Color.transparent)

        for (j in 0..frameHeight) {
            for (i in 0..frameWidth) {
                let palIdx = fileStream.read<UInt8>() ?? 0
                var color = Color.transparent
                if (palIdx > 0) {
                    color = ImageContainer.getColor(palIdx, palette)
                }
                img.setPixel(i, j, color)
            }
        }
        return img
    }

    private func decodeImageSize(frameData: Array<Byte>): Vector2u {
        if (frameData.size == 0) {
            return Vector2u()
        }

        let fileStream = LittleEndianReader(ByteBuffer(frameData))

        fileStream.seek(Current(1)) // font char
        let frameWidth = UInt32(fileStream.read<UInt16>() ?? 0)
        let frameHeight = UInt32(fileStream.read<UInt16>() ?? 0)

        return Vector2u(frameWidth, frameHeight)
    }

    public override func getImageSize(index: UInt32): Vector2u {
        let idx = Int64(index)
        if (idx >= m_frameOffsets.size) {
            return Vector2u()
        }

        let frameStart = Int64(m_frameOffsets[idx][0])
        let frameEnd = Int64(m_frameOffsets[idx][1])
        let frameData = m_fileData[frameStart..frameEnd]

        return decodeImageSize(frameData)
    }
}
