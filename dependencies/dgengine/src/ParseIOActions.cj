package dgengine

import stdx.encoding.json.*

public func parseDirCopy(elem: JsonValue): ?Action {
    ActDirCopy(
        getStringCharKey(elem, "source"),
        getStringCharKey(elem, "destination")
    )
}

public func parseDirCreate(elem: JsonValue): ?Action {
    ActDirCreate(getStringCharKey(elem, "file"))
}

public func parseFileCopy(elem: JsonValue): ?Action {
    ActFileCopy(
        getStringCharKey(elem, "dir"),
        getStringVectorKey(elem, "file").toArray(),
        getStringCharKey(elem, "writeFile"),
        getStringCharKey(elem, "nullText"),
        getReplaceVarsKey(elem, "replace")
    )
}

public func parseIODelete(elem: JsonValue): ?Action {
    ActIODelete(getStringCharKey(elem, "file"))
}

public func parseIODeleteAll(elem: JsonValue): ?Action {
    ActIODeleteAll(
        getStringCharKey(elem, "file"),
        getBoolKey(elem, "deleteRoot", default: true)
    )
}
