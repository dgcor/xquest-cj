package dgengine

public class TexturePackUtils {
    // returns direction from frame index and AnimationFlags
    // range is exclusive [startIdx, numFrames)
    public static func calculateDirection(frameIdx: UInt32, startIdx: UInt32, numFrames: UInt32, directions: UInt32): (direction: UInt32, 
        flags: AnimationFlags) {
        if (frameIdx >= startIdx && frameIdx < startIdx + numFrames) {
            if (directions == 0) {
                return (0, AnimationFlags.Overflow)
            }
            if (directions == 1) {
                return (0, AnimationFlags.Valid)
            }
            if (numFrames <= directions) {
                return (frameIdx - startIdx, AnimationFlags.Valid)
            }
            return (((frameIdx - startIdx) * directions) / numFrames, AnimationFlags.Valid)
        }
        return (0, AnimationFlags.Overflow)
    }

    // sets AnimationInfo indexRange + AnimationFlags from direction
    // range is inclusive [startIdx, stopIdx]
    // ex: [0, 2] has 3 indexes -> 0, 1, 2
    // returns AnimationInfo if animation is valid or None if not
    public static func calculateRange(startIdx: UInt32, stopIdx: UInt32, directionIdx: Int32, directions: UInt32,
        animInfo: Box<AnimationInfo>): Bool {
        if (startIdx <= stopIdx && directionIdx >= 0) {
            if (directionIdx == 0 && directions == 1) {
                animInfo.value.flags = AnimationFlags.Valid
                animInfo.value.indexRange = (startIdx, stopIdx)
                return true
            }
            var numFrames = stopIdx - startIdx + 1
            var directionIdx = UInt32(directionIdx)
            var directions = directions
            if (directions > numFrames) {
                directions = numFrames
            }
            if (directions > 0 && directionIdx < directions) {
                let frameSize = numFrames / directions
                let rangeStart = startIdx + (frameSize * directionIdx)
                if (numFrames % directions == 0) {
                    animInfo.value.indexRange = (rangeStart, startIdx + (frameSize * (directionIdx + 1)) - 1)
                } else {
                    var frameIdx = startIdx
                    var hasStart = false
                    var hasStop = false
                    do {
                        let (calculatedDirection, _) = calculateDirection(frameIdx, startIdx, numFrames, directions)
                        if (hasStart == false && calculatedDirection == directionIdx) {
                            animInfo.value.indexRange = (frameIdx, frameIdx)
                            hasStart = true
                        } else if (hasStop == false) {
                            if (calculatedDirection == directionIdx) {
                                animInfo.value.indexRange = (animInfo.value.indexRange[0], frameIdx)
                            } else if (hasStart == true) {
                                break
                            }
                        }
                        frameIdx++
                    } while (true)
                }
                animInfo.value.flags = AnimationFlags.Valid
                return true
            }
        }
        animInfo.value.flags = AnimationFlags.Overflow
        animInfo.value.indexRange = (startIdx, stopIdx)
        return false
    }
}
