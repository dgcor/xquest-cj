package dgengine

import stdx.encoding.json.*

// tries to get id from id element
public func parseValidId(elem: JsonValue): String {
    if (let Some(id) <- getValidString(elem, "id")) {
        if (isValidId(id)) {
            return id
        }
    }
    return String.empty
}

// tries to get id from id element. if id is not set, tries to get id from file element (name)
public func parseValidIdOrFile(elem: JsonValue, fileKey!: String = "file"): String {
    if (let Some(id) <- getValidString(elem, "id")) {
        if (isValidId(id)) {
            return id
        }
    } else if (let Some(file) <- getValidString(elem, fileKey)) {
        if (let Some(id) <- getIdFromFile(file)) {
            if (isValidId(id)) {
                return id
            }
        }
    }
    return String.empty
}

// tries to get id from id element. if id is not set, tries to get id from file (name)
public func parseValidIdOrFilePath(elem: JsonValue, filePath: String): String {
    if (let Some(id) <- getValidString(elem, "id")) {
        if (isValidId(id)) {
            return id
        }
    } else if (let Some(id) <- getIdFromFile(filePath)) {
        if (isValidId(id)) {
            return id
        }
    }
    return String.empty
}
