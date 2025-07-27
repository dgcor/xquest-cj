package dgengine

import stdx.encoding.json.*

public func parseBitmapButton(game: Game, elem: JsonValue): ?BitmapButton {
    var button = Option<BitmapButton>.None

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            button = BitmapButton(texture)
        }
    } else if (let Some(id) <- getValidString(elem, "texturePack")) {
        if (let Some(texPack) <- game.resources.getTexturePack(id)) {
            if (let Some(tiVar) <- texPack.getAll(getUIntKey(elem, "textureIndex"))) {
                match (tiVar) {
                    case TextureInfoSingle(ti) => button = BitmapButton(ti)
                    case TextureInfoMulti(ti) => button = BitmapButton(ti)
                }
            }
        }
    }

    if (let Some(btn) <- button) {
        parseImageProperties(game, elem, btn)
    }

    return button
}

public func parseTextButton(game: Game, elem: JsonValue): ?TextButton {
    if (let Some(font) <- game.resources.getFont(getStringKey(elem, "font"))) {
        let fontSize = getUIntKey(elem, "fontSize")
        let text = TextButton(font, characterSize: fontSize)

        parseTextObj(game, elem, text)
        parseBindableTextObj(game, elem, text)

        return text
    }
    return None
}

public func parseButtonObj(game: Game, elem: JsonValue): ?Button {
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("font") == false) {
            if (let Some(btn) <- parseBitmapButton(game, elem)) {
                return btn
            }
        } else {
            if (let Some(btn) <- parseTextButton(game, elem)) {
                return btn
            }
        }
    }
    return None
}

public func parseButtonProperties(game: Game, elem: JsonValue, button: Button): Unit {
    if (getBoolKey(elem, "focus") == true) {
        button.setFocusEnabled(focusOnClick: getBoolKey(elem, "focusOnClick", default: true))
    }
    button.enable(getBoolKey(elem, "enable", default: true))
    button.clickUp = getBoolKey(elem, "clickUp")
    button.captureInputEvents = getInputEventTypeKey(elem, "captureInputEvents")

    if (let Some(id) <- getValidString(elem, "sound")) {
        button.clickSound = game.resources.getSoundBuffer(id)
    }
    if (let Some(id) <- getValidString(elem, "focusSound")) {
        button.focusSound = game.resources.getSoundBuffer(id)
    }
}

public func parseButtonActions(game: Game, elem: JsonValue, button: Button): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("onClick")) {
            button.setAction("click", getActionVal(game, elem["onClick"]))
        }
        if (elem.containsKey("onRightClick")) {
            button.setAction("rightClick", getActionVal(game, elem["onRightClick"]))
        }
        if (elem.containsKey("onDoubleClick")) {
            button.setAction("doubleClick", getActionVal(game, elem["onDoubleClick"]))
        }
        if (elem.containsKey("onClickDrag")) {
            button.setAction("clickDrag", getActionVal(game, elem["onClickDrag"]))
        }
        if (elem.containsKey("onClickIn")) {
            button.setAction("clickIn", getActionVal(game, elem["onClickIn"]))
        }
        if (elem.containsKey("onClickOut")) {
            button.setAction("clickOut", getActionVal(game, elem["onClickOut"]))
        }
        if (elem.containsKey("onFocus")) {
            button.setAction("focus", getActionVal(game, elem["onFocus"]))
        }
        if (elem.containsKey("onHoverEnter")) {
            button.setAction("hoverEnter", getActionVal(game, elem["onHoverEnter"]))
        }
        if (elem.containsKey("onHoverLeave")) {
            button.setAction("hoverLeave", getActionVal(game, elem["onHoverLeave"]))
        }
    }
}

public func getButtonObj(game: Game, elem: JsonValue): ?Button {
    if (let Some(button) <- parseButtonObj(game, elem)) {
        parseButtonProperties(game, elem, button)
        parseButtonActions(game, elem, button)

        if (button.isFocusEnabled == true) {
            game.resources.addFocused(button, resourceId: getStringCharKey(elem, "resource"))
        }
        return button
    }
    return None
}

public func parseButton(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
            if (let Some(btn) <- getButtonObj(game, elem)) {
                return btn
            }
            return None
        }
    )
}
