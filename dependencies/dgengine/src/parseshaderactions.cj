package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseShaderSetGameShader(elem: JsonValue): ?Action {
    ActShaderSetGameShader(
        getStringCharKey(elem, "shader"),
        getStringCharKey(elem, "gameShader")
    )
}

public func parseShaderSetBool(elem: JsonValue): ?Action {
    ActShaderSetBool(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        getBoolKey(elem, "value")
    )
}

public func parseShaderSetColor(elem: JsonValue): ?Action {
    ActShaderSetColor(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        getColorKey(elem, "value")
    )
}

public func parseShaderSetFloat(elem: JsonValue): ?Action {
    ActShaderSetFloat(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        getFloatKey(elem, "value")
    )
}

public func parseShaderSetVec2(elem: JsonValue): ?Action {
    ActShaderSetVec2(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        getVector2fKey(elem, "value")
    )
}

public func parseShaderSetVec3(elem: JsonValue): ?Action {
    ActShaderSetVec3(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        getVector3fKey(elem, "value")
    )
}

public func parseShadersetVec4(elem: JsonValue): ?Action {
    let rect = getVector4fKey(elem, "value")
    return ActShaderSetVec4(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "key"),
        GlslVec4(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
    )
}
