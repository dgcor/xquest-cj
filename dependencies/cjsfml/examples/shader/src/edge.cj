package shader

import cjsfml.graphics.{Color, IntRect, RenderStates, RenderTarget, RenderTexture, Shader, Sprite, Texture}
import cjsfml.system.{Vector2f, Vector2u}
import std.collection.ArrayList
import std.math.{cos, sin}

// "Edge" post-effect fragment shader
class Edge <: Effect {
    private var m_surface: RenderTexture
    private var m_backgroundTexture: Texture
    private var m_entityTexture: Texture
    private var m_backgroundSprite: Sprite
    private var m_entities: ArrayList<Sprite>
    private let m_shader: Shader

    public init(surface: RenderTexture, backgroundTexture: Texture, entityTexture: Texture, shader: Shader) {
        m_surface = surface
        m_backgroundTexture = backgroundTexture
        m_entityTexture = entityTexture
        m_backgroundSprite = Sprite(backgroundTexture)
        m_backgroundSprite.position = Vector2f(135.0, 100.0)
        m_entities = ArrayList<Sprite>()
        // Load the moving entities
        for (i in 0i32..6) {
            let entity = Sprite(entityTexture, IntRect(96 * i, 0, 96, 96))
            m_entities.add(entity)
        }
        m_shader = shader
    }

    public func isClosed(): Bool {
        m_backgroundSprite.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_backgroundSprite.close()
        for (sprite in m_entities) {
            sprite.close()
        }
    }

    public static func tryLoad(): ?Effect {
        try {
            // Create the off-screen surface
            let surface = RenderTexture(Vector2u(800, 600))
            surface.smooth = true

            // Load the background texture
            let backgroundTexture = Texture("resources/sfml.png")
            backgroundTexture.smooth = true

            let entityTexture = Texture("resources/devices.png")
            entityTexture.smooth = true

            // Load the shader
            let shader = Shader()
            shader.createFromFile(fragmentShader: "resources/edge.frag")
            shader.setCurrentTextureUniform("texture")

            return Edge(surface, backgroundTexture, entityTexture, shader)
        } catch (ex: Exception) {
            eprintln(ex)
            return None
        }
    }

    public func update(time: Float32, x: Float32, y: Float32): Unit {
        m_shader.setUniform("edge_threshold", 1.0 - (x + y) / 2.0)

        // Update the position of the moving entities
        for (i in 0..m_entities.size) {
            var position = Vector2f()
            position.x = cos(0.25 * (time * Float32(i) + Float32(m_entities.size - i))) * 300.0 + 350.0
            position.y = sin(0.25 * (time * Float32(m_entities.size - i) + Float32(i))) * 200.0 + 250.0
            m_entities[i].position = position
        }

        // Render the updated scene to the off-screen surface
        m_surface.clear(Color.WHITE)
        m_surface.draw(m_backgroundSprite)
        for (entity in m_entities) {
            m_surface.draw(entity)
        }
        m_surface.display()
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        // Prepare the render state
        var states2 = states
        states2.shader = m_shader
        try (sprite = Sprite(m_surface.texture)) {
            target.draw(sprite, states2)
        }
    }
}
