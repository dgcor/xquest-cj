package dgengine

import stdx.encoding.json.*

public func parseFocusAdd(elem: JsonValue): ?Action {
    ActFocusAdd(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "resource"),
        getBoolKey(elem, "focus", default: true)
    )
}

public func parseFocusClick(elem: JsonValue): ?Action {
    ActFocusClick(getBoolKey(elem, "playSound", default: true))
}

public func parseFocusMoveDown(): ?Action {
    ActFocusMoveDown()
}

public func parseFocusMoveUp(): ?Action {
    ActFocusMoveUp()
}

public func parseFocusRightClick(elem: JsonValue): ?Action {
    ActFocusRightClick(getBoolKey(elem, "playSound", default: true))
}

public func parseFocusSet(elem: JsonValue): ?Action {
    ActFocusSet(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "focus", default: true)
    )
}

public func parseFocusUpdate(_: JsonValue): ?Action {
    ActFocusUpdate()
}
