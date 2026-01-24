package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException, Vector2f}

public interface Transformable {
    mut prop position: Vector2f
    mut prop rotation: Float32
    mut prop scaleVal: Vector2f
    mut prop origin: Vector2f

    func move(offset: Vector2f): Unit
    func rotate(angle: Float32): Unit
    func scale(factor: Vector2f): Unit

    prop transform: Transform
    prop inverseTransform: Transform
}

foreign {
    func sfTransformable_create(): CPointer<Unit>

    func sfTransformable_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfTransformable_destroy(handle: CPointer<Unit>): Unit

    func sfTransformable_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfTransformable_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfTransformable_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfTransformable_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfTransformable_getPosition(handle: CPointer<Unit>): Vector2f

    func sfTransformable_getRotation(handle: CPointer<Unit>): Float32

    func sfTransformable_getScale(handle: CPointer<Unit>): Vector2f

    func sfTransformable_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfTransformable_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfTransformable_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfTransformable_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfTransformable_getTransform(handle: CPointer<Unit>): Transform

    func sfTransformable_getInverseTransform(handle: CPointer<Unit>): Transform
}

public class TransformableImpl <: ResourceHandle & Transformable & Equatable<TransformableImpl> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfTransformable_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
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
            unsafe { sfTransformable_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): TransformableImpl {
        TransformableImpl(unsafe { sfTransformable_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfTransformable_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: TransformableImpl): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: TransformableImpl): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfTransformable_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfTransformable_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfTransformable_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfTransformable_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfTransformable_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfTransformable_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfTransformable_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfTransformable_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfTransformable_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfTransformable_getInverseTransform(m_handle) }
        }
    }
}
