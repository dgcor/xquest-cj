package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func getScrollableObj(game: Game, elem: JsonValue): ?Scrollable {
    if (let Some(uiObj) <- game.resources.getDrawable(getStringKey(elem, "drawable"))) {
        // scrollable will manage drawing of the UIObject to scroll
        game.resources.deleteDrawable(uiObj)

        let speed = getTimeUKey(elem, "refresh", default: Time(milliseconds: 50))
        let scrollable = Scrollable(uiObj, speed)

        let size = Box(getSizeKey(elem, "size"))
        parseDrawableProperties(game, elem, scrollable, size)

        scrollable.direction = getDirectionKey(elem, "direction", default: Direction.Down)
        scrollable.offset = Float32(getIntKey(elem, "offset"))
        scrollable.loop = getBoolKey(elem, "loop")
        scrollable.pause = getBoolKey(elem, "pause")

        scrollable.reset()
        scrollable.updateView(game)

        let elem = elem.asObject()
        if (let Some(elem) <- elem.get("onComplete")) {
            scrollable.setAction("complete", getActionVal(game, elem))
        }
        return scrollable
    }
    return None
}

public func parseScrollable(game: Game, elem: JsonValue): Unit {
    if (isValidString(elem, "drawable")) {
        parseValidIdAndAddDrawable(
            game,
            elem,
            {
                game, elem =>
                    if (let Some(obj) <- getScrollableObj(game, elem)) {
                        return obj
                    }
                    return None
            }
        )
    }
}
