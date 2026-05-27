package xquest

import dgengine.*
import std.io.*
import stdjson2.*

class LevelSave {
    static func load(level: Level, filePath: String): Bool {
        if (let Some(doc) <- JsonUtils.loadFile(filePath)) {
            return load(level, parseLevelSaveObj(level, doc))
        }
        return false
    }

    private static func load(level: Level, levelState: LevelSaveObject): Bool {
        level.gameState.state = levelState.state.state

        level.gameState.level = levelState.state.level
        level.gameState.score = levelState.state.score

        level.gameState.lives = levelState.state.lives
        level.gameState.smartBombs = levelState.state.smartBombs

        level.gameState.selectedPosition = levelState.state.selectedPosition

        level.options = level.optionsManager.get(level.gameState.level)

        return true
    }

    static func save(level: Level, filePath: String): Unit {
        let stream = ByteBuffer()
        let writer = JsonWriter(stream)
        writer.writeConfig = WriteConfig.pretty
        writer.writeConfig.indent = "  "
        serialize(level, writer)
        writer.flush()
        FileUtils.saveBytes(filePath, stream.bytes())
    }

    private static func serialize(level: Level, writer: JsonWriter): Unit {
        // root
        writer.startObject()

        SaveUtils.writeValue(writer, "state", level.gameState.state.toInt())
        SaveUtils.writeValue(writer, "level", level.gameState.level)
        SaveUtils.writeValue(writer, "score", level.gameState.score)
        SaveUtils.writeValue(writer, "lives", level.gameState.lives)
        SaveUtils.writeValue(writer, "smartBombs", level.gameState.smartBombs)
        SaveUtils.writeValue(writer, "selectedPosition", level.gameState.selectedPosition)

        // root
        writer.endObject()
    }
}
