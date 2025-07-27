package XQuest

import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.*
import std.collection.*

func parseLevelSaveObj(level: Level, elem: JsonValue): LevelSaveObject {
    var levelSave = LevelSaveObject()

    levelSave.state.state = LevelState.create(getInt64Key(elem, "state"))
    levelSave.state.level = Int64(getUIntKey(elem, "level"))
    levelSave.state.score = Int64(getUInt64Key(elem, "score"))
    levelSave.state.lives = Int64(getUIntKey(elem, "lives"))
    levelSave.state.smartBombs = Int64(getUIntKey(elem, "smartBombs"))
    let pos = getVector2iKey(elem, "selectedPosition")
    levelSave.state.selectedPosition = (Int64(pos.x), Int64(pos.y))

    return levelSave
}
