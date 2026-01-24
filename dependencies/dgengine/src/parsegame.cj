package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func parseGameElem(game: Game, name: String, elem: JsonValue): Unit {
    match (name) {
        case "frameRate" => game.frameRate = getUIntVal(elem)
        case "fullScreen" => game.fullScreen = getBoolVal(elem)
        case "icon" => parseIcon(game, elem)
        case "init" => game.initialize()
        case "load" => parseLoad(game, elem)
        case "keepAR" => game.keepAR = getBoolVal(elem, default: true)
        case "maxHeight" => game.maxHeight = getUIntVal(elem)
        case "minSize" => game.minSize = getVector2uVal(elem, default: Vector2u(Game.MinSizeX, Game.MinSizeY))
        case "onClose" => game.setAction("close", getActionVal(game, elem))
        case "onFocusGain" => game.setAction("focusGain", getActionVal(game, elem))
        case "onFocusLoss" => game.setAction("focusLoss", getActionVal(game, elem))
        case "onResize" => game.setAction("resize", getActionVal(game, elem))
        case "position" => game.position = getVector2iVal(elem)
        case "refSize" => game.refSize = getVector2uVal(elem, default: Vector2u(Game.RefSizeX, Game.RefSizeY))
        case "saveDir" => parseSaveDir(elem)
        case "size" => game.size = getVector2uVal(elem, default: Vector2u(Game.DefaultSizeX, Game.DefaultSizeY))
        case "smoothScreen" => game.smoothScreen = getBoolVal(elem)
        case "stretchToFit" => game.stretchToFit = getBoolVal(elem)
        case "title" => game.title = getStringVal(elem, default: game.title)
        case "version" => game.version = getStringVal(elem, default: game.version)
        case _ => ()
    }
}

public func parseGame(game: Game, elem: JsonValue): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        for ((name, elem) in elem.getFields()) {
            let (name2, _) = splitStringIn2(name, ".")
            parseGameElem(game, name2, elem)
        }
    }
}
