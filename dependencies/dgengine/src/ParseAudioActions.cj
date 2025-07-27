package dgengine

import stdx.encoding.json.*

public func parseAudioDelete(elem: JsonValue): ?Action {
    ActAudioDelete(getStringCharKey(elem, "id"))
}

public func parseAudioPause(elem: JsonValue): ?Action {
    ActAudioPause(getStringCharKey(elem, "id"))
}

public func parseAudioPauseAll(): ?Action {
    ActAudioPauseAll()
}

public func parseAudioPlay(elem: JsonValue): ?Action {
    let action = ActAudioPlay(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "volume") ?? VaString(String.empty),
        getBoolKey(elem, "clear")
    )

    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("loop") == true) {
            action.setLoop(getBoolVal(elem["loop"]))
        }
    }
    return action
}

public func parseAudioResumeAll(elem: JsonValue): ?Action {
    ActAudioResumeAll(getBoolKey(elem, "restart"))
}

public func parseAudioSeek(elem: JsonValue): ?Action {
    ActAudioSeek(
        getStringCharKey(elem, "id"),
        getTimeUKey(elem, "time")
    )
}

public func parseAudioSetVolume(elem: JsonValue): ?Action {
    ActAudioSetVolume(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "volume") ?? VaString(String.empty)
    )
}

public func parseAudioStop(elem: JsonValue): ?Action {
    ActAudioStop(getStringCharKey(elem, "id"))
}

public func parseAudioStopAll(): ?Action {
    ActAudioStopAll()
}
