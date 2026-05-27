package xquest

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import dgengine.*
import std.convert.*

extend Level <: UIObject {
    // Resource

    public func isClosed(): Bool {
        surface.isClosed()
    }

    public func close(): Unit {
        surface.close()
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            surface.anchor
        }
        set(value) {
            surface.anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        surface.updateSize(game)
    }

    public prop drawPosition: Vector2f {
        get() {
            surface.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            surface.position
        }
        set(value) {
            surface.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            surface.size
        }
        set(value) {
            surface.size = value
        }
    }

    public mut prop visible: Bool {
        get() {
            surface.visible
        }
        set(value) {
            surface.visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        LevelDraw.draw(this, game, target)
    }

    public func update(game: Game): Unit {
        if (surface.visible == false || pause == true) {
            return
        }

        for (border in map.borders) {
            border.update(game)
        }

        if (gameState.state.isGameOver == false) {
            if (surface.visibleRect.contains(game.mousePositionf) == true) {
                hasMouseInside = true

                if (game.mouseMove.isSome() == true) {
                    LevelDraw.updateShip(this, game)
                }
                if (game.mousePress.isSome() == true) {
                    onMouseButtonPressed(game)
                }
            } else {
                hasMouseInside = false
            }
        }
    }

    // Queryable

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "id" => VaString(id)
            case "name" => VaString(name)
            case "gameSize" => Variable.getTuple2iProp(map.size, props[1])
            case "pause" => VaBoolean(pause)
            case "gameOver" => VaBoolean(gameState.state.isGameOver)
            case "level" => VaInteger(gameState.level)
            case "score" => VaInteger(gameState.score)
            case "lives" => VaInteger(gameState.lives)
            case "smartBombs" => VaInteger(gameState.smartBombs)
            case "hasHighScore" =>
                let idx = Int64.tryParse(props[1]) ?? 0
                VaBoolean(idx < highScores.size)
            case "highScore" => highScores.getProperty(props[1])
            case _ => getProperty(props[0], props[1])
        }
    }

    public func getQueryable(propName: String): ?QueryObject {
        if (propName.isEmpty() == true) {
            return ObjQueryable(this)
        }
        var props = splitStringIn2(propName, '.')
        var queryable: ?Queryable = match (props[0]) {
            case "queue" =>
                props = splitStringIn2(props[1], '.')
                // let idx = Int64.tryParse(props[0]) ?? 0
                // match (m_unitManager.getQueuedUnit(idx)) {
                //     case Some(unit) => unit
                //     case None => None
                // }
                None
            case _ => None
        }
        return match (queryable) {
            case Some(queryable) where props[1].isEmpty() == false => queryable.getQueryable(props[1])
            case Some(queryable) => ObjQueryable(queryable)
            case None => None
        }
    }

    private func onMouseButtonPressed(game: Game): Unit {
        match (game.mousePress?.button) {
            case Some(button) where button == MouseButton.Left => game.events.addBack(leftClickAction)
            case Some(button) where button == MouseButton.Right => game.events.addBack(rightClickAction)
            case _ => ()
        }
        game.mousePress = None
    }
}
