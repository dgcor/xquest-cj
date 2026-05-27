package cjsfml.audio

import cjsfml.system.{SFMLNullHandleException, Time, Vector3f}

/**
 * Structure defining a chunk of audio data to stream.
 */
@C
public struct SoundStreamChunk {
    /**
     * Construct a SoundStreamChunk.
     *
     * @param samples Pointer to the audio samples.
     * @param sampleCount Number of samples pointed by Samples.
     */
    public SoundStreamChunk(
        public var samples!: CPointer<Int16> = CPointer(), // Pointer to the audio samples
        public var sampleCount!: UInt32 = 0 // Number of samples pointed by Samples
    ) {}
}

/**
 * Callback type for getting data from a sound stream.
 */
type SoundStreamGetDataCallback = CFunc<(data: CPointer<SoundStreamChunk>, userData: CPointer<Unit>) -> Bool>

/**
 * Callback type for seeking in a sound stream.
 */
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

/**
 * Abstract base class for streamed audio sources.
 *
 * Unlike audio buffers (see `SoundBuffer`), audio streams
 * are never completely loaded in memory. Instead, the audio
 * data is acquired continuously while the stream is playing.
 * This behavior allows to play a sound with no loading delay,
 * and keeps the memory consumption very low.
 *
 * Sound sources that need to be streamed are usually big files
 * (compressed audio musics that would eat hundreds of MB in memory)
 * or files that would take a lot of time to be received
 * (sounds played over the network).
 *
 * `SoundStream` is a base class that doesn't care about the
 * stream source, which is left to the derived class. SFML provides
 * a built-in specialization for big files (see `Music`).
 * No network stream source is provided, but you can write your own
 * by combining this class with the network module.
 *
 * A derived class has to override two virtual functions:
 * - `onGetData` fills a new chunk of audio data to be played
 * - `onSeek` changes the current playing position in the source
 *
 * It is important to note that each SoundStream is played in its
 * own separate thread, so that the streaming loop doesn't block the
 * rest of the program. In particular, the `onGetData` and `onSeek`
 * virtual functions may sometimes be called from this separate thread.
 * It is important to keep this in mind, because you may have to take
 * care of synchronization issues if you share data between threads.
 *
 * Usage example:
 * ```
 * class CustomStream <: SoundStream {
 *     public init() {
 *         // Open the source and get audio settings
 *         ...
 *         let channelCount: UInt32 = 2 // Stereo
 *         let sampleRate: UInt32 = 44100 // 44100 Hz
 *
 *         // Initialize the stream -- important!
 *         // This would typically be done via a factory or init method
 *         // calling the underlying creation function.
 *         super.init(onGetData, onSeek, channelCount, sampleRate, channelMap, userData)
 *     }
 *
 *     @C
 *     private static func onGetData(data: CPointer<SoundStreamChunk>, userData: CPointer<Unit>): Bool {
 *         // Fill the chunk with audio data from the stream source
 *         // (note: must not be empty if you want to continue playing)
 *         // ...
 *         return true // Return true to continue playing
 *     }
 *
 *     @C
 *     private static func onSeek(timeOffset: Time, userData: CPointer<Unit>): Unit {
 *         // Change the current position in the stream source
 *         // ...
 *     }
 * }
 *
 * // Usage
 * let stream = CustomStream()
 * stream.play()
 * ```
 *
 * @see Music
 */
public class SoundStream <: SFMLSoundStream<SoundStream> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the sound stream.
     *
     * This constructor initializes the stream with the necessary callbacks and parameters.
     *
     * @param onGetData Callback providing the audio data chunks.
     * @param onSeek Callback to seek in the stream.
     * @param channelCount Number of channels of the stream.
     * @param sampleRate Sample rate, in samples per second.
     * @param channelMap Map of position in sample frame to sound channel.
     * @param userData User data passed to the callbacks.
     * @throws SFMLNullHandleException If the stream creation fails.
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

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    public func isClosed(): Bool {
        m_handle.isNull()
    }

    /**
     * Closes the resource and releases the internal sound stream object.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSoundStream_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal sound stream object.
     */
    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    /**
     * Checks if this stream is equal to another stream based on their internal handles.
     *
     * @param right The other stream to compare with.
     * @return `true` if the handles are equal; `false` otherwise.
     */
    public override operator func ==(right: SoundStream): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    /**
     * Checks if this stream is not equal to another stream based on their internal handles.
     *
     * @param right The other stream to compare with.
     * @return `true` if the handles are not equal; `false` otherwise.
     */
    public override operator func !=(right: SoundStream): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundSource

    /**
     * Start or resume playing the audio stream.
     *
     * This function starts the stream if it was stopped, resumes
     * it if it was paused, and restarts it from the beginning if
     * it was already playing.
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the stream is played.
     *
     * @see pause
     * @see stop
     */
    public func play(): Unit {
        unsafe { sfSoundStream_play(m_handle) }
    }

    /**
     * Pause the audio stream.
     *
     * This function pauses the stream if it was playing,
     * otherwise (stream already paused or stopped) it has no effect.
     *
     * @see play
     * @see stop
     */
    public func pause(): Unit {
        unsafe { sfSoundStream_pause(m_handle) }
    }

    /**
     * Stop playing the audio stream.
     *
     * This function stops the stream if it was playing or paused,
     * and does nothing if it was already stopped.
     * It also resets the playing position (unlike `pause()`).
     *
     * @see play
     * @see pause
     */
    public func stop(): Unit {
        unsafe { sfSoundStream_stop(m_handle) }
    }

    /**
     * The current status of the stream (stopped, paused, playing).
     */
    public prop status: SoundStatus {
        get() {
            unsafe { sfSoundStream_getStatus(m_handle) }
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
            unsafe { sfSoundStream_getPitch(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPitch(m_handle, value) }
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
            unsafe { sfSoundStream_getPan(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPan(m_handle, value) }
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
            unsafe { sfSoundStream_getVolume(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setVolume(m_handle, value) }
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
            unsafe { sfSoundStream_isSpatializationEnabled(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setSpatializationEnabled(m_handle, value) }
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
            unsafe { sfSoundStream_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPosition(m_handle, value) }
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
            unsafe { sfSoundStream_getDirection(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDirection(m_handle, value) }
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
            unsafe { sfSoundStream_getCone(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setCone(m_handle, value) }
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
            unsafe { sfSoundStream_getVelocity(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setVelocity(m_handle, value) }
        }
    }

    /**
     * The doppler factor of the sound.
     *
     * The doppler factor determines how strong the doppler shift will be.
     */
    public mut prop dopplerFactor: Float32 {
        get() {
            unsafe { sfSoundStream_getDopplerFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDopplerFactor(m_handle, value) }
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
            unsafe { sfSoundStream_getDirectionalAttenuationFactor(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setDirectionalAttenuationFactor(m_handle, value) }
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
            unsafe { sfSoundStream_isRelativeToListener(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setRelativeToListener(m_handle, value) }
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
            unsafe { sfSoundStream_getMinDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMinDistance(m_handle, value) }
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
            unsafe { sfSoundStream_getMaxDistance(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMaxDistance(m_handle, value) }
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
            unsafe { sfSoundStream_getMinGain(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMinGain(m_handle, value) }
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
            unsafe { sfSoundStream_getMaxGain(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setMaxGain(m_handle, value) }
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
            unsafe { sfSoundStream_getAttenuation(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setAttenuation(m_handle, value) }
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
            case Some(effectProcessor) => unsafe { sfSoundStream_setEffectProcessor(m_handle, effectProcessor) }
            case None => unsafe { sfSoundStream_setEffectProcessor(m_handle, CPointer()) }
        }
    }

    // SFMLSoundStream

    /**
     * Whether or not the stream should loop after reaching the end.
     *
     * If set, the stream will restart from beginning after
     * reaching the end and so on, until it is stopped or
     * `loop` is set to `false`.
     * The default looping state for streams is `false`.
     */
    public mut prop loop: Bool {
        get() {
            unsafe { sfSoundStream_isLooping(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setLooping(m_handle, value) }
        }
    }

    /**
     * The number of channels of the stream.
     *
     * 1 channel means a mono sound, 2 means stereo, etc.
     */
    public prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundStream_getChannelCount(m_handle) }
        }
    }

    /**
     * The stream sample rate of the stream.
     *
     * The sample rate is the number of audio samples played per
     * second. The higher, the better the quality.
     */
    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundStream_getSampleRate(m_handle) }
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
            let channelsPtr = unsafe { sfSoundStream_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }

    /**
     * The current playing position of the stream.
     *
     * The playing position can be changed when the stream is
     * either paused or playing. Changing the playing position
     * when the stream is stopped has no effect, since playing
     * the stream would reset its position.
     */
    public mut prop playingOffset: Time {
        get() {
            unsafe { sfSoundStream_getPlayingOffset(m_handle) }
        }
        set(value) {
            unsafe { sfSoundStream_setPlayingOffset(m_handle, value) }
        }
    }
}
