package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public struct RectTexture {
    public RectTexture(
        public var index: UInt32,
        public var rect: IntRect,
        public var offset: Vector2f
    ) {}
}

public class RectTexturePack <: TexturePackWrapper {
    private let m_rects: ArrayList<RectTexture> = ArrayList<RectTexture>()
    private let m_absoluteOffsets: Bool

    public init(texturePack: TexturePack, absoluteOffsets!: Bool) {
        super(texturePack)
        m_absoluteOffsets = absoluteOffsets
    }

    public func addRect(index: UInt32, rect: IntRect, offset: Vector2f): Unit {
        m_rects.add(RectTexture(index, rect, offset))
    }

    public func addRect(rect: IntRect, offset: Vector2f): Unit {
        m_rects.add(RectTexture(UInt32(m_rects.size), rect, offset))
    }

    public override func get(index: UInt32): ?TextureInfo {
        if (m_rects.isEmpty() == false) {
            let idx = Int64(index)
            if (idx < m_rects.size) {
                let rect = m_rects[idx]
                if (let Some(ti) <- texturePack.get(rect.index)) {
                    var ti2 = ti
                    ti2.textureRect = rect.rect
                    ti2.offset = rect.offset
                    ti2.absoluteOffset = m_absoluteOffsets
                    return ti2
                }
            }
            return None
        }
        return texturePack.get(index)
    }

    public override func getTextureSize(index: UInt32): Vector2i {
        match ((Int64(index), m_rects.size)) {
            case (_, 0) => texturePack.getTextureSize(index)
            case (index, size) where index < size => m_rects[index].rect.size
            case _ => Vector2i()
        }
    }

    public override prop size: UInt32 {
        get() {
            match (m_rects.isEmpty()) {
                case false => UInt32(m_rects.size)
                case true => texturePack.size
            }
        }
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        match (m_rects.size) {
            case 0 => texturePack.getDirectionAnim(frameIdx)
            case size where Int64(frameIdx) < size => (0, 0, AnimationFlags.Valid)
            case _ => (0, 0, AnimationFlags.Overflow)
        }
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        match ((UInt32(m_rects.size), groupIdx, directionIdx)) {
            case (0, _, _) => texturePack.getAnimation(groupIdx, directionIdx)
            case (size, 0, 0) => AnimationInfo(indexRange: (0, size - 1), flags: AnimationFlags.Valid)
            case (size, _, _) => AnimationInfo(indexRange: (0, size - 1), flags: AnimationFlags.Overflow)
        }
    }
}
