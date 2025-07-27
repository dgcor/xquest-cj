package dgengine

import cjsfml.system.*
import std.collection.*

private struct TexturePackAnimation {
    public TexturePackAnimation(
        public var refresh!: ElapsedTime,
        public var currentIndex!: UInt32,
        public let indexes!: Array<UInt32>
    ) {}

    public prop currentAnimationIndex: UInt32 {
        get() {
            indexes[Int64(currentIndex)]
        }
    }
}

public class AnimatedTexturePack <: TexturePackIndexWrapper {
    private let m_animatedTextures: ArrayList<TexturePackAnimation> = ArrayList<TexturePackAnimation>()
    private let m_animatedIndexes: HashMap<UInt32, UInt32> = HashMap<UInt32, UInt32>()
    private var m_lastEpoch: Int32 = 0

    public init(texturePack: TexturePack) {
        super(texturePack)
    }

    public func addAnimatedTexture(animIndex: UInt32, refresh: Time, indexes: Array<UInt32>): Unit {
        if (m_animatedIndexes.contains(animIndex)) {
            return
        }
        m_animatedIndexes.add(animIndex, UInt32(m_animatedTextures.size))
        m_animatedTextures.add(
            TexturePackAnimation(
                refresh: ElapsedTime(timeout: refresh),
                currentIndex: 0,
                indexes: indexes
            )
        )
    }

    public func translateIndex(index: UInt32): ?UInt32 {
        if (let Some(index) <- m_animatedIndexes.get(index)) {
            return m_animatedTextures[Int64(index)].currentAnimationIndex
        }
        return index
    }

    public override func update(epoch: Int32, elapsedTime: Time): Unit {
        if (m_lastEpoch == epoch) {
            return
        }
        m_lastEpoch = epoch

        for (index in 0..m_animatedTextures.size) {
            let anim = Box(m_animatedTextures[index])
            anim.value.refresh.update(
                elapsedTime,
                {
                    => if (Int64(anim.value.currentIndex + 1) < anim.value.indexes.size) {
                        anim.value.currentIndex++
                    } else {
                        anim.value.currentIndex = 0
                    }
                }
            )
            m_animatedTextures[index] = anim.value
        }
    }
}
