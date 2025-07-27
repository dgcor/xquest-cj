package XQuest

import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import dgengine.*
import std.convert.*

extend Level <: UIObject {
    // Resource

    public func isClosed(): Bool {
        m_surface.isClosed()
    }

    public func close(): Unit {
        m_surface.close()
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_surface.anchor
        }
        set(value) {
            m_surface.anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        m_surface.updateSize(game)
    }

    public prop drawPosition: Vector2f {
        get() {
            m_surface.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_surface.position
        }
        set(value) {
            m_surface.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_surface.size
        }
        set(_) {}
    }

    public mut prop visible: Bool {
        get() {
            m_surface.visible
        }
        set(value) {
            m_surface.visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        LevelDraw.draw(this, game, target)
    }

    public func update(game: Game): Unit {
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
            case "gameSize" => Variable.getTuple2iProp(m_map.size, props[1])
            case "pause" => VaBoolean(m_pause)
            case "gameOver" => VaBoolean(m_gameState.state.isGameOver)
            case "level" => VaInteger(m_gameState.level)
            case "score" => VaInteger(m_gameState.score)
            case "lives" => VaInteger(m_gameState.lives)
            case "smartBombs" => VaInteger(m_gameState.smartBombs)
            case "hasHighScore" =>
                let idx = Int64.tryParse(props[1]) ?? 0
                VaBoolean(idx < m_highScoresManager.size)
            case "highScore" => m_highScoresManager.getProperty(props[1])
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
                let idx = Int64.tryParse(props[0]) ?? 0
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
            case Some(button) where button == MouseButton.Left => game.events.addBack(m_leftClickAction)
            case Some(button) where button == MouseButton.Right => game.events.addBack(m_rightClickAction)
            case _ => ()
        }
        game.mousePress = None
    }
}
