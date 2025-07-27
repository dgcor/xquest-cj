package XQuest

import cjsfml.system.*
import dgengine.*
import stdx.encoding.json.*
import std.math.*

func getStarfieldObj(game: Game, elem: JsonValue): Starfield {
    let size = getVector2fKey(elem, "size", default: Vector2f(320.0, 240.0))

    let starfield = Starfield(game, size, Int16(getIntKey(elem, "stars", default: 255)))

    let sizeBox = Box(size)
    parseDrawableProperties(game, elem, starfield, sizeBox)

    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("speed")) {
            starfield.setSpeed(getTimeUVal(elem, default: Time(milliseconds: 25)).seconds)
        }
    }

    return starfield
}

func parseStarfield(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem => getStarfieldObj(game, elem)
        }
    )
}
