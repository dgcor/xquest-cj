package dgengine

import stdjson2.*

public func parseMultiTextureTexturePack(game: Game, elem: JsonValue): ?TexturePack {
    if (let Some(texElem) <- getValidArray(elem, "texture")) {
        var palette = Option<Palette>.None
        if (let Some(id) <- getValidString(elem, "palette")) {
            palette = game.resources.getPalette(id)
        }
        let texturePack = MultiTexturePack(palette)
        let globalOffset = getVector2fKey(elem, "offset")
        for (val in texElem) {
            if (isValidString(val, "id") == false) {
                continue
            }
            if (let Some(textureGrp) <- parseTextureGroup(game, val, "id")) {
                var textureGroup = textureGrp
                textureGroup.offset += globalOffset
                texturePack.addTextureGroup(textureGroup)
            }
        }
        if (texturePack.size > 0) {
            return texturePack
        }
    }
    return None
}
