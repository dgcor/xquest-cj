package dgengine

import stdjson2.*

public func parseVariable(game: Game, elem: JsonValue): Unit {
    for ((key, value) in elem.memberIterator()) {
        if (isValidId(key) == true) {
            if (let Some(value) <- getVariableVal(value)) {
                game.variables.setVariable(key, value)
            }
        }
    }
}
