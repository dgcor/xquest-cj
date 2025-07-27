package XQuest

import cjsfml.graphics.*
import dgengine.*
import stdx.encoding.json.stream.*
import std.collection.*
import std.io.*

class LevelSave {
    public static func load(level: Level, filePath: String): Bool {
        if (let Some(doc) <- JsonUtils.loadFile(filePath)) {
            return load(level, parseLevelSaveObj(level, doc))
        }
        return false
    }

    private static func load(level: Level, levelState: LevelSaveObject): Bool {
        level.m_gameState.state = levelState.state.state

        level.m_gameState.level = levelState.state.level
        level.m_gameState.score = levelState.state.score

        level.m_gameState.lives = levelState.state.lives
        level.m_gameState.smartBombs = levelState.state.smartBombs

        level.m_gameState.selectedPosition = levelState.state.selectedPosition

        level.m_options = level.m_optionsManager.get(level.m_gameState.level)

        return true
    }

    public static func save(level: Level, filePath: String): Unit {
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

        SaveUtils.writeValue(writer, "state", level.m_gameState.state.toInt())
        SaveUtils.writeValue(writer, "level", level.m_gameState.level)
        SaveUtils.writeValue(writer, "score", level.m_gameState.score)
        SaveUtils.writeValue(writer, "lives", level.m_gameState.lives)
        SaveUtils.writeValue(writer, "smartBombs", level.m_gameState.smartBombs)
        SaveUtils.writeValue(writer, "selectedPosition", level.m_gameState.selectedPosition)

        // root
        writer.endObject()
    }
}
