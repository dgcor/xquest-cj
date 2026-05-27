package dgengine

import cjsfml.system.*
import std.math.*
import stdjson2.*

private func getOrigin(elem: JsonValue, width: Float32, height: Float32): Vector2f {
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
    }
    if (let Some(elem) <- elem.get("show")) {
        game.mouseCursorVisible = getBoolVal(elem)
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
