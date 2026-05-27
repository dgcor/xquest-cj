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

/**
 * Structure defining a time range.
 */
@C
public struct TimeSpan {
    /**
     * Construct a TimeSpan.
     *
     * @param offset The beginning offset of the time range.
     * @param length The length of the time range.
     */
    public TimeSpan(
        public var offset!: Time = Time.ZERO, // The beginning offset of the time range
        public var length!: Time = Time.ZERO // The length of the time range
    ) {}
}

/**
 * Streamed music played from an audio file.
 *
 * Musics are sounds that are streamed rather than completely
 * loaded in memory. This is especially useful for compressed
 * musics that usually take hundreds of MB when they are
 * uncompressed: by streaming it instead of loading it entirely,
 * you avoid saturating the memory and have almost no loading delay.
 * This implies that the underlying resource (file, stream or
 * memory buffer) must remain valid for the lifetime of the
 * `Music` object.
 *
 * Apart from that, a `Music` has almost the same features as
 * the `SoundBuffer` / `Sound` pair: you can play/pause/stop
 * it, request its parameters (channels, sample rate), change
 * the way it is played (pitch, volume, 3D position, ...), etc.
 *
 * As a sound stream, a music is played in its own thread in order
 * not to block the rest of the program. This means that you can
 * leave the music alone after calling `play()`, it will manage itself
 * very well.
 *
 * Usage example:
 * ```
 * // Open a music from an audio file
 * let music = Music("music.ogg")
 *
 * // Change some parameters
 * music.position = Vector3f(0, 1, 10) // change its 3D position
 * music.pitch = 2                     // increase the pitch
 * music.volume = 50                   // reduce the volume
 * music.loop = true                   // make it loop
 *
 * // Play it
 * music.play()
 * ```
 *
 * @see Sound
 * @see SoundStream
 */
public class Music <: SFMLSoundStream<Music> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a music from an audio file.
     *
     * This function doesn't start playing the music (call `play()`
     * to do so).
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * \warning Since the music is not loaded at once but rather
     * streamed continuously, the file must remain accessible until
     * the `Music` object loads a new music or is destroyed.
     *
     * @param filename Path of the music file to open.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct a music from an audio file in memory.
     *
     * This function doesn't start playing the music (call `play()`
     * to do so).
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * \warning Since the music is not loaded at once but rather streamed
     * continuously, the `data` buffer must remain accessible until
     * the `Music` object loads a new music or is destroyed. That is,
     * you can't deallocate the buffer right after calling this function.
     *
     * @param data Array containing the file data in memory.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct a music from an audio file in a custom stream.
     *
     * This function doesn't start playing the music (call `play()`
     * to do so).
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * \warning Since the music is not loaded at once but rather
     * streamed continuously, the `stream` must remain accessible
     * until the `Music` object loads a new music or is destroyed.
     *
     * @param stream Source stream to read from.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    public func isClosed(): Bool {
        m_handle.isNull()
    }

    /**
     * Closes the resource and releases the internal music object.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfMusic_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal music object.
     */
    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    /**
     * Checks if this music is equal to another music based on their internal handles.
     *
     * @param right The other music to compare with.
     * @return `true` if the handles are equal; `false` otherwise.
     */
    public override operator func ==(right: Music): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    /**
     * Checks if this music is not equal to another music based on their internal handles.
     *
     * @param right The other music to compare with.
     * @return `true` if the handles are not equal; `false` otherwise.
     */
    public override operator func !=(right: Music): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundSource

    /**
     * Start or resume playing the music.
     *
     * This function starts the stream if it was stopped, resumes
     * it if it was paused, and restarts it from the beginning if
     * it was already playing.
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the music is played.
     *
     * @see pause
     * @see stop
     */
    public func play(): Unit {
        unsafe { sfMusic_play(m_handle) }
    }

    /**
     * Pause the music.
     *
     * This function pauses the music if it was playing,
     * otherwise (music already paused or stopped) it has no effect.
     *
     * @see play
     * @see stop
     */
    public func pause(): Unit {
        unsafe { sfMusic_pause(m_handle) }
    }

    /**
     * Stop playing the music.
     *
     * This function stops the music if it was playing or paused,
     * and does nothing if it was already stopped.
     * It also resets the playing position (unlike `pause()`).
     *
     * @see play
     * @see pause
     */
    public func stop(): Unit {
        unsafe { sfMusic_stop(m_handle) }
    }

    /**
     * The current status of the music (stopped, paused, playing).
     */
    public prop status: SoundStatus {
        get() {
            unsafe { sfMusic_getStatus(m_handle) }
        }
    }

    /**
     * The pitch of the music.
     *
     * The pitch represents the perceived fundamental frequency of a sound; thus you
     * can make a sound more acute or grave by changing its pitch. A side effect of
     * changing the pitch is to modify the playing speed of the music as well.
     * The default value for the pitch is 1.
     */
    public mut prop pitch: Float32 {
        get() {
            unsafe { sfMusic_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPitch(m_handle, value) }
        }
    }

    /**
     * The pan of the music.
     *
     * Using panning, a mono sound can be panned between stereo channels. When the pan
     * is set to -1, the sound is played only on the left channel, when the pan is set
     * to +1, the sound is played only on the right channel.
     */
    public mut prop pan: Float32 {
        get() {
            unsafe { sfMusic_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPan(m_handle, value) }
        }
    }

    /**
     * The volume of the music.
     *
     * The volume is a value between 0 (mute) and 100 (full volume).
     * The default value for the volume is 100.
     */
    public mut prop volume: Float32 {
        get() {
            unsafe { sfMusic_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setVolume(m_handle, value) }
        }
    }

    /**
     * Whether spatialization of the music is enabled.
     *
     * Spatialization is the application of various effects to simulate a sound being
     * emitted at a virtual position in 3D space and exhibiting various physical phenomena
     * such as directional attenuation and doppler shift.
     */
    public mut prop spatializationEnabled: Bool {
        get() {
            unsafe { sfMusic_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setSpatializationEnabled(m_handle, value) }
        }
    }

    /**
     * The 3D position of the music in the audio scene.
     *
     * Only sounds with one channel (mono sounds) can be spatialized.
     * The default position of a sound is (0, 0, 0).
     */
    public mut prop position: Vector3f {
        get() {
            unsafe { sfMusic_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPosition(m_handle, value) }
        }
    }

    /**
     * The 3D direction of the music in the audio scene.
     *
     * The direction defines where the sound source is facing in 3D space. It will affect
     * how the sound is attenuated if facing away from the listener.
     * The default direction of a sound is (0, 0, -1).
     */
    public mut prop direction: Vector3f {
        get() {
            unsafe { sfMusic_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDirection(m_handle, value) }
        }
    }

    /**
     * The cone properties of the music in the audio scene.
     *
     * The cone defines how directional attenuation is applied.
     * The default cone of a sound is (2 * PI, 2 * PI, 1).
     */
    public mut prop cone: SoundSourceCone {
        get() {
            unsafe { sfMusic_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setCone(m_handle, value) }
        }
    }

    /**
     * The 3D velocity of the music in the audio scene.
     *
     * The velocity is used to determine how to doppler shift the sound. Sounds moving
     * towards the listener will be perceived to have a higher pitch and sounds moving
     * away from the listener will be perceived to have a lower pitch.
     */
    public mut prop velocity: Vector3f {
        get() {
            unsafe { sfMusic_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setVelocity(m_handle, value) }
        }
    }

    /**
     * The doppler factor of the music.
     *
     * The doppler factor determines how strong the doppler shift will be.
     */
    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfMusic_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDopplerFactor(m_handle, value) }
        }
    }

    /**
     * The directional attenuation factor of the music.
     *
     * Depending on the virtual position of an output channel relative to the listener
     * (such as in surround sound setups), sounds will be attenuated when emitting them
     * from certain channels. This factor determines how strong the attenuation based on
     * output channel position relative to the listener is.
     */
    public mut prop directionalAttenuationFactor: Float32 {
        get() {
            unsafe { sfMusic_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setDirectionalAttenuationFactor(m_handle, value) }
        }
    }

    /**
     * Whether the music's position is relative to the listener or absolute.
     *
     * Making a sound relative to the listener will ensure that it will always be played
     * the same way regardless of the position of the listener. This can be useful for
     * non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it.
     * The default value is `false` (position is absolute).
     */
    public mut prop relativeToListener: Bool {
        get() {
            unsafe { sfMusic_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setRelativeToListener(m_handle, value) }
        }
    }

    /**
     * The minimum distance of the music.
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
            unsafe { sfMusic_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMinDistance(m_handle, value) }
        }
    }

    /**
     * The maximum distance of the music.
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
            unsafe { sfMusic_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMaxDistance(m_handle, value) }
        }
    }

    /**
     * The minimum gain of the music.
     *
     * When the sound is further away from the listener than the "maximum distance" the
     * attenuated gain is clamped so it cannot go below the minimum gain value.
     *
     * @see attenuation
     */
    public mut prop minGain: Float32 {
        get() {
            unsafe { sfMusic_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMinGain(m_handle, value) }
        }
    }

    /**
     * The maximum gain of the music.
     *
     * When the sound is closer from the listener than the "minimum distance" the
     * attenuated gain is clamped so it cannot go above the maximum gain value.
     *
     * @see attenuation
     */
    public mut prop maxGain: Float32 {
        get() {
            unsafe { sfMusic_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setMaxGain(m_handle, value) }
        }
    }

    /**
     * The attenuation factor of the music.
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
            unsafe { sfMusic_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setAttenuation(m_handle, value) }
        }
    }

    /**
     * Set the effect processor to be applied to the music.
     *
     * The effect processor is a callable that will be called with sound data to be processed.
     *
     * @param effectProcessor The effect processor to attach to this music, pass `None` to disable processing.
     */
    public func setEffectProcessor(effectProcessor: ?EffectProcessor): Unit {
        match (effectProcessor) {
            case Some(effectProcessor) => unsafe { sfMusic_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfMusic_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // SFMLSoundStream

    /**
     * Whether or not the music should loop after reaching the end.
     *
     * If set, the music will restart from beginning after
     * reaching the end and so on, until it is stopped or
     * `loop` is set to `false`.
     * The default looping state for music is `false`.
     */
    public mut prop loop: Bool {
        get() {
            unsafe { sfMusic_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setLooping(m_handle, value) }
        }
    }

    /**
     * The number of channels of the music.
     *
     * 1 channel means a mono sound, 2 means stereo, etc.
     */
    public prop channelCount: UInt32 {
        get() {
            unsafe { sfMusic_getChannelCount(m_handle) }
        }
    }

    /**
     * The sample rate of the music.
     *
     * The sample rate is the number of audio samples played per
     * second. The higher, the better the quality.
     */
    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfMusic_getSampleRate(m_handle) }
        }
    }

    /**
     * The map of position in sample frame to sound channel.
     *
     * This is used to map a sample in the sample stream to a
     * position during spatialization.
     */
    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfMusic_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }

    /**
     * The current playing position of the music.
     *
     * The playing position can be changed when the music is
     * either paused or playing. Changing the playing position
     * when the music is stopped has no effect, since playing
     * the music would reset its position.
     */
    public mut prop playingOffset: Time {
        get() {
            unsafe { sfMusic_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setPlayingOffset(m_handle, value) }
        }
    }

    // Music

    /**
     * The total duration of the music.
     */
    public prop duration: Time {
        get() {
            unsafe { sfMusic_getDuration(m_handle) }
        }
    }

    /**
     * The positions of the of the sound's looping sequence.
     *
     * \warning Since `loopPoints` setter performs some adjustments on the
     * provided values and rounds them to internal samples, a call to
     * `loopPoints` getter is not guaranteed to return the same times passed
     * into a previous call to `loopPoints` setter. However, it is guaranteed
     * to return times that will map to the valid internal samples of
     * this Music if they are later passed to `loopPoints` setter.
     *
     * @see loopPoints
     */
    public mut prop loopPoints: TimeSpan {
        get() {
            unsafe { sfMusic_getLoopPoints(m_handle) }
        }
        set(value) {
            unsafe { sfMusic_setLoopPoints(m_handle, value) }
        }
    }
}
