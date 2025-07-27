package shader

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*
import std.math.*
import std.random.*

// "Edge" post-effect fragment shader
class Edge <: Effect {
    private var m_surface: ?RenderTexture = None
    private var m_backgroundTexture: ?Texture = None
    private var m_entityTexture: ?Texture = None
    private var m_backgroundSprite: Sprite = Sprite()
    private var m_entities: ArrayList<Sprite> = ArrayList<Sprite>()
    private let m_shader: Shader = Shader()

    public init() {
        super("Edge Post-effect")
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

    protected func onLoad(): Bool {
        try {
            // Create the off-screen surface
            let surface = RenderTexture(800, 600)
            surface.smooth = true
            m_surface = surface

            // Load the textures

            let backgroundTexture = Texture("resources/sfml.png")
            backgroundTexture.smooth = true
            m_backgroundTexture = backgroundTexture

            let entityTexture = Texture("resources/devices.png")
            entityTexture.smooth = true
            m_entityTexture = entityTexture

            // Initialize the background sprite
            m_backgroundSprite.texture = backgroundTexture
            m_backgroundSprite.position = Vector2f(135.0, 100.0)

            // Load the moving entities
            for (i in 0i32..6) {
                let entity = Sprite(entityTexture, IntRect(96 * i, 0, 96, 96))
                m_entities.add(entity)
            }

            // Load the shader
            m_shader.createFromFile(fragmentShader: "resources/edge.frag")
            m_shader.setCurrentTextureUniform("texture")
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        return true
    }

    protected func onUpdate(time: Float32, x: Float32, y: Float32): Unit {
        if (!m_shader.isClosed()) {
            m_shader.setUniform("edge_threshold", 1.0 - (x + y) / 2.0)

            // Update the position of the moving entities
            for (i in 0..m_entities.size) {
                var position = Vector2f()
                position.x = cos(0.25 * (time * Float32(i) + Float32(m_entities.size - i))) * 300.0 + 350.0
                position.y = sin(0.25 * (time * Float32(m_entities.size - i) + Float32(i))) * 200.0 + 250.0
                m_entities[i].position = position
            }

            // Render the updated scene to the off-screen surface
            if (let Some(surface) <- m_surface) {
                surface.clear(Color.white)
                surface.draw(m_backgroundSprite)
                for (entity in m_entities) {
                    surface.draw(entity)
                }
                surface.display()
            }
        }
    }

    protected func onDraw(target: RenderTarget, states: RenderStates): Unit {
        // Prepare the render state
        var states2 = states
        if (!m_shader.isClosed()) {
            states2.shader = m_shader
        }
        if (let Some(surface) <- m_surface) {
            try (sprite = Sprite(surface.texture)) {
                target.draw(sprite, states2)
            }
        }
    }
}
