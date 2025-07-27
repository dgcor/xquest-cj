package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

public func getPanelObj(game: Game, elem: JsonValue): Panel {
    let panel = Panel(getBoolKey(elem, "relativePositions"))
    let size = Box(Vector2f())
    parseDrawableProperties(game, elem, panel, size)
    return panel
}

public func parsePanel(game: Game, elem: JsonValue): Unit {
    let id = parseValidId(elem)
    if (id.isEmpty() == true) {
        return
    }
    let panel = getPanelObj(game, elem)
    game.resources.addDrawable(
        id,
        panel,
        manageObjDrawing: true,
        resourceId: getStringCharKey(elem, "resource")
    )
}
