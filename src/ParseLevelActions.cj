package XQuest

import dgengine.*
import stdx.encoding.json.*

public func parseLevelAddHighScore(elem: JsonValue): ?Action {
    ActLevelAddHighScore(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "scoreName"),
        Int64(getIntKey(elem, "scoreLevel")),
        getInt64Key(elem, "score")
    )
}

public func parseLevelLoadGame(elem: JsonValue): ?Action {
    ActLevelLoadGame(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "file")
    )
}

public func parseLevelNewGame(elem: JsonValue): ?Action {
    ActLevelNewGame(getStringCharKey(elem, "level"))
}

public func parseLevelPause(elem: JsonValue): ?Action {
    ActLevelPause(
        getStringCharKey(elem, "level"),
        getBoolKey(elem, "pause", default: true)
    )
}

public func parseLevelSaveGame(elem: JsonValue): ?Action {
    ActLevelSaveGame(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "file")
    )
}

public func parseLevelSetShader(elem: JsonValue): ?Action {
    ActLevelSetShader(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "shader")
    )
}
