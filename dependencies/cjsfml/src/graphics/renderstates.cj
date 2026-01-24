package cjsfml.graphics

@C
public struct RenderStates {
    private var m_blendMode: BlendMode
    private var m_stencilMode: StencilMode
    private var m_transform: Transform
    private var m_coordinateType: CoordinateType
    private var m_texture: CPointer<Unit>
    private var m_shader: CPointer<Unit>

    public init(blendMode!: BlendMode = BlendMode.ALPHA, stencilMode!: StencilMode = StencilMode.DEFAULT,
        transform!: Transform = Transform.IDENTITY, coordinateType!: CoordinateType = CoordinateType.Pixels,
        texture!: ?Texture = None, shader!: ?Shader = None) {
        m_blendMode = blendMode
        m_stencilMode = stencilMode
        m_transform = transform
        m_coordinateType = coordinateType
        m_texture = texture?.handle ?? CPointer()
        m_shader = shader?.handle ?? CPointer()
    }

    public mut prop blendMode: BlendMode {
        get() {
            m_blendMode
        }
        set(value) {
            m_blendMode = value
        }
    }

    public mut prop stencilMode: StencilMode {
        get() {
            m_stencilMode
        }
        set(value) {
            m_stencilMode = value
        }
    }

    public mut prop transform: Transform {
        get() {
            m_transform
        }
        set(value) {
            m_transform = value
        }
    }

    public mut prop coordinateType: CoordinateType {
        get() {
            m_coordinateType
        }
        set(value) {
            m_coordinateType = value
        }
    }

    public mut prop texture: ?Texture {
        get() {
            if (m_texture.isNull()) {
                None
            } else {
                Texture(m_texture, isOwner: false)
            }
        }
        set(value) {
            m_texture = value?.handle ?? CPointer()
        }
    }

    public mut prop shader: ?Shader {
        get() {
            if (m_shader.isNull()) {
                None
            } else {
                Shader(m_shader, isOwner: false)
            }
        }
        set(value) {
            m_shader = value?.handle ?? CPointer()
        }
    }

    public static let DEFAULT: RenderStates = RenderStates()
}
