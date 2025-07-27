package dgengine

import ctemplate.*
import cjsfml.graphics.*
import stdx.encoding.json.*

@Template[functionName, actionName: parseTextAppendText, ActTextAppendText ; parseTextSetText, ActTextSetText](
public func functionName(elem: JsonValue): ?Action {
    var action: ?ActTextAppendOrSetText = None
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("binding") == true) {
            action = actionName(
                getStringCharKey(elem, "id"),
                getStringCharKey(elem, "format"),
                getStringVectorVal(elem["binding"]).toArray()
            )
        } else if (let Some(query) <- getValidString(elem, "query")) {
            action = actionName(
                getStringCharKey(elem, "id"),
                getStringCharKey(elem, "text"),
                query
            )
        } else {
            var textOp = TextOp.Replace
            if (getBoolKey(elem, "set") == true) {
                textOp = TextOp.Set
            }
            action = actionName(
                getStringCharKey(elem, "id"),
                getStringCharKey(elem, "text"),
                textOp
            )
        }
    }
    if (let Some(action) <- action) {
        if (getBoolKey(elem, "replaceAll") == true) {
            action.replaceAll()
        }
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

public func parseTextSetColor(elem: JsonValue): ?Action {
    ActTextSetColor(
        getStringCharKey(elem, "id"),
        getColorKey(elem, "color", default: Color.white)
    )
}

public func parseTextSetFont(elem: JsonValue): ?Action {
    ActTextSetFont(
        getStringCharKey(elem, "id"),
        getStringCharKey(elem, "font")
    )
}

public func parseTextSetSpacing(elem: JsonValue): ?Action {
    let action = ActTextSetSpacing(getStringCharKey(elem, "id"))
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("horizontal")) {
            action.setHorizontalSpaceOffset(getIntVal(elem))
        }
        if (let Some(elem) <- elem.get("vertical")) {
            action.setVerticalSpaceOffset(getIntVal(elem))
        }
    }
    return action
}
