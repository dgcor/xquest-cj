package cjsfml.graphics

import cjsfml.system.*

foreign {
    func sfView_create(): CPointer<Unit>

    func sfView_createFromRect(rectangle: FloatRect): CPointer<Unit>

    func sfView_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfView_destroy(handle: CPointer<Unit>): Unit

    // View

    func sfView_setCenter(handle: CPointer<Unit>, center: Vector2f): Unit

    func sfView_setSize(handle: CPointer<Unit>, size: Vector2f): Unit

    func sfView_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfView_setViewport(handle: CPointer<Unit>, viewport: FloatRect): Unit

    func sfView_reset(handle: CPointer<Unit>, rectangle: FloatRect): Unit

    func sfView_getCenter(handle: CPointer<Unit>): Vector2f

    func sfView_getSize(handle: CPointer<Unit>): Vector2f

    func sfView_getRotation(handle: CPointer<Unit>): Float32

    func sfView_getViewport(handle: CPointer<Unit>): FloatRect

    func sfView_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfView_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfView_zoom(handle: CPointer<Unit>, factor: Float32): Unit
}

public class View <: ResourceHandle & Equatable<View> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    public init() {
        m_handle = unsafe { sfView_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    public init(rectangle: FloatRect) {
        m_handle = unsafe { sfView_createFromRect(rectangle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

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

    public func clone() {
        View(unsafe { sfView_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || m_isOwner == false) {
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

    public func reset(rectangle: FloatRect): Unit {
        unsafe { sfView_reset(m_handle, rectangle) }
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
