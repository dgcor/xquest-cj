package dgengine

import stdx.encoding.json.*

public func parseSaveDir(elem: JsonValue): Unit {
    let saveDir = getStringChar(elem)
    if (saveDir.size > 0 && FileUtils.setSaveDir(saveDir) == true) {
        PhysFS.mount(PhysFS.getWriteDir(), String.empty, false)
    }
}
