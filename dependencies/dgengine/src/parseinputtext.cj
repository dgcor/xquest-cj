package dgengine

import stdjson2.*

public func getInputTextObj(game: Game, elem: JsonValue): ?InputText {
    if (let Some(font) <- game.resources.getFont(getStringKey(elem, "font"))) {
        let fontSize = getUIntKey(elem, "fontSize")
        let text = InputText(font, characterSize: fontSize)

        parseTextObj(game, elem, text)

        if (let Some(elem) <- elem.get("minLength")) {
            text.minLength = getUIntVal(elem)
        }
        if (let Some(elem) <- elem.get("maxLength")) {
            text.maxLength = getUIntVal(elem)
        }
        if (let Some(elem) <- elem.get("minValue")) {
            text.minValue = getVariableVal(elem)
        }
        if (let Some(elem) <- elem.get("maxValue")) {
            text.maxValue = getVariableVal(elem)
        }
        if (let Some(regex) <- getValidString(elem, "regex")) {
            text.setRegex(regex)
        }

        if (let Some(elem) <- elem.get("onClick")) {
            text.setAction("click", getActionVal(game, elem))
        }
        if (let Some(elem) <- elem.get("onChange")) {
            text.setAction("change", getActionVal(game, elem))
        }
        if (let Some(elem) <- elem.get("onMinLength")) {
            text.setAction("minLength", getActionVal(game, elem))
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
