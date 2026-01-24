package cjsfml.graphics

import cenum.CEnum
import cjsfml.system.{ResourceHandle, SFMLNullHandleException}

foreign {
    func sfVertexBuffer_create(vertexCount: UIntNative, primitiveType: PrimitiveType, usage: VertexBufferUsage): CPointer<Unit>

    func sfVertexBuffer_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfVertexBuffer_destroy(handle: CPointer<Unit>): Unit

    // VertexBuffer

    func sfVertexBuffer_getVertexCount(handle: CPointer<Unit>): UInt32

    func sfVertexBuffer_update(handle: CPointer<Unit>, vertices: CPointer<Vertex>, vertexCount: UInt32, offset: UInt32): Bool

    func sfVertexBuffer_updateFromVertexBuffer(handle: CPointer<Unit>, other: CPointer<Unit>): Bool

    func sfVertexBuffer_swap(left: CPointer<Unit>, right: CPointer<Unit>): Unit

    func sfVertexBuffer_getNativeHandle(handle: CPointer<Unit>): UInt32

    func sfVertexBuffer_setPrimitiveType(handle: CPointer<Unit>, primitiveType: PrimitiveType): Unit

    func sfVertexBuffer_getPrimitiveType(handle: CPointer<Unit>): PrimitiveType

    func sfVertexBuffer_setUsage(handle: CPointer<Unit>, usage: VertexBufferUsage): Unit

    func sfVertexBuffer_getUsage(handle: CPointer<Unit>): VertexBufferUsage

    func sfVertexBuffer_bind(handle: CPointer<Unit>): Unit

    func sfVertexBuffer_isAvailable(): Bool
}

@CEnum[public VertexBufferUsage](
    Stream
    Dynamic
    Static
)

public class VertexBuffer <: ResourceHandle & RenderTargetDrawable & Equatable<VertexBuffer> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init(vertexCount!: UIntNative = 0, primitiveType!: PrimitiveType = PrimitiveType.Points,
        usage!: VertexBufferUsage = VertexBufferUsage.Stream) {
        m_handle = unsafe { sfVertexBuffer_create(vertexCount, primitiveType, usage) }
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
            unsafe { sfVertexBuffer_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): VertexBuffer {
        VertexBuffer(unsafe { sfVertexBuffer_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfVertexBuffer_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: VertexBuffer): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: VertexBuffer): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexBuffer(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexBuffer(window.handle, m_handle, inout states2)
        }
    }

    // VertexBuffer

    public prop vertexCount: UInt32 {
        get() {
            unsafe { sfVertexBuffer_getVertexCount(m_handle) }
        }
    }

    public func update(vertices: Array<Vertex>, offset: UInt32): Bool {
        var success = false
        unsafe {
            let rawData = acquireArrayRawData(vertices)
            try {
                success = sfVertexBuffer_update(m_handle, rawData.pointer, UInt32(vertices.size), offset)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        return success
    }

    public func update(other: VertexBuffer): Unit {
        unsafe { sfVertexBuffer_updateFromVertexBuffer(m_handle, other.m_handle) }
    }

    public func swap(other: VertexBuffer): Unit {
        unsafe { sfVertexBuffer_swap(m_handle, other.m_handle) }
    }

    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfVertexBuffer_getNativeHandle(m_handle) }
        }
    }

    public mut prop primitiveType: PrimitiveType {
        get() {
            unsafe { sfVertexBuffer_getPrimitiveType(m_handle) }
        }
        set(value) {
            unsafe { sfVertexBuffer_setPrimitiveType(m_handle, value) }
        }
    }

    public mut prop usage: VertexBufferUsage {
        get() {
            unsafe { sfVertexBuffer_getUsage(m_handle) }
        }
        set(value) {
            unsafe { sfVertexBuffer_setUsage(m_handle, value) }
        }
    }

    public func bind(): Unit {
        unsafe { sfVertexBuffer_bind(m_handle) }
    }

    public static prop isAvailable: Bool { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfVertexBuffer_isAvailable() }
        }
    }
}
