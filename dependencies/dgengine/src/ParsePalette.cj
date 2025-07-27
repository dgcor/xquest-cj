package dgengine

import stdx.encoding.json.*
import std.math.*

public func parsePalette(game: Game, elem: JsonValue): Unit {
    if (parseResourceFromId<Palette>(game.resources, elem) == true) {
        return
    }
    if (let JsObject <- elem.kind()) {
        try {
            let elem = elem.asObject()
            if (let Some(file) <- getValidString(elem, "file")) {
                let id = parseValidIdOrFilePath(elem, file)
                if (id.isEmpty() == true) {
                    return
                }
                if (game.resources.hasPalette(id) == true) {
                    return
                }
                var colorFormat = ColorFormat.RGB
                if (isValidString(elem, "colorFormat") == true) {
                    colorFormat = ColorFormat.get(getStringChar(elem["colorFormat"]))
                }
                let palette = Palette(file, colorFormat)
                game.resources.addPalette(id, palette, resourceId: getStringCharKey(elem, "resource"))
            } else if (isValidString(elem, "palette") && isValidString(elem, "trnFile")) {
                let file = getStringChar(elem["trnFile"])
                let id = parseValidIdOrFilePath(elem, file)
                if (id.isEmpty() == true) {
                    return
                }
                if (game.resources.hasPalette(id) == true) {
                    return
                }
                if (let Some(refPalette) <- game.resources.getPalette(getStringChar(elem["palette"]))) {
                    let trnFile = FileUtils.readBytes(file)
                    let trnStart = Int64(min(getUIntKey(elem, "trnStart"), UInt32.Max))
                    let trnLength = Int64(min(getUIntKey(elem, "trnLength", default: 256), 256))
                    let palette = Palette(refPalette, trnFile, trnStart, trnLength)
                    game.resources.addPalette(id, palette, resourceId: getStringCharKey(elem, "resource"))
                }
            } else if (let Some(clone) <- getValidString(elem, "clone")) {
                if (let Some(id) <- getValidString(elem, "id")) {
                    if (clone == id || isValidId(id) == false) {
                        return
                    }
                    if (let Some(obj) <- game.resources.getPalette(clone)) {
                        let palette = obj.clone()
                        game.resources.addPalette(id, palette, resourceId: getStringCharKey(elem, "resource"))
                    }
                }
            }
        } catch (ex: Exception) {
            logger.error(ex.toString())
        }
    }
}
