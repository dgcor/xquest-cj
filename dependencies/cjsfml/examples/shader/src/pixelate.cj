package shader

import cjsfml.graphics.{RenderStates, RenderTarget, Shader, Sprite, Texture}

// "Pixelate" fragment shader
class Pixelate <: Effect {
    private var m_texture: Texture
    private let m_sprite: Sprite
    private let m_shader: Shader

    public init(texture: Texture, shader: Shader) {
        m_texture = texture
        m_sprite = Sprite(texture)
        m_shader = shader
        m_shader.setCurrentTextureUniform("texture")
    }

    public func isClosed(): Bool {
        m_shader.isClosed() && m_sprite.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_sprite.close()
        m_texture.close()
    }

    public static func tryLoad(): ?Effect {
        try {
            let texture = Texture("resources/background.jpg")
            texture.smooth = true

            let shader = Shader()
            shader.createFromFile(fragmentShader: "resources/pixelate.frag")
            shader.setCurrentTextureUniform("texture")

            return Pixelate(texture, shader)
        } catch (ex: Exception) {
            eprintln(ex)
            return None
        }
    }

    public func update(_: Float32, x: Float32, y: Float32): Unit {
        m_shader.setUniform("pixel_threshold", (x + y) / 30.0)
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states // cjlint-ignore !G.VAR.02 minimize scope
        if (!m_shader.isClosed()) {
            states2.shader = m_shader
        }
        target.draw(m_sprite, states2)
    }
}
