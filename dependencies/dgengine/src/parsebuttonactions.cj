package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseButtonClick(elem: JsonValue): ?Action {
    ActButtonClick(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseButtonEnable(elem: JsonValue): ?Action {
    ActButtonEnable(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "enable", default: true)
    )
}

public func parseButtonRightClick(elem: JsonValue): ?Action {
    ActButtonRightClick(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseButtonSetColor(elem: JsonValue): ?Action {
    ActButtonSetColor(
        getStringCharKey(elem, "id"),
        getColorKey(elem, "color", default: Color.WHITE)
    )
}
