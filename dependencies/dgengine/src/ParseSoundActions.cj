package dgengine

import stdx.encoding.json.*

public func parseSoundLoadPlay(elem: JsonValue): ?Action {
    ActSoundLoadPlay(
        getStringCharKey(elem, "file"),
        getVariableKey(elem, "volume") ?? VaString(String.empty),
        getTimeUKey(elem, "seek"),
        getBoolKey(elem, "unique")
    )
}

public func parseSoundPlay(elem: JsonValue): ?Action {
    ActSoundPlay(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "volume") ?? VaString(String.empty),
        getTimeUKey(elem, "seek"),
        getBoolKey(elem, "unique")
    )
}
