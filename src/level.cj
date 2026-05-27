package xquest

import dgengine.*
import std.collection.*

class Level {
    let surface = Surface(forceEvenSize: false, isometricZoom: false)
    var gameShader: ?GameShader = None

    let map = LevelMap()

    var bordersTexturePack: ?TexturePack = None

    var id = String.empty
    var name = String.empty

    var pause = false
    var hasMouseInside = true

    var gameState = LevelStateObject()

    var scoreFormula = Formula()
    var options = LevelOptions()

    let optionsManager = LevelOptionsManager()

    var leftClickAction: ?Action = None
    var rightClickAction: ?Action = None
    var newRoundAction: ?Action = None
    var gameOverAction: ?Action = None

    let levelObjectsClasses = HashMap<String, LevelObjectClass>()

    let highScores = LevelScoreManager()

    // Level

    func initialize(bordersTexturePack: TexturePack, mapSize: (Int64, Int64), padding: (Int64, Int64)): Unit {
        this.bordersTexturePack = bordersTexturePack
        map.initialize(this, mapSize, padding)
    }

    // func addLevelObject(cls: LevelObjectClass, mapPos: (Int64, Int64)): Unit {
    //     addLevelObject(LevelObject(cls, mapPosition: mapPos))
    // }

    func addLevelObject(obj: LevelObject): Unit {
        map.levelObjects.add(obj)
    }

    private func initNewGame(game: Game): Unit {
        pause = false

        surface.setCenter()
        surface.initialize(game)
        surface.updateView(game)

        gameState = LevelStateObject()
        gameState.state = AddLevelObjects
        options = LevelOptions()
    }

    func newGame(game: Game): Unit {
        initNewGame(game)
        nextLevel(game)
    }

    func loadGame(game: Game, filePath: String): Unit {
        initNewGame(game)
        if (LevelSave.load(this, filePath) == true) {
            game.events.addBack(newRoundAction)
        }
    }

    func saveGame(filePath: String): Unit {
        LevelSave.save(this, filePath)
    }

    private func nextLevel(game: Game): Unit {
        gameState.level = gameState.level + 1
        options = optionsManager.get(gameState.level)
        gameState.lives = gameState.lives + Int64(options.lives)
        gameState.smartBombs = gameState.smartBombs + Int64(options.smartBombs)

        if (map.m_ship.isNone()) {
            let class_ = levelObjectsClasses.get("ship")
            if (class_.isSome()) {
                map.m_ship = LevelObject(class_.getOrThrow())
            }
        }

        if (let Some(ship) <- map.m_ship) {
            ship.movement = (Float32(map.size[0] / 2), Float32(map.size[1] / 2))
            if (let Some(shipClass) <- levelObjectsClasses.get("ship")) {
                ship.setAnimation(shipClass.texturePack, 0, 0)
            }
        }

        for (item in options.insert) {
            let (key, val) = item
            let class_ = levelObjectsClasses.get(key)
            let numObjects = Int32(val.eval(this))
            if (class_.isSome() && numObjects > 0 && numObjects <= 255) {
                for (_ in 0..numObjects) {
                    let obj = LevelObject(class_.getOrThrow())
                    let mapPosX = Float32(Random.get(0, map.size[0]))
                    let mapPosY = Float32(Random.get(0, map.size[1]))
                    obj.movement = (mapPosX, mapPosY)
                    map.levelObjects.add(obj)
                }
            }
        }

        game.events.addBack(newRoundAction)
    }

    // Properties

    // private func onMouseButtonPressed(game: Game): Unit {
    //     match (game.mousePress?.button) {
    //         case Some(button) where button == MouseButton.Left => game.events.addBack(m_leftClickAction)
    //         case Some(button) where button == MouseButton.Right => game.events.addBack(m_rightClickAction)
    //         case _ => ()
    //     }
    //     game.mousePress = None
    // }
}
