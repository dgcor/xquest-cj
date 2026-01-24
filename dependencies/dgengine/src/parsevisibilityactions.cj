package dgengine

import stdx.encoding.json.*

public func parseToggleVisible(elem: JsonValue): ?Action {
    ActToggleVisible(getStringCharKey(elem, "id"))
}

public func parseSetVisible(elem: JsonValue): ?Action {
    ActSetVisible(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "visible", default: true)
    )
}
