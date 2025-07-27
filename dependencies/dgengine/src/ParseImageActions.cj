package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseImageEnableOutline(elem: JsonValue): ?Action {
    ActImageEnableOutline(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "enable", default: true)
    )
}

public func parseImageInverseResize(elem: JsonValue, applyToY: Bool): ?Action {
    ActImageInverseResizeXY(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "size") ?? VaString(String.empty),
        getVariableKey(elem, "inputRangeMin") ?? VaString(String.empty),
        getVariableKey(elem, "inputRangeMax") ?? VaString(String.empty),
        getVector2iKey(elem, "range"),
        applyToY
    )
}

public func parseImageInverseResizeX(elem: JsonValue): ?Action {
    parseImageInverseResize(elem, false)
}

public func parseImageInverseResizeY(elem: JsonValue): ?Action {
    parseImageInverseResize(elem, true)
}

public func parseImageSetOutline(elem: JsonValue): ?Action {
    ActImageSetOutline(
        getStringCharKey(elem, "id"),
        getColorKey(elem, "outline", default: Color.transparent),
        getColorKey(elem, "ignore", default: Color.transparent)
    )
}

public func parseImageSetPalette(elem: JsonValue): ?Action {
    ActImageSetPalette(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "palette"),
        getColorKey(elem, "color", default: Color.white)
    )
}

public func parseImageSetTexture(elem: JsonValue): ?Action {
    if (let Some(texture) <- getValidString(elem, "texture")) {
        return ActImageSetTexture(
            getStringCharKey(elem, "id"),
            texture,
            getBoolKey(elem, "resetRect")
        )
    } else if (let Some(texturePack) <- getValidString(elem, "texturePack")) {
        return ActImageSetTextureFromPack(
            getStringCharKey(elem, "id"),
            texturePack,
            getUIntKey(elem, "index")
        )
    } else {
        return ActImageSetTextureFromQueryable(
            getStringCharKey(elem, "id"),
            getStringCharKey(elem, "query"),
            getUIntKey(elem, "index")
        )
    }
}

public func parseImageSetTextureRect(elem: JsonValue): ?Action {
    ActImageSetTextureRect(
        getStringCharKey(elem, "id"),
        getIntRectKey(elem, "rect")
    )
}
