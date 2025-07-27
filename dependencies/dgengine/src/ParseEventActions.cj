package dgengine

import stdx.encoding.json.*

public func parseEventAdd(game: Game, elem: JsonValue): ?Action {
    ActEventAdd(
        getStringCharKey(elem, "id"),
        getActionKey(game, elem, "action"),
        getTimeUKey(elem, "time"),
        getBoolKey(elem, "addToFront")
    )
}

public func parseEventDelete(elem: JsonValue): ?Action {
    ActEventDelete(getStringCharKey(elem, "id"))
}

public func parseEventDeleteAll(): ?Action {
    ActEventDeleteAll()
}

public func parseEventResetTime(elem: JsonValue): ?Action {
    ActEventResetTime(getStringCharKey(elem, "id"))
}

public func parseEventTimeout(elem: JsonValue): ?Action {
    ActEventTimeout(getStringCharKey(elem, "id"))
}
