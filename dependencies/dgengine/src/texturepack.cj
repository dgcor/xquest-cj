package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public interface TexturePack {
    static func getTextureRect(texture: Texture): IntRect {
        let size = texture.size
        return IntRect(0, 0, Int32(size.x), Int32(size.y))
    }

    // if texture is an index texture, sets the palette in TextureInfo
    func get(index: UInt32): ?TextureInfo

    func getAll(index: UInt32): ?TextureInfoVar {
        if (let Some(ti) <- get(index)) {
            return TextureInfoSingle(ti)
        }
        return None
    }

    func getTextureSize(index: UInt32): Vector2i

    // epoch: Int32, elapsedTime: Time
    func update(_: Int32, _: Time): Unit {}

    // returns a texture only if the same texture is used for all calls to get
    // returns nullptr if more than one texture is used
    prop texture: ?Texture {
        get() {
            None
        }
    }

    prop palette: ?Palette

    prop size: UInt32

    prop groupCount: UInt32 {
        get() {
            1
        }
    }

    func getDirectionCount(_: UInt32): UInt32 {
        1
    }

    func getDirection(frameIdx: UInt32): UInt32 {
        getDirectionAnim(frameIdx)[1]
    }

    // returns a pair with group, direction anf AnimationFlags
    func getDirectionAnim(_: UInt32): (group: UInt32, direction: UInt32, flags: AnimationFlags) {
        (0, 0, AnimationFlags.Invalid)
    }

    // groupIdx: Int32, directionIdx: Int32
    func getAnimation(_: Int32, _: Int32): AnimationInfo {
        match (size) {
            case 0 => AnimationInfo(indexRange: (0, 0))
            case size => AnimationInfo(indexRange: (0, size - 1))
        }
    }
}
