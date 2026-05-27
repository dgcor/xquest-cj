package dgengine

import stdjson2.*

public func parseActionSet(game: Game, elem: JsonValue): ?Action {
    ActActionSet(
        getStringCharKey(elem, "id"),
        getActionKey(game, elem, "action")
    )
}
