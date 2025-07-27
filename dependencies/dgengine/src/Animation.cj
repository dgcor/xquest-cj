package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public open class Animation <: Image {
    protected let m_animation: BaseAnimation

    public init() {
        m_animation = BaseAnimation()
    }

    public init(texture: Texture) {
        super(texture)
        m_animation = BaseAnimation()
    }

    public init(texturePack: TexturePack, pause!: Bool = false) {
        m_animation = BaseAnimation(texturePack, pause: pause)
        m_animation.updateTexture(m_sprite)
    }

    public init(texturePack: TexturePack, animInfo: AnimationInfo, pause!: Bool = false) {
        m_animation = BaseAnimation(texturePack, animInfo, pause: pause)
        m_animation.updateTexture(m_sprite)
    }

    // Image

    public open override func update(game: Game): Unit {
        if (visible == true && m_animation.update(game.elapsedTime) == true) {
            m_animation.updateTexture(m_sprite)
        }
    }

    public open override func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "finished" => VaBoolean(m_animation.hasPlayOnceAnimationFinished)
            case "isAtBeginning" => VaBoolean(m_animation.isAnimationAtBeginning)
            case "isAtEnd" => VaBoolean(m_animation.isAnimationAtEnd)
            case "paused" => VaBoolean(m_animation.pause)
            case _ => getProperty(props[0], props[1])
        }
    }

    // Animation

    public func updateTexture(): Unit {
        m_animation.updateTexture(m_sprite)
    }

    public mut prop pause: Bool {
        get() {
            m_animation.pause
        }
        set(value) {
            m_animation.pause = value
        }
    }

    public func setAnimation(animInfo: AnimationInfo): Unit {
        m_animation.setAnimation(animInfo)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(texturePack: ?TexturePack, animInfo: AnimationInfo): Unit {
        m_animation.texturePack = texturePack
        m_animation.setAnimation(animInfo)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32): Unit {
        m_animation.setAnimation(groupIdx, directionIdx)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(texturePack: ?TexturePack, groupIdx: Int32, directionIdx: Int32): Unit {
        m_animation.texturePack = texturePack
        m_animation.setAnimation(groupIdx, directionIdx)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32, resetAnimation: Bool, updateAnimationType: Bool): Unit {
        m_animation.setAnimation(groupIdx, directionIdx, resetAnimation, updateAnimationType)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(texturePack: ?TexturePack, groupIdx: Int32, directionIdx: Int32, resetAnimation: Bool,
        updateAnimationType: Bool): Unit {
        m_animation.texturePack = texturePack
        m_animation.setAnimation(groupIdx, directionIdx, resetAnimation, updateAnimationType)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(groupIdx: Int32, directionIdx: Int32, animationType: AnimationType): Unit {
        m_animation.setAnimation(groupIdx, directionIdx, animationType)
        m_animation.updateTexture(m_sprite)
    }

    public func setAnimation(texturePack: ?TexturePack, groupIdx: Int32, directionIdx: Int32,
        animationType: AnimationType): Unit {
        m_animation.texturePack = texturePack
        m_animation.setAnimation(groupIdx, directionIdx, animationType)
        m_animation.updateTexture(m_sprite)
    }

    public mut prop frameTime: Time {
        get() {
            m_animation.elapsedTime.timeout
        }
        set(value) {
            m_animation.elapsedTime.timeout = value
        }
    }

    public func reset(): Unit {
        m_animation.reset()
    }

    public prop isAnimationAtBeginning: Bool {
        get() {
            m_animation.isAnimationAtBeginning
        }
    }

    public prop isAnimationAtEnd: Bool {
        get() {
            m_animation.isAnimationAtEnd
        }
    }

    public prop hasPlayOnceAnimationFinished: Bool {
        get() {
            m_animation.hasPlayOnceAnimationFinished
        }
    }

    public prop texturePack: ?TexturePack {
        get() {
            m_animation.texturePack
        }
    }
}
