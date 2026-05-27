package cjsfml.audio

import cjsfml.system.SFMLNullHandleException

/**
 * Callback type for starting a sound recorder.
 */
type SoundRecorderStartCallback = CFunc<(userData: CPointer<Unit>) -> Bool>

/**
 * Callback type for processing recorded samples.
 */
type SoundRecorderProcessCallback = CFunc<(samples: CPointer<Int16>, sampleCount: UIntNative) -> Bool>

/**
 * Callback type for stopping a sound recorder.
 */
type SoundRecorderStopCallback = CFunc<(userData: CPointer<Unit>) -> Bool>

foreign {
    func sfSoundRecorder_create(onStart: SoundRecorderStartCallback, onProcess: SoundRecorderProcessCallback,
        onStop: SoundRecorderStopCallback, userData: CPointer<Unit>): CPointer<Unit>

    func sfSoundRecorder_destroy(handle: CPointer<Unit>): Unit

    func sfSoundRecorder_start(handle: CPointer<Unit>, sampleRate: UInt32): Bool

    func sfSoundRecorder_stop(handle: CPointer<Unit>): Unit

    func sfSoundRecorder_getSampleRate(handle: CPointer<Unit>): UInt32

    func sfSoundRecorder_setDevice(handle: CPointer<Unit>, name: CString): Bool

    func sfSoundRecorder_getDevice(handle: CPointer<Unit>): CString

    func sfSoundRecorder_setChannelCount(handle: CPointer<Unit>, channelCount: UInt32): Unit

    func sfSoundRecorder_getChannelCount(handle: CPointer<Unit>): UInt32

    func sfSoundRecorder_getChannelMap(handle: CPointer<Unit>, count: UIntNative): CPointer<SoundChannel>
}

/**
 * Abstract base class for capturing sound data.
 *
 * `SoundRecorder` provides a simple interface to access
 * the audio recording capabilities of the computer
 * (the microphone). As an abstract base class, it only cares
 * about capturing sound samples, the task of making something
 * useful with them is left to the derived class. Note that
 * SFML provides a built-in specialization for saving the
 * captured data to a sound buffer (see `SoundBufferRecorder`).
 *
 * A derived class has only one virtual function to override:
 * - `onProcessSamples` provides the new chunks of audio samples while the capture happens
 *
 * Moreover, two additional virtual functions can be overridden
 * as well if necessary:
 * - `onStart` is called before the capture happens, to perform custom initializations
 * - `onStop` is called after the capture ends, to perform custom cleanup
 *
 * The audio capture feature may not be supported or activated
 * on every platform, thus it is recommended to check its
 * availability with the `isAvailable` function. If it returns
 * `false`, then any attempt to use an audio recorder will fail.
 *
 * If you have multiple sound input devices connected to your
 * computer (for example: microphone, external sound card, webcam mic, ...)
 * you can get a list of all available devices through the
 * `availableDevices` function. You can then select a device
 * by calling `setDevice()` with the appropriate device. Otherwise
 * the default capturing device will be used.
 *
 * By default the recording is in 16-bit mono. Using the
 * setChannelCount method you can change the number of channels
 * used by the audio capture device to record. Note that you
 * have to decide whether you want to record in mono or stereo
 * before starting the recording.
 *
 * It is important to note that the audio capture happens in a
 * separate thread, so that it doesn't block the rest of the
 * program. In particular, the `onProcessSamples` virtual function
 * (but not `onStart` and not `onStop`) will be called
 * from this separate thread. It is important to keep this in
 * mind, because you may have to take care of synchronization
 * issues if you share data between threads.
 * Another thing to bear in mind is that you must call `stop()`
 * in the destructor of your derived class, so that the recording
 * thread finishes before your object is destroyed.
 *
 * Usage example:
 * ```
 * class CustomRecorder <: SoundBufferRecorder {
 *     public func onStart(): Bool {
 *         // Initialize whatever has to be done before the capture starts
 *         ...
 *
 *         // Return true to start playing
 *         return true
 *     }
 *
 *     public func onProcessSamples(samples: CPointer<Int16>, sampleCount: UIntNative): Bool {
 *         // Do something with the new chunk of samples (store them, send them, ...)
 *         ...
 *
 *         // Return true to continue playing
 *         return true
 *     }
 *
 *     public func onStop(): Unit {
 *         // Clean up whatever has to be done after the capture ends
 *         ...
 *     }
 * }
 *
 * // Usage
 * if (SoundRecorder.isAvailable) {
 *     let recorder = CustomRecorder()
 *
 *     if (!recorder.start()) {
 *         return -1
 *     }
 *
 *     ...
 *     recorder.stop()
 * }
 * ```
 *
 * @see SoundBufferRecorder
 */
public class SoundRecorder <: SFMLSoundRecorder {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the sound recorder with callbacks.
     *
     * @param onStart Callback that is called when the recorder starts.
     * @param onProcess Callback that is called when new samples are available.
     * @param onStop Callback that is called when the recorder stops.
     * @param userData User data passed to the callbacks.
     * @throws SFMLNullHandleException If the recorder creation fails.
     */
    public init(onStart!: SoundRecorderStartCallback, onProcess!: SoundRecorderProcessCallback,
        onStop!: SoundRecorderStopCallback, userData!: CPointer<Unit>) {
        m_handle = unsafe { sfSoundRecorder_create(onStart, onProcess, onStop, userData) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfSoundRecorder_destroy(m_handle) }
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
     * Closes the resource and releases the internal sound recorder object.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfSoundRecorder_destroy(m_handle) }
        m_handle = CPointer()
    }

    /**
     * Gets the raw pointer to the internal sound recorder object.
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
        unsafe { sfSoundRecorder_start(m_handle, sampleRate) }
    }

    /**
     * Stop the capture.
     *
     * @see start
     */
    public func stop(): Unit {
        unsafe { sfSoundRecorder_stop(m_handle) }
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
            unsafe { sfSoundRecorder_getSampleRate(m_handle) }
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
            unsafe { sfSoundRecorder_getDevice(m_handle).toString() }
        }
        set(value) {
            unsafe {
                try (valueRes = LibC.mallocCString(value).asResource()) {
                    sfSoundRecorder_setDevice(m_handle, valueRes.value)
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
            unsafe { sfSoundRecorder_getChannelCount(m_handle) }
        }
        set(value) {
            unsafe { sfSoundRecorder_setChannelCount(m_handle, value) }
        }
    }

    // SoundRecorder

    /**
     * The map of position in sample frame to sound channel.
     *
     * This is used to map a sample in the sample stream to a
     * position during spatialization.
     */
    public prop channelMap: Array<SoundChannel> {
        get() {
            var channelCount: UIntNative = 0
            let channelsPtr = unsafe { sfSoundRecorder_getChannelMap(m_handle, inout channelCount) }
            return Array<SoundChannel>(Int64(channelCount), {
                i => unsafe { channelsPtr.read(i) }
            })
        }
    }
}
