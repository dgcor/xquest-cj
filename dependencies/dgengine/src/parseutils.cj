package dgengine

import stdjson2.*

public func getIdFromFile(file: String): ?String {
    let id = FileUtils.getFileNameWithoutExt(file).replace(".", "")
    match (id.isEmpty()) {
        case false => id
        case true => None
    }
}

public func getValidArray(elem: JsonValue): ?JsonValue {
    match {
        case elem.size > 0 => elem
        case _ => None
    }
}

public func getValidArray(elem: JsonValue, key: String): ?JsonValue {
    match (elem.get(key)) {
        case Some(elem) where elem.size > 0 => elem
        case _ => None
    }
}

public func isValidArray(elem: JsonValue): Bool {
    elem.size > 0
}

public func isValidArray(elem: JsonValue, key: String): Bool {
    match (elem.get(key)) {
        case Some(elem) => elem.size > 0
        case _ => false
    }
}

public func isValidId(id: String): Bool {
    if (id.isEmpty() == true) {
        LOGGER.warn("Invalid id: (empty)")
        return false
    }
    for (ch in id.runes()) {
        if (ch.isAsciiNumberOrLetter() || ch == r"_") {
            continue
        }
        LOGGER.warn("Invalid id: ${id}")
        return false
    }
    return true
}

public func getValidObject(elem: JsonValue): ?JsonValue {
    match {
        case elem.memberSize > 0 => elem
        case _ => None
    }
}

public func getValidObject(elem: JsonValue, key: String): ?JsonValue {
    match (elem.get(key)) {
        case Some(elem) where elem.memberSize > 0 => elem
        case _ => None
    }
}

public func isValidObject(elem: JsonValue): Bool {
    elem.memberSize > 0
}

public func isValidObject(elem: JsonValue, key: String): Bool {
    match (elem.get(key)) {
        case Some(elem) => elem.memberSize > 0
        case _ => false
    }
}

public func getValidString(elem: JsonValue): ?String {
    match (elem.getString()) {
        case Some(str) where str.isEmpty() == false => str
        case _ => None
    }
}

public func getValidString(elem: JsonValue, key: String): ?String {
    match (elem.getString(key)) {
        case Some(str) where str.isEmpty() == false => str
        case _ => None
    }
}

public func isValidString(elem: JsonValue): Bool {
    let size = elem.getString()?.size ?? return false
    return size > 0
}

public func isValidString(elem: JsonValue, key: String): Bool {
    let size = elem.getString(key)?.size ?? return false
    return size > 0
}
