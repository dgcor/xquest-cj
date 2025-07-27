package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public struct TextureGroup {
    public TextureGroup(
        public let texture!: Texture,
        public var offset!: Vector2f = Vector2f(),
        public var startIndex!: UInt32 = 0,
        public var maxFrames!: UInt32 = 0,
        public var numFrames!: UInt32 = 0,
        public var subImageSizeX!: UInt32 = 0,
        public var subImageSizeY!: UInt32 = 0,
        public var verticalDirection!: Bool = false
    ) {}

    public mut func makeTexturePack(frames: (UInt32, UInt32)): Bool {
        numFrames = frames[0] * frames[1]
        if (numFrames == 0) {
            return false
        }
        let imgSize = texture.size
        if (imgSize.x == 0 || imgSize.y == 0 || frames[0] > imgSize.x || frames[1] > imgSize.y ||
            imgSize.x % frames[0] != 0 || imgSize.y % frames[1] != 0) {
            numFrames = 0
            return false
        }
        maxFrames = match (verticalDirection) {
            case true => frames[1]
            case false => frames[0]
        }
        subImageSizeX = imgSize.x / frames[0]
        subImageSizeY = imgSize.y / frames[1]
        return true
    }

    public func isValid(): Bool {
        numFrames > 0
    }

    public func getTexture(index: UInt32): ?TextureInfo {
        var ti = TextureInfo(
            texture,
            offset: offset
        )
        if (numFrames <= 1 && index == 0) {
            ti.textureRect.left = 0
            ti.textureRect.top = 0
        } else if (verticalDirection == false) {
            ti.textureRect.left = Int32((index % maxFrames) * subImageSizeX)
            ti.textureRect.top = Int32((index / maxFrames) * subImageSizeY)
        } else {
            ti.textureRect.left = Int32((index / maxFrames) * subImageSizeX)
            ti.textureRect.top = Int32((index % maxFrames) * subImageSizeY)
        }
        ti.textureRect.width = Int32(subImageSizeX)
        ti.textureRect.height = Int32(subImageSizeY)
        return ti
    }

    public func getDirectionAnim(frameIdx: UInt32): (direction: UInt32, flags: AnimationFlags) {
        let flags = match (frameIdx >= startIndex && frameIdx < startIndex + numFrames) {
            case true => AnimationFlags.Valid
            case false => AnimationFlags.Overflow
        }
        return (0, flags)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        AnimationInfo(
            indexRange: (startIndex, startIndex + numFrames - 1),
            flags: match (groupIdx == 0 && directionIdx == 0) {
                case true => AnimationFlags.Valid
                case false => AnimationFlags.Overflow
            }
        )
    }
}
