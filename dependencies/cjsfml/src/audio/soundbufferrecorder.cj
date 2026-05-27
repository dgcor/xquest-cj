package cjsfml.audio

import cjsfml.system.SFMLNullHandleException

foreign {
    func sfSoundBufferRecorder_create(): CPointer<Unit>

    func sfSoundBufferRecorder_destroy(handle: CPointer<Unit>): Unit

    func sfSoundBufferRecorder_start(handle: CPointer<Unit>, sampleRate: UInt32): Bool

    func sfSoundBufferRecorder_stop(handle: CPointer<Unit>): Unit

    func sfSoundBufferRecorder_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundBufferRecorder_getBuffer(handle: CPointer<Unit>): CPointer<Unit>

    func sfSoundBufferRecorder_setDevice(handle: CPointer<Unit>, name: CString): Bool

    func sfSoundBufferRecorder_getDevice(handle: CPointer<Unit>): CString

    func sfSoundBufferRecorder_setChannelCount(handle: CPointer<Unit>, channelCount: UInt32): Unit

    func sfSoundBufferRecorder_getChannelCount(handle: CPointer<Unit>): UInt32
}

/**
 * Specialized SoundRecorder which stores the captured audio data into a sound buffer.
 *
 * `SoundBufferRecorder` allows to access a recorded sound
 * through a `SoundBuffer`, so that it can be played, saved
 * to a file, etc.
 *
 * It has the same simple interface as its base class (`start()`, `stop()`)
 * and adds a function to retrieve the recorded sound buffer
 * (`buffer`).
 *
 * As usual, don't forget to call the `isAvailable()` function
 * before using this class (see `SoundRecorder` for more details
 * about this).
 *
 * Usage example:
 * ```
 * if (SoundBufferRecorder.isAvailable) {
 *     // Record some audio data
 *     let recorder = SoundBufferRecorder()
 *     if (!recorder.start()) {
 *         // Handle error...
 *     }
 *     ...
 *     recorder.stop()
 *
 *     // Get the buffer containing the captured audio data
 *     let buffer = recorder.buffer
 *
 *     // Save it to a file (for example...)
 *     if (buffer != None) {
 *         buffer?.saveToFile("my_record.ogg")
 *     }
 * }
 * ```
 *
 * @see SFMLSoundRecorder
 */
public class SoundBufferRecorder <: SFMLSoundRecorder {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a new sound buffer recorder.
     *
     * @throws SFMLNullHandleException If the recorder creation fails.
     */
    public init() {
        m_handle = unsafe { sfSoundBufferRecorder_create() }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSoundBufferRecorder_destroy(m_handle) }
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
     * Closes the resource and releases the internal sound buffer recorder object.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSoundBufferRecorder_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal sound buffer recorder object.
     */
    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // SFMLSoundRecorder

    /**
     * Start the capture.
     *
     * The `sampleRate` parameter defines the number of audio samples
     * captured per second. The higher, the better the quality
     * (for example, 44100 samples/sec is CD quality).
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the capture runs.
     * Please note that only one capture can happen at the same time.
     * You can select which capture device will be used by passing
     * the name to the `device` property. If none was selected
     * before, the default capture device will be used. You can get a
     * list of the names of all available capture devices by calling
     * `availableDevices`.
     *
     * @param sampleRate Desired capture rate, in number of samples per second.
     * @return `true`, if start of capture was successful.
     *
     * @see stop
     * @see availableDevices
     */
    public func start(sampleRate: UInt32): Bool {
        unsafe { sfSoundBufferRecorder_start(m_handle, sampleRate) }
    }

    /**
     * Stop the capture.
     *
     * @see start
     */
    public func stop(): Unit {
        unsafe { sfSoundBufferRecorder_stop(m_handle) }
    }

    /**
     * The sample rate.
     *
     * The sample rate defines the number of audio samples
     * captured per second. The higher, the better the quality
     * (for example, 44100 samples/sec is CD quality).
     */
    public prop sampleRate: UInt32 {
        get() {
            unsafe { sfSoundBufferRecorder_getSampleRate(m_handle) }
        }
    }

    /**
     * The name of the current audio capture device.
     *
     * This property sets the audio capture device to the device
     * with the given name. It can be called on the fly (i.e:
     * while recording). If you do so while recording and
     * opening the device fails, it stops the recording.
     *
     * @see availableDevices
     * @see defaultDevice
     */
    public mut prop device: String {
        get() {
            unsafe { sfSoundBufferRecorder_getDevice(m_handle).toString() }
        }
        set(value) {
            unsafe {
                try (valueRes = LibC.mallocCString(value).asResource()) {
                    sfSoundBufferRecorder_setDevice(m_handle, valueRes.value)
                }
            }
        }
    }

    /**
     * The channel count of the audio capture device.
     *
     * This property allows you to specify the number of channels
     * used for recording. Currently only 16-bit mono and
     * 16-bit stereo are supported.
     *
     * @see channelCount
     */
    public mut prop channelCount: UInt32 {
        get() {
            unsafe { sfSoundBufferRecorder_getChannelCount(m_handle) }
        }
        set(value) {
            unsafe { sfSoundBufferRecorder_setChannelCount(m_handle, value) }
        }
    }

    // SoundBufferRecorder

    /**
     * Get the sound buffer containing the captured audio data.
     *
     * The sound buffer is valid only after the capture has ended.
     * This function provides a read-only access to the internal
     * sound buffer, but it can be copied if you need to
     * make any modification to it.
     *
     * @return Read-only access to the sound buffer, or `None` if capture hasn't produced data yet.
     */
    public prop buffer: ?SoundBuffer {
        get() {
            let bufferPtr = unsafe { sfSoundBufferRecorder_getBuffer(m_handle) }
            if (bufferPtr.isNull()) {
                return None
            }
            SoundBuffer(bufferPtr, isOwner: false)
        }
    }
}
