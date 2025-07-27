package dgengine

import stdx.encoding.json.*

public func parseDrawableAddToPosition(elem: JsonValue): ?Action {
    ActDrawableAddToPosition(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "offset")
    )
}

public func parseDrawableAddToSize(elem: JsonValue): ?Action {
    ActDrawableAddToSize(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "offset")
    )
}

public func parseDrawableAnchor(elem: JsonValue): ?Action {
    ActDrawableAnchor(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchor"),
        getAnchorKey(elem, "anchor"),
        getVector2fKey(elem, "offset")
    )
}

public func parseDrawableAnchorSize(elem: JsonValue, applyToY: Bool): ?Action {
    ActDrawableAnchorSizeXY(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        Float32(getIntKey(elem, "offset")),
        applyToY
    )
}

public func parseDrawableAnchorSizeX(elem: JsonValue): ?Action {
    parseDrawableAnchorSize(elem, false)
}

public func parseDrawableAnchorSizeY(elem: JsonValue): ?Action {
    parseDrawableAnchorSize(elem, true)
}

public func parseDrawableAnchorToFocused(elem: JsonValue): ?Action {
    ActDrawableAnchorToFocused(
        getStringCharKey(elem, "id"),
        getAnchorKey(elem, "anchor"),
        getVector2fKey(elem, "offset")
    )
}

public func parseDrawableBringToFront(elem: JsonValue): ?Action {
    ActDrawableBringToFront(getStringCharKey(elem, "id"))
}

public func parseDrawableCenter(elem: JsonValue): ?Action {
    ActDrawableCenter(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idCenterOn"),
        getVector2fKey(elem, "offset")
    )
}

public func parseDrawableCenterOnMouseX(elem: JsonValue): ?Action {
    ActDrawableCenterOnMouseX(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "steps") ?? VaString(String.empty)
    )
}

public func parseDrawableCenterOnMouseY(elem: JsonValue): ?Action {
    ActDrawableCenterOnMouseY(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "steps") ?? VaString(String.empty)
    )
}

public func parseDrawableDelete(elem: JsonValue): ?Action {
    ActDrawableDelete(getStringCharKey(elem, "id"))
}

public func parseDrawableExecuteAction(elem: JsonValue): ?Action {
    ActDrawableExecuteAction(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "action")
    )
}

public func parseDrawableHorizontalAnchorToFocused(elem: JsonValue): ?Action {
    ActDrawableHorizontalAnchorToFocused(
        getStringCharKey(elem, "id"),
        Float32(getIntKey(elem, "offset"))
    )
}

public func parseDrawableMoveX(elem: JsonValue): ?Action {
    ActDrawableMoveX(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "position") ?? VaString(String.empty),
        getUIntKey(elem, "min"),
        getUIntKey(elem, "max"),
        getVariableKey(elem, "steps") ?? VaString(String.empty)
    )
}

public func parseDrawableMoveY(elem: JsonValue): ?Action {
    ActDrawableMoveY(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "position") ?? VaString(String.empty),
        getUIntKey(elem, "min"),
        getUIntKey(elem, "max"),
        getVariableKey(elem, "steps") ?? VaString(String.empty)
    )
}

public func parseDrawableMoveStepX(elem: JsonValue): ?Action {
    ActDrawableMoveStepX(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "steps") ?? VaString(String.empty),
        getIntKey(elem, "stepOffset")
    )
}

public func parseDrawableMoveStepY(elem: JsonValue): ?Action {
    ActDrawableMoveStepY(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getVariableKey(elem, "steps") ?? VaString(String.empty),
        getIntKey(elem, "stepOffset")
    )
}

public func parseDrawableResize(elem: JsonValue, applyToY: Bool): ?Action {
    ActDrawableResizeXY(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "size") ?? VaString(String.empty),
        getVariableKey(elem, "inputRangeMin") ?? VaString(String.empty),
        getVariableKey(elem, "inputRangeMax") ?? VaString(String.empty),
        getVector2iKey(elem, "range"),
        applyToY
    )
}

public func parseDrawableResizeX(elem: JsonValue): ?Action {
    parseDrawableResize(elem, false)
}

public func parseDrawableResizeY(elem: JsonValue): ?Action {
    parseDrawableResize(elem, true)
}

public func parseDrawableResizeOnMouseX(elem: JsonValue): ?Action {
    ActDrawableResizeOnMouseX(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "range")
    )
}

public func parseDrawableResizeOnMouseY(elem: JsonValue): ?Action {
    ActDrawableResizeOnMouseY(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "range")
    )
}

public func parseDrawableResizeToPositionX(elem: JsonValue): ?Action {
    ActDrawableResizeToPositionX(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idToPosition"),
        Float32(getIntKey(elem, "offset"))
    )
}

public func parseDrawableResizeToPositionY(elem: JsonValue): ?Action {
    ActDrawableResizeToPositionY(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "idToPosition"),
        Float32(getIntKey(elem, "offset"))
    )
}

public func parseDrawableSendToBack(elem: JsonValue): ?Action {
    ActDrawableSendToBack(getStringCharKey(elem, "id"))
}

public func parseDrawableSetAction(game: Game, elem: JsonValue): ?Action {
    ActDrawableSetAction(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "event"),
        getActionKey(game, elem, "action")
    )
}

public func parseDrawableSetPosition(elem: JsonValue): ?Action {
    ActDrawableSetPosition(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "position"),
        getVector2fKey(elem, "offset"),
        getBoolKey(elem, "relativeCoords", default: true)
    )
}

public func parseDrawableSetPosition(elem: JsonValue, applyToY: Bool): ?Action {
    ActDrawableSetPositionXY(
        getStringCharKey(elem, "id"),
        Float32(getIntKey(elem, "position")),
        applyToY
    )
}

public func parseDrawableSetPositionX(elem: JsonValue): ?Action {
    parseDrawableSetPosition(elem, false)
}

public func parseDrawableSetPositionY(elem: JsonValue): ?Action {
    parseDrawableSetPosition(elem, true)
}

public func parseDrawableSetSize(elem: JsonValue): ?Action {
    ActDrawableSetSize(
        getStringCharKey(elem, "id"),
        getVector2fKey(elem, "size")
    )
}

public func parseDrawableSetSize(elem: JsonValue, applyToY: Bool): ?Action {
    ActDrawableSetSizeXY(
        getStringCharKey(elem, "id"),
        Float32(getIntKey(elem, "size")),
        applyToY
    )
}

public func parseDrawableSetSizeX(elem: JsonValue): ?Action {
    parseDrawableSetSize(elem, false)
}

public func parseDrawableSetSizeY(elem: JsonValue): ?Action {
    parseDrawableSetSize(elem, true)
}

public func parseDrawableVerticalAnchorToFocused(elem: JsonValue): ?Action {
    ActDrawableVerticalAnchorToFocused(
        getStringCharKey(elem, "id"),
        Float32(getIntKey(elem, "offset"))
    )
}
