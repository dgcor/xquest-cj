package xquest

import dgengine.*
import std.collection.*
import stdjson2.*

func parseLevelObjectClass(game: Game, elem: JsonValue): Unit {
    if (let Some(level) <- game.resources.getLevel<Level>(getStringCharKey(elem, "level"))) {
        if (let Some(id) <- getValidString(elem, "id")) {
            if (isValidId(id) == false || level.levelObjectsClasses.contains(id)) {
                return
            }

            let texturePackId = getStringCharKey(elem, "texturePack")
            let texturePack = match (game.resources.getTexturePack(texturePackId)) {
                case Some(texturePack) => texturePack
                case None =>
                    LOGGER.debug("parseLevelObjectClass texturePack not found: ${texturePackId}")
                    return
            }

            let texturePackDestroyId = getStringCharKey(elem, "texturePackDestroy")
            let texturePackDestroy = match (game.resources.getTexturePack(texturePackDestroyId)) {
                case Some(texturePack) => texturePack
                case None =>
                    LOGGER.debug("parseLevelObjectClass texturePackDestroy not found: ${texturePackDestroyId}")
                    return
            }

            let levelObjectClass = LevelObjectClass(texturePack, texturePackDestroy)

            levelObjectClass.id = id
            levelObjectClass.clsType = getStringCharKey(elem, "type")
            levelObjectClass.points = Int64(getIntKey(elem, "points"))

            if (let Some(actionElem) <- elem.get("onCreate")) {
                levelObjectClass.createAction = getActionVal(game, actionElem)
            }
            if (let Some(actionElem) <- elem.get("onDestroy")) {
                levelObjectClass.destroyAction = getActionVal(game, actionElem)
            }

            level.levelObjectsClasses[id] = levelObjectClass
        }
    }
}
