package dgengine

import cjsfml.graphics.Image as SFMLImage
import cjsfml.system.*
import std.collection.*

// Lazy loading image container for common formats
public abstract class LazyImageContainer <: ImageContainer {
    protected let m_fileData: Array<Byte>
    protected let m_frameOffsets: ArrayList<(UInt32, UInt32)> = ArrayList<(UInt32, UInt32)>()
    protected var m_blendMode: BlendModeType = BlendAlpha

    public init(fileData: Array<Byte>) {
        m_fileData = fileData
    }

    public mut open prop blendMode: BlendModeType {
        get() {
            m_blendMode
        }
        set(value) {
            m_blendMode = value
        }
    }

    public func decode(frameData: Array<Byte>, palette: ?PaletteArray): SFMLImage

    public open func get(index: UInt32, palette: ?PaletteArray): ?(SFMLImage, ImageInfo) {
        let idx = Int64(index)
        if (idx >= m_frameOffsets.size) {
            return None
        }

        let frameStart = Int64(m_frameOffsets[idx][0])
        let frameEnd = Int64(m_frameOffsets[idx][1])
        let frameData = m_fileData[frameStart..frameEnd]

        return (decode(frameData, palette), ImageInfo(blendMode: m_blendMode))
    }

    public open prop size: UInt32 {
        get() {
            UInt32(m_frameOffsets.size)
        }
    }

    public open prop directions: UInt32 {
        get() {
            1
        }
    }
}
