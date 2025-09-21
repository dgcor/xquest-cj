package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public class MultiTexturePack <: TexturePack {
    private let m_textureGroups: ArrayList<TextureGroup>
    private var m_textureCount: UInt32 = 0
    private var m_numFrames: UInt32 = 0
    private var m_frameRange: (UInt32, UInt32) = (0, 0)
    private let m_palette: ?Palette
    private var m_texturesHaveSameSize: Bool = false
    private var m_indexesHaveGaps: Bool = false

    public init(palette: ?Palette) {
        m_textureGroups = ArrayList<TextureGroup>()
        m_palette = palette
    }

    public init(textureGroup: TextureGroup, palette: ?Palette) {
        m_textureGroups = ArrayList<TextureGroup>()
        m_palette = palette
        addTextureGroup(textureGroup)
    }

    public func addTextureGroup(textureGrp: TextureGroup): Unit {
        var textureGroup = textureGrp
        if (textureGroup.startIndex < m_textureCount) {
            textureGroup.startIndex = m_textureCount
        }
        if (textureGroup.isValid() == true) {
            if (m_textureGroups.isEmpty() == true) {
                m_texturesHaveSameSize = true
                m_numFrames = textureGroup.numFrames
                if (textureGroup.startIndex > 0) {
                    m_indexesHaveGaps = true
                }
                m_frameRange = (textureGroup.startIndex, textureGroup.startIndex + m_numFrames - 1)
            } else {
                if (m_texturesHaveSameSize == true && (textureGroup.subImageSizeX != m_textureGroups.back.subImageSizeX ||
                    textureGroup.subImageSizeY != m_textureGroups.back.subImageSizeY)) {
                    m_texturesHaveSameSize = false
                }
                if (texturesHaveSameNumFrames() == true && m_numFrames != textureGroup.numFrames) {
                    m_numFrames = 0
                }
                let frameRangeEnd = m_textureGroups.back.startIndex + m_textureGroups.back.numFrames
                if (textureGroup.startIndex < frameRangeEnd) {
                    textureGroup.startIndex = frameRangeEnd
                }
                let indexGap = match (textureGroup.startIndex > frameRangeEnd) {
                    case true => textureGroup.startIndex - frameRangeEnd
                    case false => 0u32
                }
                if (m_indexesHaveGaps == false && indexGap > 0) {
                    m_indexesHaveGaps = true
                }
                m_frameRange = (m_frameRange[0], m_frameRange[1] + m_textureGroups.back.numFrames + indexGap)
            }
            m_textureCount += textureGroup.numFrames
            m_textureGroups.add(textureGroup)
        }
    }

    private func texturesHaveSameNumFrames(): Bool {
        m_numFrames != 0
    }

    private func fetchIndex(index: UInt32): ?(indexX: UInt32, indexY: UInt32) {
        if (m_textureGroups.isEmpty() == true) {
            return None
        }
        if (m_indexesHaveGaps == false && texturesHaveSameNumFrames() == true) {
            let indexX = index % m_numFrames
            let indexY = index / m_numFrames
            let indexY64 = Int64(indexY)
            if (indexY64 >= m_textureGroups.size || indexX >= m_textureGroups[indexY64].numFrames) {
                return None
            }
            return (indexX, indexY)
        }
        var indexX = 0u32
        var indexY = -1
        do {
            indexY++
            if (indexY >= m_textureGroups.size || index < m_textureGroups[indexY].startIndex) {
                return None
            }
            indexX = index - m_textureGroups[indexY].startIndex
        } while (indexX >= m_textureGroups[indexY].numFrames)
        return (indexX, UInt32(indexY))
    }

    public func get(index: UInt32): ?TextureInfo {
        if (let Some((indexX, indexY)) <- fetchIndex(index)) {
            if (let Some(ti) <- m_textureGroups[Int64(indexY)].getTexture(indexX)) {
                var ti2 = ti
                ti2.palette = m_palette
                return ti2
            }
        }
        return None
    }

    public func getTextureSize(index: UInt32): Vector2i {
        if (let Some((_, indexY)) <- fetchIndex(index)) {
            let index = Int64(indexY)
            return Vector2i(Int32(m_textureGroups[index].subImageSizeX), Int32(m_textureGroups[index].subImageSizeY))
        }
        return Vector2i()
    }

    public prop texture: ?Texture {
        get() {
            match (m_textureGroups.size) {
                case 1 => m_textureGroups[0].texture
                case _ => None
            }
        }
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
            match (m_textureGroups.size) {
                case 0 => 1
                case value => UInt32(value)
            }
        }
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        for ((groupIdx, textureGroup) in m_textureGroups |> enumerate) {
            let (direction, flags) = textureGroup.getDirectionAnim(frameIdx)
            if (flags.isSet(AnimationFlags.Valid)) {
                return (UInt32(groupIdx), direction, flags)
            }
        }
        return (0, 0, AnimationFlags.Overflow)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        if (m_textureGroups.size == 1) {
            return m_textureGroups[0].getAnimation(groupIdx, directionIdx)
        }
        let groupIndex = Int64(groupIdx)
        if (groupIndex >= 0 && groupIndex < m_textureGroups.size) {
            return m_textureGroups[groupIndex].getAnimation(0, directionIdx)
        }
        return AnimationInfo(indexRange: m_frameRange)
    }
}
