package xquest

import dgengine.*
import stdjson2.*

func parseLevelAddHighScore(elem: JsonValue): ?Action {
    ActLevelAddHighScore(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "scoreName"),
        Int64(getIntKey(elem, "scoreLevel")),
        getInt64Key(elem, "score")
    )
}

func parseLevelLoadGame(elem: JsonValue): ?Action {
    ActLevelLoadGame(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "file")
    )
}

func parseLevelNewGame(elem: JsonValue): ?Action {
    ActLevelNewGame(getStringCharKey(elem, "level"))
}

func parseLevelPause(elem: JsonValue): ?Action {
    ActLevelPause(
        getStringCharKey(elem, "level"),
        getBoolKey(elem, "pause", default: true)
    )
}

func parseLevelSaveGame(elem: JsonValue): ?Action {
    ActLevelSaveGame(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "file")
    )
}

func parseLevelSetShader(elem: JsonValue): ?Action {
    ActLevelSetShader(
        getStringCharKey(elem, "level"),
        getStringCharKey(elem, "shader")
    )
}
