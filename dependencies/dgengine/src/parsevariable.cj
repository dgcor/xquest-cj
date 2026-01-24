package dgengine

import stdx.encoding.json.*

public func parseVariable(game: Game, elem: JsonValue): Unit {
    match (elem.kind()) {
        case JsObject => for ((key, value) in elem.asObject().getFields()) {
            if (isValidId(key) == true) {
                if (let Some(value) <- getVariableVal(value)) {
                    game.variables.setVariable(key, value)
                }
            }
        }
        case _ => ()
    }
}
