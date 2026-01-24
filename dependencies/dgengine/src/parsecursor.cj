package dgengine

import cjsfml.system.*
import stdx.encoding.json.*
import std.math.*

private func getOrigin(elem: JsonObject, width: Float32, height: Float32): Vector2f {
    if (let Some(str) <- getValidString(elem, "origin")) {
        if (str == "center") {
            return Vector2f(round(width / 2.0), round(height / 2.0))
        }
    }
    return getVector2fKey(elem, "origin")
}

public func parseCursorF(game: Game, elem: JsonValue, getAnimationObj: (game: Game, elem: JsonValue) -> ?Animation): Unit {
    if (elem.isNull() == true) {
        game.resources.addCursor(None)
        return
    } else if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("show") == true) {
            game.mouseCursorVisible = getBoolVal(elem["show"])
        }

        if (getBoolKey(elem, "pop") == true) {
            game.resources.popCursor()
            game.updateMousePosition()
        }

        if (let Some(cursor) <- getAnimationObj(game, elem)) {
            let size = cursor.size
            cursor.setOrigin(getOrigin(elem, size.x, size.y))
            game.resources.addCursor(cursor)
            game.updateMousePosition()
        }
    }
}

public func parseCursor(game: Game, elem: JsonValue): Unit {
    parseCursorF(
        game,
        elem,
        {
            game, elem =>
                if (let Some(anim) <- getAnimationObj(game, elem)) {
                    return anim
                }
                return None
        }
    )
}
