package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class Movie <: ActionQueryable & UIObject {
    private let m_movie: RectangleShape = RectangleShape()
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_visible: Bool = true
    private var m_actionComplete: ?Action = None

    public init(_: String) {
        m_movie.fillColor = Color.black
    }

    // Resource

    public func isClosed(): Bool {
        m_movie.isClosed()
    }

    public func close(): Unit {
        m_movie.close()
    }

    // ActionQueryable

    public func getAction(name: String): ?Action {
        match (name) {
            case "complete" => m_actionComplete
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "complete" => m_actionComplete = action
            case _ => return false
        }
        return true
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_anchor
        }
        set(value) {
            m_anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        let pos = Box(m_movie.position)
        let size = Box(m_movie.size)
        anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_movie.position = pos.value
        m_movie.size = size.value
    }

    public prop drawPosition: Vector2f {
        get() {
            m_movie.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_movie.position
        }
        set(value) {
            m_movie.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_movie.size
        }
        set(value) {
            m_movie.size = value
        }
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public func draw(_: Game, target: RenderTarget): Unit {
        if (m_visible == true) {
            target.draw(m_movie)
        }
    }

    public override func update(game: Game): Unit {
        if (m_visible == false) {
            return
        }
        game.events.addBack(m_actionComplete)
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return getProperty(props[0], props[1])
    }

    // Movie

    public func load(): Bool {
        true
    }

    public func play(): Unit {}

    public func pause(): Unit {}

    public mut prop volume: Float32 {
        get() {
            0.0
        }
        set(_) {
        }
    }
}
