package dgengine

import stdx.encoding.json.*

public func parseGameAddToProperty(elem: JsonValue): ?Action {
    ActGameAddToProperty(
        getStringCharKey(elem, "property"),
        getVariableKey(elem, "value") ?? VaString(String.empty)
    )
}

public func parseGameClearPlayingSounds(): ?Action {
    ActGameClearPlayingSounds()
}

public func parseGameClose(): ?Action {
    ActGameClose()
}

public func parseGameDraw(): ?Action {
    ActGameDraw()
}

public func parseGameEnableInput(elem: JsonValue): ?Action {
    ActGameEnableInput(getBoolKey(elem, "enable", default: true))
}

public func parseGameGC(): ?Action {
    ActGameGC()
}

public func parseGameLoad(elem: JsonValue): ?Action {
    ActGameLoad(
        getStringCharKey(elem, "file"),
        getStringCharKey(elem, "mainFile", default: "main.json")
    )
}

public func parseGameSetGamma(elem: JsonValue): ?Action {
    ActGameSetGamma(getVariableKey(elem, "gamma") ?? VaString(String.empty))
}

public func parseGameSetMusicVolume(elem: JsonValue): ?Action {
    ActGameSetMusicVolume(getVariableKey(elem, "volume") ?? VaString(String.empty))
}

public func parseGameSetProperty(elem: JsonValue): ?Action {
    let action = ActGameSetProperty(
        getStringCharKey(elem, "property"),
        getVariableKey(elem, "value") ?? VaString(String.empty)
    )
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("propRange") == true) {
            action.setPropRange(getVector2iKey(elem, "propRange"))
        }
        if (elem.containsKey("valueRange") == true) {
            action.setValueRange(getVector2iKey(elem, "valueRange"))
        }
    }
    return action
}

public func parseGameSetSoundVolume(elem: JsonValue): ?Action {
    ActGameSetSoundVolume(getVariableKey(elem, "volume") ?? VaString(String.empty))
}
