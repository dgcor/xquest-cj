package dgengine

import cjsfml.system.*

public abstract class TexturePackIndexWrapper <: TexturePackWrapper {
    public init(texturePack: TexturePack) {
        super(texturePack)
    }

    // returns index if index exists and None otherwise
    public func translateIndex(index: UInt32): ?UInt32

    // only works if translateIndex returns an index
    public override func get(index: UInt32): ?TextureInfo {
        if (let Some(index) <- translateIndex(index)) {
            return m_texturePack.get(index)
        }
        return None
    }

    // only works if translateIndex returns an index
    public override func getTextureSize(index: UInt32): Vector2i {
        if (let Some(index) <- translateIndex(index)) {
            return m_texturePack.getTextureSize(index)
        }
        return Vector2i()
    }
}
