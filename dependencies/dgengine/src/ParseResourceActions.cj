package dgengine

import stdx.encoding.json.*

public func parseResourceAdd(elem: JsonValue): ?Action {
    let id = getStringCharKey(elem, "id")
    if (isValidId(id) == false) {
        return None
    }
    let action = ActResourceAdd(id)
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("ignorePrevious")) {
            action.setIgnorePrevious(getIgnoreResourceVal(elem))
        }
    }
    return action
}

public func parseResourceBringToFront(elem: JsonValue): ?Action {
    ActResourceBringToFront(getStringCharKey(elem, "id"))
}

public func parseResourceIgnore(elem: JsonValue): ?Action {
    ActResourceIgnore(
        getStringCharKey(elem, "id"),
        getIgnoreResourceKey(elem, "ignore", default: IgnoreResource.Draw | IgnoreResource.Update)
    )
}

public func parseResourcePop(elem: JsonValue): ?Action {
    ActResourcePop(
        getStringCharKey(elem, "id"),
        getIgnoreResourceKey(elem, "ignorePrevious")
    )
}

public func parseResourcePopAll(elem: JsonValue): ?Action {
    ActResourcePopAll(
        getStringCharKey(elem, "id"),
        getBoolKey(elem, "popBase"),
        getIgnoreResourceKey(elem, "ignorePrevious")
    )
}
