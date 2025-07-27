package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func parseEvent(game: Game, elem: JsonValue): Unit {
    if (let Some(action) <- getActionKey(game, elem, "action")) {
        let timeout = getTimeUKey(elem, "time", default: Time(milliseconds: 10))
        let evt = Event(action, timeout: timeout)

        if (let Some(id) <- getValidString(elem, "id")) {
            if (isValidId(id) == true) {
                evt.id = id
            }
        }
        if (getBoolKey(elem, "addToFront") == true) {
            game.events.addFront(evt)
        } else {
            game.events.addBack(evt)
        }
    }
}
