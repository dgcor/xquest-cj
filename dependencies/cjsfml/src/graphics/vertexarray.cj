package cjsfml.graphics

import cjsfml.system.{ResourceHandle, SFMLNullHandleException}

foreign {
    func sfVertexArray_create(): CPointer<Unit>

    func sfVertexArray_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfVertexArray_destroy(handle: CPointer<Unit>): Unit

    // VertexArray

    func sfVertexArray_getVertexCount(handle: CPointer<Unit>): UIntNative

    func sfVertexArray_getVertex(handle: CPointer<Unit>, index: UIntNative): CPointer<Vertex>

    func sfVertexArray_clear(handle: CPointer<Unit>): Unit

    func sfVertexArray_resize(handle: CPointer<Unit>, vertexCount: UIntNative): Unit

    func sfVertexArray_append(handle: CPointer<Unit>, vertex: Vertex): Unit

    func sfVertexArray_setPrimitiveType(handle: CPointer<Unit>, primitiveType: PrimitiveType): Unit

    func sfVertexArray_getPrimitiveType(handle: CPointer<Unit>): PrimitiveType

    func sfVertexArray_getBounds(handle: CPointer<Unit>): FloatRect
}

public class VertexArray <: ResourceHandle & RenderTargetDrawable & Equatable<VertexArray> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init() {
        this(PrimitiveType.Points, 0)
    }

    public init(primitiveType: PrimitiveType) {
        this(primitiveType, 0)
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(primitiveType: PrimitiveType, vertexCount: UInt32) {
        m_handle = unsafe { sfVertexArray_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (primitiveType != PrimitiveType.Points) {
            unsafe { sfVertexArray_setPrimitiveType(m_handle, primitiveType) }
        }
        if (vertexCount > 0) {
            unsafe { sfVertexArray_resize(m_handle, UIntNative(vertexCount)) }
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
            unsafe { sfVertexArray_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): VertexArray {
        VertexArray(unsafe { sfVertexArray_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfVertexArray_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: VertexArray): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: VertexArray): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawVertexArray(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexArray(window.handle, m_handle, inout states2)
        }
    }

    // VertexArray

    public mut prop vertexCount: UInt32 {
        get() {
            UInt32(unsafe { sfVertexArray_getVertexCount(m_handle) })
        }
        set(value) {
            unsafe { sfVertexArray_resize(m_handle, UIntNative(value)) }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public func getVertex(index: UInt32): Vertex {
        let vertexPtr = unsafe { sfVertexArray_getVertex(m_handle, UIntNative(index)) }
        if (vertexPtr.isNull()) {
            throw IndexOutOfBoundsException()
        }
        unsafe { vertexPtr.read() }
    }

    // cjlint-ignore -start !G.OPR.01 uncommon operator overloading

    public operator func [](index: Int64): Vertex {
        getVertex(UInt32(index))
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func [](index: Int64, value!: Vertex): Unit {
        if (index < 0 || index >= Int64(vertexCount)) {
            throw IndexOutOfBoundsException()
        }
        unsafe {
            let vertexPtr = sfVertexArray_getVertex(m_handle, UIntNative(index))
            vertexPtr.write(value)
        }
    }

    // cjlint-ignore -end uncommon operator overloading

    public func clear(): Unit {
        unsafe { sfVertexArray_clear(m_handle) }
    }

    public func resize(vertexCount: UInt32): Unit {
        unsafe { sfVertexArray_resize(m_handle, UIntNative(vertexCount)) }
    }

    public func append(vertex: Vertex): Unit {
        unsafe { sfVertexArray_append(m_handle, vertex) }
    }

    public mut prop primitiveType: PrimitiveType {
        get() {
            unsafe { sfVertexArray_getPrimitiveType(m_handle) }
        }
        set(value) {
            unsafe { sfVertexArray_setPrimitiveType(m_handle, value) }
        }
    }

    public prop bounds: FloatRect {
        get() {
            unsafe { sfVertexArray_getBounds(m_handle) }
        }
    }
}
