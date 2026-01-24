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

public class Sprite <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<Sprite> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init(texture: Texture) {
        m_handle = unsafe { sfSprite_create(texture.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
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

    public operator override func ==(right: Sprite): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Sprite): Bool {
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

    public mut prop texture: Texture {
        get() {
            Texture(unsafe { sfSprite_getTexture(m_handle) }, isOwner: false)
        }
        set(value) {
            setTexture(value, resetRect: false)
        }
    }

    public func setTexture(texture: Texture, resetRect!: Bool = false): Unit {
        unsafe { sfSprite_setTexture(m_handle, texture.handle, resetRect) }
    }

    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfSprite_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setTextureRect(m_handle, value) }
        }
    }

    public mut prop color: Color {
        get() {
            unsafe { sfSprite_getColor(m_handle) }
        }
        set(value) {
            unsafe { sfSprite_setColor(m_handle, value) }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            unsafe { sfSprite_getLocalBounds(m_handle) }
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfSprite_getGlobalBounds(m_handle) }
        }
    }
}
