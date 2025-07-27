package dgengine

import stdx.encoding.json.*
import std.fs.*

public func parseGame(game: Game, filePath: String, fileName: String): Unit {
    if (FileUtils.mount(filePath, "", false) == false) {
        throw FSException(PhysFS.lastError)
    }

    var doc: JsonValue = JsonNull()
    try {
        let jsonText = FileUtils.readText(fileName)
        doc = JsonValue.fromStr(jsonText)
    } catch (_: Exception) {
        logger.warn("parseGame parse error: \"${filePath}\" -> \"${fileName}\"")
        FileUtils.unmount(filePath)
        return
    }

    logger.info("parseGame: \"${filePath}\" -> \"${fileName}\"")

    var filePath2 = FileUtils.getFilePath(filePath)

    if (filePath2.isEmpty() == false) {
        filePath2 += PhysFS.dirSeparator
    } else {
        filePath2 = "." + PhysFS.dirSeparator
    }

    game.path = filePath2

    parseDocument(game, doc)
}
