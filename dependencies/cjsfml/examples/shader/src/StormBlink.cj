package shader

import cjsfml.graphics.*
import cjsfml.system.*
import std.math.*
import std.random.*

// "StormBlink" fragment shader
class StormBlink <: Effect {
    private let m_points: VertexArray = VertexArray()
    private let m_shader: Shader = Shader()
    private let m_rand: Random = Random()

    public init() {
        super("Storm + Blink")
    }

    public func isClosed(): Bool {
        m_points.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_points.close()
    }

    protected func onLoad(): Bool {
        // Create the points
        m_points.primitiveType = PrimitiveType.Points
        for (_ in 0..40000) {
            let x = Float32(m_rand.nextInt16(800))
            let y = Float32(m_rand.nextInt16(600))
            let r = m_rand.nextUInt8()
            let g = m_rand.nextUInt8()
            let b = m_rand.nextUInt8()
            m_points.append(Vertex(position: Vector2f(x, y), color: Color(r, g, b)))
        }

        // Load the shader
        try {
            m_shader.createFromFile(vertexShader: "resources/storm.vert", fragmentShader: "resources/blink.frag")
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        return true
    }

    protected func onUpdate(time: Float32, x: Float32, y: Float32): Unit {
        if (!m_shader.isClosed()) {
            let radius = 200.0 + cos(time) * 150.0
            m_shader.setUniform("storm_position", Vector2f(x * 800.0, y * 600.0))
            m_shader.setUniform("storm_inner_radius", radius / 3.0)
            m_shader.setUniform("storm_total_radius", radius)
            m_shader.setUniform("blink_alpha", 0.5 + cos(time * 3.0) * 0.25)
        }
    }

    protected func onDraw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states
        if (!m_shader.isClosed()) {
            states2.shader = m_shader
        }
        target.draw(m_points, states2)
    }
}
