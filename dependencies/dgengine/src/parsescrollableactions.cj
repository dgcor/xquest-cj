package dgengine

import stdjson2.*

public func parseScrollableSetSpeed(elem: JsonValue): ?Action {
    ActScrollableSetSpeed(
        getStringCharKey(elem, "id"),
        getTimeUKey(elem, "speed")
    )
}
