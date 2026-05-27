package cjsfml.window

import cjsfml.system.Vector2u

foreign {
    func sfVideoMode_getDesktopMode(): VideoMode

    func sfVideoMode_getFullscreenModes(count: CPointer<UIntNative>): CPointer<VideoMode>

    func sfVideoMode_isValid(mode: VideoMode): Bool
}

/**
 * VideoMode defines a video mode (size, bpp).
 *
 * A video mode is defined by a width and a height (in pixels)
 * and a depth (in bits per pixel). Video modes are used to
 * setup windows at creation time.
 *
 * The main usage of video modes is for fullscreen mode:
 * indeed you must use one of the valid video modes
 * allowed by the OS (which are defined by what the monitor
 * and the graphics card support), otherwise your window
 * creation will just fail.
 *
 * `VideoMode` provides a static function for retrieving
 * the list of all the video modes supported by the system:
 * `fullscreenModes`.
 *
 * A custom video mode can also be checked directly for
 * fullscreen compatibility with its `isValid()` function.
 *
 * Additionally, `VideoMode` provides a static function
 * to get the mode currently used by the desktop: `desktopMode`.
 * This allows to build windows with the same size or pixel
 * depth as the current resolution.
 *
 * Usage example:
 * ```
 * // Display the list of all the video modes available for fullscreen
 * let modes = VideoMode.fullscreenModes
 * for (i in 0..modes.size) {
 *     let mode = modes[i]
 *     println("Mode #${i}: ${mode.size.x}x${mode.size.y} - ${mode.bitsPerPixel} bpp")
 * }
 *
 * // Create a window with the same pixel depth as the desktop
 * let desktop = VideoMode.desktopMode
 * // window.create(VideoMode(Vector2u(1024, 768), desktop.bitsPerPixel), "SFML window")
 * ```
 */
@C
public struct VideoMode {
    /**
     * Video mode width and height, in pixels.
     */
    public let size: Vector2u
    /**
     * Video mode pixel depth, in bits per pixels.
     */
    public let bitsPerPixel: UInt32

    /**
     * Default constructor.
     *
     * This constructors initializes all members to 0.
     */
    public const init() {
        size = Vector2u()
        bitsPerPixel = 0
    }

    /**
     * Construct the video mode with its attributes.
     *
     * @param modeSize         Width and height in pixels
     * @param modeBitsPerPixel Pixel depths in bits per pixel
     */
    public const init(size: Vector2u, bitsPerPixel!: UInt32 = 32) {
        this.size = size
        this.bitsPerPixel = bitsPerPixel
    }

    // cjlint-ignore -start !G.NAM.05 use all capital letters for static variable

    /**
     * Get the current desktop video mode.
     *
     * @return Current desktop video mode
     */
    public static prop desktopMode: VideoMode {
        get() {
            unsafe { sfVideoMode_getDesktopMode() }
        }
    }

    /**
     * Retrieve all the video modes supported in fullscreen mode.
     *
     * When creating a fullscreen window, the video mode is restricted
     * to be compatible with what the graphics driver and monitor
     * support. This function returns the complete list of all video
     * modes that can be used in fullscreen mode.
     * The returned array is sorted from best to worst, so that
     * the first element will always give the best mode (higher
     * width, height and bits-per-pixel).
     *
     * @return Array containing all the supported fullscreen modes
     */
    public static prop fullscreenModes: Array<VideoMode> {
        get() {
            var count: UIntNative = 0
            let modesPtr = unsafe { sfVideoMode_getFullscreenModes(inout count) }
            return Array<VideoMode>(Int64(count), {
                i => unsafe { modesPtr.read(i) }
            })
        }
    }

    // cjlint-ignore -end use all capital letters for static variable

    /**
     * Tell whether or not the video mode is valid.
     *
     * The validity of video modes is only relevant when using
     * fullscreen windows; otherwise any video mode can be used
     * with no restriction.
     *
     * @param mode Video mode to check
     *
     * @return `true` if the video mode is valid for fullscreen mode
     */
    public static func isValid(mode: VideoMode): Bool {
        unsafe { sfVideoMode_isValid(mode) }
    }
}
