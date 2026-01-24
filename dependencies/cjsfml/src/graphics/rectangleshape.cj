package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfRectangleShape_create(): CPointer<Unit>

    func sfRectangleShape_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfRectangleShape_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfRectangleShape_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfRectangleShape_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfRectangleShape_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfRectangleShape_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfRectangleShape_getPosition(handle: CPointer<Unit>): Vector2f

    func sfRectangleShape_getRotation(handle: CPointer<Unit>): Float32

    func sfRectangleShape_getScale(handle: CPointer<Unit>): Vector2f

    func sfRectangleShape_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfRectangleShape_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfRectangleShape_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfRectangleShape_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfRectangleShape_getTransform(handle: CPointer<Unit>): Transform

    func sfRectangleShape_getInverseTransform(handle: CPointer<Unit>): Transform

    // Shape

    func sfRectangleShape_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: Bool): Unit

    func sfRectangleShape_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfRectangleShape_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfRectangleShape_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfRectangleShape_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfRectangleShape_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfRectangleShape_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfRectangleShape_getFillColor(handle: CPointer<Unit>): Color

    func sfRectangleShape_getOutlineColor(handle: CPointer<Unit>): Color

    func sfRectangleShape_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfRectangleShape_getPointCount(handle: CPointer<Unit>): UIntNative

    func sfRectangleShape_getPoint(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfRectangleShape_getGeometricCenter(handle: CPointer<Unit>): Vector2f

    func sfRectangleShape_setSize(handle: CPointer<Unit>, size: Vector2f): Unit

    func sfRectangleShape_getSize(handle: CPointer<Unit>): Vector2f

    func sfRectangleShape_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfRectangleShape_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

public class RectangleShape <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<RectangleShape> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init() {
        this(Vector2f())
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(size: Vector2f) {
        m_handle = unsafe { sfRectangleShape_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (size.x != 0.0 && size.y != 0.0) {
            unsafe { sfRectangleShape_setSize(m_handle, size) }
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
            unsafe { sfRectangleShape_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): RectangleShape {
        RectangleShape(unsafe { sfRectangleShape_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfRectangleShape_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: RectangleShape): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: RectangleShape): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawRectangleShape(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawRectangleShape(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfRectangleShape_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfRectangleShape_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfRectangleShape_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfRectangleShape_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfRectangleShape_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfRectangleShape_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfRectangleShape_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfRectangleShape_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfRectangleShape_getInverseTransform(m_handle) }
        }
    }

    // Shape

    public mut prop texture: ?Texture {
        get() {
            let texturePtr = unsafe { sfRectangleShape_getTexture(m_handle) }
            if (texturePtr.isNull()) {
                return None
            }
            Texture(texturePtr, isOwner: false)
        }
        set(value) {
            setTexture(value)
        }
    }

    public func setTexture(texture: ?Texture, resetRect!: Bool = false): Unit {
        unsafe { sfRectangleShape_setTexture(m_handle, texture?.handle ?? CPointer(), resetRect) }
    }

    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfRectangleShape_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setTextureRect(m_handle, value) }
        }
    }

    public mut prop fillColor: Color {
        get() {
            unsafe { sfRectangleShape_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setFillColor(m_handle, value) }
        }
    }

    public mut prop outlineColor: Color {
        get() {
            unsafe { sfRectangleShape_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setOutlineColor(m_handle, value) }
        }
    }

    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfRectangleShape_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setOutlineThickness(m_handle, value) }
        }
    }

    public mut prop pointCount: UInt32 {
        get() {
            unsafe { UInt32(sfRectangleShape_getPointCount(m_handle)) }
        }
        set(_) {}
    }

    public func getPoint(index: UInt32): Vector2f {
        unsafe { sfRectangleShape_getPoint(m_handle, UIntNative(index)) }
    }

    public prop geometricCenter: Vector2f {
        get() {
            unsafe { sfRectangleShape_getGeometricCenter(m_handle) }
        }
    }

    public mut prop size: Vector2f {
        get() {
            unsafe { sfRectangleShape_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfRectangleShape_setSize(m_handle, value) }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            unsafe { sfRectangleShape_getLocalBounds(m_handle) }
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfRectangleShape_getGlobalBounds(m_handle) }
        }
    }
}
