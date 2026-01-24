package cjsfml.audio

import cjsfml.system.{SFMLNullHandleException, Time, Vector3f}

@C
public struct SoundStreamChunk {
    public SoundStreamChunk(
        public var samples!: CPointer<Int16> = CPointer(), // Pointer to the audio samples
        public var sampleCount!: UInt32 = 0 // Number of samples pointed by Samples
    ) {}
}

type SoundStreamGetDataCallback = CFunc<(data: CPointer<SoundStreamChunk>, userData: CPointer<Unit>) -> Bool>

type SoundStreamSeekCallback = CFunc<(timeOffset: Time, userData: CPointer<Unit>) -> Unit>

foreign {
    func sfSoundStream_create( // cjlint-ignore !G.FUN.01 too many parameters
        onGetData: SoundStreamGetDataCallback,
        onSeek: SoundStreamSeekCallback,
        channelCount: UInt32,
        sampleRate: UInt32,
        channelMapData: CPointer<SoundChannel>,
        channelMapSize: UIntNative,
        userData: CPointer<Unit>
    ): CPointer<Unit>

    func sfSoundStream_destroy(handle: CPointer<Unit>): Unit

    func sfSoundStream_setLooping(handle: CPointer<Unit>, loop: Bool): Unit

    func sfSoundStream_isLooping(handle: CPointer<Unit>): Bool

    func sfSoundStream_setEffectProcessor(handle: CPointer<Unit>, effectProcessor: EffectProcessor): Unit

    func sfSoundStream_play(handle: CPointer<Unit>): Unit

    func sfSoundStream_pause(handle: CPointer<Unit>): Unit

    func sfSoundStream_stop(handle: CPointer<Unit>): Unit

    func sfSoundStream_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfSoundStream_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundStream_getChannelMap(handle: CPointer<Unit>, count: CPointer<UIntNative>): CPointer<SoundChannel>

    func sfSoundStream_getStatus(handle: CPointer<Unit>): SoundStatus

    func sfSoundStream_getPlayingOffset(handle: CPointer<Unit>): Time

    func sfSoundStream_setPitch(handle: CPointer<Unit>, pitch: Float32): Unit

    func sfSoundStream_setPan(handle: CPointer<Unit>, pan: Float32): Unit

    func sfSoundStream_setVolume(handle: CPointer<Unit>, volume: Float32): Unit

    func sfSoundStream_setSpatializationEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfSoundStream_setPosition(handle: CPointer<Unit>, position: Vector3f): Unit

    func sfSoundStream_setDirection(handle: CPointer<Unit>, direction: Vector3f): Unit

    func sfSoundStream_setCone(handle: CPointer<Unit>, cone: SoundSourceCone): Unit

    func sfSoundStream_setVelocity(handle: CPointer<Unit>, velocity: Vector3f): Unit

    func sfSoundStream_setDopplerFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfSoundStream_setDirectionalAttenuationFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfSoundStream_setRelativeToListener(handle: CPointer<Unit>, relative: Bool): Unit

    func sfSoundStream_setMinDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfSoundStream_setMaxDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfSoundStream_setMinGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfSoundStream_setMaxGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfSoundStream_setAttenuation(handle: CPointer<Unit>, attenuation: Float32): Unit

    func sfSoundStream_setPlayingOffset(handle: CPointer<Unit>, timeOffset: Time): Unit

    func sfSoundStream_getPitch(handle: CPointer<Unit>): Float32

    func sfSoundStream_getPan(handle: CPointer<Unit>): Float32

    func sfSoundStream_isSpatializationEnabled(handle: CPointer<Unit>): Bool

    func sfSoundStream_getVolume(handle: CPointer<Unit>): Float32

    func sfSoundStream_getPosition(handle: CPointer<Unit>): Vector3f

    func sfSoundStream_getDirection(handle: CPointer<Unit>): Vector3f

    func sfSoundStream_getCone(handle: CPointer<Unit>): SoundSourceCone

    func sfSoundStream_getVelocity(handle: CPointer<Unit>): Vector3f

    func sfSoundStream_getDopplerFactor(handle: CPointer<Unit>): Float32

    func sfSoundStream_getDirectionalAttenuationFactor(handle: CPointer<Unit>): Float32

    func sfSoundStream_isRelativeToListener(handle: CPointer<Unit>): Bool

    func sfSoundStream_getMinDistance(handle: CPointer<Unit>): Float32

    func sfSoundStream_getMaxDistance(handle: CPointer<Unit>): Float32

    func sfSoundStream_getMinGain(handle: CPointer<Unit>): Float32

    func sfSoundStream_getMaxGain(handle: CPointer<Unit>): Float32

    func sfSoundStream_getAttenuation(handle: CPointer<Unit>): Float32
}

public class SoundStream <: SFMLSoundStream<SoundStream> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init(onGetData!: SoundStreamGetDataCallback, onSeek!: SoundStreamSeekCallback, channelCount!: UInt32,
        sampleRate!: UInt32, channelMap!: Array<SoundChannel>, userData!: CPointer<Unit>) {
        unsafe {
            let rawChannelMap = acquireArrayRawData(channelMap)
            m_handle = sfSoundStream_create(
                onGetData,
                onSeek,
                channelCount,
                sampleRate,
                rawChannelMap.pointer,
                UIntNative(rawChannelMap.array.size),
                userData
            )
            releaseArrayRawData(rawChannelMap)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSoundStream_destroy(m_handle) }
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
        unsafe { sfSoundStream_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: SoundStream): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: SoundStream): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundSource

    public func play(): Unit {
        unsafe { sfSoundStream_play(m_handle) }
    }

    public func pause(): Unit {
        unsafe { sfSoundStream_pause(m_handle) }
    }

    public func stop(): Unit {
        unsafe { sfSoundStream_stop(m_handle) }
    }

    public prop status: SoundStatus {
        get() {
            unsafe { sfSoundStream_getStatus(m_handle) }
        }
    }

    public mut prop pitch: Float32 {
        get() {
            unsafe { sfSoundStream_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPitch(m_handle, value) }
        }
    }

    public mut prop pan: Float32 {
        get() {
            unsafe { sfSoundStream_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPan(m_handle, value) }
        }
    }

    public mut prop volume: Float32 {
        get() {
            unsafe { sfSoundStream_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setVolume(m_handle, value) }
        }
    }

    public mut prop spatializationEnabled: Bool {
        get() {
            unsafe { sfSoundStream_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setSpatializationEnabled(m_handle, value) }
        }
    }

    public mut prop position: Vector3f {
        get() {
            unsafe { sfSoundStream_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPosition(m_handle, value) }
        }
    }

    public mut prop direction: Vector3f {
        get() {
            unsafe { sfSoundStream_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDirection(m_handle, value) }
        }
    }

    public mut prop cone: SoundSourceCone {
        get() {
            unsafe { sfSoundStream_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setCone(m_handle, value) }
        }
    }

    public mut prop velocity: Vector3f {
        get() {
            unsafe { sfSoundStream_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setVelocity(m_handle, value) }
        }
    }

    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfSoundStream_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDopplerFactor(m_handle, value) }
        }
    }

    public mut prop directionalAttenuationFactor: Float32 {
        get() {
            unsafe { sfSoundStream_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDirectionalAttenuationFactor(m_handle, value) }
        }
    }

    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfSoundStream_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setRelativeToListener(m_handle, value) }
        }
    }

    public mut prop minDistance: Float32 {
        get() {
            unsafe { sfSoundStream_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMinDistance(m_handle, value) }
        }
    }

    public mut prop maxDistance: Float32 {
        get() {
            unsafe { sfSoundStream_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMaxDistance(m_handle, value) }
        }
    }

    public mut prop minGain: Float32 {
        get() {
            unsafe { sfSoundStream_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMinGain(m_handle, value) }
        }
    }

    public mut prop maxGain: Float32 {
        get() {
            unsafe { sfSoundStream_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMaxGain(m_handle, value) }
        }
    }

    public mut prop attenuation: Float32 {
        get() {
            unsafe { sfSoundStream_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setAttenuation(m_handle, value) }
        }
    }

    public func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit {
        match (effectProcessor) {
            case Some(effectProcessor) => unsafe { sfSoundStream_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfSoundStream_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // SFMLSoundStream

    public mut prop loop: Bool {
        get() {
            unsafe { sfSoundStream_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setLooping(m_handle, value) }
        }
    }

    public prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundStream_getChannelCount(m_handle) }
        }
    }

    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundStream_getSampleRate(m_handle) }
        }
    }

    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfSoundStream_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }

    public mut prop playingOffset: Time {
        get() {
            unsafe { sfSoundStream_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPlayingOffset(m_handle, value) }
        }
    }
}
