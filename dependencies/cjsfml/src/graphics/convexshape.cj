package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfConvexShape_create(): CPointer<Unit>

    func sfConvexShape_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfConvexShape_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfConvexShape_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfConvexShape_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfConvexShape_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfConvexShape_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfConvexShape_getPosition(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_getRotation(handle: CPointer<Unit>): Float32

    func sfConvexShape_getScale(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfConvexShape_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfConvexShape_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfConvexShape_getTransform(handle: CPointer<Unit>): Transform

    func sfConvexShape_getInverseTransform(handle: CPointer<Unit>): Transform

    // Shape

    func sfConvexShape_setTexture(handle: CPointer<Unit>, texture: CPointer<Unit>, resetRect: Bool): Unit

    func sfConvexShape_setTextureRect(handle: CPointer<Unit>, rect: IntRect): Unit

    func sfConvexShape_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfConvexShape_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfConvexShape_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfConvexShape_getTexture(handle: CPointer<Unit>): CPointer<Unit>

    func sfConvexShape_getTextureRect(handle: CPointer<Unit>): IntRect

    func sfConvexShape_getFillColor(handle: CPointer<Unit>): Color

    func sfConvexShape_getOutlineColor(handle: CPointer<Unit>): Color

    func sfConvexShape_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfConvexShape_getPointCount(handle: CPointer<Unit>): UIntNative

    func sfConvexShape_getPoint(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfConvexShape_getGeometricCenter(handle: CPointer<Unit>): Vector2f

    func sfConvexShape_setPointCount(handle: CPointer<Unit>, count: UIntNative): Unit

    func sfConvexShape_setPoint(handle: CPointer<Unit>, index: UIntNative, point: Vector2f): Unit

    func sfConvexShape_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfConvexShape_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

public class ConvexShape <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<ConvexShape> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init() {
        this(0)
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(pointCount: UInt32) {
        m_handle = unsafe { sfConvexShape_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (pointCount > 0) {
            unsafe { sfConvexShape_setPointCount(m_handle, UIntNative(pointCount)) }
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
            unsafe { sfConvexShape_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): ConvexShape {
        ConvexShape(unsafe { sfConvexShape_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfConvexShape_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: ConvexShape): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: ConvexShape): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawConvexShape(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawConvexShape(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfConvexShape_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfConvexShape_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfConvexShape_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfConvexShape_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfConvexShape_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfConvexShape_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfConvexShape_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfConvexShape_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfConvexShape_getInverseTransform(m_handle) }
        }
    }

    // Shape

    public mut prop texture: ?Texture {
        get() {
            let texturePtr = unsafe { sfConvexShape_getTexture(m_handle) }
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
        unsafe { sfConvexShape_setTexture(m_handle, texture?.handle ?? CPointer(), resetRect) }
    }

    public mut prop textureRect: IntRect {
        get() {
            unsafe { sfConvexShape_getTextureRect(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setTextureRect(m_handle, value) }
        }
    }

    public mut prop fillColor: Color {
        get() {
            unsafe { sfConvexShape_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setFillColor(m_handle, value) }
        }
    }

    public mut prop outlineColor: Color {
        get() {
            unsafe { sfConvexShape_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOutlineColor(m_handle, value) }
        }
    }

    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfConvexShape_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfConvexShape_setOutlineThickness(m_handle, value) }
        }
    }

    public mut prop pointCount: UInt32 {
        get() {
            unsafe { UInt32(sfConvexShape_getPointCount(m_handle)) }
        }
        set(value) {
            unsafe { sfConvexShape_setPointCount(m_handle, UIntNative(value)) }
        }
    }

    public func getPoint(index: UInt32): Vector2f {
        unsafe { sfConvexShape_getPoint(m_handle, UIntNative(index)) }
    }

    public func setPoint(index: UInt32, point: Vector2f): Unit {
        unsafe { sfConvexShape_setPoint(m_handle, UIntNative(index), point) }
    }

    public prop geometricCenter: Vector2f {
        get() {
            unsafe { sfConvexShape_getGeometricCenter(m_handle) }
        }
    }

    public prop localBounds: FloatRect {
        get() {
            unsafe { sfConvexShape_getLocalBounds(m_handle) }
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfConvexShape_getGlobalBounds(m_handle) }
        }
    }
}
