package dgengine

import stdx.encoding.json.*

public func parseMount(elem: JsonValue): ?Action {
    ActMount(
        getStringCharKey(elem, "file"),
        getStringCharKey(elem, "mount"),
        getBoolKey(elem, "append", default: true),
        getBoolKey(elem, "useSaveDir")
    )
}

public func parseUnmount(elem: JsonValue): ?Action {
    ActUnmount(
        getStringCharKey(elem, "file"),
        getBoolKey(elem, "useSaveDir")
    )
}

public func parseUnmountAll(): ?Action {
    ActUnmountAll()
}
