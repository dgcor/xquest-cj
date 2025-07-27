package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public struct AnimationGroup {
    public AnimationGroup(
        public let indexRange!: (UInt32, UInt32),
        public var directions!: UInt32 = 0,
        public var directionsVec!: ?ArrayList<(UInt32, UInt32)> = None,
        public var animType!: AnimationType = AnimationType.Looped,
        public var refresh!: Time = Time.zero
    ) {
        updateDirection()
    }

    public mut func updateDirection(): Unit {
        if (let Some(vec) <- directionsVec) {
            if (vec.isEmpty() == false) {
                directions = UInt32(vec.size)
            } else {
                directionsVec = None
            }
        }
        if (directions == 0) {
            directions = 1
        }
    }

    public func size(): UInt32 {
        indexRange[1] + 1 - indexRange[0]
    }

    public func getDirectionAnim(frameIdx: UInt32): (direction: UInt32, flags: AnimationFlags) {
        if (let Some(directionsVec) <- directionsVec) {
            if (directionsVec.isEmpty() == false) {
                for ((direction, range) in directionsVec |> enumerate) {
                    if (indexRange[0] <= frameIdx) {
                        let index = frameIdx - indexRange[0]
                        if (index >= range[0] && index <= range[1]) {
                            return (UInt32(direction), AnimationFlags.Valid)
                        }
                    }
                }
                return (0, AnimationFlags.Overflow)
            }
        }
        return TexturePackUtils.calculateDirection(frameIdx, indexRange[0], size(), directions)
    }

    public func getAnimation(groupIdx: Int32, directionIdx: Int32): AnimationInfo {
        let animInfo = Box(
            AnimationInfo(
                animType: animType,
                refresh: refresh
            )
        )
        if (groupIdx == 0 && directionIdx >= 0) {
            if (let Some(directionsVec) <- directionsVec) {
                let dirIndex = Int64(directionIdx)
                if (dirIndex < directionsVec.size) {
                    var (indexStart, indexEnd) = directionsVec[dirIndex]
                    if (indexRange[0] > 0) {
                        indexStart += indexRange[0]
                        indexEnd += indexRange[0]
                    }
                    animInfo.value.indexRange = (indexStart, indexEnd)
                    animInfo.value.flags = AnimationFlags.Valid
                    return animInfo.value
                }
            } else if (UInt32(directionIdx) < directions) {
                TexturePackUtils.calculateRange(
                    indexRange[0],
                    indexRange[1],
                    directionIdx,
                    directions,
                    animInfo
                )
                return animInfo.value
            }
        }
        animInfo.value.indexRange = indexRange
        animInfo.value.flags = AnimationFlags.Overflow
        return animInfo.value
    }
}
