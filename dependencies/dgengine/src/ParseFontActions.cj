package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseFontSetPaletteOrColor(elem: JsonValue): ?Action {
    ActFontSetPaletteOrColor(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "palette"),
        getColorKey(elem, "color", default: Color.white)
    )
}

public func parseFontSetSmooth(elem: JsonValue): ?Action {
    ActFontSetSmooth(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "smooth", default: true)
    )
}
