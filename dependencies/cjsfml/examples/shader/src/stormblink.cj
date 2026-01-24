package shader

import cjsfml.graphics.{Color, PrimitiveType, RenderStates, RenderTarget, Shader, Vertex, VertexArray}
import cjsfml.system.Vector2f
import std.math.cos
import std.random.Random

// "StormBlink" fragment shader
class StormBlink <: Effect {
    private let m_points: VertexArray
    private let m_shader: Shader

    public init(shader: Shader) {
        m_points = VertexArray()
        m_shader = shader
        let rand = Random() // cjlint-ignore !G.VAR.02 minimize scope

        // Create the points
        m_points.primitiveType = PrimitiveType.Points
        for (_ in 0..40000) {
            let x = Float32(rand.nextInt16(800))
            let y = Float32(rand.nextInt16(600))
            let r = rand.nextUInt8()
            let g = rand.nextUInt8()
            let b = rand.nextUInt8()
            m_points.append(Vertex(position: Vector2f(x, y), color: Color(r, g, b)))
        }
    }

    public func isClosed(): Bool {
        m_points.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_points.close()
    }

    public static func tryLoad(): ?Effect {
        try {
            let shader = Shader()
            shader.createFromFile(vertexShader: "resources/storm.vert", fragmentShader: "resources/blink.frag")

            return StormBlink(shader)
        } catch (ex: Exception) {
            eprintln(ex)
            return None
        }
    }

    public func update(time: Float32, x: Float32, y: Float32): Unit {
        let radius = 200.0 + cos(time) * 150.0
        m_shader.setUniform("storm_position", Vector2f(x * 800.0, y * 600.0))
        m_shader.setUniform("storm_inner_radius", radius / 3.0)
        m_shader.setUniform("storm_total_radius", radius)
        m_shader.setUniform("blink_alpha", 0.5 + cos(time * 3.0) * 0.25)
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states
        states2.shader = m_shader
        target.draw(m_points, states2)
    }
}
