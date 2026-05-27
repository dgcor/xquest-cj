package xquest

import dgengine.*
import stdjson2.*

func parseDocumentElem(game: Game, name: String, elem: JsonValue, replaceVars: Box<ReplaceVars>): Bool {
    match (name) {
        case "level" => parseDocumentElemArray(parseLevel, game, name, elem, replaceVars)
        case "levelObject" => parseDocumentElemArray(parseLevelObject, game, name, elem, replaceVars)
        case "levelObjectClass" => parseDocumentElemArray(parseLevelObjectClass, game, name, elem, replaceVars)
        case "starfield" => parseDocumentElemArray(parseStarfield, game, name, elem, replaceVars)
        case _ => return false
    }
    return true
}
