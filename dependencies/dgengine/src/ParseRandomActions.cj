package dgengine

import stdx.encoding.json.*

public func parseRandom(game: Game, elem: JsonValue): ?Action {
    ActRandom(
        getDoubleKey(elem, "percentage", default: 0.5),
        getActionKey(game, elem, "action1"),
        getActionKey(game, elem, "action2")
    )
}

public func parseRandomList(game: Game, elem: JsonValue): ?Action {
    let actionList = ActRandomList()
    if (let Some(elem) <- getValidArray(elem, "actions")) {
        for (val in elem.getItems()) {
            if (let Some(action) <- getActionVal(game, val)) {
                actionList.add(action)
            }
        }
    }
    if (actionList.isEmpty() == true) {
        return None
    }
    return actionList
}
