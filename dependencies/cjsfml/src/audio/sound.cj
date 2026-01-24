package cjsfml.audio

import cjsfml.system.{SFMLNullHandleException, Time, Vector3f}

foreign {
    func sfSound_create(buffer: CPointer<Unit>): CPointer<Unit>

    func sfSound_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfSound_destroy(handle: CPointer<Unit>): Unit

    func sfSound_setBuffer(handle: CPointer<Unit>, buffer: CPointer<Unit>): Unit

    func sfSound_getBuffer(handle: CPointer<Unit>): CPointer<Unit>

    func sfSound_setLooping(handle: CPointer<Unit>, loop: Bool): Unit

    func sfSound_isLooping(handle: CPointer<Unit>): Bool

    func sfSound_play(handle: CPointer<Unit>): Unit

    func sfSound_pause(handle: CPointer<Unit>): Unit

    func sfSound_stop(handle: CPointer<Unit>): Unit

    func sfSound_getStatus(handle: CPointer<Unit>): SoundStatus

    func sfSound_getPlayingOffset(handle: CPointer<Unit>): Time

    func sfSound_setPitch(handle: CPointer<Unit>, pitch: Float32): Unit

    func sfSound_setPan(handle: CPointer<Unit>, pan: Float32): Unit

    func sfSound_setVolume(handle: CPointer<Unit>, volume: Float32): Unit

    func sfSound_setSpatializationEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfSound_setPosition(handle: CPointer<Unit>, position: Vector3f): Unit

    func sfSound_setDirection(handle: CPointer<Unit>, direction: Vector3f): Unit

    func sfSound_setCone(handle: CPointer<Unit>, cone: SoundSourceCone): Unit

    func sfSound_setVelocity(handle: CPointer<Unit>, velocity: Vector3f): Unit

    func sfSound_setDopplerFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfSound_setDirectionalAttenuationFactor(handle: CPointer<Unit>, factor: Float32): Unit

    func sfSound_setRelativeToListener(handle: CPointer<Unit>, relative: Bool): Unit

    func sfSound_setMinDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfSound_setMaxDistance(handle: CPointer<Unit>, distance: Float32): Unit

    func sfSound_setMinGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfSound_setMaxGain(handle: CPointer<Unit>, gain: Float32): Unit

    func sfSound_setAttenuation(handle: CPointer<Unit>, attenuation: Float32): Unit

    func sfSound_setPlayingOffset(handle: CPointer<Unit>, timeOffset: Time): Unit

    func sfSound_setEffectProcessor(handle: CPointer<Unit>, effectProcessor: EffectProcessor): Unit

    func sfSound_getPitch(handle: CPointer<Unit>): Float32

    func sfSound_getPan(handle: CPointer<Unit>): Float32

    func sfSound_isSpatializationEnabled(handle: CPointer<Unit>): Bool

    func sfSound_getVolume(handle: CPointer<Unit>): Float32

    func sfSound_getPosition(handle: CPointer<Unit>): Vector3f

    func sfSound_getDirection(handle: CPointer<Unit>): Vector3f

    func sfSound_getCone(handle: CPointer<Unit>): SoundSourceCone

    func sfSound_getVelocity(handle: CPointer<Unit>): Vector3f

    func sfSound_getDopplerFactor(handle: CPointer<Unit>): Float32

    func sfSound_getDirectionalAttenuationFactor(handle: CPointer<Unit>): Float32

    func sfSound_isRelativeToListener(handle: CPointer<Unit>): Bool

    func sfSound_getMinDistance(handle: CPointer<Unit>): Float32

    func sfSound_getMaxDistance(handle: CPointer<Unit>): Float32

    func sfSound_getMinGain(handle: CPointer<Unit>): Float32

    func sfSound_getMaxGain(handle: CPointer<Unit>): Float32

    func sfSound_getAttenuation(handle: CPointer<Unit>): Float32
}

public class Sound <: SoundSource<Sound> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * @throws SFMLNullHandleException
     */
    public init(buffer: SoundBuffer) {
        m_handle = unsafe { sfSound_create(buffer.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
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
            unsafe { sfSound_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone(): Sound {
        Sound(unsafe { sfSound_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSound_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: Sound): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Sound): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundSource

    public func play(): Unit {
        unsafe { sfSound_play(m_handle) }
    }

    public func pause(): Unit {
        unsafe { sfSound_pause(m_handle) }
    }

    public func stop(): Unit {
        unsafe { sfSound_stop(m_handle) }
    }

    public prop status: SoundStatus {
        get() {
            unsafe { sfSound_getStatus(m_handle) }
        }
    }

    public mut prop pitch: Float32 {
        get() {
            unsafe { sfSound_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPitch(m_handle, value) }
        }
    }

    public mut prop pan: Float32 {
        get() {
            unsafe { sfSound_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPan(m_handle, value) }
        }
    }

    public mut prop volume: Float32 {
        get() {
            unsafe { sfSound_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setVolume(m_handle, value) }
        }
    }

    public mut prop spatializationEnabled: Bool {
        get() {
            unsafe { sfSound_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setSpatializationEnabled(m_handle, value) }
        }
    }

    public mut prop position: Vector3f {
        get() {
            unsafe { sfSound_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPosition(m_handle, value) }
        }
    }

    public mut prop direction: Vector3f {
        get() {
            unsafe { sfSound_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDirection(m_handle, value) }
        }
    }

    public mut prop cone: SoundSourceCone {
        get() {
            unsafe { sfSound_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setCone(m_handle, value) }
        }
    }

    public mut prop velocity: Vector3f {
        get() {
            unsafe { sfSound_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setVelocity(m_handle, value) }
        }
    }

    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfSound_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDopplerFactor(m_handle, value) }
        }
    }

    public mut prop directionalAttenuationFactor: Float32 {
        get() {
            unsafe { sfSound_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDirectionalAttenuationFactor(m_handle, value) }
        }
    }

    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfSound_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setRelativeToListener(m_handle, value) }
        }
    }

    public mut prop minDistance: Float32 {
        get() {
            unsafe { sfSound_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMinDistance(m_handle, value) }
        }
    }

    public mut prop maxDistance: Float32 {
        get() {
            unsafe { sfSound_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMaxDistance(m_handle, value) }
        }
    }

    public mut prop minGain: Float32 {
        get() {
            unsafe { sfSound_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMinGain(m_handle, value) }
        }
    }

    public mut prop maxGain: Float32 {
        get() {
            unsafe { sfSound_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMaxGain(m_handle, value) }
        }
    }

    public mut prop attenuation: Float32 {
        get() {
            unsafe { sfSound_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setAttenuation(m_handle, value) }
        }
    }

    public func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit {
        match (effectProcessor) {
            case Some(effectProcessor) => unsafe { sfSound_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfSound_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // Sound

    public mut prop buffer: ?SoundBuffer {
        get() {
            let bufferPtr = unsafe { sfSound_getBuffer(m_handle) }
            if (bufferPtr.isNull()) {
                return None
            }
            SoundBuffer(bufferPtr, isOwner: false)
        }
        set(value) {
            unsafe { sfSound_setBuffer(m_handle, value?.handle ?? CPointer()) }
        }
    }

    public mut prop loop: Bool {
        get() {
            unsafe { sfSound_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setLooping(m_handle, value) }
        }
    }

    public mut prop playingOffset: Time {
        get() {
            unsafe { sfSound_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPlayingOffset(m_handle, value) }
        }
    }
}
