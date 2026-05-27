package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import stdjson2.*

public func getCircleObj(game: Game, elem: JsonValue): Circle {
    let circle = Circle(Float32(getIntKey(elem, "radius")))

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            circle.setTexture(texture)
        }
    }

    if (let Some(elem) <- elem.get("textureRect")) {
        let rect = IntRect(0, 0, Int32(game.drawRegionSize.x), Int32(game.drawRegionSize.y))
        circle.textureRect = getIntRectVal(elem, default: rect)
    }

    parseDrawableProperties(game, elem, circle)

    circle.fillColor = getColorKey(elem, "color", default: Color.WHITE)
    circle.outlineColor = getColorKey(elem, "outlineColor", default: Color.WHITE)
    circle.outlineThickness = Float32(getUIntKey(elem, "outlineThickness"))

    return circle
}

public func parseCircle(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(game, elem, {
        game, elem => getCircleObj(game, elem)
    })
}
