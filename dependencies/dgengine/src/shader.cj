package dgengine

import cjsfml.graphics.*

public class GameShader <: Resource {
    private GameShader(
        private let m_shader: Shader,
        private let m_uniforms: Array<String>
    ) {}

    public static func create(vertexShader!: ?String = None, geometryShader!: ?String = None,
        fragmentShader!: ?String = None, uniforms!: Array<String> = []): ?GameShader {
        if (Shader.isAvailable == false) {
            return None
        }
        let shader = Shader()
        try {
            shader.createFromMemory(
                vertexShader: vertexShader,
                geometryShader: geometryShader,
                fragmentShader: fragmentShader
            )
            return GameShader(shader, uniforms)
        } catch (_: Exception) {
            shader.close()
            return None
        }
    }

    // Resource

    public func isClosed(): Bool {
        m_shader.isClosed()
    }

    public func close(): Unit {
        m_shader.close()
    }

    // GameShader

    public prop shader: Shader {
        get() {
            m_shader
        }
    }

    public prop uniforms: Array<String> {
        get() {
            m_uniforms
        }
    }
}

public class GameShaders <: Resource {
    public var game: ?GameShader = None
    public var level: ?GameShader = None
    public var sprite: ?GameShader = None

    // Resource

    public func isClosed(): Bool {
        game?.isClosed() ?? level?.isClosed() ?? sprite?.isClosed() ?? false
    }

    public func close(): Unit {
        game?.close()
        level?.close()
        sprite?.close()
    }

    public func set(id: String, shader: ?GameShader): Unit {
        match (id) {
            case "game" => game = shader
            case "level" => level = shader
            case "sprite" => sprite = shader
            case _ => ()
        }
    }
}
