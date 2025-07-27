package dgengine

import stdx.encoding.json.*

public func parseVariableAdd(elem: JsonValue): ?Action {
    ActVariableAdd(
        getStringCharKey(elem, "key"),
        getVariableKey(elem, "value") ?? VaString(String.empty)
    )
}

public func parseVariableClear(elem: JsonValue): ?Action {
    ActVariableClear(getStringCharKey(elem, "key"))
}

public func parseVariableSave(elem: JsonValue): ?Action {
    ActVariableSave(
        getStringCharKey(elem, "file"),
        getStringVectorKey(elem, "vars").toArray()
    )
}

public func parseVariableSet(elem: JsonValue): ?Action {
    if (let Some(elem) <- getValidObject(elem, "values")) {
        return ActVariablesSet(
            getVariables(elem).toArray(),
            getBoolKey(elem, "resolveValue", default: true)
        )
    }
    let key = getStringCharKey(elem, "key")
    if (isValidId(key) == false) {
        return None
    }
    return ActVariableSet(
        key,
        getVariableKey(elem, "value") ?? VaString(String.empty),
        getBoolKey(elem, "resolveValue", default: true)
    )
}

public func parseVariableSetIfNull(elem: JsonValue): ?Action {
    let key = getStringCharKey(elem, "key")
    if (isValidId(key) == false) {
        return None
    }
    return ActVariableSetIfNull(
        key,
        getVariableKey(elem, "value") ?? VaString(String.empty),
        getBoolKey(elem, "resolveValue", default: true)
    )
}
