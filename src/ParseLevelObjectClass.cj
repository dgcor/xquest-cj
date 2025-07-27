package XQuest

import dgengine.*
import stdx.encoding.json.*
import std.collection.*

func parseLevelObjectClass(game: Game, elem: JsonValue): Unit {
    if (let Some(level) <- game.resources.getLevel<Level>(getStringCharKey(elem, "level"))) {
        if (let Some(id) <- getValidString(elem, "id")) {
            // if (isValidId(id) == false || level.getUnitClass(id).isSome()) {
            //     return
            // }
            let elem = elem.asObject()
            // let texturePack = game.resources.getTexturePack(getStringCharKey(elem, "texturePack"))
            // let unitClass = match (texturePack) {
            //     case Some(tp) =>
            //         let explosionTexturePack = game.resources.getTexturePack(
            //             getStringCharKey(elem, "explosionTexturePack"))
            //         let directions = getUIntKey(elem, "directions")
            //         UnitClass(tp, explosionTexturePack, directions)
            //     case _ => return
            // }
            // unitClass.id = id
            // unitClass.points = Int64(getIntKey(elem, "points"))
            // unitClass.name = getStringCharKey(elem, "name")
            // unitClass.unitType = getStringCharKey(elem, "type")
            // unitClass.spawns = getStringCharKey(elem, "spawns")
            // unitClass.spawnCount = Formula(getStringKey(elem, "spawnCount", default: "1"))
            // unitClass.spawnArea = getIntRectKey(elem, "spawnArea")
            // unitClass.links = getStringCharKey(elem, "links")
            // unitClass.linkType = getUnitLinkKey(elem, "linkType")
            // unitClass.linkCount = Formula(getStringKey(elem, "linkCount", default: "1"))

            // if (let Some(elem) <- elem.get("onCreate")) {
            //     unitClass.createAction = getActionVal(game, elem)
            // }
            // if (let Some(elem) <- elem.get("onDestroy")) {
            //     unitClass.destroyAction = getActionVal(game, elem)
            // }

            // level.addUnitClass(id, unitClass)
        }
    }
}
