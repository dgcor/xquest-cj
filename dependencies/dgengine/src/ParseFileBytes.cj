package dgengine

import stdx.encoding.json.*
import std.math.*

public func parseFileBytes(game: Game, elem: JsonValue): Unit {
    if (parseResourceFromId<Array<Byte>>(game.resources, elem) == true) {
        return
    }
    if (let JsObject <- elem.kind()) {
        let elem = elem.asObject()
        if (elem.containsKey("file") == false) {
            return
        }

        let file = getStringChar(elem["file"])
        let id = parseValidIdOrFilePath(elem, file)

        if (id.isEmpty() == true) {
            return
        }

        let startPosition = Int64(getUIntKey(elem, "startPosition"))
        let maxNumBytes = Int64(getNumberKey(elem, "bytesToRead", default: UInt32.Max))

        let bytes = FileUtils.readBytes(file, startPosition: startPosition, maxNumBytes: maxNumBytes)
        if (bytes.isEmpty() == true) {
            return
        }

        game.resources.addFileBytes(id, bytes, resourceId: getStringCharKey(elem, "resource"))
    }
}
