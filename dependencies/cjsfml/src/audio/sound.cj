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

/**
 * Regular sound that can be played in the audio environment.
 *
 * `Sound` is the class to use to play sounds.
 * It provides:
 * - Control (play, pause, stop)
 * - Ability to modify output parameters in real-time (pitch, volume, ...)
 * - 3D spatial features (position, attenuation, ...).
 *
 * `Sound` is perfect for playing short sounds that can
 * fit in memory and require no latency, like foot steps or
 * gun shots. For longer sounds, like background musics
 * or long speeches, rather see `Music` (which is based
 * on streaming).
 *
 * In order to work, a sound must be given a buffer of audio
 * data to play. Audio data (samples) is stored in `SoundBuffer`,
 * and attached to a sound when it is created or with the `buffer` property.
 * The buffer object attached to a sound must remain alive
 * as long as the sound uses it. Note that multiple sounds
 * can use the same sound buffer at the same time.
 *
 * Usage example:
 * ```
 * let buffer = SoundBuffer("sound.wav")
 * let sound = Sound(buffer)
 * sound.play()
 * ```
 *
 * @see SoundBuffer
 * @see Music
 */
public class Sound <: SoundSource<Sound> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the sound with a buffer.
     *
     * @param buffer Sound buffer containing the audio data to play with the sound.
     * @throws SFMLNullHandleException If the sound creation fails.
     */
    public init(buffer: SoundBuffer) {
        m_handle = unsafe { sfSound_create(buffer.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the sound from an existing handle.
     *
     * @param handle The handle to the internal sound object.
     * @throws SFMLNullHandleException If the handle is null.
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

    /**
     * Creates a copy of the sound.
     *
     * @return A new `Sound` instance that is a copy of this sound.
     */
    public func clone(): Sound {
        Sound(unsafe { sfSound_copy(m_handle) })
    }

    // ResourceHandle

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    public func isClosed(): Bool {
        m_handle.isNull()
    }

    /**
     * Closes the resource and releases the internal sound object.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSound_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal sound object.
     */
    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    /**
     * Checks if this sound is equal to another sound based on their internal handles.
     *
     * @param right The other sound to compare with.
     * @return `true` if the handles are equal; `false` otherwise.
     */
    public override operator func ==(right: Sound): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    /**
     * Checks if this sound is not equal to another sound based on their internal handles.
     *
     * @param right The other sound to compare with.
     * @return `true` if the handles are not equal; `false` otherwise.
     */
    public override operator func !=(right: Sound): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundSource

    /**
     * Start or resume playing the sound.
     *
     * This function starts the stream if it was stopped, resumes
     * it if it was paused, and restarts it from beginning if it
     * was it already playing.
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the sound is played.
     *
     * @see pause
     * @see stop
     */
    public func play(): Unit {
        unsafe { sfSound_play(m_handle) }
    }

    /**
     * Pause the sound.
     *
     * This function pauses the sound if it was playing,
     * otherwise (sound already paused or stopped) it has no effect.
     *
     * @see play
     * @see stop
     */
    public func pause(): Unit {
        unsafe { sfSound_pause(m_handle) }
    }

    /**
     * Stop playing the sound.
     *
     * This function stops the sound if it was playing or paused,
     * and does nothing if it was already stopped.
     * It also resets the playing position (unlike `pause()`).
     *
     * @see play
     * @see pause
     */
    public func stop(): Unit {
        unsafe { sfSound_stop(m_handle) }
    }

    /**
     * The current status of the sound (stopped, paused, playing).
     */
    public prop status: SoundStatus {
        get() {
            unsafe { sfSound_getStatus(m_handle) }
        }
    }

    /**
     * The pitch of the sound.
     *
     * The pitch represents the perceived fundamental frequency of a sound; thus you
     * can make a sound more acute or grave by changing its pitch. A side effect of
     * changing the pitch is to modify the playing speed of the sound as well.
     * The default value for the pitch is 1.
     */
    public mut prop pitch: Float32 {
        get() {
            unsafe { sfSound_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPitch(m_handle, value) }
        }
    }

    /**
     * The pan of the sound.
     *
     * Using panning, a mono sound can be panned between stereo channels. When the pan
     * is set to -1, the sound is played only on the left channel, when the pan is set
     * to +1, the sound is played only on the right channel.
     */
    public mut prop pan: Float32 {
        get() {
            unsafe { sfSound_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPan(m_handle, value) }
        }
    }

    /**
     * The volume of the sound.
     *
     * The volume is a value between 0 (mute) and 100 (full volume).
     * The default value for the volume is 100.
     */
    public mut prop volume: Float32 {
        get() {
            unsafe { sfSound_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setVolume(m_handle, value) }
        }
    }

    /**
     * Whether spatialization of the sound is enabled.
     *
     * Spatialization is the application of various effects to simulate a sound being
     * emitted at a virtual position in 3D space and exhibiting various physical phenomena
     * such as directional attenuation and doppler shift.
     */
    public mut prop spatializationEnabled: Bool {
        get() {
            unsafe { sfSound_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setSpatializationEnabled(m_handle, value) }
        }
    }

    /**
     * The 3D position of the sound in the audio scene.
     *
     * Only sounds with one channel (mono sounds) can be spatialized.
     * The default position of a sound is (0, 0, 0).
     */
    public mut prop position: Vector3f {
        get() {
            unsafe { sfSound_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPosition(m_handle, value) }
        }
    }

    /**
     * The 3D direction of the sound in the audio scene.
     *
     * The direction defines where the sound source is facing in 3D space. It will affect
     * how the sound is attenuated if facing away from the listener.
     * The default direction of a sound is (0, 0, -1).
     */
    public mut prop direction: Vector3f {
        get() {
            unsafe { sfSound_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDirection(m_handle, value) }
        }
    }

    /**
     * The cone properties of the sound in the audio scene.
     *
     * The cone defines how directional attenuation is applied.
     * The default cone of a sound is (2 * PI, 2 * PI, 1).
     */
    public mut prop cone: SoundSourceCone {
        get() {
            unsafe { sfSound_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setCone(m_handle, value) }
        }
    }

    /**
     * The 3D velocity of the sound in the audio scene.
     *
     * The velocity is used to determine how to doppler shift the sound. Sounds moving
     * towards the listener will be perceived to have a higher pitch and sounds moving
     * away from the listener will be perceived to have a lower pitch.
     */
    public mut prop velocity: Vector3f {
        get() {
            unsafe { sfSound_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setVelocity(m_handle, value) }
        }
    }

    /**
     * The doppler factor of the sound.
     *
     * The doppler factor determines how strong the doppler shift will be.
     */
    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfSound_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDopplerFactor(m_handle, value) }
        }
    }

    /**
     * The directional attenuation factor of the sound.
     *
     * Depending on the virtual position of an output channel relative to the listener
     * (such as in surround sound setups), sounds will be attenuated when emitting them
     * from certain channels. This factor determines how strong the attenuation based on
     * output channel position relative to the listener is.
     */
    public mut prop directionalAttenuationFactor: Float32 {
        get() {
            unsafe { sfSound_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setDirectionalAttenuationFactor(m_handle, value) }
        }
    }

    /**
     * Whether the sound's position is relative to the listener or absolute.
     *
     * Making a sound relative to the listener will ensure that it will always be played
     * the same way regardless of the position of the listener. This can be useful for
     * non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it.
     * The default value is `false` (position is absolute).
     */
    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfSound_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setRelativeToListener(m_handle, value) }
        }
    }

    /**
     * The minimum distance of the sound.
     *
     * The "minimum distance" of a sound is the maximum distance at which it is heard at
     * its maximum volume. Further than the minimum distance, it will start to fade out
     * according to its attenuation factor. A value of 0 ("inside the head of the listener")
     * is an invalid value and is forbidden.
     * The default value of the minimum distance is 1.
     *
     * @see attenuation
     */
    public mut prop minDistance: Float32 {
        get() {
            unsafe { sfSound_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMinDistance(m_handle, value) }
        }
    }

    /**
     * The maximum distance of the sound.
     *
     * The "maximum distance" of a sound is the minimum distance at which it is heard at
     * its minimum volume. Closer than the maximum distance, it will start to fade in
     * according to its attenuation factor.
     * The default value of the maximum distance is the maximum value a float can represent.
     *
     * @see attenuation
     */
    public mut prop maxDistance: Float32 {
        get() {
            unsafe { sfSound_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMaxDistance(m_handle, value) }
        }
    }

    /**
     * The minimum gain of the sound.
     *
     * When the sound is further away from the listener than the "maximum distance" the
     * attenuated gain is clamped so it cannot go below the minimum gain value.
     *
     * @see attenuation
     */
    public mut prop minGain: Float32 {
        get() {
            unsafe { sfSound_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMinGain(m_handle, value) }
        }
    }

    /**
     * The maximum gain of the sound.
     *
     * When the sound is closer from the listener than the "minimum distance" the
     * attenuated gain is clamped so it cannot go above the maximum gain value.
     *
     * @see attenuation
     */
    public mut prop maxGain: Float32 {
        get() {
            unsafe { sfSound_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setMaxGain(m_handle, value) }
        }
    }

    /**
     * The attenuation factor of the sound.
     *
     * The attenuation is a multiplicative factor which makes the sound more or less loud
     * according to its distance from the listener. An attenuation of 0 will produce a
     * non-attenuated sound, i.e. its volume will always be the same whether it is heard
     * from near or from far. On the other hand, an attenuation value such as 100 will make
     * the sound fade out very quickly as it gets further from the listener.
     * The default value of the attenuation is 1.
     *
     * @see minDistance
     */
    public mut prop attenuation: Float32 {
        get() {
            unsafe { sfSound_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setAttenuation(m_handle, value) }
        }
    }

    /**
     * Set the effect processor to be applied to the sound.
     *
     * The effect processor is a callable that will be called with sound data to be processed.
     *
     * @param effectProcessor The effect processor to attach to this sound, pass `None` to disable processing.
     */
    public func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit {
        match (effectProcessor) {
            case Some(effectProcessor) => unsafe { sfSound_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfSound_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // Sound

    /**
     * The source buffer containing the audio data to play.
     *
     * It is important to note that the sound buffer is not copied,
     * thus the `SoundBuffer` instance must remain alive as long
     * as it is attached to the sound.
     *
     * Setting this property to `None` detaches the current buffer.
     */
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

    /**
     * Whether or not the sound should loop after reaching the end.
     *
     * If set, the sound will restart from beginning after
     * reaching the end and so on, until it is stopped or
     * `loop` is set to `false`.
     * The default looping state for sound is `false`.
     */
    public mut prop loop: Bool {
        get() {
            unsafe { sfSound_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setLooping(m_handle, value) }
        }
    }

    /**
     * The current playing position of the sound.
     *
     * The playing position can be changed when the sound is
     * either paused or playing. Changing the playing position
     * when the sound is stopped has no effect, since playing
     * the sound will reset its position.
     */
    public mut prop playingOffset: Time {
        get() {
            unsafe { sfSound_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfSound_setPlayingOffset(m_handle, value) }
        }
    }
}
