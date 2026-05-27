package dgengine

import stdjson2.*

private func getTexturePackObj2(game: Game, elem: JsonValue): ?TexturePack {
    return getTexturePackObj(game, elem, getTexturePackType)
}

public func parseTexturePack(game: Game, elem: JsonValue): Unit {
    parseTexturePackF(game, elem, getTexturePackObj2)
}
