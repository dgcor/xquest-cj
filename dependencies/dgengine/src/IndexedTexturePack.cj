package dgengine

import cjsfml.system.*
import std.collection.*

public class IndexedTexturePack <: TexturePackIndexWrapper {
    private let m_textureIndexes: HashMap<UInt32, UInt32> = HashMap<UInt32, UInt32>()
    private var m_indexRange: (UInt32, UInt32) = (0, 0)
    private let m_onlyUseIndexed: Bool

    public init(texturePack: TexturePack, onlyUseIndexed!: Bool) {
        super(texturePack)
        m_onlyUseIndexed = onlyUseIndexed
        if (onlyUseIndexed == false) {
            m_indexRange = texturePack.getAnimation(-1, -1).indexRange
        }
    }

    // maps index to the current size of mapped indexes (10 -> 0, 20 -> 1, 21 -> 2)
    // if reverseMap is true, maps the current size of mapped indexes to index (0 -> 10, 1 -> 20, 2 -> 21)
    public func mapTextureIndex(mapIndex: UInt32, reverseMap!: Bool = false): Unit {
        if (reverseMap == false) {
            mapTextureIndex(mapIndex, UInt32(m_textureIndexes.size))
        } else {
            mapTextureIndex(UInt32(m_textureIndexes.size), mapIndex)
        }
    }

    // maps index to another index (10 -> 0, 20 -> 22)
    public func mapTextureIndex(mapIndex: UInt32, toIndex: UInt32): Unit {
        var rangeStart = m_indexRange[0]
        var rangeEnd = m_indexRange[1]
        if (m_onlyUseIndexed == true && m_textureIndexes.isEmpty() == true) {
            rangeStart = mapIndex
            rangeEnd = mapIndex
        }
        if (rangeStart > mapIndex) {
            rangeStart = mapIndex
        }
        if (rangeEnd < mapIndex) {
            rangeEnd = mapIndex
        }
        m_indexRange = (rangeStart, rangeEnd)
        m_textureIndexes.add(mapIndex, toIndex)
    }

    // maps index range
    // if range stop index is smaller than start index, maps in reverse
    public func mapTextureIndexRange(indexRange: (Int32, Int32), indexRangeStart!: Int32 = -1, reverseMap!: Bool = false): Unit {
        let startIndex = Int64(indexRange[0])
        let stopIndex = Int64(indexRange[1])
        if (indexRangeStart < 0) {
            if (startIndex <= stopIndex) {
                for (idx in startIndex..=stopIndex) {
                    mapTextureIndex(UInt32(idx), reverseMap: reverseMap)
                }
            } else {
                for (idx in startIndex..=stopIndex : -1) {
                    mapTextureIndex(UInt32(idx), reverseMap: reverseMap)
                }
            }
        } else {
            if (startIndex <= stopIndex) {
                for ((idxMapTo, idx) in (startIndex..=stopIndex) |> enumerate) {
                    mapTextureIndex(UInt32(idx), UInt32(Int64(indexRangeStart) + idxMapTo))
                }
            } else {
                for ((idxMapTo, idx) in (startIndex..=stopIndex : -1) |> enumerate) {
                    mapTextureIndex(UInt32(idx), UInt32(Int64(indexRangeStart) + idxMapTo))
                }
            }
        }
    }

    public func translateIndex(index: UInt32): ?UInt32 {
        if (let Some(index) <- m_textureIndexes.get(index)) {
            return index
        } else if (m_onlyUseIndexed == true) {
            return None
        }
        return index
    }

    public prop size: UInt32 {
        get() {
            if (m_onlyUseIndexed == true) {
                return UInt32(m_textureIndexes.size)
            }
            return m_indexRange[1] + 1 - m_indexRange[0]
        }
    }

    public prop groupCount: UInt32 {
        get() {
            if (m_onlyUseIndexed == false) {
                return m_texturePack.groupCount
            }
            return 1
        }
    }

    public func getDirectionCount(groupIdx: UInt32): UInt32 {
        if (m_onlyUseIndexed == false) {
            return m_texturePack.getDirectionCount(groupIdx)
        }
        return 1
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        if (m_onlyUseIndexed == false) {
            let tuple = m_texturePack.getDirectionAnim(frameIdx)
            if (tuple[2].isSet(AnimationFlags.Valid)) {
                return tuple
            }
        }
        let flags = match (frameIdx >= m_indexRange[0] && frameIdx <= m_indexRange[1]) {
            case true => AnimationFlags.Valid
            case false => AnimationFlags.Overflow
        }
        return (0, 0, flags)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        if (m_onlyUseIndexed == false) {
            let animInfo = m_texturePack.getAnimation(groupIdx, directionIdx)
            if (animInfo.valid == true) {
                return animInfo
            }
        }
        let flags = match (groupIdx == 0 && directionIdx == 0) {
            case true => AnimationFlags.Valid
            case false => AnimationFlags.Overflow
        }
        return AnimationInfo(indexRange: m_indexRange, flags: flags)
    }
}
