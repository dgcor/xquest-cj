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

/**
 * Storage for audio samples defining a sound.
 *
 * A sound buffer holds the data of a sound, which is
 * an array of audio samples. A sample is a 16 bit signed integer
 * that defines the amplitude of the sound at a given time.
 * The sound is then reconstituted by playing these samples at
 * a high rate (for example, 44100 samples per second is the
 * standard rate used for playing CDs). In short, audio samples
 * are like texture pixels, and a `SoundBuffer` is similar to
 * a `Texture`.
 *
 * A sound buffer can be loaded from a file, from memory, from
 * a custom stream (see `InputStream`) or directly from an array
 * of samples. It can also be saved back to a file.
 *
 * Sound buffers alone are not very useful: they hold the audio data
 * but cannot be played. To do so, you need to use the `Sound` class,
 * which provides functions to play/pause/stop the sound as well as
 * changing the way it is outputted (volume, pitch, 3D position, ...).
 * This separation allows more flexibility and better performances:
 * indeed a `SoundBuffer` is a heavy resource, and any operation on it
 * is slow (often too slow for real-time applications). On the other
 * side, a `Sound` is a lightweight object, which can use the audio data
 * of a sound buffer and change the way it is played without actually
 * modifying that data. Note that it is also possible to bind
 * several `Sound` instances to the same `SoundBuffer`.
 *
 * It is important to note that the `Sound` instance doesn't
 * copy the buffer that it uses, it only keeps a reference to it.
 * Thus, a `SoundBuffer` must not be destructed while it is
 * used by a `Sound` (i.e. never write a function that
 * uses a local `SoundBuffer` instance for loading a sound).
 *
 * When loading sound samples from an array, a channel map needs to be
 * provided, which specifies the mapping of the position in the sample frame
 * to the sound channel. For example when you have six samples in a frame and
 * a 5.1 sound system, the channel map defines how each of those samples map
 * to which speaker channel.
 *
 * Usage example:
 * ```
 * // Load a new sound buffer from a file
 * let buffer = SoundBuffer("sound.wav")
 *
 * // Create a sound source bound to the buffer
 * let sound1 = Sound(buffer)
 *
 * // Play the sound
 * sound1.play()
 *
 * // Create another sound source bound to the same buffer
 * let sound2 = Sound(buffer)
 *
 * // Play it with a higher pitch -- the first sound remains unchanged
 * sound2.pitch = 2
 * sound2.play()
 *
 * // Load samples with a channel map
 * let samples = Array<Int16>(...) // ...
 * let channelMap = Array<SoundChannel>([
 *     SoundChannel.FrontLeft,
 *     SoundChannel.FrontCenter,
 *     SoundChannel.FrontRight,
 *     SoundChannel.BackRight,
 *     SoundChannel.BackLeft,
 *     SoundChannel.LowFrequencyEffects
 * ])
 * let soundBuffer = SoundBuffer(samples, samples.size, channelMap.size, 44100, channelMap)
 * let sound = Sound(soundBuffer)
 * ```
 *
 * @see Sound
 * @see SoundBufferRecorder
 */
public class SoundBuffer <: ResourceHandle & Equatable<SoundBuffer> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * Construct the sound buffer from a file.
     *
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * @param filename Path of the sound file to load.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct the sound buffer from a file in memory.
     *
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * @param data Array containing the file data in memory.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct the sound buffer from a custom stream.
     *
     * See the documentation of `InputSoundFile` for the list
     * of supported formats.
     *
     * @param stream Source stream to read from.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct the sound buffer from an array of audio samples.
     *
     * The assumed format of the audio samples is 16 bit signed integer.
     *
     * @param samples Array of samples in memory.
     * @param sampleCount Number of samples in the array.
     * @param channelCount Number of channels (1 = mono, 2 = stereo, ...).
     * @param sampleRate Sample rate (number of samples to play per second).
     * @param channelMap Map of position in sample frame to sound channel.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct the sound buffer from a pointer to audio samples.
     *
     * The assumed format of the audio samples is 16 bit signed integer.
     *
     * @param samples Pointer to the array of samples in memory.
     * @param sampleCount Number of samples in the array.
     * @param channelCount Number of channels (1 = mono, 2 = stereo, ...).
     * @param sampleRate Sample rate (number of samples to play per second).
     * @param channelMap Map of position in sample frame to sound channel.
     * @throws SFMLNullHandleException If loading was unsuccessful.
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
     * Construct the sound buffer from an existing handle.
     *
     * @param handle The handle to the internal sound buffer object.
     * @param isOwner Whether this instance owns the handle (default `true`).
     * @throws SFMLNullHandleException If the handle is null.
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

    /**
     * Creates a copy of the sound buffer.
     *
     * @return A new `SoundBuffer` instance that is a copy of this buffer.
     */
    public func clone(): SoundBuffer {
        SoundBuffer(unsafe { sfSoundBuffer_copy(m_handle) })
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
     * Closes the resource and releases the internal sound buffer object.
     */
    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfSoundBuffer_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal sound buffer object.
     */
    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    /**
     * Checks if this instance owns the handle.
     */
    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    /**
     * Checks if this sound buffer is equal to another based on their internal handles.
     *
     * @param right The other sound buffer to compare with.
     * @return `true` if the handles are equal; `false` otherwise.
     */
    public override operator func ==(right: SoundBuffer): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    /**
     * Checks if this sound buffer is not equal to another based on their internal handles.
     *
     * @param right The other sound buffer to compare with.
     * @return `true` if the handles are not equal; `false` otherwise.
     */
    public override operator func !=(right: SoundBuffer): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // SoundBuffer

    /**
     * Save the sound buffer to an audio file.
     *
     * See the documentation of `OutputSoundFile` for the list
     * of supported formats.
     *
     * @param filename Path of the sound file to write.
     * @return `true` if saving succeeded, `false` if it failed.
     */
    public func savetoFile(filename: String): Bool {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                return sfSoundBuffer_saveToFile(m_handle, filenameRes.value)
            }
        }
        return false
    }

    /**
     * Get the array of audio samples stored in the buffer.
     *
     * The format of the returned samples is 16 bit signed integer.
     * The total number of samples in this array is given by the
     * `sampleCount` property.
     *
     * @return Read-only pointer to the array of sound samples.
     *
     * @see sampleCount
     */
    public prop samples: CPointer<Int16> {
        get() {
            unsafe { sfSoundBuffer_getSamples(m_handle) }
        }
    }

    /**
     * Get the number of samples stored in the buffer.
     *
     * The array of samples can be accessed with the `samples`
     * property.
     *
     * @return Number of samples.
     *
     * @see samples
     */
    public prop sampleCount: UInt64 {
        get() {
            unsafe { sfSoundBuffer_getSampleCount(m_handle) }
        }
    }

    /**
     * Get the sample rate of the sound.
     *
     * The sample rate is the number of samples played per second.
     * The higher, the better the quality (for example, 44100
     * samples/s is CD quality).
     *
     * @return Sample rate (number of samples per second).
     *
     * @see channelCount
     * @see channelMap
     * @see duration
     */
    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundBuffer_getSampleRate(m_handle) }
        }
    }

    /**
     * Get the number of channels used by the sound.
     *
     * If the sound is mono then the number of channels will
     * be 1, 2 for stereo, etc.
     *
     * @return Number of channels.
     *
     * @see sampleRate
     * @see channelMap
     * @see duration
     */
    public prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundBuffer_getChannelCount(m_handle) }
        }
    }

    /**
     * Get the map of position in sample frame to sound channel.
     *
     * This is used to map a sample in the sample stream to a
     * position during spatialization.
     *
     * @return Map of position in sample frame to sound channel.
     *
     * @see sampleRate
     * @see channelCount
     * @see duration
     */
    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfSoundBuffer_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }

    /**
     * Get the total duration of the sound.
     *
     * @return Sound duration.
     *
     * @see sampleRate
     * @see channelCount
     * @see channelMap
     */
    public prop duration: Time {
        get() {
            unsafe { sfSoundBuffer_getDuration(m_handle) }
        }
    }
}
