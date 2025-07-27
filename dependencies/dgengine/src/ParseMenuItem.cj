package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import stdx.encoding.json.*
import std.collection.*

public type MenuFilterObject = (condition: String, property: String, value: Variable)

public func parseMenuFilterObj(elem: JsonValue, list: ArrayList<MenuFilterObject>): Unit {
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("value")) {
            let condition = getStringCharKey(elem, "if")
            let property = getStringKey(elem, "property")
            if (let Some(elem) <- getValidArray(elem)) {
                for (val in elem.getItems()) {
                    list.add((condition, property, getVariableVal(val) ?? VaString(String.empty)))
                }
            } else {
                list.add((condition, property, getVariableVal(elem) ?? VaString(String.empty)))
            }
        }
    }
}

public func parseMenuFilterList(elem: JsonValue): ArrayList<MenuFilterObject> {
    let list = ArrayList<MenuFilterObject>()
    match (elem.kind()) {
        case JsObject => parseMenuFilterObj(elem, list)
        case JsArray => for (val in elem.asArray().getItems()) {
            if (val.isObject() == true) {
                parseMenuFilterObj(val, list)
            }
        }
        case _ => ()
    }
    return list
}

public func parseAndExecuteMenuAction(game: Game, elem: JsonValue): Unit {
    game.events.addBack(getActionKey(game, elem, "executeAction"))
}

public func compareMenuFilterVariables(condition: String, var1: Variable, var2: Variable): Bool {
    match (condition) {
        case "!=" => var1 != var2
        case ">" => var1 > var2
        case ">=" => var1 >= var2
        case "<" => var1 < var2
        case "<=" => var1 <= var2
        case _ => var1 == var2
    }
}

public func getMenuFilterResult(filterList: ArrayList<MenuFilterObject>, varToCheck: Variable, includedOrExcluded: Bool): Bool {
    var skip = includedOrExcluded
    for ((condition, property, value) in filterList) {
        if (compareMenuFilterVariables(condition, varToCheck, value) == true) {
            skip = !includedOrExcluded
            break
        }
    }
    return skip
}

public func getMenuFilterResult(filterList: ArrayList<MenuFilterObject>, queryable: Queryable, includedOrExcluded: Bool): Bool {
    var skip = includedOrExcluded
    for ((condition, property, value) in filterList) {
        if (let Some(varToCheck) <- queryable.getProperty(property)) {
            if (compareMenuFilterVariables(condition, varToCheck, value) == true) {
                skip = !includedOrExcluded
                break
            }
        }
    }
    return skip
}

public func parseMenuButton(game: Game, elem: JsonObject, menu: Menu, referenceButton: TextButton, relativePos: Bool,
    resource: String): Unit {
    let button = referenceButton.clone()

    button.enable(getBoolKey(elem, "enable", default: referenceButton.isEnabled))

    parseTextDisplayText(elem, button)
    parseBindableTextObj(game, elem, button)

    let recalculatePosition = elem.containsKey("position") == false
    if (recalculatePosition == false) {
        let pos = Box(getVector2fVal(elem["position"], default: referenceButton.position))
        if (relativePos == true && game.refSize != game.drawRegionSize) {
            let size = Box(button.size)
            referenceButton.anchor.getPosSize(pos, size, game.refSize, game.drawRegionSize)
        }
        button.position = pos.value
    }

    parseButtonActions(game, elem, button)

    menu.addItem(button, recalculatePosition)

    if (button.isFocusEnabled == true) {
        game.resources.addFocused(button, resourceId: resource)
    }
}

// returns the next menuIdx
public func parseMenuItem(game: Game, elem: JsonValue, menu: Menu, menuIdx: Int64, referenceButton: TextButton,
    relativePos: Bool, resource: String): Int64 {
    if (let Some(query) <- getValidString(elem, "load")) {
        let elem = elem.asObject()
        var menuIdx = menuIdx
        let (include, filterList) = match (false) {
            case _ where elem.containsKey("exclude") => (false, parseMenuFilterList(elem["exclude"]))
            case _ where elem.containsKey("include") => (true, parseMenuFilterList(elem["include"]))
            case _ => (true, ArrayList<MenuFilterObject>())
        }
        let menuItems = game.getQueryableList(query)
        for ((index, menuItem) in menuItems |> enumerate) {
            let elemCopy = match (menuItem) {
                case VarOrQueryQueryObject(obj) =>
                    let queryable = obj.getQueryable()
                    if (filterList.isEmpty() == false && getMenuFilterResult(filterList, queryable, include) == true) {
                        continue
                    }
                    let menuIdx = menuIdx
                    let listIdx = obj.getIndex(index)
                    JsonUtils.replaceValuesWithFunction(
                        elem.clone(),
                        {
                            value =>
                            var val = JsonUtils.replaceStringValueWithQueryable(
                                value,
                                queryable,
                                changeValueType: true
                            )
                            val = JsonUtils.replaceStringValueWithVariable(
                                val,
                                "!listIdx!",
                                VaInteger(listIdx),
                                changeValueType: true
                            )
                            val = JsonUtils.replaceStringValueWithVariable(
                                val,
                                "!menuIdx!",
                                VaInteger(menuIdx),
                                changeValueType: true
                            )
                            return val
                        }
                    )
                case VarOrQueryVariable(variable) =>
                    if (filterList.isEmpty() == false && getMenuFilterResult(filterList, variable, include) == true) {
                        continue
                    }
                    let menuIdx = menuIdx
                    JsonUtils.replaceValuesWithFunction(
                        elem.clone(),
                        {
                            value =>
                            var val = JsonUtils.replaceStringValueWithVariable(
                                value,
                                "!listItem!",
                                VaString(variable.toString())
                            )
                            val = JsonUtils.replaceStringValueWithVariable(
                                val,
                                "!menuIdx!",
                                VaInteger(menuIdx),
                                changeValueType: true
                            )
                            return val
                        }
                    )
            }
            parseMenuButton(game, elemCopy.asObject(), menu, referenceButton, relativePos, resource)
            parseAndExecuteMenuAction(game, elemCopy)
            menuIdx++
        }
        return menuIdx
    } else if (let Some(elem) <- getValidObject(elem)) {
        let elemCopy = JsonUtils.replaceValuesWithFunction(
            elem.clone(),
            {
                value => JsonUtils.replaceStringValueWithVariable(
                    value,
                    "!menuIdx!",
                    VaInteger(menuIdx),
                    changeValueType: true
                )
            }
        )
        parseMenuButton(game, elemCopy.asObject(), menu, referenceButton, relativePos, resource)
        parseAndExecuteMenuAction(game, elemCopy)
        return menuIdx + 1
    } else {
        return menuIdx
    }
}
