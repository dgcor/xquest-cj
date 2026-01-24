package cjsfml.audio

import cjsfml.system.SFMLNullHandleException

type SoundRecorderStartCallback = CFunc<(userData: CPointer<Unit>) -> Bool>

type SoundRecorderProcessCallback = CFunc<(samples: CPointer<Int16>, sampleCount: UIntNative) -> Bool>

type SoundRecorderStopCallback = CFunc<(userData: CPointer<Unit>) -> Bool>

foreign {
    func sfSoundRecorder_create(onStart: SoundRecorderStartCallback, onProcess: SoundRecorderProcessCallback,
        onStop: SoundRecorderStopCallback, userData: CPointer<Unit>): CPointer<Unit>

    func sfSoundRecorder_destroy(handle: CPointer<Unit>): Unit

    func sfSoundRecorder_start(handle: CPointer<Unit>, sampleRate: UInt32): Bool

    func sfSoundRecorder_stop(handle: CPointer<Unit>): Unit

    func sfSoundRecorder_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundRecorder_setDevice(handle: CPointer<Unit>, name: CString): Bool

    func sfSoundRecorder_getDevice(handle: CPointer<Unit>): CString

    func sfSoundRecorder_setChannelCount(handle: CPointer<Unit>, channelCount: UInt32): Unit

    func sfSoundRecorder_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfSoundRecorder_getChannelMap(handle: CPointer<Unit>, count: UIntNative): CPointer<SoundChannel>
}

public class SoundRecorder <: SFMLSoundRecorder {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init(onStart!: SoundRecorderStartCallback, onProcess!: SoundRecorderProcessCallback,
        onStop!: SoundRecorderStopCallback, userData!: CPointer<Unit>) {
        m_handle = unsafe { sfSoundRecorder_create(onStart, onProcess, onStop, userData) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSoundRecorder_destroy(m_handle) }
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
        unsafe { sfSoundRecorder_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // SFMLSoundRecorder

    public func start(sampleRate: UInt32): Bool {
        unsafe { sfSoundRecorder_start(m_handle, sampleRate) }
    }

    public func stop(): Unit {
        unsafe { sfSoundRecorder_stop(m_handle) }
    }

    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundRecorder_getSampleRate(m_handle) }
        }
    }

    public mut prop device: String {
        get() {
            unsafe { sfSoundRecorder_getDevice(m_handle).toString() }
        }
        set(value) {
            unsafe {
                try (valueRes = LibC.mallocCString(value).asResource()) {
                    sfSoundRecorder_setDevice(m_handle, valueRes.value)
                }
            }
        }
    }

    public mut prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundRecorder_getChannelCount(m_handle) }
        }
        set(value) {
            unsafe { sfSoundRecorder_setChannelCount(m_handle, value) }
        }
    }

    // SoundRecorder

    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfSoundRecorder_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }
}
