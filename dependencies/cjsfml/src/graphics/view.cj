package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

foreign {
    func sfView_create(): CPointer<Unit>

    func sfView_createFromRect(rectangle: FloatRect): CPointer<Unit>

    func sfView_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfView_destroy(handle: CPointer<Unit>): Unit

    // View

    @FastNative
    func sfView_setCenter(handle: CPointer<Unit>, center: Vector2f): Unit

    @FastNative
    func sfView_setSize(handle: CPointer<Unit>, size: Vector2f): Unit

    @FastNative
    func sfView_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    @FastNative
    func sfView_setViewport(handle: CPointer<Unit>, viewport: FloatRect): Unit

    @FastNative
    func sfView_setScissor(handle: CPointer<Unit>, scissor: FloatRect): Unit

    @FastNative
    func sfView_getCenter(handle: CPointer<Unit>): Vector2f

    @FastNative
    func sfView_getSize(handle: CPointer<Unit>): Vector2f

    @FastNative
    func sfView_getRotation(handle: CPointer<Unit>): Float32

    @FastNative
    func sfView_getViewport(handle: CPointer<Unit>): FloatRect

    @FastNative
    func sfView_getScissor(handle: CPointer<Unit>): FloatRect

    @FastNative
    func sfView_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    @FastNative
    func sfView_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    @FastNative
    func sfView_zoom(handle: CPointer<Unit>, factor: Float32): Unit
}

public class View <: ResourceHandle & Equatable<View> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfView_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(rectangle: FloatRect) {
        m_handle = unsafe { sfView_createFromRect(rectangle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfView_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): View {
        View(unsafe { sfView_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfView_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    public operator override func ==(right: View): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: View): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // View

    public mut prop center: Vector2f {
        get() {
            unsafe { sfView_getCenter(m_handle) }
        }
        set(value) {
            unsafe { sfView_setCenter(m_handle, value) }
        }
    }

    public mut prop size: Vector2f {
        get() {
            unsafe { sfView_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfView_setSize(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfView_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfView_setRotation(m_handle, value) }
        }
    }

    public mut prop viewport: FloatRect {
        get() {
            unsafe { sfView_getViewport(m_handle) }
        }
        set(value) {
            unsafe { sfView_setViewport(m_handle, value) }
        }
    }

    public mut prop scissor: FloatRect {
        get() {
            unsafe { sfView_getScissor(m_handle) }
        }
        set(value) {
            unsafe { sfView_setScissor(m_handle, value) }
        }
    }

    public func reset(rectangle: FloatRect): Unit {
        let center = Vector2f(
            rectangle.position.x + rectangle.size.x / 2.0,
            rectangle.position.y + rectangle.size.y / 2.0
        )
        let size = rectangle.size
        let defaultRect = FloatRect(0.0, 0.0, 1.0, 1.0)

        unsafe {
            sfView_setCenter(m_handle, center)
            sfView_setSize(m_handle, size)
            sfView_setRotation(m_handle, 0.0)
            sfView_setViewport(m_handle, defaultRect)
            sfView_setScissor(m_handle, defaultRect)
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfView_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfView_rotate(m_handle, angle) }
    }

    public func zoom(factor: Float32): Unit {
        unsafe { sfView_zoom(m_handle, factor) }
    }
}
