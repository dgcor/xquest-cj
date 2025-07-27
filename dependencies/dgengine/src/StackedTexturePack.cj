package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public open class StackedTexturePack <: TexturePack {
    protected var m_texturePacks = ArrayList<TexturePack>()
    protected var m_palette: ?Palette = None
    protected var m_frameRange: (UInt32, UInt32) = (0, 0)

    public func addTexturePack(texturePack: TexturePack): Unit {
        if (texturePack.size == 0) {
            return
        }
        if (m_texturePacks.isEmpty() == true) {
            let animInfo = texturePack.getAnimation(-1, -1)
            m_frameRange = animInfo.indexRange
        } else {
            let animInfo = texturePack.getAnimation(-1, -1)
            var (frameStart, frameEnd) = m_frameRange
            if (animInfo.indexRange[0] < frameStart) {
                frameStart = animInfo.indexRange[0]
            }
            if (animInfo.indexRange[1] > frameEnd) {
                frameEnd = animInfo.indexRange[1]
            }
            m_frameRange = (frameStart, frameEnd)
        }
        m_texturePacks.add(texturePack)
    }

    public open func get(index: UInt32): ?TextureInfo {
        for (texturePack in m_texturePacks) {
            let ti = texturePack.get(index)
            if (ti.isSome()) {
                return ti
            }
        }
        return None
    }

    public open func getTextureSize(index: UInt32): Vector2i {
        for (texturePack in m_texturePacks) {
            let size = texturePack.getTextureSize(index)
            if (size.x > 0 && size.y > 0) {
                return size
            }
        }
        return Vector2i()
    }

    public prop texture: ?Texture {
        get() {
            if (m_texturePacks.size == 1) {
                return m_texturePacks.front.texture
            }
            return None
        }
    }

    public prop palette: ?Palette {
        get() {
            if (m_texturePacks.isEmpty() == false) {
                return m_texturePacks.front.palette
            }
            return m_palette
        }
    }

    public open prop size: UInt32 {
        get() {
            if (m_texturePacks.isEmpty() == false) {
                return m_frameRange[1] + 1 - m_frameRange[0]
            }
            return 0
        }
    }

    public open prop groupCount: UInt32 {
        get() {
            if (m_texturePacks.isEmpty() == false) {
                return m_texturePacks.front.groupCount
            }
            return 1
        }
    }

    public open func getDirectionCount(groupIdx: UInt32): UInt32 {
        if (m_texturePacks.isEmpty() == false) {
            return m_texturePacks.front.getDirectionCount(groupIdx)
        }
        return 1
    }

    public func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        for (texturePack in m_texturePacks) {
            let tuple = texturePack.getDirectionAnim(frameIdx)
            if (tuple[2].isSet(AnimationFlags.Valid)) {
                return tuple
            }
        }
        return (0, 0, AnimationFlags.Invalid)
    }

    public open func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        for (texturePack in m_texturePacks) {
            let animInfo = texturePack.getAnimation(groupIdx, directionIdx)
            if (animInfo.valid == true) {
                return animInfo
            }
        }
        return AnimationInfo(
            indexRange: m_frameRange,
            flags: AnimationFlags.Overflow
        )
    }
}
