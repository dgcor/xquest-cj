package cjsfml.graphics

import cjsfml.system.*

foreign {
    func sfCircleShape_create(): CPointer<Unit>

    func sfCircleShape_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfCircleShape_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfCircleShape_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfCircleShape_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfCircleShape_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfCircleShape_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfCircleShape_getPosition(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_getRotation(handle: CPointer<Unit>): Float32

    func sfCircleShape_getScale(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfCircleShape_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfCircleShape_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfCircleShape_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfCircleShape_getTransform(handle: CPointer<Unit>): Transform

    func sfCircleShape_getInverseTransform(handle: CPointer<Unit>): Transform

    // Shape

    func sfCircleShape_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: SfBool): Unit

    func sfCircleShape_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfCircleShape_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfCircleShape_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfCircleShape_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfCircleShape_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfCircleShape_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfCircleShape_getFillColor(handle: CPointer<Unit>): Color

    func sfCircleShape_getOutlineColor(handle: CPointer<Unit>): Color

    func sfCircleShape_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfCircleShape_getPointCount(handle: CPointer<Unit>): UIntNative

    func sfCircleShape_getPoint(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfCircleShape_setRadius(handle: CPointer<Unit>, radius: Float32): Unit

    func sfCircleShape_getRadius(handle: CPointer<Unit>): Float32

    func sfCircleShape_setPointCount(handle: CPointer<Unit>, count: UIntNative): Unit

    func sfCircleShape_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfCircleShape_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

public class CircleShape <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<CircleShape> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init() {
        this(0.0)
    }

    public init(radius: Float32, pointCount!: UInt32 = 30) {
        m_handle = unsafe { sfCircleShape_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (radius > 0.0) {
            unsafe { sfCircleShape_setRadius(m_handle, radius) }
        }
        if (pointCount > 0 && pointCount != 30) {
            unsafe { sfCircleShape_setPointCount(m_handle, UIntNative(pointCount)) }
        }
    }

    private init(handle: CPointer<Unit>) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfCircleShape_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone() {
        CircleShape(unsafe { sfCircleShape_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfCircleShape_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: CircleShape): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: CircleShape): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        var states2 = states
        unsafe { sfRenderTexture_drawCircleShape(window.handle, m_handle, inout states2) }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        var states2 = states
        unsafe { sfRenderWindow_drawCircleShape(window.handle, m_handle, inout states2) }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfCircleShape_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfCircleShape_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfCircleShape_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfCircleShape_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfCircleShape_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfCircleShape_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfCircleShape_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfCircleShape_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfCircleShape_getInverseTransform(m_handle) }
        }
    }

    // Shape

    public mut prop texture: ?Texture {
        get() {
            let texturePtr = unsafe { sfCircleShape_getTexture(m_handle) }
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
        unsafe { sfCircleShape_setTexture(m_handle, texture?.handle ?? CPointer(), SfBool.fromBool(resetRect)) }
    }

    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfCircleShape_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setTextureRect(m_handle, value) }
        }
    }

    public mut prop fillColor: Color {
        get() {
            unsafe { sfCircleShape_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setFillColor(m_handle, value) }
        }
    }

    public mut prop outlineColor: Color {
        get() {
            unsafe { sfCircleShape_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOutlineColor(m_handle, value) }
        }
    }

    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfCircleShape_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setOutlineThickness(m_handle, value) }
        }
    }

    public mut prop pointCount: UInt32 {
        get() {
            unsafe { UInt32(sfCircleShape_getPointCount(m_handle)) }
        }
        set(value) {
            unsafe { sfCircleShape_setPointCount(m_handle, UIntNative(value)) }
        }
    }

    public func getPoint(index: UInt32): Vector2f {
        unsafe { sfCircleShape_getPoint(m_handle, UIntNative(index)) }
    }

    public mut prop radius: Float32 {
        get() {
            unsafe { sfCircleShape_getRadius(m_handle) }
        }
        set(value) {
            unsafe { sfCircleShape_setRadius(m_handle, value) }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            unsafe { sfCircleShape_getLocalBounds(m_handle) }
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfCircleShape_getGlobalBounds(m_handle) }
        }
    }
}
