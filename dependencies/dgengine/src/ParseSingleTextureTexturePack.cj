package dgengine

import stdx.encoding.json.*
import std.collection.*

public func parseTextureGroup(game: Game, elem: JsonValue, textureKey: String): ?TextureGroup {
    if (let Some(id) <- getValidString(elem, textureKey)) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            var frames = getRange1Key(elem, "frames", default: (0u32, 0u32))
            if (frames[0] == 0 || frames[1] == 0) {
                frames = (1, 1)
            }
            var textureGroup = TextureGroup(
                texture: texture,
                offset: getVector2fKey(elem, "offset"),
                startIndex: getUIntKey(elem, "startIndex"),
                verticalDirection: getStringCharKey(elem, "direction") == "vertical"
            )
            if (textureGroup.makeTexturePack(frames) == true) {
                return textureGroup
            }
        }
    }
    return None
}

public func parseSingleTextureTexturePack(game: Game, elem: JsonValue): ?TexturePack {
    if (let Some(textureGroup) <- parseTextureGroup(game, elem, "texture")) {
        var palette = Option<Palette>.None
        if (let Some(id) <- getValidString(elem, "palette")) {
            palette = game.resources.getPalette(id)
        }
        let texturePack = MultiTexturePack(textureGroup, palette)
        if (texturePack.size > 0) {
            return texturePack
        }
    }
    return None
}
