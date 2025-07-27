package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func cloneFont(game: Game, elem: JsonValue): Bool {
    if (let Some(cloneId) <- getValidString(elem, "clone")) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (cloneId != id && isValidId(id) == true) {
                if (let Some(obj) <- game.resources.getFont(cloneId)) {
                    let elem = elem.asObject()
                    try {
                        match (obj) {
                            case FontBitmap(obj) =>
                                let font = obj.clone()
                                if (elem.containsKey("fontPalette") == true && game.shaders.sprite.isSome() == true) {
                                    let palette = game.resources.getPalette(getStringChar(elem["fontPalette"]))
                                    font.palette = palette
                                }
                                if (let Some(elem) <- elem.get("fontColor")) {
                                    font.color = getColorVal(elem, default: Color.white)
                                }
                                game.resources.addFont(id, FontBitmap(font),
                                    resourceId: getStringCharKey(elem, "resource"))
                                return true
                            case FontFreeType(obj) =>
                                let font = obj.clone()
                                if (let Some(elem) <- elem.get("fontColor")) {
                                    font.color = getColorVal(elem, default: Color.white)
                                }
                                if (let Some(elem) <- elem.get("fontSize")) {
                                    font.characterSize = getUIntVal(elem)
                                }
                                game.resources.addFont(id, FontFreeType(font),
                                    resourceId: getStringCharKey(elem, "resource"))
                                return true
                        }
                    } catch (ex: Exception) {
                        logger.error(ex.toString())
                    }
                }
            }
        }
        return true
    }
    return false
}

public func parseBitmapFont(game: Game, elem: JsonValue): Bool {
    let id = parseValidId(elem)
    if (id.isEmpty() == true) {
        return false
    }

    if (let Some(texturePack) <- game.resources.getTexturePack(getStringCharKey(elem, "texturePack"))) {
        let newLine = getIntKey(elem, "newLine", default: -1)
        let space = getIntKey(elem, "space", default: -1)
        let tab = getIntKey(elem, "tab", default: -1)

        try {
            let elem = elem.asObject()
            let font = BitmapFont(texturePack, newLine: newLine, space: space, tab: tab)

            if (elem.containsKey("fontPalette") == true && game.shaders.sprite.isSome() == true) {
                let palette = game.resources.getPalette(getStringChar(elem["fontPalette"]))
                font.palette = palette
            }
            if (let Some(elem) <- elem.get("fontColor")) {
                font.color = getColorVal(elem, default: Color.white)
            }
            if (let Some(elem) <- elem.get("drawWhitespace")) {
                font.drawWhitespace = getBoolVal(elem)
            }

            font.horizontalSpaceOffset = getIntKey(elem, "horizontalSpaceOffset")
            font.verticalSpaceOffset = getIntKey(elem, "verticalSpaceOffset")

            game.resources.addFont(id, FontBitmap(font), resourceId: getStringCharKey(elem, "resource"))
            return true
        } catch (ex: Exception) {
            logger.error(ex.toString())
        }
    }
    return false
}

public func parseFreeTypeFont(game: Game, elem: JsonValue): Bool {
    if (let Some(file) <- getValidString(elem, "file")) {
        let id = parseValidIdOrFilePath(elem, file)

        if (id.isEmpty() == true) {
            return false
        }
        let elem = elem.asObject()
        try {
            let font = FreeTypeFont(PhysFSStream(file))

            if (let Some(elem) <- elem.get("fontColor")) {
                font.color = getColorVal(elem, default: Color.white)
            }
            if (let Some(elem) <- elem.get("fontSize")) {
                font.characterSize = getUIntVal(elem)
            }
            if (let Some(elem) <- elem.get("smooth")) {
                font.smooth = getBoolVal(elem, default: true)
            }

            game.resources.addFont(id, FontFreeType(font), resourceId: getStringCharKey(elem, "resource"))
            return true
        } catch (ex: Exception) {
            logger.error(ex.toString())
        }
    }
    return false
}

public func parseFont(game: Game, elem: JsonValue): Unit {
    if (parseResourceFromId<Font>(game.resources, elem) == true) {
        return
    }
    if (cloneFont(game, elem) == true) {
        return
    }
    if (parseBitmapFont(game, elem) == true) {
        return
    }
    parseFreeTypeFont(game, elem)
}
