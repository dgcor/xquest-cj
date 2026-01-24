package dgengine

import stdx.encoding.json.*
import std.collection.*

public func parseIfCondition(condition: String, game: Game, elem: JsonValue): ?Action {
    ActIfCondition(
        condition,
        getVarOrPredicateKey(game, elem, "param1"),
        getVarOrPredicateKey(game, elem, "param2"),
        getActionKey(game, elem, "then"),
        getActionKey(game, elem, "else")
    )
}

public func parseInListCondition(game: Game, elem: JsonValue): ?Action {
    let list = ArrayList<Variable>()
    if (let Some(elem) <- getValidArray(elem, "list")) {
        for (val in elem.getItems()) {
            if (let Some(value) <- getVariableVal(val)) {
                list.add(value)
            }
        }
    }
    return ActInListCondition(
        getVarOrPredicateKey(game, elem, "param"),
        list.toArray(),
        getActionKey(game, elem, "then"),
        getActionKey(game, elem, "else")
    )
}

public func parseMultiIfConditionHelper(game: Game, conditions: IfCondition, elem: JsonArray): Unit {
    var step = 0
    var condition = "=="
    var param1 = VaVariable(VaString(String.empty))
    var param2 = VaVariable(VaString(String.empty))
    for (val in elem.getItems()) {
        // step 0 - param 1 - can be a new condition array
        // step 1 - == != > >= < <= regex
        // step 2 - param 2 - adds condition ex: (param 1 > param2)
        // step 3 - and/or - ex: param1 == param2 and param3 == param4
        if (step == 1) {
            condition = getStringChar(val)
        } else if (step == 3) {
            match (getStringChar(val)) {
                case "or" => conditions.addCondition(CoOr)
                case _ => conditions.addCondition(CoAnd)
            }
            step = 0
            continue
        } else {
            if (let Some(val) <- getValidArray(val)) {
                conditions.addCondition(CoLeftBracket)
                parseMultiIfConditionHelper(game, conditions, val)
                conditions.addCondition(CoRightBracket)
                step = 3
                continue
            }
            if (step == 0) {
                param1 = getVarOrPredicateVal(game, val)
            } else if (step == 2) {
                param2 = getVarOrPredicateVal(game, val)
                conditions.addCondition(condition, param1, param2)
                condition = "=="
                param1 = VaVariable(VaString(String.empty))
                param2 = VaVariable(VaString(String.empty))
            }
        }
        step++
    }
}

public func parseMultiIfCondition(game: Game, elem: JsonValue): ?Action {
    if (let Some(params) <- getValidArray(elem, "params")) {
        let action = ActMultiIfCondition(
            getActionKey(game, elem, "then"),
            getActionKey(game, elem, "else")
        )
        parseMultiIfConditionHelper(game, action.conditions, params)
        return action
    }
    return None
}

public func parseSwitchConditionHelper(game: Game, elem: JsonObject, actionName: String,
    cases: ArrayList<(Variable, ?Action)>): ?Action {
    if (let Some(elem) <- elem.get(actionName)) {
        if (elem.isObject() == false) {
            let actionRef = getVariableKey(elem, actionName) ?? VaString(String.empty)
            for (caseObj in cases) {
                if (caseObj[0] == actionRef) {
                    return caseObj[1]
                }
            }
        }
        return getActionVal(game, elem)
    }
    return None
}

public func parseSwitchCondition(game: Game, elem: JsonValue): ?Action {
    if (let Some(elem) <- getValidObject(elem)) {
        let cases = ArrayList<(Variable, ?Action)>()
        if (let Some(elem) <- getValidArray(elem, "case")) {
            for (val in elem.getItems()) {
                if (let Some(val) <- getValidObject(val)) {
                    if (let Some(value) <- getVariableKey(val, "value")) {
                        cases.add((value, parseSwitchConditionHelper(game, val, "action", cases)))
                    }
                }
            }
        }
        return ActSwitchCondition(
            getVarOrPredicateKey(game, elem, "param"),
            cases.toArray(),
            parseSwitchConditionHelper(game, elem, "default", cases)
        )
    }
    return None
}
