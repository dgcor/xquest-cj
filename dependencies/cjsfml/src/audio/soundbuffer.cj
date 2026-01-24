package cjsfml.audio

import cjsfml.system.{InputStream, InputStreamData, ResourceHandle, SFMLNullHandleException, Time}

foreign {
    func sfSoundBuffer_createFromFile(filename: CString): CPointer<Unit>

    func sfSoundBuffer_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfSoundBuffer_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfSoundBuffer_createFromSamples( // cjlint-ignore !G.FUN.01 too many parameters
        samples: CPointer<Int16>,
        sampleCount: UInt64,
        channelCount: UInt32,
        sampleRate: UInt32,
        channelMapData: CPointer<SoundChannel>,
        channelMapSize: UIntNative
    ): CPointer<Unit>

    func sfSoundBuffer_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfSoundBuffer_destroy(handle: CPointer<Unit>): Unit

    func sfSoundBuffer_saveToFile(handle: CPointer<Unit>, filename: CString): Bool

    func sfSoundBuffer_getSamples(handle: CPointer<Unit>): CPointer<Int16>

    func sfSoundBuffer_getSampleCount(handle: CPointer<Unit>): UInt64

    func sfSoundBuffer_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundBuffer_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfSoundBuffer_getChannelMap(handle: CPointer<Unit>, count: CPointer<UIntNative>): CPointer<SoundChannel>

    func sfSoundBuffer_getDuration(handle: CPointer<Unit>): Time
}

public class SoundBuffer <: ResourceHandle & Equatable<SoundBuffer> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * @throws SFMLNullHandleException
     */
    public init(filename: String) {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                m_handle = sfSoundBuffer_createFromFile(filenameRes.value)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(data: Array<Byte>) {
        unsafe {
            let rawData = acquireArrayRawData(data)
            m_handle = sfSoundBuffer_createFromMemory(rawData.pointer, UIntNative(data.size))
            releaseArrayRawData(rawData)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(stream: InputStream) {
        unsafe {
            var stream2 = stream.stream
            m_handle = sfSoundBuffer_createFromStream(inout stream2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(samples!: Array<Int16>, sampleCount!: UInt64, channelCount!: UInt32, sampleRate!: UInt32,
        channelMap!: Array<SoundChannel>) {
        unsafe {
            let rawSamples = acquireArrayRawData(samples)
            let rawChannelMap = acquireArrayRawData(channelMap)
            m_handle = sfSoundBuffer_createFromSamples(
                rawSamples.pointer,
                sampleCount,
                channelCount,
                sampleRate,
                rawChannelMap.pointer,
                UIntNative(rawChannelMap.array.size)
            )
            releaseArrayRawData(rawChannelMap)
            releaseArrayRawData(rawSamples)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(samples!: CPointer<Int16>, sampleCount!: UInt64, channelCount!: UInt32, sampleRate!: UInt32,
        channelMap!: Array<SoundChannel>) {
        unsafe {
            let rawChannelMap = acquireArrayRawData(channelMap)
            m_handle = sfSoundBuffer_createFromSamples(
                samples,
                sampleCount,
                channelCount,
                sampleRate,
                rawChannelMap.pointer,
                UIntNative(rawChannelMap.array.size)
            )
            releaseArrayRawData(rawChannelMap)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfSoundBuffer_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): SoundBuffer {
        SoundBuffer(unsafe { sfSoundBuffer_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfSoundBuffer_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    public operator override func ==(right: SoundBuffer): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: SoundBuffer): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundBuffer

    public func savetoFile(filename: String): Bool {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                return sfSoundBuffer_saveToFile(m_handle, filenameRes.value)
            }
        }
        return false
    }

    public prop samples: CPointer<Int16> {
        get() {
            unsafe { sfSoundBuffer_getSamples(m_handle) }
        }
    }

    public prop sampleCount: UInt64 {
        get() {
            unsafe { sfSoundBuffer_getSampleCount(m_handle) }
        }
    }

    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundBuffer_getSampleRate(m_handle) }
        }
    }

    public prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundBuffer_getChannelCount(m_handle) }
        }
    }

    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfSoundBuffer_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }

    public prop duration: Time {
        get() {
            unsafe { sfSoundBuffer_getDuration(m_handle) }
        }
    }
}
