package XQuest

import dgengine.*
import stdx.encoding.json.*

func parseLevel(game: Game, elem: JsonValue): Unit {
    let id = getStringCharKey(elem, "id")
    var level = game.resources.getLevel<Level>(id)
    if (level.isNone()) {
        if (isValidId(id) == false) {
            return
        }

        let lvl = Level()

        game.resources.addDrawable(id, lvl, manageObjDrawing: true, resourceId: getStringCharKey(elem, "resource"))
        game.resources.setCurrentLevel(lvl)
        lvl.id = id
        lvl.setShader(game.shaders.level)

        let size = Box(getVector2fKey(elem, "size"))
        parseDrawableProperties(game, elem, lvl, size)
        level = lvl
    }

    if (let Some(level) <- level) {
        if (let Some(elem) <- getValidObject(elem)) {
            if (let Some(elem) <- elem.get("name")) {
                level.name = getStringChar(elem)
            }
            // if (let Some(elem) <- elem.get("scoreFormula")) {
            //     level.setScoreFormula(getStringChar(elem))
            // }
            // if (let Some(elem) <- getValidArray(elem, "levels")) {
            //     parseLevelOptions(level.allOptions, elem)
            // }
            // if (let Some(elem) <- getValidArray(elem, "highScores")) {
            //     parseLevelScores(level.highScores, elem)
            // }

            if (let Some(elem) <- elem.get("onLeftClick")) {
                level.setAction(
                    "leftClick",
                    getActionVal(game, elem)
                )
            }
            if (let Some(elem) <- elem.get("onRightClick")) {
                level.setAction(
                    "rightClick",
                    getActionVal(game, elem)
                )
            }
            if (let Some(elem) <- elem.get("onNewRound")) {
                level.setAction(
                    "newRound",
                    getActionVal(game, elem)
                )
            }
            if (let Some(elem) <- elem.get("onGameOver")) {
                level.setAction(
                    "gameOver",
                    getActionVal(game, elem)
                )
            }

            let borders = game.resources.getTexturePack(getStringCharKey(elem, "bordersTexturePack"))

            let initLevel = getBoolKey(elem, "init")
            if (initLevel == false && borders.isNone()) {
                return
            }

            let mapSize = getVector2iKey(elem, "mapSize")
            let padding = getVector2iKey(elem, "padding")

            level.initialize(borders.getOrThrow(), (Int64(mapSize.x), Int64(mapSize.y)),
                (Int64(padding.x), Int64(padding.y)))
        }
    }
}
