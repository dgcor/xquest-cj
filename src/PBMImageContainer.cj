package XQuest

import cjsfml.graphics.*
import cjsfml.graphics.Image as SFMLImage
import dgengine.*
import endian.*
import std.io.{ByteBuffer, SeekPosition}

// PBM image format
//
// https://moddingwiki.shikadi.net/wiki/Planar_VGA
//
// UInt8 0          The bitmap width in bytes(4 pixel groups) range 1..255
// UInt8 1          The bitmap height in rows range 1..255
// UInt8 2..n1      The plane 0 pixels width * height bytes
// UInt8 n1..n2     The plane 1 pixels width * height bytes
// UInt8 n2..n3     The plane 2 pixels width * height bytes
// UInt8 n3..n4     The plane 3 pixels width * height bytes

class PBMImageContainer <: LazyImageContainer {
    init(fileData: Array<Byte>) {
        super(fileData)

        if (fileData.size < 6) {
            return
        }

        let fileStream = LittleEndianReader(ByteBuffer(fileData))

        var frameStartOffset = 0u32

        while (Int64(frameStartOffset) < fileStream.length) {
            let width = UInt32(fileStream.read<UInt8>() ?? 0)
            let height = UInt32(fileStream.read<UInt8>() ?? 0)
            let frameSize = width * height * 4 + 2

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

        let framePlaneWidth = UInt32(fileStream.read<UInt8>() ?? 0)
        let framePlaneHeight = UInt32(fileStream.read<UInt8>() ?? 0)
        let frameWidth = framePlaneWidth * 4
        let frameHeight = framePlaneHeight
        let frameSize = Int64(frameWidth) * Int64(frameHeight) + 2

        if (frameSize > fileStream.length) {
            return SFMLImage(0, 0)
        }

        let img = SFMLImage(frameWidth, frameHeight, Color.black)

        for (plane in 0u32..4) {
            for (j in 0..framePlaneHeight) {
                for (i in 0..framePlaneWidth) {
                    let palIdx = fileStream.read<UInt8>() ?? 0
                    var color = Color.transparent
                    if (palIdx != 0) {
                        color = ImageContainer.getColor(palIdx, palette)
                    }
                    img.setPixel(i * 4 + plane, j, color)
                }
            }
        }
        return img
    }
}
