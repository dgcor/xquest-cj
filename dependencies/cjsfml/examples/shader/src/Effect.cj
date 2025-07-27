package shader

import cjsfml.graphics.*
import cjsfml.system.*

// Base class for effects
abstract class Effect <: Drawable & Resource {
    private let m_name: String
    private var m_isLoaded: Bool = false
    protected static var s_font: ?Font = None

    public init(name: String) {
        m_name = name
    }

    public prop name: String {
        get() {
            m_name
        }
    }

    public static func setFont(font: Font): Unit {
        s_font = font
    }

    public func load(): Unit {
        m_isLoaded = Shader.isAvailable && onLoad()
    }

    public func update(time: Float32, x: Float32, y: Float32): Unit {
        if (m_isLoaded) {
            onUpdate(time, x, y)
        }
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        if (m_isLoaded) {
            onDraw(target, states)
        } else if (let Some(font) <- s_font) {
            try (error = Text("Shader not\nsupported", font)) {
                error.position = Vector2f(320.0, 200.0)
                error.characterSize = 36
                target.draw(error, states)
            }
        }
    }

    protected func onLoad(): Bool
    protected func onUpdate(time: Float32, x: Float32, y: Float32): Unit
    protected func onDraw(target: RenderTarget, states: RenderStates): Unit
}
