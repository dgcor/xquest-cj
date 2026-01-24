package dgengine

import cjsfml.system.*
import stdx.encoding.json.*

// sets anchor, position, size and visible
public func parseDrawableProperties(game: Game, elem: JsonValue, obj: UIObject): Unit {
    let size = Box(obj.size)
    parseDrawableProperties(game, elem, obj, size)
}

// sets anchor, position, size and visible
public func parseDrawableProperties(game: Game, elem: JsonValue, obj: UIObject, size: Box<Vector2f>): Unit {
    let anchor = getAnchorKey(elem, "anchor")
    obj.anchor = anchor
    let pos = Box(getPositionKey(elem, "position", size.value, game.refSize))
    if (getBoolKey(elem, "relativeCoords", default: true) == true && game.refSize != game.drawRegionSize) {
        anchor.getPosSize(pos, size, game.refSize, game.drawRegionSize)
    }
    obj.position = pos.value
    obj.size = size.value
    obj.visible = getBoolKey(elem, "visible", default: true)
}

// adds a drawable to an existing panel, if the panel element is present
public func parseDrawablePanel(resources: ResourceManager, elem: JsonValue, drawable: UIObject): Bool {
    if (let Some(panelId) <- getValidString(elem, "panel")) {
        if (let Some(panel) <- resources.getDrawable<Panel>(panelId)) {
            return panel.addDrawable(drawable)
        }
    }
    return false
}

public func parseDrawablePanelAndAdd(resources: ResourceManager, elem: JsonValue, id: String, obj: UIObject): Unit {
    let manageObjDrawing = parseDrawablePanel(resources, elem, obj) == false
    resources.addDrawable(
        id,
        obj,
        manageObjDrawing: manageObjDrawing,
        resourceId: getStringCharKey(elem, "resource")
    )
}

public func parseValidIdAndAddDrawable(game: Game, elem: JsonValue, parseDrawableFunc: (Game, JsonValue) -> ?UIObject): Unit {
    let id = parseValidId(elem)
    if (id.isEmpty() == true) {
        return
    }
    if (let Some(obj) <- parseDrawableFunc(game, elem)) {
        parseDrawablePanelAndAdd(game.resources, elem, id, obj)
    }
}

public func parseValidIdFileAndAddDrawable(game: Game, elem: JsonValue, parseDrawableFunc: (Game, JsonValue) -> ?UIObject): Unit {
    let id = parseValidIdOrFile(elem)
    if (id.isEmpty() == true) {
        return
    }
    if (let Some(obj) <- parseDrawableFunc(game, elem)) {
        parseDrawablePanelAndAdd(game.resources, elem, id, obj)
    }
}
