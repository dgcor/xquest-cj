package dgengine

import stdx.encoding.json.*

public enum TexturePackType {
    | TexturePackGeneric
    | TexturePackBitmapFont
    | TexturePackStacked
    | TexturePackComposite
}

public func getTexturePackType(elem: JsonObject): TexturePackType {
    match (getStringCharKey(elem, "type")) {
        case "font" => TexturePackBitmapFont
        case "composite" => TexturePackComposite
        case _ where elem.containsKey("texturePacks") => TexturePackStacked
        case _ => TexturePackGeneric
    }
}

public func getTexturePackObj(game: Game, elem: JsonValue, getTexturePackType: (elem: JsonObject) -> TexturePackType): ?TexturePack {
    if (let JsObject <- elem.kind()) {
        let elem = elem.asObject()
        let packType = getTexturePackType(elem)
        match (packType) {
            case TexturePackStacked => return parseStackedTexturePack(game, elem)
            case TexturePackComposite => return getCompositeTexturePackObj(game, elem)
            case _ => ()
        }

        var texturePack = Box<?TexturePack>(None)

        if (let TexturePackBitmapFont <- packType) {
            texturePack.value = parseBitmapFontTexturePack(game, elem)
        } else if (elem.containsKey("imageContainer") == true) {
            texturePack.value = parseImageContainerTexturePack(game, elem)
        } else if (elem.containsKey("texture") == true) {
            if (let JsArray <- elem["texture"].kind()) {
                texturePack.value = parseMultiTextureTexturePack(game, elem)
            } else {
                texturePack.value = parseSingleTextureTexturePack(game, elem)
            }
        }
        if (texturePack.value.isNone()) {
            return None
        }

        var parsedAnimated = false
        var parsedGroups = false
        var parsedIndexes = false
        var parsedRects = false

        for (key in elem.getFields().keys()) {
            match (key) {
                case "animatedTextures" where parsedAnimated == false =>
                    parsedAnimated = true
                    parseTexturePackAnimatedTextures(texturePack, elem)
                case "groups" where parsedGroups == false =>
                    parsedGroups = true
                    parseTexturePackGroups(texturePack, elem)
                case "textureIndexes" | "textureIndexRange" | "utf8Indexes" | "utf8IndexFile" where parsedIndexes ==
                    false =>
                    parsedIndexes = true
                    parseTexturePackIndexes(texturePack, elem)
                case "rects" where parsedRects == false =>
                    parsedRects = true
                    parseTexturePackRects(texturePack, elem)
                case _ => ()
            }
        }

        return texturePack.value
    }
    return None
}

public func parseTexturePackF(game: Game, elem: JsonValue,
    getTexturePackObj: (game: Game, elem: JsonValue) -> ?TexturePack): Unit {
    if (parseResourceFromId<TexturePack>(game.resources, elem) == true) {
        return
    }
    let id = parseValidId(elem)
    if (id.isEmpty() == true) {
        return
    }
    if (game.resources.hasTexturePack(id) == true) {
        return
    }
    if (let Some(texturePack) <- getTexturePackObj(game, elem)) {
        game.resources.addTexturePack(id, texturePack, resourceId: getStringCharKey(elem, "resource"))
    }
}
