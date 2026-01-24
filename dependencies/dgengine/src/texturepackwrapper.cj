package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public abstract class TexturePackWrapper <: TexturePack {
    protected var m_texturePack: TexturePack

    public init(texturePack: TexturePack) {
        m_texturePack = texturePack
    }

    public open prop texturePack: TexturePack {
        get() {
            m_texturePack
        }
    }

    public open func get(index: UInt32): ?TextureInfo {
        m_texturePack.get(index)
    }

    public open func getTextureSize(index: UInt32): Vector2i {
        m_texturePack.getTextureSize(index)
    }

    public open func update(epoch: Int32, elapsedTime: Time): Unit {
        m_texturePack.update(epoch, elapsedTime)
    }

    public open prop texture: ?Texture {
        get() {
            m_texturePack.texture
        }
    }

    public open prop palette: ?Palette {
        get() {
            m_texturePack.palette
        }
    }

    public open prop size: UInt32 {
        get() {
            m_texturePack.size
        }
    }

    public open prop groupCount: UInt32 {
        get() {
            m_texturePack.groupCount
        }
    }

    public open func getDirectionCount(groupIdx: UInt32): UInt32 {
        m_texturePack.getDirectionCount(groupIdx)
    }

    public open func getDirectionAnim(frameIdx: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        m_texturePack.getDirectionAnim(frameIdx)
    }

    public open func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        m_texturePack.getAnimation(groupIdx, directionIdx)
    }
}
