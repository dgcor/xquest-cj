package cjsfml.system

foreign {
    func sfBuffer_create(): CPointer<Unit>

    func sfBuffer_destroy(handle: CPointer<Unit>): Unit

    @FastNative
    func sfBuffer_getSize(handle: CPointer<Unit>): UIntNative

    @FastNative
    func sfBuffer_getData(handle: CPointer<Unit>): CPointer<UInt8>
}

protected class Buffer <: ResourceHandle {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Create an empty buffer
     *
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfBuffer_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfBuffer_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfBuffer_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // buffer

    /**
     * Return the size of a buffer
     *
     * @return Size in bytes
     */
    public prop size: Int64 {
        get() {
            unsafe { Int64(sfBuffer_getSize(m_handle)) }
        }
    }

    /**
     * Get a read-only pointer to the array of bytes of a buffer
     *
     * @return Read-only pointer to the array of bytes
     */
    public prop data: CPointer<UInt8> {
        get() {
            unsafe { sfBuffer_getData(m_handle) }
        }
    }
}
