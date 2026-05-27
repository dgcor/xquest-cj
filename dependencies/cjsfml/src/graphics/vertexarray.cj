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

/**
 * Set of one or more 2D primitives.
 *
 * `VertexArray` is a very simple wrapper around a dynamic
 * array of vertices and a primitives type.
 *
 * It inherits `Drawable`, but unlike other drawables it
 * is not transformable.
 *
 * Example:
 * ```
 * let lines = VertexArray(PrimitiveType.LineStrip, 4);
 * lines[0].position = Vector2f(10.0, 0.0);
 * lines[1].position = Vector2f(20.0, 0.0);
 * lines[2].position = Vector2f(30.0, 5.0);
 * lines[3].position = Vector2f(40.0, 2.0);
 *
 * window.draw(lines);
 * ```
 *
 * @see `Vertex`
 */
public class VertexArray <: ResourceHandle & RenderTargetDrawable & Equatable<VertexArray> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Default constructor.
     *
     * Creates an empty vertex array.
     */
    public init() {
        this(PrimitiveType.Points, 0)
    }

    /**
     * Construct the vertex array with a type.
     *
     * @param primitiveType Type of primitives
     */
    public init(primitiveType: PrimitiveType) {
        this(primitiveType, 0)
    }

    /**
     * Construct the vertex array with a type and an initial number of vertices.
     *
     * @param primitiveType Type of primitives
     * @param vertexCount   Initial number of vertices in the array
     *
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
     * Construct the vertex array from an existing handle.
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
            unsafe { sfVertexArray_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the vertex array.
     *
     * @return A new vertex array instance that is a copy of this one.
     */
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

    public override operator func ==(right: VertexArray): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: VertexArray): Bool {
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

    /**
     * Return the vertex count.
     *
     * @return Number of vertices in the array
     */
    public mut prop vertexCount: UInt32 {
        get() {
            UInt32(unsafe { sfVertexArray_getVertexCount(m_handle) })
        }
        set(value) {
            unsafe { sfVertexArray_resize(m_handle, UIntNative(value)) }
        }
    }

    /**
     * Get a read-write access to a vertex by its index.
     *
     * This function doesn't check `index`, it must be in range
     * [0, `vertexCount` - 1]. The behavior is undefined
     * otherwise.
     *
     * @param index Index of the vertex to get
     *
     * @return Reference to the `index`-th vertex
     *
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

    /**
     * Get a read-write access to a vertex by its index.
     *
     * This function doesn't check `index`, it must be in range
     * [0, `vertexCount` - 1]. The behavior is undefined
     * otherwise.
     *
     * @param index Index of the vertex to get
     *
     * @return Reference to the `index`-th vertex
     */
    public operator func [](index: Int64): Vertex {
        getVertex(UInt32(index))
    }

    /**
     * Set a vertex by its index.
     *
     * This function doesn't check `index`, it must be in range
     * [0, `vertexCount` - 1]. The behavior is undefined
     * otherwise.
     *
     * @param index Index of the vertex to set
     * @param value Vertex to assign
     *
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

    /**
     * Clear the vertex array.
     *
     * This function removes all the vertices from the array.
     * It doesn't deallocate the corresponding memory, so that
     * adding new vertices after clearing doesn't involve
     * reallocating all the memory.
     */
    public func clear(): Unit {
        unsafe { sfVertexArray_clear(m_handle) }
    }

    /**
     * Resize the vertex array.
     *
     * If `vertexCount` is greater than the current size, the previous
     * vertices are kept and new (default-constructed) vertices are
     * added.
     * If `vertexCount` is less than the current size, existing vertices
     * are removed from the array.
     *
     * @param vertexCount New size of the array (number of vertices)
     */
    public func resize(vertexCount: UInt32): Unit {
        unsafe { sfVertexArray_resize(m_handle, UIntNative(vertexCount)) }
    }

    /**
     * Add a vertex to the array.
     *
     * @param vertex Vertex to add
     */
    public func append(vertex: Vertex): Unit {
        unsafe { sfVertexArray_append(m_handle, vertex) }
    }

    /**
     * Set the type of primitives to draw.
     *
     * This function defines how the vertices must be interpreted
     * when it's time to draw them:
     * - As points
     * - As lines
     * - As triangles
     *
     * The default primitive type is `PrimitiveType.Points`.
     *
     * @param value Type of primitive
     */
    public mut prop primitiveType: PrimitiveType {
        get() {
            unsafe { sfVertexArray_getPrimitiveType(m_handle) }
        }
        set(value) {
            unsafe { sfVertexArray_setPrimitiveType(m_handle, value) }
        }
    }

    /**
     * Compute the bounding rectangle of the vertex array.
     *
     * This function returns the minimal axis-aligned rectangle
     * that contains all the vertices of the array.
     *
     * @return Bounding rectangle of the vertex array
     */
    public prop bounds: FloatRect {
        get() {
            unsafe { sfVertexArray_getBounds(m_handle) }
        }
    }
}
