package dgengine

import cjsfml.graphics.*
import stdjson2.*

public func cloneFont(game: Game, elem: JsonValue): Bool {
    if (let Some(cloneId) <- getValidString(elem, "clone")) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (cloneId != id && isValidId(id) == true) {
                if (let Some(obj) <- game.resources.getFont(cloneId)) {
                    try {
                        match (obj) {
                            case FontBitmap(obj) =>
                                let font = obj.clone()
                                if (let Some(elem) <- elem.get("fontPalette")) {
                                    if (game.shaders.sprite.isSome() == true) {
                                        let palette = game.resources.getPalette(getStringChar(elem))
                                        font.palette = palette
                                    }
                                }
                                if (let Some(elem) <- elem.get("fontColor")) {
                                    font.color = getColorVal(elem, default: Color.WHITE)
                                }
                                game.resources.addFont(id, FontBitmap(font),
                                    resourceId: getStringCharKey(elem, "resource"))
                                return true
                            case FontFreeType(obj) =>
                                let font = obj.clone()
                                if (let Some(elem) <- elem.get("fontColor")) {
                                    font.color = getColorVal(elem, default: Color.WHITE)
                                }
                                if (let Some(elem) <- elem.get("fontSize")) {
                                    font.characterSize = getUIntVal(elem)
                                }
                                if (let Some(elem) <- elem.get("style")) {
                                    font.style = getTextStyleVal(elem)
                                }
                                game.resources.addFont(id, FontFreeType(font),
                                    resourceId: getStringCharKey(elem, "resource"))
                                return true
                        }
                    } catch (ex: Exception) {
                        LOGGER.error(ex.toString())
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
            let font = BitmapFont(texturePack, newLine: newLine, space: space, tab: tab)

            if (let Some(elem) <- elem.get("fontPalette")) {
                if (game.shaders.sprite.isSome() == true) {
                    let palette = game.resources.getPalette(getStringChar(elem))
                    font.palette = palette
                }
            }
            if (let Some(elem) <- elem.get("fontColor")) {
                font.color = getColorVal(elem, default: Color.WHITE)
            }
            if (let Some(elem) <- elem.get("drawWhitespace")) {
                font.drawWhitespace = getBoolVal(elem)
            }

            font.horizontalSpaceOffset = getIntKey(elem, "horizontalSpaceOffset")
            font.verticalSpaceOffset = getIntKey(elem, "verticalSpaceOffset")

            game.resources.addFont(id, FontBitmap(font), resourceId: getStringCharKey(elem, "resource"))
            return true
        } catch (ex: Exception) {
            LOGGER.error(ex.toString())
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
        try {
            let font = FreeTypeFont(PhysFSStream(file))

            if (let Some(elem) <- elem.get("fontColor")) {
                font.color = getColorVal(elem, default: Color.WHITE)
            }
            if (let Some(elem) <- elem.get("fontSize")) {
                font.characterSize = getUIntVal(elem)
            }
            if (let Some(elem) <- elem.get("style")) {
                font.style = getTextStyleVal(elem)
            }
            if (let Some(elem) <- elem.get("smooth")) {
                font.smooth = getBoolVal(elem, default: true)
            }

            game.resources.addFont(id, FontFreeType(font), resourceId: getStringCharKey(elem, "resource"))
            return true
        } catch (ex: Exception) {
            LOGGER.error(ex.toString())
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
