package dgengine

import stdx.encoding.json.*

public func getMenuObj(game: Game, elem: JsonValue): ?Menu {
    if (let Some(referenceButton) <- parseTextButton(game, elem)) {
        parseButtonProperties(game, elem, referenceButton)
        parseButtonActions(game, elem, referenceButton)

        let menu = Menu()
        let elem = elem.asObject()
        if (elem.containsKey("items") == true) {
            var menuIdx = 0

            let relativePos = getBoolKey(elem, "relativeCoords", default: true)
            let resource = getStringCharKey(elem, "resource")

            let items = elem["items"]
            match (items.kind()) {
                case JsObject => menuIdx = parseMenuItem(game, items, menu, menuIdx, referenceButton, relativePos,
                    resource)
                case JsArray => for (itemVal in items.asArray().getItems()) {
                    menuIdx = parseMenuItem(game, itemVal, menu, menuIdx, referenceButton, relativePos, resource)
                }
                case _ => ()
            }
        }

        if (referenceButton.isFocusEnabled == true) {
            menu.setFocusEnabled()
        }

        let size = Box(getSizeKey(elem, "size"))
        parseDrawableProperties(game, elem, menu, size)

        let pos = menu.position
        let horizAlign = referenceButton.horizontalAlign
        let vertAlign = referenceButton.verticalAlign

        menu.setVerticalAlign(vertAlign)
        menu.setScrollPosition(GameUtils.getAlignmentPosition(pos, size.value, horizAlign, vertAlign))
        menu.setVerticalPad(getIntKey(elem, "verticalPad"))
        menu.setVisibleItems(Int64(getUIntKey(elem, "visibleItems")))

        if (elem.containsKey("onScrollDown")) {
            menu.setAction("scrollDown", getActionVal(game, elem["onScrollDown"]))
        }
        if (elem.containsKey("onScrollUp")) {
            menu.setAction("scrollUp", getActionVal(game, elem["onScrollUp"]))
        }

        menu.updateVisibleItems()
        menu.calculatePositions()

        return menu
    }
    return None
}

public func parseMenu(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
                if (let Some(menu) <- getMenuObj(game, elem)) {
                    return menu
                }
                return None
        }
    )
}
