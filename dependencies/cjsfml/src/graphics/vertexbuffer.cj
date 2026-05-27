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

/**
 * Usage specifiers.
 *
 * If data is going to be updated once or more every frame,
 * set the usage to Stream. If data is going to be set once
 * and used for a long time without being modified, set the
 * usage to Static. For everything else Dynamic should be a
 * good compromise.
 */
@CEnum[public VertexBufferUsage](
    Stream // Constantly changing data
    Dynamic // Occasionally changing data
    Static // Rarely changing data
)

/**
 * Vertex buffer storage for one or more 2D primitives.
 *
 * `VertexBuffer` is a simple wrapper around a dynamic
 * buffer of vertices and a primitives type.
 *
 * Unlike `VertexArray`, the vertex data is stored in
 * graphics memory.
 *
 * In situations where a large amount of vertex data would
 * have to be transferred from system memory to graphics memory
 * every frame, using `VertexBuffer` can help. By using a
 * `VertexBuffer`, data that has not been changed between frames
 * does not have to be re-transferred from system to graphics
 * memory as would be the case with `VertexArray`. If data transfer
 * is a bottleneck, this can lead to performance gains.
 *
 * Using `VertexBuffer`, the user also has the ability to only modify
 * a portion of the buffer in graphics memory. This way, a large buffer
 * can be allocated at the start of the application and only the
 * applicable portions of it need to be updated during the course of
 * the application. This allows the user to take full control of data
 * transfers between system and graphics memory if they need to.
 *
 * In special cases, the user can make use of multiple threads to update
 * vertex data in multiple distinct regions of the buffer simultaneously.
 * This might make sense when e.g. the position of multiple objects has to
 * be recalculated very frequently. The computation load can be spread
 * across multiple threads as long as there are no other data dependencies.
 *
 * Simultaneous updates to the vertex buffer are not guaranteed to be
 * carried out by the driver in any specific order. Updating the same
 * region of the buffer from multiple threads will not cause undefined
 * behavior, however the final state of the buffer will be unpredictable.
 *
 * Simultaneous updates of distinct non-overlapping regions of the buffer
 * are also not guaranteed to complete in a specific order. However, in
 * this case the user can make sure to synchronize the writer threads at
 * well-defined points in their code. The driver will make sure that all
 * pending data transfers complete before the vertex buffer is sourced
 * by the rendering pipeline.
 *
 * It inherits `Drawable`, but unlike other drawables it
 * is not transformable.
 *
 * Example:
 * ```
 * let vertices = Array<Vertex>(15, { ... });
 * ...
 * let triangles = VertexBuffer(vertices.size, PrimitiveType.Triangles);
 * triangles.update(vertices, 0);
 * ...
 * window.draw(triangles);
 * ```
 *
 * @see `Vertex`, `VertexArray`
 */
public class VertexBuffer <: ResourceHandle & RenderTargetDrawable & Equatable<VertexBuffer> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Default constructor.
     *
     * Creates an empty vertex buffer.
     *
     * @param vertexCount   Number of vertices worth of memory to allocate
     * @param primitiveType Type of primitive
     * @param usage         Usage specifier
     *
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
     * Construct the vertex buffer from an existing handle.
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
            unsafe { sfVertexBuffer_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the vertex buffer.
     *
     * @return A new vertex buffer instance that is a copy of this one.
     */
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

    public override operator func ==(right: VertexBuffer): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: VertexBuffer): Bool {
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

    /**
     * Return the vertex count.
     *
     * @return Number of vertices in the vertex buffer
     */
    public prop vertexCount: UInt32 {
        get() {
            unsafe { sfVertexBuffer_getVertexCount(m_handle) }
        }
    }

    /**
     * Update a part of the buffer from an array of vertices.
     *
     * `offset` is specified as the number of vertices to skip
     * from the beginning of the buffer.
     *
     * If `offset` is 0 and `vertexCount` is equal to the size of
     * the currently created buffer, its whole contents are replaced.
     *
     * If `offset` is 0 and `vertexCount` is greater than the
     * size of the currently created buffer, a new buffer is created
     * containing the vertex data.
     *
     * If `offset` is 0 and `vertexCount` is less than the size of
     * the currently created buffer, only the corresponding region
     * is updated.
     *
     * If `offset` is not 0 and `offset` + `vertexCount` is greater
     * than the size of the currently created buffer, the update fails.
     *
     * No additional check is performed on the size of the vertex
     * array. Passing invalid arguments will lead to undefined
     * behavior.
     *
     * @param vertices Array of vertices to copy to the buffer
     * @param offset   Offset in the buffer to copy to
     *
     * @return `true` if the update was successful
     */
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

    /**
     * Copy the contents of another buffer into this buffer.
     *
     * @param other Vertex buffer whose contents to copy into this vertex buffer
     *
     * @return `true` if the copy was successful
     */
    public func update(other: VertexBuffer): Unit {
        unsafe { sfVertexBuffer_updateFromVertexBuffer(m_handle, other.m_handle) }
    }

    /**
     * Swap the contents of this vertex buffer with those of another.
     *
     * @param other Instance to swap with
     */
    public func swap(other: VertexBuffer): Unit {
        unsafe { sfVertexBuffer_swap(m_handle, other.m_handle) }
    }

    /**
     * Get the underlying OpenGL handle of the vertex buffer.
     *
     * You shouldn't need to use this function, unless you have
     * very specific stuff to implement that SFML doesn't support,
     * or implement a temporary workaround until a bug is fixed.
     *
     * @return OpenGL handle of the vertex buffer or 0 if not yet created
     */
    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfVertexBuffer_getNativeHandle(m_handle) }
        }
    }

    /**
     * Set the type of primitives to draw.
     *
     * This function defines how the vertices must be interpreted
     * when it's time to draw them.
     *
     * The default primitive type is `PrimitiveType.Points`.
     *
     * @param value Type of primitive
     */
    public mut prop primitiveType: PrimitiveType {
        get() {
            unsafe { sfVertexBuffer_getPrimitiveType(m_handle) }
        }
        set(value) {
            unsafe { sfVertexBuffer_setPrimitiveType(m_handle, value) }
        }
    }

    /**
     * Set the usage specifier of this vertex buffer.
     *
     * This function provides a hint about how this vertex buffer is
     * going to be used in terms of data update frequency.
     *
     * After changing the usage specifier, the vertex buffer has
     * to be updated with new data for the usage specifier to
     * take effect.
     *
     * The default usage type is `VertexBufferUsage.Stream`.
     *
     * @param value Usage specifier
     */
    public mut prop usage: VertexBufferUsage {
        get() {
            unsafe { sfVertexBuffer_getUsage(m_handle) }
        }
        set(value) {
            unsafe { sfVertexBuffer_setUsage(m_handle, value) }
        }
    }

    /**
     * Bind a vertex buffer for rendering.
     *
     * This function is not part of the graphics API, it mustn't be
     * used when drawing SFML entities. It must be used only if you
     * mix `VertexBuffer` with OpenGL code.
     */
    public func bind(): Unit {
        unsafe { sfVertexBuffer_bind(m_handle) }
    }

    /**
     * Tell whether or not the system supports vertex buffers.
     *
     * This function should always be called before using
     * the vertex buffer features. If it returns `false`, then
     * any attempt to use `VertexBuffer` will fail.
     *
     * @return `true` if vertex buffers are supported, `false` otherwise
     */
    public static prop isAvailable: Bool { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfVertexBuffer_isAvailable() }
        }
    }
}
