package cjsfml.graphics

/**
 * Define the states used for drawing to a `RenderTarget`.
 *
 * There are six global states that can be applied to
 * the drawn objects:
 * - the blend mode: how pixels of the object are blended with the background
 * - the stencil mode: how pixels of the object interact with the stencil buffer
 * - the transform: how the object is positioned/rotated/scaled
 * - the texture coordinate type: how texture coordinates are interpreted
 * - the texture: what image is mapped to the object
 * - the shader: what custom effect is applied to the object
 *
 * High-level objects such as sprites or text force some of
 * these states when they are drawn. For example, a sprite
 * will set its own texture, so that you don't have to care
 * about it when drawing the sprite.
 *
 * The transform is a special case: sprites, texts and shapes
 * (and it's a good idea to do it with your own drawable classes
 * too) combine their transform with the one that is passed in the
 * RenderStates structure. So that you can use a "global" transform
 * on top of each object's transform.
 *
 * Most objects, especially high-level drawables, can be drawn
 * directly without defining render states explicitly -- the
 * default set of states is ok in most cases.
 * ```
 * window.draw(sprite);
 * ```
 *
 * If you want to use a single specific render state,
 * for example a shader, you can pass it directly to the Draw
 * function: `RenderStates` has an implicit one-argument
 * constructor for each state.
 * ```
 * window.draw(sprite, RenderStates(shader: shader));
 * ```
 *
 * When you're inside the Draw function of a drawable
 * object (inherited from `Drawable`), you can
 * either pass the render states unmodified, or change
 * some of them.
 * For example, a transformable object will combine the
 * current transform with its own transform. A sprite will
 * set its texture. Etc.
 *
 * @see `RenderTarget`, `Drawable`
 */
@C
public struct RenderStates {
    private var m_blendMode: BlendMode
    private var m_stencilMode: StencilMode
    private var m_transform: Transform
    private var m_coordinateType: CoordinateType
    private var m_texture: CPointer<Unit>
    private var m_shader: CPointer<Unit>

    /**
     * Default constructor.
     *
     * Constructing a default set of render states is equivalent
     * to using `RenderStates.DEFAULT`.
     * The default set defines:
     * - the `BlendMode.ALPHA` blend mode
     * - the default `StencilMode` (no stencil)
     * - the identity transform
     * - a `nullptr` texture
     * - a `nullptr` shader
     *
     * @param blendMode      Blend mode to use
     * @param stencilMode    Stencil mode to use
     * @param transform      Transform to use
     * @param coordinateType Texture coordinate type to use
     * @param texture        Texture to use
     * @param shader         Shader to use
     */
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

    /**
     * Blending mode.
     */
    public mut prop blendMode: BlendMode {
        get() {
            m_blendMode
        }
        set(value) {
            m_blendMode = value
        }
    }

    /**
     * Stencil mode.
     */
    public mut prop stencilMode: StencilMode {
        get() {
            m_stencilMode
        }
        set(value) {
            m_stencilMode = value
        }
    }

    /**
     * Transform.
     */
    public mut prop transform: Transform {
        get() {
            m_transform
        }
        set(value) {
            m_transform = value
        }
    }

    /**
     * Texture coordinate type.
     */
    public mut prop coordinateType: CoordinateType {
        get() {
            m_coordinateType
        }
        set(value) {
            m_coordinateType = value
        }
    }

    /**
     * Texture.
     */
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

    /**
     * Shader.
     */
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

    /**
     * Special instance holding the default render states.
     */
    public static let DEFAULT: RenderStates = RenderStates()
}
