package dgengine

import cjsfml.graphics.*
import stdx.encoding.json.*

public func getShapeObj(game: Game, elem: JsonValue): ?Shape {
    let shape = Shape(getPrimitiveTypeKey(elem, "type"))

    if (let Some(elem) <- getValidArray(elem, "vertices")) {
        for (elem in elem.getItems()) {
            shape.addVertex(
                Vertex(
                    position: getVector2fKey(elem, "position"),
                    color: getColorKey(elem, "color", default: Color.white)
                )
            )
        }
        if (shape.pointCount > 0) {
            parseDrawableProperties(game, elem, shape)
            return shape
        }
    }
    return None
}

public func parseShape(game: Game, elem: JsonValue): Unit {
    if (isValidArray(elem, "vertices")) {
        parseValidIdAndAddDrawable(
            game,
            elem,
            {
                game, elem =>
                if (let Some(shape) <- getShapeObj(game, elem)) {
                    return shape
                }
                return None
            }
        )
    }
}
