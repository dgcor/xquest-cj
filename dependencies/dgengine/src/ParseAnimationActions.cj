package dgengine

import stdx.encoding.json.*

public func parseAnimationPause(elem: JsonValue): ?Action {
    ActAnimationPause(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "pause", default: true),
        getBoolKey(elem, "reset")
    )
}

public func parseAnimationSetAnimation(elem: JsonValue): ?Action {
    ActAnimationSetAnimation(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "texturePack"),
        getIntKey(elem, "group", default: -1),
        getIntKey(elem, "direction", default: -1),
        getTimeUKey(elem, "refresh"),
        getBoolKey(elem, "reset", default: true),
        getBoolKey(elem, "updateAnimationType")
    )
}

public func parseAnimationSetRefresh(elem: JsonValue): ?Action {
    ActAnimationSetRefresh(
        getStringCharKey(elem, "id"),
        getTimeUKey(elem, "refresh")
    )
}
