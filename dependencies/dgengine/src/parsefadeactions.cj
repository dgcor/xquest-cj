package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import stdx.encoding.json.*

public func parseGameFade(game: Game, elem: JsonValue, defautlColor: Color, isFadeOut: Bool): ?Action {
    let action = ActGameFade(
        getColorKey(elem, "color", default: defautlColor),
        isFadeOut,
        getBoolKey(elem, "enableInput", default: !isFadeOut),
        UInt8(clamp(getUIntKey(elem, "fade", default: 25), 0, 255)),
        getTimeUKey(elem, "refresh", default: Time(milliseconds: 15))
    )
    if (let Some(elem) <- getValidObject(elem)) {
        if (let Some(elem) <- elem.get("action")) {
            action.setAction(getActionVal(game, elem))
        }
    }
    return action
}

public func parseGameFadeIn(game: Game, elem: JsonValue): ?Action {
    parseGameFade(game, elem, Color(), false)
}

public func parseGameFadeOut(game: Game, elem: JsonValue): ?Action {
    parseGameFade(game, elem, Color.TRANSPARENT, true)
}
