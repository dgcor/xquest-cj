package dgengine

import stdx.encoding.json.*

public func parseInputTextClick(elem: JsonValue): ?Action {
    ActInputTextClick(getStringCharKey(elem, "id"))
}
