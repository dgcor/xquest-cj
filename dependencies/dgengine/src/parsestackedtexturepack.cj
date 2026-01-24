package dgengine

import stdx.encoding.json.*

public func parseStackedTexturePack(game: Game, elem: JsonValue): ?TexturePack {
    let texturePack = StackedTexturePack()
    if (let Some(elem) <- getValidArray(elem, "texturePacks")) {
        for (val in elem.getItems()) {
            if (let Some(texPack) <- game.resources.getTexturePack(getStringVal(val))) {
                texturePack.addTexturePack(texPack)
            }
        }
    }
    if (texturePack.size == 0) {
        return None
    }
    return texturePack
}
