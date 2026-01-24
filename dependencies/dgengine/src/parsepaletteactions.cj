package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func parsePaletteReplace(elem: JsonValue): ?Action {
    ActPaletteReplace(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idSource"),
        Int64(getUIntKey(elem, "srcStart", default: 0)),
        Int64(getUIntKey(elem, "size", default: 256)),
        Int64(getUIntKey(elem, "dstStart", default: 0)),
        0,
        getBoolKey(elem, "stepReplace")
    )
}

public func parsePaletteShiftLeft(elem: JsonValue): ?Action {
    let range = getVector2uKey(elem, "range", default: Vector2u(0, 256))
    ActPaletteShiftLeft(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "shift", default: 1)),
        (Int64(range.x), Int64(range.y))
    )
}

public func parsePaletteShiftRight(elem: JsonValue): ?Action {
    let range = getVector2uKey(elem, "range", default: Vector2u(0, 256))
    ActPaletteShiftRight(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "shift", default: 1)),
        (Int64(range.x), Int64(range.y))
    )
}
