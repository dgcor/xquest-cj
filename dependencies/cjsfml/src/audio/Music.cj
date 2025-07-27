package cjsfml.audio

import cjsfml.system.*

foreign {
    func sfMusic_createFromFile(filename: CString): CPointer<Unit>

    func sfMusic_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfMusic_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfMusic_destroy(handle: CPointer<Unit>): Unit

    // Music

    func sfMusic_setLoop(handle: CPointer<Unit>, loop: SfBool): Unit

    func sfMusic_getLoop(handle: CPointer<Unit>): SfBool

    func sfMusic_getDuration(handle: CPointer<Unit>): Time

    func sfMusic_getLoopPoints(handle: CPointer<Unit>): TimeSpan

    func sfMusic_setLoopPoints(handle: CPointer<Unit>, timePoints: TimeSpan): Unit

    func sfMusic_play(handle: CPointer<Unit>): Unit

    func sfMusic_pause(handle: CPointer<Unit>): Unit

    func sfMusic_stop(handle: CPointer<Unit>): Unit

    func sfMusic_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfMusic_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfMusic_getStatus(handle: CPointer<Unit>): SoundStatus

    func sfMusic_getPlayingOffset(handle: CPointer<Unit>): Time

    func sfMusic_setPitch(handle: CPointer<Unit>, pitch: Float32): Unit

    func sfMusic_setVolume(handle: CPointer<Unit>, volume: Float32): Unit

    func sfMusic_setPosition(handle: CPointer<Unit>, position: Vector3f): Unit

    func sfMusic_setRelativeToListener(handle: CPointer<Unit>, relative: SfBool): Unit

    func sfMusic_setMinDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfMusic_setAttenuation(handle: CPointer<Unit>, attenuation: Float32): Unit

    func sfMusic_setPlayingOffset(handle: CPointer<Unit>, timeOffset: Time): Unit

    func sfMusic_getPitch(handle: CPointer<Unit>): Float32

    func sfMusic_getVolume(handle: CPointer<Unit>): Float32

    func sfMusic_getPosition(handle: CPointer<Unit>): Vector3f

    func sfMusic_isRelativeToListener(handle: CPointer<Unit>): SfBool

    func sfMusic_getMinDistance(handle: CPointer<Unit>): Float32

    func sfMusic_getAttenuation(handle: CPointer<Unit>): Float32
}

@C
public struct TimeSpan {
    public TimeSpan(
        public var offset!: Time = Time.zero,
        public var length!: Time = Time.zero
    ) {}
}

public class Music <: ResourceHandle & Equatable<Music> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init(filename: String) {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                m_handle = sfMusic_createFromFile(filenameRes.value)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(data: Array<Byte>) {
        unsafe {
            let rawData = acquireArrayRawData(data)
            try {
                m_handle = sfMusic_createFromMemory(rawData.pointer, UIntNative(data.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(stream: InputStream) {
        unsafe {
            var stream2 = stream.stream
            m_handle = sfMusic_createFromStream(inout stream2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfMusic_destroy(m_handle) }
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
        unsafe { sfMusic_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: Music): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Music): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Music

    public mut prop loop: Bool {
        get() {
            unsafe { sfMusic_getLoop(m_handle).toBool() }
        }
        set(value) {
            unsafe { sfMusic_setLoop(m_handle, SfBool.fromBool(value)) }
        }
    }

    public prop duration: Time {
        get() {
            unsafe { sfMusic_getDuration(m_handle) }
        }
    }

    public mut prop loopPoints: TimeSpan {
        get() {
            unsafe { sfMusic_getLoopPoints(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setLoopPoints(m_handle, value) }
        }
    }

    public func play(): Unit {
        unsafe { sfMusic_play(m_handle) }
    }

    public func pause(): Unit {
        unsafe { sfMusic_pause(m_handle) }
    }

    public func stop(): Unit {
        unsafe { sfMusic_stop(m_handle) }
    }

    public prop channelCount: UInt32 {
        get() {
            unsafe { sfMusic_getChannelCount(m_handle) }
        }
    }

    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfMusic_getSampleRate(m_handle) }
        }
    }

    public prop status: SoundStatus {
        get() {
            unsafe { sfMusic_getStatus(m_handle) }
        }
    }

    public mut prop pitch: Float32 {
        get() {
            unsafe { sfMusic_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPitch(m_handle, value) }
        }
    }

    public mut prop volume: Float32 {
        get() {
            unsafe { sfMusic_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setVolume(m_handle, value) }
        }
    }

    public mut prop position: Vector3f {
        get() {
            unsafe { sfMusic_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPosition(m_handle, value) }
        }
    }

    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfMusic_isRelativeToListener(m_handle).toBool() }
        }
        set(value) {
            unsafe { sfMusic_setRelativeToListener(m_handle, SfBool.fromBool(value)) }
        }
    }

    public mut prop minDistance: Float32 {
        get() {
            unsafe { sfMusic_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMinDistance(m_handle, value) }
        }
    }

    public mut prop attenuation: Float32 {
        get() {
            unsafe { sfMusic_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setAttenuation(m_handle, value) }
        }
    }

    public mut prop playingOffset: Time {
        get() {
            unsafe { sfMusic_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPlayingOffset(m_handle, value) }
        }
    }
}
