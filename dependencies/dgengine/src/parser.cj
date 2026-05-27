package dgengine

import physfs4cj.{PhysFS, PhysFSException}
import stdjson2.*

/**
 * @throws PhysFSException
 */
public func parseGame(game: Game, filePath: String, fileName: String): Unit {
    if (FileUtils.mount(filePath, "", false) == false) {
        throw PhysFSException()
    }
    try {
        let jsonText = FileUtils.readText(fileName)
        let doc = JsonValue.fromStr(jsonText)
        LOGGER.info("parseGame: \"${filePath}\" -> \"${fileName}\"")

        var filePath2 = FileUtils.getFilePath(filePath)

        if (filePath2.isEmpty() == false) {
            filePath2 += PhysFS.getDirSeparator()
        } else {
            filePath2 = "." + PhysFS.getDirSeparator()
        }

        game.path = filePath2

        parseDocument(game, doc)
    } catch (_: Exception) {
        LOGGER.warn("parseGame parse error: \"${filePath}\" -> \"${fileName}\"")
        FileUtils.unmount(filePath)
        return
    }
}
