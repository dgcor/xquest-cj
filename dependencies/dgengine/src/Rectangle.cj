package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public class Rectangle <: UIObject {
    private var m_shape: RectangleShape
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_visible: Bool = true

    public init() {
        m_shape = RectangleShape()
    }

    public init(size: Vector2f) {
        m_shape = RectangleShape(size)
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
        m_shape.size = size.value
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
            m_shape.size
        }
        set(value) {
            m_shape.size = value
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

    // Rectangle

    public func setTexture(texture: ?Texture, resetRect!: Bool = false): Unit {
        m_shape.setTexture(texture, resetRect: resetRect)
    }

    public mut prop textureRect: IntRect {
        get() {
            m_shape.textureRect
        }
        set(value) {
            m_shape.textureRect = value
        }
    }

    public mut prop fillColor: Color {
        get() {
            m_shape.fillColor
        }
        set(value) {
            m_shape.fillColor = value
        }
    }

    public mut prop outlineColor: Color {
        get() {
            m_shape.outlineColor
        }
        set(value) {
            m_shape.outlineColor = value
        }
    }

    public mut prop outlineThickness: Float32 {
        get() {
            m_shape.outlineThickness
        }
        set(value) {
            m_shape.outlineThickness = value
        }
    }
}
