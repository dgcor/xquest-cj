package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public class ImageContainerTexturePack <: TexturePack {
    private let m_imgVec: Array<ImageContainer>
    private let m_offset: Vector2f
    private var m_palette: ?Palette
    private let m_indexed: Bool
    private let m_textureCount: UInt32
    private let m_cache: Array<?(Texture, ImageInfo)>

    public init(imgPack: ImageContainer, offset: Vector2f, palette: ?Palette, isIndexed: Bool) {
        m_imgVec = [imgPack]
        m_offset = offset
        m_palette = palette
        m_indexed = isIndexed
        m_textureCount = imgPack.size
        m_cache = Array<?(Texture, ImageInfo)>(Int64(m_textureCount), {_ => None})
    }

    public init(imgVec: Array<ImageContainer>, offset: Vector2f, palette: ?Palette, isIndexed: Bool) {
        m_imgVec = imgVec
        m_offset = offset
        m_palette = palette
        m_indexed = isIndexed
        var textureCount = 0u32
        for (imgPack in imgVec) {
            textureCount += imgPack.size
        }
        m_textureCount = textureCount
        m_cache = Array<?(Texture, ImageInfo)>(Int64(m_textureCount), {_ => None})
    }

    public prop imageContainers: Array<ImageContainer> {
        get() {
            m_imgVec
        }
    }

    private func fetchTexture(index: UInt32): Bool {
        if (m_imgVec.isEmpty() == true || index >= m_textureCount) {
            return false
        }
        if (m_cache[Int64(index)].isNone()) {
            let index = Int64(index)
            var indexX = index
            var indexY = 0
            while (indexX >= Int64(m_imgVec[indexY].size)) {
                indexX -= Int64(m_imgVec[indexY].size)
                indexY++
                if (indexY >= m_imgVec.size) {
                    return false
                }
            }
            var palArray: ?PaletteArray = None
            if (m_indexed == false) {
                palArray = m_palette?.palette
            }
            if (let Some((img, imgInfo)) <- m_imgVec[indexY].get(UInt32(indexX), palArray)) {
                try (img = img) {
                    m_cache[index] = (Texture(img), imgInfo)
                } catch (ex: Exception) {
                    logger.error(ex.message)
                    return false
                }
            }
        }
        return true
    }

    public func get(index: UInt32): ?TextureInfo {
        if (fetchTexture(index) == false) {
            return None
        }
        if (let Some((texture, imgInfo)) <- m_cache[Int64(index)]) {
            return TextureInfo(
                texture,
                textureRect: getTextureRect(texture),
                palette: m_palette,
                offset: imgInfo.offset + m_offset,
                absoluteOffset: imgInfo.absoluteOffset,
                blendMode: imgInfo.blendMode,
                nextIndex: imgInfo.nextIndex
            )
        }
        return None
    }

    public func getTextureSize(index: UInt32): Vector2i {
        if (fetchTexture(index) == false) {
            return Vector2i()
        }
        let size = m_cache[Int64(index)]?[0].size ?? Vector2u()
        return Vector2i(Int32(size.x), Int32(size.y))
    }

    public prop palette: ?Palette {
        get() {
            m_palette
        }
    }

    public prop size: UInt32 {
        get() {
            m_textureCount
        }
    }

    public prop groupCount: UInt32 {
        get() {
            UInt32(m_imgVec.size)
        }
    }

    public func getDirectionCount(groupIdx: UInt32): UInt32 {
        let index = Int64(groupIdx)
        if (index < m_imgVec.size) {
            return m_imgVec[index].directions
        }
        return 1
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        var startIdx = 0u32
        for ((groupIdx, imgPack) in m_imgVec |> enumerate) {
            let numFrames = imgPack.size
            if (frameIdx < startIdx + numFrames) {
                let (direction, flags) = TexturePackUtils.calculateDirection(
                    frameIdx,
                    startIdx,
                    numFrames,
                    imgPack.directions
                )
                return (UInt32(groupIdx), direction, flags)
            }
            startIdx += numFrames
        }
        return (0, 0, AnimationFlags.Overflow)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        let animInfo = Box(AnimationInfo())
        if (groupIdx >= 0) {
            let groupIdx = Int64(groupIdx)
            if (groupIdx < m_imgVec.size) {
                var startIdx = 0u32
                var stopIdx = 0u32
                for ((index, imgPack) in m_imgVec |> enumerate) {
                    stopIdx += imgPack.size
                    if (index == groupIdx) {
                        let directions = imgPack.directions
                        let stopIdx = match (stopIdx > 0) {
                            case true => stopIdx - 1
                            case false => 0u32
                        }
                        TexturePackUtils.calculateRange(
                            startIdx,
                            stopIdx,
                            directionIdx,
                            directions,
                            animInfo
                        )
                        return animInfo.value
                    }
                    startIdx = stopIdx
                }
            }
        }
        animInfo.value.indexRange = (0, m_textureCount - 1)
        animInfo.value.flags = AnimationFlags.Overflow
        return animInfo.value
    }
}
