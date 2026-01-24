package dgengine

import stdx.encoding.json.*

private func getTexturePackObj2(game: Game, elem: JsonValue): ?TexturePack {
    return getTexturePackObj(game, elem, getTexturePackType)
}

public func parseTexturePack(game: Game, elem: JsonValue): Unit {
    parseTexturePackF(game, elem, getTexturePackObj2)
}
