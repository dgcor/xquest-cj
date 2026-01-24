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

    public prop size: Int64 {
        get() {
            unsafe { Int64(sfBuffer_getSize(m_handle)) }
        }
    }

    public prop data: CPointer<UInt8> {
        get() {
            unsafe { sfBuffer_getData(m_handle) }
        }
    }
}
