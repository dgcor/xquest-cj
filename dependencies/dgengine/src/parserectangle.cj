package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import stdx.encoding.json.*

public func getRectangleObj(game: Game, elem: JsonValue): Rectangle {
    let rectangle = Rectangle(getSizeKey(elem, "size"))

    if (let Some(id) <- getValidString(elem, "texture")) {
        if (let Some(texture) <- game.resources.getTexture(id)) {
            rectangle.setTexture(texture)
        }
    }

    if (let Some(elem) <- getValidObject(elem)) {
        if (elem.containsKey("textureRect")) {
            let rect = IntRect(0, 0, Int32(game.drawRegionSize.x), Int32(game.drawRegionSize.y))
            rectangle.textureRect = getIntRectVal(elem["textureRect"], default: rect)
        }
    }

    parseDrawableProperties(game, elem, rectangle)

    rectangle.fillColor = getColorKey(elem, "color", default: Color.WHITE)
    rectangle.outlineColor = getColorKey(elem, "outlineColor", default: Color.WHITE)
    rectangle.outlineThickness = Float32(getUIntKey(elem, "outlineThickness"))

    return rectangle
}

public func parseRectangle(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(game, elem, {
        game, elem => getRectangleObj(game, elem)
    })
}
