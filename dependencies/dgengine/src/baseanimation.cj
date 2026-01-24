package dgengine

import cjsfml.system.*

public class BaseAnimation {
    public var texturePack: ?TexturePack = None
    public var animInfo: AnimationInfo = AnimationInfo(animType: AnimationType.PlayOnce)
    public var currentTextureIdx: UInt32 = 0
    public var elapsedTime: ElapsedTime = ElapsedTime(timeout: Time(milliseconds: 50))
    public var pause: Bool = false
    public var backDirection: Bool = false

    public init() {}

    public init(texturePack: TexturePack, pause!: Bool) {
        this.texturePack = texturePack
        this.pause = pause
        setAnimation(-1, -1)
    }

    public init(texturePack: TexturePack, animInfo: AnimationInfo, pause!: Bool) {
        this.texturePack = texturePack
        this.animInfo = animInfo
        this.currentTextureIdx = animInfo.indexRange[0]
        this.elapsedTime = ElapsedTime(timeout: animInfo.refresh)
        this.pause = pause
    }

    public func clear(): Unit {
        animInfo.indexRange = (0, 0)
        elapsedTime.reset()
        backDirection = false
    }

    public func reset(): Unit {
        currentTextureIdx = animInfo.indexRange[0]
        elapsedTime.reset()
        backDirection = false
    }

    public func setAnimation(animInfo: AnimationInfo): Unit {
        this.animInfo = animInfo
        currentTextureIdx = animInfo.indexRange[0]
        elapsedTime = ElapsedTime(timeout: animInfo.refresh)
        backDirection = false
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32): Unit {
        if (let Some(texturePack) <- texturePack) {
            setAnimation(texturePack.getAnimation(groupIdx, directionIdx))
        }
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32, resetAnimation: Bool, animationType: AnimationType): Unit {
        var at = AnimationType.Looped
        var currentRelativeIndex = 0u32
        if (resetAnimation == false) {
            currentRelativeIndex = currentTextureIdx - animInfo.indexRange[0]
        }
        match (texturePack) {
            case Some(texturePack) =>
                var animInfo = texturePack.getAnimation(groupIdx, directionIdx)
                this.animInfo.indexRange = animInfo.indexRange
                at = animInfo.animType
            case None =>
                animInfo.indexRange = (0, 0)
                at = AnimationType.PlayOnce
        }
        currentTextureIdx = animInfo.indexRange[0] + currentRelativeIndex
        animInfo.animType = match (animationType != AnimationType.Size) {
            case true => animationType
            case false => at
        }
        if (resetAnimation == true || (resetAnimation == false && animInfo.animType != AnimationType.BackAndForth)) {
            backDirection = false
        }
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32, resetAnimation: Bool, updateAnimationType: Bool): Unit {
        let animationType = match (updateAnimationType) {
            case true => AnimationType.Size
            case false => animInfo.animType
        }
        setAnimation(groupIdx, directionIdx, resetAnimation, animationType)
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32, animationType: AnimationType): Unit {
        setAnimation(groupIdx, directionIdx, true, animationType)
    }

    private func updateFrameIndex(): Unit {
        if (animInfo.animType != AnimationType.BackAndForth) {
            if (currentTextureIdx < animInfo.indexRange[1]) {
                currentTextureIdx++
            } else {
                currentTextureIdx = animInfo.indexRange[0]
            }
        } else {
            if (backDirection == false) {
                if (currentTextureIdx < animInfo.indexRange[1]) {
                    currentTextureIdx++
                }
                if (currentTextureIdx == animInfo.indexRange[1]) {
                    backDirection = true
                }
            } else {
                if (currentTextureIdx > animInfo.indexRange[0]) {
                    currentTextureIdx--
                }
                if (currentTextureIdx == animInfo.indexRange[0]) {
                    backDirection = false
                }
            }
        }
    }

    public prop isAnimationAtBeginning: Bool {
        get() {
            currentTextureIdx <= animInfo.indexRange[0]
        }
    }

    public prop isAnimationAtEnd: Bool {
        get() {
            currentTextureIdx >= animInfo.indexRange[1]
        }
    }

    public prop hasPlayOnceAnimationFinished: Bool {
        get() {
            animInfo.animType == AnimationType.PlayOnce && currentTextureIdx >= animInfo.indexRange[1]
        }
    }

    public func update(elapsedTime: Time): Bool {
        if (pause == true || animInfo.indexRange[1] <= animInfo.indexRange[0]) {
            return false
        }
        if (hasPlayOnceAnimationFinished == true) {
            return false
        }
        if (this.elapsedTime.timeout == Time.ZERO) {
            return false
        }
        this.elapsedTime.update(
            elapsedTime,
            {
                =>
                    updateFrameIndex()
                    if (hasPlayOnceAnimationFinished == true) {
                        return false
                    }
                    return true
            }
        )
        return true
    }

    // returns bool with absoluteOffset if texture was updated successfully or None
    public func updateTexture(sprite: CompositeSprite): ?Bool {
        match (texturePack) {
            case Some(texturePack) => match (texturePack as CompositeTexturePack) {
                case Some(compositeTexturePack) =>
                    if (let Some(ti) <- texturePack.getAll(currentTextureIdx)) {
                        sprite.setTexture(ti)
                        return match (ti) {
                            case TextureInfoSingle(ti) => ti.absoluteOffset
                            case TextureInfoMulti(ti) => ti[0].absoluteOffset
                        }
                    }
                case None =>
                    if (let Some(ti) <- texturePack.get(currentTextureIdx)) {
                        sprite.setTexture(ti)
                        return ti.absoluteOffset
                    }
            }
            case None => return None
        }
        return None
    }
}
