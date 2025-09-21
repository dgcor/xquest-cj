package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*
import std.convert.*

public class Panel <: UIObject {
    private let m_drawables: ArrayList<UIObject> = ArrayList<UIObject>()
    private var m_position: Vector2f = Vector2f()
    private var m_drawPosition: Vector2f = Vector2f()
    private var m_drawSize: Vector2f = Vector2f()
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_visible: Bool = true
    private let m_relativePositions: Bool
    private var m_sizePosNeedsUpdate: Bool = true
    private var m_closed: Bool = false

    public init(relativePositions: Bool) {
        m_relativePositions = relativePositions
    }

    // Resource

    public func isClosed(): Bool {
        m_closed
    }

    public func close(): Unit {
        m_closed = true
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
        let pos = Box(m_position)
        let size = Box(Vector2f())
        m_anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_position = pos.value
        for (drawable in m_drawables) {
            if (drawable.isClosed() == false) {
                drawable.updateSize(game)
            }
        }
        updateDrawPositionAndSize()
    }

    // calculate the draw position/size based on all its children's draw positions/sizes
    private func updateDrawPositionAndSize(): Unit {
        m_drawPosition.x = Float32.Max
        m_drawPosition.y = Float32.Max
        m_drawSize = m_position
        for (drawable in m_drawables) {
            if (drawable.isClosed()) {
                continue
            }
            let objDrawPos = drawable.drawPosition
            if (objDrawPos.x < m_drawPosition.x) {
                m_drawPosition.x = objDrawPos.x
            }
            if (objDrawPos.y < m_drawPosition.y) {
                m_drawPosition.y = objDrawPos.y
            }
            let posAndSize = objDrawPos + drawable.size
            if (posAndSize.x > m_drawSize.x) {
                m_drawSize.x = posAndSize.x
            }
            if (posAndSize.y > m_drawSize.y) {
                m_drawSize.y = posAndSize.y
            }
        }
        if (m_drawPosition.x == Float32.Max) {
            m_drawPosition = m_position
        }
        m_drawSize -= m_drawPosition
    }

    public prop drawPosition: Vector2f {
        get() {
            m_drawPosition
        }
    }

    public mut prop position: Vector2f {
        get() {
            if (m_sizePosNeedsUpdate == true) {
                m_sizePosNeedsUpdate = false
                updateDrawPositionAndSize()
            }
            return m_position
        }
        set(value) {
            if (m_position == value) {
                return
            }
            for (drawable in m_drawables) {
                if (drawable.isClosed() == false) {
                    drawable.position = (drawable.position - m_position + value)
                }
            }
            m_position = value
            updateDrawPositionAndSize()
        }
    }

    public mut prop size: Vector2f {
        get() {
            if (m_sizePosNeedsUpdate == true) {
                m_sizePosNeedsUpdate = false
                updateDrawPositionAndSize()
            }
            return m_drawSize
        }
        set(_) {}
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget, visibleRect: FloatRect): Bool {
        if (m_visible == false) {
            return false
        }
        var hasDrawn = false
        for (drawable in m_drawables) {
            if (drawable.isClosed() == false) {
                let itemRect = FloatRect(drawable.drawPosition, drawable.size)
                if (visibleRect.intersects(itemRect).isSome()) {
                    drawable.draw(game, target)
                    hasDrawn = true
                }
            }
        }
        return hasDrawn
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        if (m_visible == false) {
            return
        }
        for (drawable in m_drawables) {
            if (drawable.isClosed() == false) {
                drawable.draw(game, target)
            }
        }
    }

    public override func update(game: Game): Unit {
        if (m_visible == false) {
            return
        }
        m_sizePosNeedsUpdate = true
        for (index in m_drawables.size - 1..=0 : -1) {
            let drawable = m_drawables[index]
            match (drawable.isClosed()) {
                case true => m_drawables.remove(at: index)
                case false => drawable.update(game)
            }
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "itemCount" => VaInteger(m_drawables.size)
            case "item" =>
                let props2 = splitStringIn2(props[1], '.')
                let itemIdx = Int64.tryParse(props2[0]) ?? 0
                return match (m_drawables.get(itemIdx)) {
                    case Some(drawable) where drawable.isClosed() == false => drawable.getProperty(props2[1])
                    case _ => None
                }
            case _ => getProperty(props[0], props[1])
        }
    }

    // Panel

    public func addDrawable(obj: UIObject): Bool {
        if (isObjEq(obj, this)) {
            return false
        }
        for (drawable in m_drawables) {
            if (isObjEq(obj, drawable)) {
                return false
            }
        }
        m_drawables.add(obj)
        if (m_relativePositions == true) {
            obj.position = obj.position + m_position
        }
        return true
    }

    public func getDrawable(index: Int64): ?UIObject {
        let drawable = m_drawables.get(index)
        if (let Some(obj) <- drawable) {
            return match (obj.isClosed()) {
                case true => None
                case false => drawable
            }
        }
        return drawable
    }

    public prop drawableCount: Int64 {
        get() {
            m_drawables.size
        }
    }
}
