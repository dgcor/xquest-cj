package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfSprite_create(texture: CPointer<Unit>): CPointer<Unit>

    func sfSprite_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfSprite_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfSprite_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfSprite_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfSprite_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfSprite_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfSprite_getPosition(handle: CPointer<Unit>): Vector2f

    func sfSprite_getRotation(handle: CPointer<Unit>): Float32

    func sfSprite_getScale(handle: CPointer<Unit>): Vector2f

    func sfSprite_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfSprite_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfSprite_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfSprite_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfSprite_getTransform(handle: CPointer<Unit>): Transform

    func sfSprite_getInverseTransform(handle: CPointer<Unit>): Transform

    // Sprite

    func sfSprite_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: Bool): Unit

    func sfSprite_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfSprite_setColor(handle: CPointer<Unit>, color: Color): Unit

    func sfSprite_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfSprite_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfSprite_getColor(handle: CPointer<Unit>): Color

    func sfSprite_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfSprite_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

/**
 * Drawable representation of a texture, with its own transformations, color, etc.
 *
 * `Sprite` is a drawable class that allows to easily display
 * a texture (or a part of it) on a render target.
 *
 * It inherits all the functions from `Transformable`:
 * position, rotation, scale, origin. It also adds sprite-specific
 * properties such as the texture to use, the part of it to display,
 * and some convenience functions to change the overall color of the
 * sprite, or to get its bounding rectangle.
 *
 * `Sprite` works in combination with the `Texture` class, which
 * loads and provides the pixel data of a given texture.
 *
 * The separation of `Sprite` and `Texture` allows more flexibility
 * and better performances: indeed a `Texture` is a heavy resource,
 * and any operation on it is slow (often too slow for real-time
 * applications). On the other side, a `Sprite` is a lightweight
 * object which can use the pixel data of a `Texture` and draw
 * it with its own transformation/color/blending attributes.
 *
 * It is important to note that the `Sprite` instance doesn't
 * copy the texture that it uses, it only keeps a reference to it.
 * Thus, a `Texture` must not be destroyed while it is
 * used by a `Sprite` (i.e. never write a function that
 * uses a local `Texture` instance for creating a sprite).
 *
 * Usage example:
 * ```
 * // Load a texture
 * let texture = Texture("texture.png");
 *
 * // Create a sprite
 * let sprite = Sprite(texture);
 * sprite.setTextureRect(IntRect(Vector2i(10, 10), Vector2i(50, 30)));
 * sprite.setColor(Color(255, 255, 255, 200));
 * sprite.setPosition(Vector2f(100.0, 25.0));
 *
 * // Draw it
 * window.draw(sprite);
 * ```
 *
 * @see `Texture`, `Transformable`
 */
public class Sprite <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<Sprite> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the sprite from a source texture.
     *
     * @param texture Source texture
     *
     * @throws SFMLNullHandleException
     */
    public init(texture: Texture) {
        m_handle = unsafe { sfSprite_create(texture.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the sprite from a sub-rectangle of a source texture.
     *
     * @param texture   Source texture
     * @param rect      Sub-rectangle of the texture to assign to the sprite
     *
     * @throws SFMLNullHandleException
     */
    public init(texture: Texture, rect: IntRect) {
        m_handle = unsafe { sfSprite_create(texture.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        unsafe {
            sfSprite_setTextureRect(m_handle, rect)
        }
    }

    /**
     * Construct the sprite from an existing handle.
     *
     * @param handle The handle to use.
     *
     * @throws SFMLNullHandleException
     */
    private init(handle: CPointer<Unit>) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSprite_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the sprite.
     *
     * @return A new sprite instance that is a copy of this one.
     */
    public func clone(): Sprite {
        Sprite(unsafe { sfSprite_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSprite_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: Sprite): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Sprite): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawSprite(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawSprite(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfSprite_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfSprite_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfSprite_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfSprite_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfSprite_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfSprite_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfSprite_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfSprite_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfSprite_getInverseTransform(m_handle) }
        }
    }

    // Sprite

    /**
     * Get the source texture of the sprite.
     *
     * The returned reference is const, which means that you can't
     * modify the texture when you retrieve it with this function.
     *
     * @return Reference to the sprite's texture
     */
    public mut prop texture: Texture {
        get() {
            Texture(unsafe { sfSprite_getTexture(m_handle) }, isOwner: false)
        }
        set(value) {
            setTexture(value, resetRect: false)
        }
    }

    /**
     * Change the source texture of the sprite.
     *
     * The `texture` argument refers to a texture that must
     * exist as long as the sprite uses it. Indeed, the sprite
     * doesn't store its own copy of the texture, but rather keeps
     * a pointer to the one that you passed to this function.
     * If the source texture is destroyed and the sprite tries to
     * use it, the behavior is undefined.
     * If `resetRect` is `true`, the `TextureRect` property of
     * the sprite is automatically adjusted to the size of the new
     * texture. If it is `false`, the texture rect is left unchanged.
     *
     * @param texture   New texture
     * @param resetRect Should the texture rect be reset to the size of the new texture?
     */
    public func setTexture(texture: Texture, resetRect!: Bool = false): Unit {
        unsafe { sfSprite_setTexture(m_handle, texture.handle, resetRect) }
    }

    /**
     * Set the sub-rectangle of the texture that the sprite will display.
     *
     * The texture rect is useful when you don't want to display
     * the whole texture, but rather a part of it.
     * By default, the texture rect covers the entire texture.
     *
     * @param value Rectangle defining the region of the texture to display
     */
    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfSprite_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setTextureRect(m_handle, value) }
        }
    }

    /**
     * Set the global color of the sprite.
     *
     * This color is modulated (multiplied) with the sprite's
     * texture. It can be used to colorize the sprite, or change
     * its global opacity.
     * By default, the sprite's color is opaque white.
     *
     * @param value New color of the sprite
     */
    public mut prop color: Color {
        get() {
            unsafe { sfSprite_getColor(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setColor(m_handle, value) }
        }
    }

    /**
     * Get the local bounding rectangle of the entity.
     *
     * The returned rectangle is in local coordinates, which means
     * that it ignores the transformations (translation, rotation,
     * scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * entity in the entity's coordinate system.
     *
     * @return Local bounding rectangle of the entity
     */
    public prop localBounds: FloatRect {
        get() {
            unsafe { sfSprite_getLocalBounds(m_handle) }
        }
    }

    /**
     * Get the global bounding rectangle of the entity.
     *
     * The returned rectangle is in global coordinates, which means
     * that it takes into account the transformations (translation,
     * rotation, scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * sprite in the global 2D world's coordinate system.
     *
     * @return Global bounding rectangle of the entity
     */
    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfSprite_getGlobalBounds(m_handle) }
        }
    }
}
