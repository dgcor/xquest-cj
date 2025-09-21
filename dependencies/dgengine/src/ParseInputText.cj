package dgengine

import stdx.encoding.json.*

public func getInputTextObj(game: Game, elem: JsonValue): ?InputText {
    if (let Some(font) <- game.resources.getFont(getStringKey(elem, "font"))) {
        let fontSize = getUIntKey(elem, "fontSize")
        let text = InputText(font, characterSize: fontSize)

        parseTextObj(game, elem, text)

        let elem = elem.asObject()
        if (elem.containsKey("minLength") == true) {
            text.minLength = getUIntVal(elem["minLength"])
        }
        if (elem.containsKey("maxLength") == true) {
            text.maxLength = getUIntVal(elem["maxLength"])
        }
        if (elem.containsKey("minValue") == true) {
            text.minValue = getVariableVal(elem["minValue"])
        }
        if (elem.containsKey("maxValue") == true) {
            text.maxValue = getVariableVal(elem["maxValue"])
        }
        if (let Some(regex) <- getValidString(elem, "regex")) {
            text.setRegex(regex)
        }

        if (elem.containsKey("onClick")) {
            text.setAction("click", getActionVal(game, elem["onClick"]))
        }
        if (elem.containsKey("onChange")) {
            text.setAction("change", getActionVal(game, elem["onChange"]))
        }
        if (elem.containsKey("onMinLength")) {
            text.setAction("minLength", getActionVal(game, elem["onMinLength"]))
        }
        return text
    }
    return None
}

public func parseInputText(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
                if (let Some(text) <- getInputTextObj(game, elem)) {
                    return text
                }
                return None
        }
    )
}
