package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseCursorCenterOnDrawable(elem: JsonValue): ?Action {
    ActCursorCenterOnDrawable(getStringCharKey(elem, "id"))
}

public func parseCursorEnableOutline(elem: JsonValue): ?Action {
    ActCursorEnableOutline(getBoolKey(elem, "enable", default: true))
}

public func parseCursorPop(elem: JsonValue): ?Action {
    ActCursorPop(getBoolKey(elem, "popAll"))
}

public func parseCursorSetColor(elem: JsonValue): ?Action {
    ActCursorSetColor(getColorKey(elem, "color", default: Color.white))
}

public func parseCursorSetOutline(elem: JsonValue): ?Action {
    ActCursorSetOutline(
        getColorKey(elem, "outline", default: Color.transparent),
        getColorKey(elem, "ignore", default: Color.transparent)
    )
}

public func parseCursorSetPalette(elem: JsonValue): ?Action {
    ActCursorSetPalette(
        getStringCharKey(elem, "palette"),
        getColorKey(elem, "color", default: Color.white)
    )
}

public func parseCursorSetPosition(elem: JsonValue): ?Action {
    ActCursorSetPosition(getVector2iKey(elem, "position"))
}

public func parseCursorShow(elem: JsonValue): ?Action {
    ActCursorShow(getBoolKey(elem, "show"))
}
