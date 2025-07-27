package XQuest

import dgengine.*
import stdx.encoding.json.*

func parseDocumentElem(game: Game, name: String, elem: JsonValue, replaceVars: Box<ReplaceVars>): Bool {
    match (name) {
        case "level" => parseDocumentElemArray(parseLevel, game, name, elem, replaceVars)
        case "levelObjectClass" => parseDocumentElemArray(parseLevelObjectClass, game, name, elem, replaceVars)
        case "starfield" => parseDocumentElemArray(parseStarfield, game, name, elem, replaceVars)
        case _ => return false
    }
    return true
}
