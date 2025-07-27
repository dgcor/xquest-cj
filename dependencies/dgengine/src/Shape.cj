package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class Shape <: UIObject {
    private var m_shape: VertexShape
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_visible: Bool = true

    public init(primitiveType: PrimitiveType) {
        m_shape = VertexShape(primitiveType)
    }

    // Resource

    public func isClosed(): Bool {
        m_shape.isClosed()
    }

    public func close(): Unit {
        m_shape.close()
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
        var pos = Box(position)
        var size = Box(size)
        m_anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_shape.position = pos.value
        this.size = size.value
    }

    public prop drawPosition: Vector2f {
        get() {
            m_shape.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_shape.position
        }
        set(value) {
            m_shape.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_shape.globalBounds.size
        }
        set(value) {
            let origSize = m_shape.localBounds.size
            m_shape.scaleVal = Vector2f(value.x / origSize.x, value.y / origSize.y)
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
            target.draw(m_shape)
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        getProperty(props[0], props[1])
    }

    // Shape

    public func update(): Unit {
        m_shape.update()
    }

    public func addVertex(vertex: Vertex): Unit {
        m_shape.addVertex(vertex)
    }

    public prop pointCount: UInt32 {
        get() {
            m_shape.pointCount
        }
    }
}
