package dgengine

import cjsfml.system.*
import std.collection.*

public struct CompositeTextureGroup {
    public CompositeTextureGroup(
        public var texturePackStartIdx!: UInt32 = 0,
        public var texturePackStopIdx!: UInt32 = 0,
        public var layersOrdersStartIdx!: UInt32 = 0,
        public var layersOrdersStopIdx!: UInt32 = 0,
        public var texturePackGroups!: UInt32 = 0,
        public var directions!: UInt32 = 0,
        public var rangeStartIdx!: UInt32 = 0,
        public var range!: (UInt32, UInt32) = (0, 0)
    ) {}
}

public class CompositeTexturePack <: StackedTexturePack {
    protected var m_compositeTextureGroups = ArrayList<CompositeTextureGroup>()
    protected var m_layersOrders = ArrayList<Int8>()
    protected var m_numberOfFrames: UInt32 = 0
    protected var m_totalTexturePackGroups: UInt32 = 0

    public func addGroup(): Bool {
        if (m_compositeTextureGroups.isEmpty() == true) {
            if (m_texturePacks.isEmpty() == false) {
                var group = CompositeTextureGroup(
                    texturePackStartIdx: 0,
                    texturePackStopIdx: UInt32(m_texturePacks.size - 1),
                    texturePackGroups: m_texturePacks[0].groupCount,
                    directions: m_texturePacks[0].getDirectionCount(0),
                    range: m_texturePacks[0].getAnimation(-1, -1).indexRange,
                )
                m_compositeTextureGroups.add(group)
                m_totalTexturePackGroups += group.texturePackGroups
                m_numberOfFrames += group.range[1] + 1 - group.range[0]
                return true
            }
        } else {
            let texturePackStartIdx = m_compositeTextureGroups.back.texturePackStopIdx + 1
            let texturePackCount = UInt32(m_texturePacks.size) - texturePackStartIdx
            let texturePackStopIdx = texturePackStartIdx + texturePackCount - 1
            if (texturePackStopIdx >= texturePackStartIdx && Int64(texturePackStopIdx) < m_texturePacks.size) {
                let rangeStartIdx = m_compositeTextureGroups.back.range[1] + 1
                var range = m_texturePacks[Int64(texturePackStartIdx)].getAnimation(-1, -1).indexRange
                range = (range[0] + rangeStartIdx, range[1] + rangeStartIdx)
                var group = CompositeTextureGroup(
                    texturePackStartIdx: texturePackStartIdx,
                    texturePackStopIdx: texturePackStopIdx,
                    texturePackGroups: m_texturePacks[Int64(texturePackStartIdx)].groupCount,
                    directions: m_texturePacks[0].getDirectionCount(0),
                    rangeStartIdx: rangeStartIdx,
                    range: range
                )
                m_compositeTextureGroups.add(group)
                m_totalTexturePackGroups += group.texturePackGroups
                m_numberOfFrames += group.range[1] + 1 - group.range[0]
                return true
            }
        }
        return false
    }

    public func setLayersOrders(groupLayersOrders: ArrayList<Int8>): Unit {
        if (m_compositeTextureGroups.isEmpty() == true || groupLayersOrders.isEmpty() == true) {
            return
        }

        let layersOrdersStartIdx = match (m_layersOrders.size) {
            case 0 => 0u32
            case size => UInt32(size)
        }
        let layersOrdersStopIdx = layersOrdersStartIdx + UInt32(groupLayersOrders.size - 1)

        m_layersOrders.add(all: groupLayersOrders)

        var group = m_compositeTextureGroups.back
        group.layersOrdersStartIdx = layersOrdersStartIdx
        group.layersOrdersStopIdx = layersOrdersStopIdx
        m_compositeTextureGroups.back = group
    }

    public prop texturePackCount: UInt32 {
        get() {
            UInt32(m_texturePacks.size)
        }
    }

    public prop compositeTextureGroupSize: UInt32 {
        get() {
            UInt32(m_compositeTextureGroups.size)
        }
    }

    public func getLayerCount(groupIdx: UInt32): UInt32 {
        if (m_compositeTextureGroups.size <= 1) {
            return UInt32(m_texturePacks.size)
        }
        var numGroups = 0u32
        for (group in m_compositeTextureGroups) {
            numGroups += group.texturePackGroups
            if (groupIdx < numGroups) {
                return group.texturePackStopIdx - group.texturePackStartIdx + 1
            }
        }
        return 0
    }

    // processes texturePacks in the correct drawing order
    // processFunc: return true to continue or false to stop iterating texturePacks
    protected func processTexturePacksInOrder(
        index: UInt32,
        processFunc: (index: UInt32, texturePack: TexturePack) -> Bool
    ): Unit {
        var texPackStartIdx = 0u32
        var texPackStopIdx = 0u32
        var numTexturePacks = 0u32
        var loStartIdx = 0u32
        var loStopIdx = 0u32
        var index2 = index

        if (m_compositeTextureGroups.isEmpty() == false) {
            for (group in m_compositeTextureGroups) {
                if (index2 >= group.range[0] && index2 <= group.range[1]) {
                    texPackStartIdx = group.texturePackStartIdx
                    texPackStopIdx = group.texturePackStopIdx
                    index2 -= group.rangeStartIdx

                    if (m_layersOrders.isEmpty() == true) {
                        break
                    }

                    numTexturePacks = texPackStopIdx - texPackStartIdx + 1
                    if (Int64(m_numberOfFrames) * Int64(numTexturePacks) != m_layersOrders.size) {
                        // use same layer order for all texturePacks
                        let directionIdx = m_texturePacks[Int64(texPackStartIdx)].getDirection(index2)
                        if (directionIdx < group.directions) {
                            loStartIdx = directionIdx * numTexturePacks
                            loStopIdx = min(loStartIdx + numTexturePacks, UInt32(m_layersOrders.size))
                        }
                    } else {
                        // use different layer order for each texturePack
                        loStartIdx = group.layersOrdersStartIdx + (index2 * numTexturePacks)
                        loStopIdx = min(loStartIdx + numTexturePacks, UInt32(m_layersOrders.size))
                    }
                    break
                }
            }
        }

        if (loStartIdx < loStopIdx) {
            for (i in loStartIdx..loStopIdx) {
                let idx = Int64(m_layersOrders[Int64(i)])
                if (idx >= 0 && idx < Int64(numTexturePacks)) {
                    let texPackIdx = Int64(texPackStartIdx) + idx
                    if (texPackIdx < m_texturePacks.size) {
                        if (processFunc(index2, m_texturePacks[texPackIdx]) == false) {
                            break
                        }
                    }
                }
            }
        } else {
            for (i in texPackStartIdx..=texPackStopIdx) {
                if (processFunc(index2, m_texturePacks[Int64(i)]) == false) {
                    break
                }
            }
        }
    }

    // gets the first texture
    public override func get(index: UInt32): ?TextureInfo {
        if (let Some(tiVec) <- getAll(index)) {
            match (tiVec) {
                case TextureInfoMulti(tiVec) => return tiVec[0]
                case _ => ()
            }
        }
        return None
    }

    public override func getAll(index: UInt32): ?TextureInfoVar {
        if (let Some(tiVec) <- getTextures(index)) {
            return TextureInfoMulti(tiVec)
        }
        return None
    }

    // gets the textures in the correct drawing order
    public func getTextures(index: UInt32): ?ArrayList<TextureInfo> {
        let tiVec = ArrayList<TextureInfo>()
        processTexturePacksInOrder(
            index,
            {
                index, texturePack =>
                    if (let Some(ti) <- texturePack.get(index)) {
                        tiVec.add(ti)
                    }
                    return true
            }
        )

        if (tiVec.isEmpty() == false) {
            return tiVec
        }
        return None
    }

    // uses first texturePack of each group
    public override func getTextureSize(index: UInt32): Vector2i {
        let textureSize = Box(Vector2i())
        processTexturePacksInOrder(
            index,
            {
                index, texturePack =>
                    textureSize.value = texturePack.getTextureSize(index)
                    return textureSize.value.x == 0 || textureSize.value.y == 0
            }
        )
        return textureSize.value
    }

    // uses first texturePack of each group
    public override prop size: UInt32 {
        get() {
            m_numberOfFrames
        }
    }

    // uses first texturePack of each group
    public override prop groupCount: UInt32 {
        get() {
            m_totalTexturePackGroups
        }
    }

    // uses first texturePack of each group
    public override func getDirectionCount(groupIdx: UInt32): UInt32 {
        var numGroups = 0u32
        for (group in m_compositeTextureGroups) {
            numGroups += group.texturePackGroups
            if (groupIdx < numGroups) {
                return group.directions
            }
        }
        return 1
    }

    // uses first texturePack of each group
    public override func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        var animInfo = AnimationInfo()

        if (m_compositeTextureGroups.isEmpty() == true) {
            animInfo.flags = AnimationFlags.Overflow
            return animInfo
        } else if (groupIdx >= 0) {
            if (m_compositeTextureGroups.size == 1) {
                return m_texturePacks[0].getAnimation(groupIdx, directionIdx)
            } else {
                var normalizedGroupIdx = groupIdx
                for (group in m_compositeTextureGroups) {
                    if (UInt32(normalizedGroupIdx) < group.texturePackGroups) {
                        animInfo = m_texturePacks[Int64(group.texturePackStartIdx)].getAnimation(normalizedGroupIdx,
                            directionIdx)
                        animInfo.indexRange = (animInfo.indexRange[0] + group.rangeStartIdx, animInfo.indexRange[1] + group
                                .rangeStartIdx)
                        return animInfo
                    } else {
                        normalizedGroupIdx -= Int32(group.texturePackGroups)
                    }
                }
            }
        }
        animInfo.indexRange = (m_compositeTextureGroups.front.range[0], m_compositeTextureGroups.back.range[1])
        animInfo.flags = AnimationFlags.Overflow
        return animInfo
    }
}
