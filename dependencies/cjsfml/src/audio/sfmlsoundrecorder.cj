package cjsfml.audio

import cjsfml.system.ResourceHandle

foreign {
    func sfSoundRecorder_isAvailable(): Bool

    func sfSoundRecorder_getAvailableDevices(count: CPointer<UIntNative>): CPointer<CString>

    func sfSoundRecorder_getDefaultDevice(): CString
}

/**
 * Abstract base interface for capturing sound data.
 *
 * `SFMLSoundRecorder` defines the common interface for sound recorders.
 * It provides access to the audio recording capabilities of the computer.
 * This interface corresponds to the base class `sf::SoundRecorder` in SFML.
 *
 * The audio capture feature may not be supported or activated
 * on every platform, thus it is recommended to check its
 * availability with the static `isAvailable` property before using it.
 *
 * If you have multiple sound input devices connected to your
 * computer (for example: microphone, external sound card, webcam mic, ...)
 * you can get a list of all available devices through the
 * static `availableDevices` property.
 *
 * It is important to note that the audio capture happens in a
 * separate thread, so that it doesn't block the rest of the
 * program.
 */
public interface SFMLSoundRecorder <: ResourceHandle {
    /**
     * Start the capture using the default sample rate (44100 Hz).
     *
     * The sample rate defines the number of audio samples
     * captured per second. The higher, the better the quality
     * (for example, 44100 samples/sec is CD quality).
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the capture runs.
     * Please note that only one capture can happen at the same time.
     *
     * @return `true`, if start of capture was successful.
     *
     * @see stop
     */
    func start(): Bool {
        start(44100)
    }

    /**
     * Start the capture.
     *
     * The `sampleRate` parameter defines the number of audio samples
     * captured per second. The higher, the better the quality
     * (for example, 44100 samples/sec is CD quality).
     * This function uses its own thread so that it doesn't block
     * the rest of the program while the capture runs.
     * Please note that only one capture can happen at the same time.
     *
     * @param sampleRate Desired capture rate, in number of samples per second.
     * @return `true`, if start of capture was successful.
     *
     * @see stop
     */
    func start(sampleRate: UInt32): Bool

    /**
     * Stop the capture.
     *
     * @see start
     */
    func stop(): Unit

    /**
     * The sample rate.
     *
     * The sample rate defines the number of audio samples
     * captured per second. The higher, the better the quality
     * (for example, 44100 samples/sec is CD quality).
     */
    prop sampleRate: UInt32

    /**
     * The name of the current audio capture device.
     *
     * This property sets the audio capture device to the device
     * with the given name. It can be called on the fly (i.e:
     * while recording). If you do so while recording and
     * opening the device fails, it stops the recording.
     */
    mut prop device: String

    /**
     * The channel count of the audio capture device.
     *
     * This property allows you to specify the number of channels
     * used for recording. Currently only 16-bit mono and
     * 16-bit stereo are supported.
     */
    mut prop channelCount: UInt32

    // cjlint-ignore -start !G.NAM.05 use all capital letters for static variable

    /**
     * Check if the system supports audio capture.
     *
     * This function should always be called before using
     * the audio capture features. If it returns `false`, then
     * any attempt to use `SoundRecorder` or one of its derived
     * classes will fail.
     *
     * @return `true` if audio capture is supported, `false` otherwise.
     */
    static prop isAvailable: Bool {
        get() {
            unsafe { sfSoundRecorder_isAvailable() }
        }
    }

    /**
     * Get a list of the names of all available audio capture devices.
     *
     * This function returns an array of strings, containing
     * the names of all available audio capture devices.
     *
     * @return An array of strings containing the names.
     */
    static prop availableDevices: Array<String> {
        get() {
            var deviceCount: UIntNative = 0
            let devicesPtr = unsafe { sfSoundRecorder_getAvailableDevices(inout deviceCount) }
            return Array<String>(Int64(deviceCount), {
                i => unsafe { devicesPtr.read(i).toString() }
            })
        }
    }

    /**
     * Get the name of the default audio capture device.
     *
     * This function returns the name of the default audio
     * capture device. If none is available, `None` is returned.
     *
     * @return The name of the default audio capture device, or `None`.
     */
    static prop defaultDevice: ?String {
        get() {
            let device = unsafe { sfSoundRecorder_getDefaultDevice() }
            return match (device.isNull()) {
                case false => device.toString()
                case true => None
            }
        }
    }

    // cjlint-ignore -end use all capital letters for static variable
}
