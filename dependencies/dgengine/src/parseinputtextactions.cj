package dgengine

import stdjson2.*

public func parseInputTextClick(elem: JsonValue): ?Action {
    ActInputTextClick(getStringCharKey(elem, "id"))
}
