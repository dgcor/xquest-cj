package dgengine

import physfs4cj.PhysFS
import stdjson2.*

public func parseSaveDir(elem: JsonValue): Unit {
    let saveDir = getStringChar(elem)
    if (saveDir.size > 0 && FileUtils.setSaveDir(saveDir) == true) {
        FileUtils.mount(PhysFS.getWriteDir() ?? "", String.empty, false)
    }
}
