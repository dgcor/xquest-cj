package dgengine

import stdx.encoding.json.*

public func parseScrollableSetSpeed(elem: JsonValue): ?Action {
    ActScrollableSetSpeed(
        getStringCharKey(elem, "id"),
        getTimeUKey(elem, "speed")
    )
}
