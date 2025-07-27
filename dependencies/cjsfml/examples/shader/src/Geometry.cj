package shader

import cjsfml.graphics.*
import cjsfml.system.*
import std.math.*
import std.random.*

// "Geometry" geometry shader example
class Geometry <: Effect {
    private var m_logoTexture: ?Texture = None
    private var m_transform: Transform = Transform()
    private var m_pointCloud: VertexArray
    private let m_shader: Shader = Shader()
    private let m_rand: Random = Random()

    public init() {
        super("Geometry Shader Billboards")
        m_pointCloud = VertexArray(PrimitiveType.Points, 10000)
    }

    public func isClosed(): Bool {
        m_pointCloud.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_pointCloud.close()
    }

    protected func onLoad(): Bool {
        // Check if geometry shaders are supported
        if (!Shader.isGeometryAvailable) {
            return false
        }

        // Move the points in the point cloud to random positions
        for (i in 0..10000) {
            // Spread the coordinates from -480 to +480
            // So they'll always fill the viewport at 800x600
            var vertex = m_pointCloud[i]
            vertex.position.x = Float32(m_rand.nextInt16(960)) - 480.0
            vertex.position.y = Float32(m_rand.nextInt16(960)) - 480.0
            m_pointCloud[i] = vertex
        }

        // Load the texture
        try {
            let texture = Texture("resources/logo.png")
            m_logoTexture = texture
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        // Load the shader
        try {
            m_shader.createFromFile(vertexShader: "resources/billboard.vert", geometryShader: "resources/billboard.geom",
                fragmentShader: "resources/billboard.frag")
            m_shader.setCurrentTextureUniform("texture")

            // Set the render resolution (used for proper scaling)
            m_shader.setUniform("resolution", Vector2f(800.0, 600.0))
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        return true
    }

    protected func onUpdate(_: Float32, x: Float32, y: Float32): Unit {
        if (!m_shader.isClosed()) {
            // Reset our transformation matrix
            m_transform = Transform.identity
            // Move to the center of the window
            m_transform = m_transform.translate(400.0, 300.0)
            // Rotate everything based on cursor position
            m_transform = m_transform.rotate(x * 360.0)

            // Adjust billboard size to scale between 25 and 75
            let size = 25.0 + abs(y) * 50.0

            // Update the shader parameter
            m_shader.setUniform("size", Vector2f(size, size))
        }
    }

    protected func onDraw(target: RenderTarget, states: RenderStates): Unit {
        // Prepare the render state
        var states2 = states
        if (!m_shader.isClosed()) {
            states2.shader = m_shader
        }
        if (let Some(texture) <- m_logoTexture) {
            states2.texture = texture
        }
        states2.transform = m_transform

        // Draw the point cloud
        target.draw(m_pointCloud, states2)
    }
}
