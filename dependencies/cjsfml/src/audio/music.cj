package cjsfml.audio

import cjsfml.system.{InputStream, InputStreamData, SFMLNullHandleException, Time, Vector3f}

foreign {
    func sfMusic_createFromFile(filename: CString): CPointer<Unit>

    func sfMusic_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfMusic_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfMusic_destroy(handle: CPointer<Unit>): Unit

    func sfMusic_setLooping(handle: CPointer<Unit>, loop: Bool): Unit

    func sfMusic_isLooping(handle: CPointer<Unit>): Bool

    func sfMusic_setEffectProcessor(handle: CPointer<Unit>, effectProcessor: EffectProcessor): Unit

    func sfMusic_getDuration(handle: CPointer<Unit>): Time

    func sfMusic_getLoopPoints(handle: CPointer<Unit>): TimeSpan

    func sfMusic_setLoopPoints(handle: CPointer<Unit>, timePoints: TimeSpan): Unit

    func sfMusic_play(handle: CPointer<Unit>): Unit

    func sfMusic_pause(handle: CPointer<Unit>): Unit

    func sfMusic_stop(handle: CPointer<Unit>): Unit

    func sfMusic_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfMusic_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfMusic_getChannelMap(handle: CPointer<Unit>, count: CPointer<UIntNative>): CPointer<SoundChannel>

    func sfMusic_getStatus(handle: CPointer<Unit>): SoundStatus

    func sfMusic_getPlayingOffset(handle: CPointer<Unit>): Time

    func sfMusic_setPitch(handle: CPointer<Unit>, pitch: Float32): Unit

    func sfMusic_setPan(handle: CPointer<Unit>, pan: Float32): Unit

    func sfMusic_setVolume(handle: CPointer<Unit>, volume: Float32): Unit

    func sfMusic_setSpatializationEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfMusic_setPosition(handle: CPointer<Unit>, position: Vector3f): Unit

    func sfMusic_setDirection(handle: CPointer<Unit>, direction: Vector3f): Unit

    func sfMusic_setCone(handle: CPointer<Unit>, cone: SoundSourceCone): Unit

    func sfMusic_setVelocity(handle: CPointer<Unit>, velocity: Vector3f): Unit

    func sfMusic_setDopplerFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfMusic_setDirectionalAttenuationFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfMusic_setRelativeToListener(handle: CPointer<Unit>, relative: Bool): Unit

    func sfMusic_setMinDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfMusic_setMaxDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfMusic_setMinGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfMusic_setMaxGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfMusic_setAttenuation(handle: CPointer<Unit>, attenuation: Float32): Unit

    func sfMusic_setPlayingOffset(handle: CPointer<Unit>, timeOffset: Time): Unit

    func sfMusic_getPitch(handle: CPointer<Unit>): Float32

    func sfMusic_getPan(handle: CPointer<Unit>): Float32

    func sfMusic_isSpatializationEnabled(handle: CPointer<Unit>): Bool

    func sfMusic_getVolume(handle: CPointer<Unit>): Float32

    func sfMusic_getPosition(handle: CPointer<Unit>): Vector3f

    func sfMusic_getDirection(handle: CPointer<Unit>): Vector3f

    func sfMusic_getCone(handle: CPointer<Unit>): SoundSourceCone

    func sfMusic_getVelocity(handle: CPointer<Unit>): Vector3f

    func sfMusic_getDopplerFactor(handle: CPointer<Unit>): Float32

    func sfMusic_getDirectionalAttenuationFactor(handle: CPointer<Unit>): Float32

    func sfMusic_isRelativeToListener(handle: CPointer<Unit>): Bool

    func sfMusic_getMinDistance(handle: CPointer<Unit>): Float32

    func sfMusic_getMaxDistance(handle: CPointer<Unit>): Float32

    func sfMusic_getMinGain(handle: CPointer<Unit>): Float32

    func sfMusic_getMaxGain(handle: CPointer<Unit>): Float32

    func sfMusic_getAttenuation(handle: CPointer<Unit>): Float32
}

@C
public struct TimeSpan {
    public TimeSpan(
        public var offset!: Time = Time.ZERO,
        public var length!: Time = Time.ZERO
    ) {}
}

public class Music <: SFMLSoundStream<Music> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
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

    /**
     * @throws SFMLNullHandleException
     */
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

    /**
     * @throws SFMLNullHandleException
     */
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

    // SoundSource

    public func play(): Unit {
        unsafe { sfMusic_play(m_handle) }
    }

    public func pause(): Unit {
        unsafe { sfMusic_pause(m_handle) }
    }

    public func stop(): Unit {
        unsafe { sfMusic_stop(m_handle) }
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

    public mut prop pan: Float32 {
        get() {
            unsafe { sfMusic_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPan(m_handle, value) }
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

    public mut prop spatializationEnabled: Bool {
        get() {
            unsafe { sfMusic_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setSpatializationEnabled(m_handle, value) }
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

    public mut prop direction: Vector3f {
        get() {
            unsafe { sfMusic_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDirection(m_handle, value) }
        }
    }

    public mut prop cone: SoundSourceCone {
        get() {
            unsafe { sfMusic_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setCone(m_handle, value) }
        }
    }

    public mut prop velocity: Vector3f {
        get() {
            unsafe { sfMusic_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setVelocity(m_handle, value) }
        }
    }

    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfMusic_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDopplerFactor(m_handle, value) }
        }
    }

    public mut prop directionalAttenuationFactor: Float32 {
        get() {
            unsafe { sfMusic_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDirectionalAttenuationFactor(m_handle, value) }
        }
    }

    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfMusic_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setRelativeToListener(m_handle, value) }
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

    public mut prop maxDistance: Float32 {
        get() {
            unsafe { sfMusic_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMaxDistance(m_handle, value) }
        }
    }

    public mut prop minGain: Float32 {
        get() {
            unsafe { sfMusic_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMinGain(m_handle, value) }
        }
    }

    public mut prop maxGain: Float32 {
        get() {
            unsafe { sfMusic_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMaxGain(m_handle, value) }
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

    public func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit {
        match (effectProcessor) {
            case Some(effectProcessor) => unsafe { sfMusic_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfMusic_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // SFMLSoundStream

    public mut prop loop: Bool {
        get() {
            unsafe { sfMusic_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setLooping(m_handle, value) }
        }
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

    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfMusic_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
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

    // Music

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
}
