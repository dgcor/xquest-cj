package dgengine

import stdx.encoding.json.*

public func parseMountFile(game: Game, elem: JsonValue): Unit {
    var file = getStringKey(elem, "file")
    if (file.isEmpty() == true) {
        return
    }
    if (getBoolKey(elem, "useSaveDir") == false) {
        file = game.path + file
    } else {
        file = FileUtils.getSaveDir() + file
    }
    if (getBoolKey(elem, "unmount") == false) {
        let mount = getStringCharKey(elem, "mount")
        let append = getBoolKey(elem, "append", default: true)
        FileUtils.mount(file, mount, append)
    } else {
        FileUtils.unmount(file)
    }
}
