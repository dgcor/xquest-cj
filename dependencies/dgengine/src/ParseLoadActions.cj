package dgengine

import stdx.encoding.json.*

public func parseLoad(elem: JsonValue): ?Action {
    ActLoad(getStringVectorKey(elem, "file").toArray())
}

public func parseLoadJson(elem: JsonValue): ?Action {
    var json = String.empty
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("json") == true) {
            let elem = elem["json"]
            if (let Some(str) <- getValidString(elem)) {
                json = str
            } else {
                json = JsonUtils.jsonToString(elem)
            }
        } else if (let Some(file) <- getValidString(elem, "file")) {
            json = FileUtils.readText(file)
        }
    }
    if (let Some(elem) <- getValidArray(elem, "args")) {
        return ActLoadJson(
            json,
            args: getStringVectorVal(elem).toArray()
        )
    } else {
        return ActLoadJson(json)
    }
}

public func parseLoadRandom(elem: JsonValue): ?Action {
    ActLoadRandom(
        getStringVectorKey(elem, "file").toArray(),
        getStringCharKey(elem, "endsWith", default: ".json")
    )
}
