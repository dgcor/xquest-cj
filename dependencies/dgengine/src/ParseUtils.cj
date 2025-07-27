package dgengine

import stdx.encoding.json.*

public func getIdFromFile(file: String): ?String {
    let id = FileUtils.getFileNameWithoutExt(file).replace(".", "")
    match (id.isEmpty()) {
        case false => id
        case true => None
    }
}

public func getValidArray(elem: JsonValue): ?JsonArray {
    match (elem.kind()) {
        case JsArray =>
            let array = elem.asArray()
            if (array.size() > 0) {
                return array
            }
        case _ => ()
    }
    return None
}

public func getValidArray(elem: JsonValue, key: String): ?JsonArray {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getValidArray(elem)
            }
        case _ => ()
    }
    return None
}

public func isValidArray(elem: JsonValue): Bool {
    match (elem.kind()) {
        case JsArray => elem.asArray().size() > 0
        case _ => false
    }
}

public func isValidArray(elem: JsonValue, key: String): Bool {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return isValidArray(elem)
            }
        case _ => ()
    }
    return false
}

public func isValidId(id: String): Bool {
    if (id.isEmpty() == true) {
        logger.warn("Invalid id: (empty)")
        return false
    }
    for (ch in id.runes()) {
        if (ch.isAsciiNumberOrLetter() || ch == r"_") {
            continue
        }
        logger.warn("Invalid id: ${id}")
        return false
    }
    return true
}

public func getValidObject(elem: JsonValue): ?JsonObject {
    match (elem.kind()) {
        case JsObject =>
            let obj = elem.asObject()
            if (obj.size() > 0) {
                return obj
            }
        case _ => ()
    }
    return None
}

public func getValidObject(elem: JsonValue, key: String): ?JsonObject {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                match (elem.kind()) {
                    case JsObject =>
                        let obj = elem.asObject()
                        if (obj.size() > 0) {
                            return obj
                        }
                    case _ => ()
                }
            }
        case _ => ()
    }
    return None
}

public func isValidObject(elem: JsonValue): Bool {
    match (elem.kind()) {
        case JsObject => elem.asObject().size() > 0
        case _ => false
    }
}

public func isValidObject(elem: JsonValue, key: String): Bool {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                match (elem.kind()) {
                    case JsObject => return elem.asObject().size() > 0
                    case _ => ()
                }
            }
        case _ => ()
    }
    return false
}

public func getValidString(elem: JsonValue): ?String {
    match (elem.kind()) {
        case JsString =>
            let str = elem.asString().getValue()
            if (str.isEmpty() == false) {
                return str
            }
        case _ => ()
    }
    return None
}

public func getValidString(elem: JsonValue, key: String): ?String {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                return getValidString(elem)
            }
        case _ => ()
    }
    return None
}

public func isValidString(elem: JsonValue): Bool {
    match (elem.kind()) {
        case JsString => elem.asString().getValue().isEmpty() == false
        case _ => false
    }
}

public func isValidString(elem: JsonValue, key: String): Bool {
    match (elem.kind()) {
        case JsObject =>
            if (let Some(elem) <- elem.asObject().get(key)) {
                match (elem.kind()) {
                    case JsString => return isValidString(elem)
                    case _ => ()
                }
            }
        case _ => ()
    }
    return false
}
