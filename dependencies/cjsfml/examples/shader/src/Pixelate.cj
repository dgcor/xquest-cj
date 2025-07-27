package shader

import cjsfml.graphics.*
import cjsfml.system.*

// "Pixelate" fragment shader
class Pixelate <: Effect {
    private var m_texture: ?Texture = None
    private let m_sprite: Sprite = Sprite()
    private let m_shader: Shader = Shader()

    public init() {
        super("Pixelate")
    }

    public func isClosed(): Bool {
        m_shader.isClosed() && m_sprite.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_sprite.close()
        if (let Some(texture) <- m_texture) {
            texture.close()
        }
    }

    protected func onLoad(): Bool {
        // Load the texture and initialize the sprite
        try {
            let texture = Texture("resources/background.jpg")
            m_texture = texture
            m_sprite.setTexture(texture)
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        // Load the shader
        try {
            m_shader.createFromFile(fragmentShader: "resources/pixelate.frag")
            m_shader.setCurrentTextureUniform("texture")
        } catch (ex: Exception) {
            println(ex)
            return false
        }

        return true
    }

    protected func onUpdate(_: Float32, x: Float32, y: Float32): Unit {
        if (!m_shader.isClosed()) {
            m_shader.setUniform("pixel_threshold", (x + y) / 30.0)
        }
    }

    protected func onDraw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states
        if (!m_shader.isClosed()) {
            states2.shader = m_shader
        }
        target.draw(m_sprite, states2)
    }
}
