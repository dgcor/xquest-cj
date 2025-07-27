package dgengine

import stdx.encoding.json.*

public func parseGameInputEvent(game: Game, elem: JsonValue): Unit {
    if (let Some(key) <- getValidString(elem, "name")) {
        let inputEvents = parseInputEvents(elem)
        for (evt in inputEvents) {
            game.gameInputEvents.set(key, evt)
        }
    }
}
