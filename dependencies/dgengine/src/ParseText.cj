package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func parseTextObj(game: Game, elem: JsonValue, text: Text): Unit {
    text.horizontalSpaceOffset = getIntKey(elem, "horizontalSpaceOffset")
    text.verticalSpaceOffset = getIntKey(elem, "verticalSpaceOffset")
    text.horizontalAlign = HorizontalAlign.get(getStringCharKey(elem, "horizontalAlign"))
    text.verticalAlign = VerticalAlign.get(getStringCharKey(elem, "verticalAlign"), default: AlignBottom)

    text.color = getColorKey(elem, "color", default: Color.white)

    parseTextDisplayText(elem, text)

    parseDrawableProperties(game, elem, text)
}

// parse "text"/"file" property of Text
public func parseTextDisplayText(elem: JsonValue, text: Text): Unit {
    var displayText = String.empty

    if (let Some(text) <- getValidString(elem, "text")) {
        displayText = text
    } else if (let Some(file) <- getValidString(elem, "file")) {
        displayText = FileUtils.readText(file)
    }

    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("wordWrap") == true) {
            let maxLength = Int64(getUIntVal(elem["wordWrap"]))
            if (maxLength > 0) {
                displayText = wordWrap(displayText, maxLength)
            }
        }
    }
    text.text = displayText
}

public func getTextObj(game: Game, elem: JsonValue): ?Text {
    if (let Some(font) <- game.resources.getFont(getStringKey(elem, "font"))) {
        let fontSize = getUIntKey(elem, "fontSize")
        let text = Text(font, characterSize: fontSize)

        parseTextObj(game, elem, text)

        return text
    }
    return None
}

public func parseBindableTextObj(game: Game, elem: JsonValue, text: BindableText): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        let hasBinding = elem.containsKey("binding") == true
        if (hasBinding == true) {
            text.setBinding(getStringVectorKey(elem, "binding"))
            if (getBoolKey(elem, "bindToFormat", default: true) == true) {
                text.format = getStringCharKey(elem, "format", default: "[1]")
            } else {
                text.format = text.text
            }
            text.bindingFlags = getBindingFlagsKey(elem, "bindingFlags")
        }
        if (elem.containsKey("onChange")) {
            text.setAction("change", getActionVal(game, elem["onChange"]))
        }
        if (hasBinding == true) {
            text.updateText(game)
        }
    }
}

public func getBindableTextObj(game: Game, elem: JsonValue): ?BindableText {
    if (let Some(font) <- game.resources.getFont(getStringKey(elem, "font"))) {
        let fontSize = getUIntKey(elem, "fontSize")
        let text = BindableText(font, characterSize: fontSize)

        parseTextObj(game, elem, text)
        parseBindableTextObj(game, elem, text)

        return text
    }
    return None
}

public func parseText(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
                if (let Some(text) <- getBindableTextObj(game, elem)) {
                    return text
                }
                return None
        }
    )
}
