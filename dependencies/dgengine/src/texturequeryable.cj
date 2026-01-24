package dgengine

public interface TextureQueryable {
    // textureNumber: UInt32
    func getTexture(_: UInt32): ?TextureInfo {
        None
    }
}
