package shader

import cjsfml.graphics.{Font, RenderStates, RenderTarget, Shader, Text}
import cjsfml.system.Vector2f

// "WaveBlur" fragment shader
class WaveBlur <: Effect {
    private let m_font: Font
    private let m_text: Text
    private let m_shader: Shader

    public init(font: Font, shader: Shader) {
        m_font = font
        const string = "Praesent suscipit augue in velit pulvinar hendrerit varius purus aliquam.\n" +
            "Mauris mi odio, bibendum quis fringilla a, laoreet vel orci. Proin vitae vulputate tortor.\n" +
            "Praesent cursus ultrices justo, ut feugiat ante vehicula quis.\n" +
            "Donec fringilla scelerisque mauris et viverra.\n" +
            "Maecenas adipiscing ornare scelerisque. Nullam at libero elit.\n" +
            "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.\n" +
            "Nullam leo urna, tincidunt id semper eget, ultricies sed mi.\n" +
            "Morbi mauris massa, commodo id dignissim vel, lobortis et elit.\n" +
            "Fusce vel libero sed neque scelerisque venenatis.\n" + "Integer mattis tincidunt quam vitae iaculis.\n" +
            "Vivamus fringilla sem non velit venenatis fermentum.\n" + "Vivamus varius tincidunt nisi id vehicula.\n" +
            "Integer ullamcorper, enim vitae euismod rutrum, massa nisl semper ipsum,\n" +
            "vestibulum sodales sem ante in massa.\n" + "Vestibulum in augue non felis convallis viverra.\n" +
            "Mauris ultricies dolor sed massa convallis sed aliquet augue fringilla.\n" +
            "Duis erat eros, porta in accumsan in, blandit quis sem.\n" +
            "In hac habitasse platea dictumst. Etiam fringilla est id odio dapibus sit amet semper dui laoreet.\n"
        m_text = Text(font, string, characterSize: 22)
        m_text.position = Vector2f(30.0, 20.0)
        m_shader = shader
    }

    public func isClosed(): Bool {
        m_text.isClosed() && m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
        m_text.close()
    }

    public static func tryLoad(font: Font): ?Effect {
        try {
            let shader = Shader()
            shader.createFromFile(vertexShader: "resources/wave.vert", fragmentShader: "resources/blur.frag")

            return WaveBlur(font, shader)
        } catch (ex: Exception) {
            eprintln(ex)
            return None
        }
    }

    public func update(time: Float32, x: Float32, y: Float32): Unit {
        m_shader.setUniform("wave_phase", time)
        m_shader.setUniform("wave_amplitude", Vector2f(x * 40.0, y * 40.0))
        m_shader.setUniform("blur_radius", (x + y) * 0.008)
    }

    public func draw(target: RenderTarget, states: RenderStates): Unit {
        var states2 = states
        states2.shader = m_shader
        target.draw(m_text, states2)
    }
}
