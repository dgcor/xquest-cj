package shader

import cjsfml.graphics.{PrimitiveType, RenderStates, RenderTarget, Shader, Texture, Transform, VertexArray}
import cjsfml.system.Vector2f
import std.math.abs
import std.random.Random

// "Geometry" geometry shader example
class Geometry <: Effect {
    private let m_logoTexture: Texture
    private var m_transform: Transform
    private let m_shader: Shader
    private let m_pointCloud: VertexArray

    public init(logoTexture: Texture, shader: Shader) {
        m_logoTexture = logoTexture
        m_transform = Transform()
        m_shader = shader
        m_pointCloud = VertexArray(PrimitiveType.Points, 10000)
        let rand = Random()

        // Move the points in the point cloud to random positions
        for (i in 0..10000) {
            // Spread the coordinates from -480 to +480
            // So they'll always fill the viewport at 800x600
            var vertex = m_pointCloud[i]
            vertex.position.x = Float32(rand.nextInt16(960)) - 480.0
            vertex.position.y = Float32(rand.nextInt16(960)) - 480.0
            m_pointCloud[i] = vertex
        }
    }

    public func isClosed(): Bool {
        m_pointCloud.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_pointCloud.close()
    }

    public static func tryLoad(): ?Effect {
        // Check if geometry shaders are supported
        if (!Shader.isGeometryAvailable) {
            return None
        }

        try {
            // Load the logo texture
            let logoTexture = Texture("resources/logo.png")
            logoTexture.smooth = true

            // Load the shader
            let shader = Shader()
            shader.createFromFile(
                vertexShader: "resources/billboard.vert",
                geometryShader: "resources/billboard.geom",
                fragmentShader: "resources/billboard.frag"
            )
            shader.setCurrentTextureUniform("texture")

            // Set the render resolution (used for proper scaling)
            shader.setUniform("resolution", Vector2f(800.0, 600.0))

            return Geometry(logoTexture, shader)
        } catch (ex: Exception) {
            eprintln(ex)
            return None
        }
    }

    public func update(_: Float32, x: Float32, y: Float32): Unit {
        // Reset our transformation matrix
        m_transform = Transform.IDENTITY
        // Move to the center of the window
        m_transform = m_transform.translate(Vector2f(400.0, 300.0))
        // Rotate everything based on cursor position
        m_transform = m_transform.rotate(x * 360.0)

        // Adjust billboard size to scale between 25 and 75
        let size = 25.0 + abs(y) * 50.0

        // Update the shader parameter
        m_shader.setUniform("size", Vector2f(size, size))
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        // Prepare the render state
        var states2 = states
        states2.shader = m_shader
        states2.texture = m_logoTexture
        states2.transform = m_transform

        // Draw the point cloud
        target.draw(m_pointCloud, states2)
    }
}
