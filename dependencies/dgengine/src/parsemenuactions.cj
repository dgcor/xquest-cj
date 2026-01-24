package dgengine

import ctemplate.*
import cjsfml.graphics.*
import stdx.encoding.json.*

@Template[functionName, actionName: parseMenuAppendText, ActMenuAppendText ; parseMenuSetText, ActMenuSetText](
public func functionName(elem: JsonValue): ?Action {
    let index = Int64(getUIntKey(elem, "index"))
    var action: ?ActTextAppendOrSetText = None
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("binding") == true) {
            action = actionName(
                getStringCharKey(elem, "id"),
                index,
                getStringCharKey(elem, "format"),
                getStringVectorVal(elem["binding"]).toArray()
            )
        } else if (let Some(query) <- getValidString(elem, "query")) {
            action = actionName(
                getStringCharKey(elem, "id"),
                index,
                getStringCharKey(elem, "text"),
                query
            )
        } else {
            var textOp = TextOp.Replace
            if (getBoolKey(elem, "set") == true) {
                textOp = TextOp.Set
            }
            else if (getBoolKey(elem, "replaceAll") == true) {
                textOp = TextOp.ReplaceAll
            }
            action = actionName(
                getStringCharKey(elem, "id"),
                index,
                getStringCharKey(elem, "text"),
                textOp
            )
        }
    }
    if (let Some(action) <- action) {
        if (getBoolKey(elem, "removeEmptyLines") == true) {
            action.removeEmptyLines()
        }
        if (getBoolKey(elem, "trim") == true) {
            action.trim()
        }
        return action
    }
    return None
})

public func parseMenuClick(elem: JsonValue): ?Action {
    ActMenuClick(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "index")),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseMenuClickVisible(elem: JsonValue): ?Action {
    ActMenuClickVisible(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "index")),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseMenuMoveScrollbar(elem: JsonValue): ?Action {
    ActMenuMoveScrollbar(
        getStringCharKey(elem, "idMenu"),
        getStringCharKey(elem, "idScrollbar"),
        getStringCharKey(elem, "idAnchorTo"),
        getUIntKey(elem, "range"),
        getBoolKey(elem, "focus")
    )
}

public func parseMenuRightClick(elem: JsonValue): ?Action {
    ActMenuRightClick(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "index")),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseMenuRightClickVisible(elem: JsonValue): ?Action {
    ActMenuRightClickVisible(
        getStringCharKey(elem, "id"),
        Int64(getUIntKey(elem, "index")),
        getBoolKey(elem, "playSound", default: true)
    )
}

public func parseMenuSetColor(elem: JsonValue): ?Action {
    ActMenuSetColor(
        getStringCharKey(elem, "id"),
        Int64(getIntKey(elem, "index", default: -1)),
        getColorKey(elem, "color", default: Color.WHITE)
    )
}

public func parseMenuSetFont(elem: JsonValue): ?Action {
    ActMenuSetFont(
        getStringCharKey(elem, "id"),
        Int64(getIntKey(elem, "index", default: -1)),
        getStringCharKey(elem, "font")
    )
}

public func parseMenuSetIndex(elem: JsonValue): ?Action {
    ActMenuSetIndex(
        getStringCharKey(elem, "id"),
        getVariableKey(elem, "index") ?? VaString(String.empty),
        getBoolKey(elem, "focus")
    )
}
