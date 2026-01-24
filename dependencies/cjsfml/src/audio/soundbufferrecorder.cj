package cjsfml.audio

import cjsfml.system.SFMLNullHandleException

foreign {
    func sfSoundBufferRecorder_create(): CPointer<Unit>

    func sfSoundBufferRecorder_destroy(handle: CPointer<Unit>): Unit

    func sfSoundBufferRecorder_start(handle: CPointer<Unit>, sampleRate: UInt32): Bool

    func sfSoundBufferRecorder_stop(handle: CPointer<Unit>): Unit

    func sfSoundBufferRecorder_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundBufferRecorder_getBuffer(handle: CPointer<Unit>): CPointer<Unit>

    func sfSoundBufferRecorder_setDevice(handle: CPointer<Unit>, name: CString): Bool

    func sfSoundBufferRecorder_getDevice(handle: CPointer<Unit>): CString

    func sfSoundBufferRecorder_setChannelCount(handle: CPointer<Unit>, channelCount: UInt32): Unit

    func sfSoundBufferRecorder_getChannelCount(handle: CPointer<Unit>): UInt32
}

public class SoundBufferRecorder <: SFMLSoundRecorder {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init() {
        m_handle = unsafe { sfSoundBufferRecorder_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSoundBufferRecorder_destroy(m_handle) }
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
        unsafe { sfSoundBufferRecorder_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // SFMLSoundRecorder

    public func start(sampleRate: UInt32): Bool {
        unsafe { sfSoundBufferRecorder_start(m_handle, sampleRate) }
    }

    public func stop(): Unit {
        unsafe { sfSoundBufferRecorder_stop(m_handle) }
    }

    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundBufferRecorder_getSampleRate(m_handle) }
        }
    }

    public mut prop device: String {
        get() {
            unsafe { sfSoundBufferRecorder_getDevice(m_handle).toString() }
        }
        set(value) {
            unsafe {
                try (valueRes = LibC.mallocCString(value).asResource()) {
                    sfSoundBufferRecorder_setDevice(m_handle, valueRes.value)
                }
            }
        }
    }

    public mut prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundBufferRecorder_getChannelCount(m_handle) }
        }
        set(value) {
            unsafe { sfSoundBufferRecorder_setChannelCount(m_handle, value) }
        }
    }

    // SoundBufferRecorder

    public prop buffer: ?SoundBuffer {
        get() {
            let bufferPtr = unsafe { sfSoundBufferRecorder_getBuffer(m_handle) }
            if (bufferPtr.isNull()) {
                return None
            }
            SoundBuffer(bufferPtr, isOwner: false)
        }
    }
}
