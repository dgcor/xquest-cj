package cjsfml.window

import cenum.CEnum
import cjsfml.system.{ResourceHandle, SFMLNullHandleException, SFMLOutOfBoundsException, Vector2u}

foreign {
    func sfCursor_createFromPixels(pixels: CPointer<UInt8>, size: Vector2u, hotspot: Vector2u): CPointer<Unit>

    func sfCursor_createFromSystem(cursorType: CursorType): CPointer<Unit>

    func sfCursor_destroy(handle: CPointer<Unit>): Unit
}

/**
 * Enumeration of the native system cursor types
 *
 * Refer to the following table to determine which cursor
 * is available on which platform.
 *
 *  Type                                       | Linux | macOS | Windows  |
 * --------------------------------------------|:-----:|:-----:|:--------:|
 *  `CursorType.Arrow`                         |  yes  | yes   |   yes    |
 *  `CursorType.ArrowWait`                     |  no   | no    |   yes    |
 *  `CursorType.Wait`                          |  yes  | no    |   yes    |
 *  `CursorType.Text`                          |  yes  | yes   |   yes    |
 *  `CursorType.Hand`                          |  yes  | yes   |   yes    |
 *  `CursorType.SizeHorizontal`                |  yes  | yes   |   yes    |
 *  `CursorType.SizeVertical`                  |  yes  | yes   |   yes    |
 *  `CursorType.SizeTopLeftBottomRight`        |  no   | yes*  |   yes    |
 *  `CursorType.SizeBottomLeftTopRight`        |  no   | yes*  |   yes    |
 *  `CursorType.SizeLeft`                      |  yes  | yes** |   yes**  |
 *  `CursorType.SizeRight`                     |  yes  | yes** |   yes**  |
 *  `CursorType.SizeTop`                       |  yes  | yes** |   yes**  |
 *  `CursorType.SizeBottom`                    |  yes  | yes** |   yes**  |
 *  `CursorType.SizeTopLeft`                   |  yes  | yes** |   yes**  |
 *  `CursorType.SizeTopRight`                  |  yes  | yes** |   yes**  |
 *  `CursorType.SizeBottomLeft`                |  yes  | yes** |   yes**  |
 *  `CursorType.SizeBottomRight`               |  yes  | yes** |   yes**  |
 *  `CursorType.SizeAll`                       |  yes  | no    |   yes    |
 *  `CursorType.Cross`                         |  yes  | yes   |   yes    |
 *  `CursorType.Help`                          |  yes  | yes*  |   yes    |
 *  `CursorType.NotAllowed`                    |  yes  | yes   |   yes    |
 *
 *  * These cursor types are undocumented so may not
 *    be available on all versions, but have been tested on 10.13
 *
 *  ** On Windows and macOS, double-headed arrows are used
 */
@CEnum[public CursorType](
    Arrow // Arrow cursor (default)
    ArrowWait // Busy arrow cursor
    Wait // Busy cursor
    Text // I-beam, cursor when hovering over a field allowing text entry
    Hand // Pointing hand cursor
    SizeHorizontal // Horizontal double arrow cursor
    SizeVertical // Vertical double arrow cursor
    SizeTopLeftBottomRight // Double arrow cursor going from top-left to bottom-right
    SizeBottomLeftTopRight // Double arrow cursor going from bottom-left to top-right
    SizeLeft // Left arrow cursor on Linux, same as SizeHorizontal on other platforms
    SizeRight // Right arrow cursor on Linux, same as SizeHorizontal on other platforms
    SizeTop // Up arrow cursor on Linux, same as SizeVertical on other platforms
    SizeBottom // Down arrow cursor on Linux, same as SizeVertical on other platforms
    SizeTopLeft // Top-left arrow cursor on Linux, same as SizeTopLeftBottomRight on other platforms
    SizeBottomRight // Bottom-right arrow cursor on Linux, same as SizeTopLeftBottomRight on other platforms
    SizeBottomLeft // Bottom-left arrow cursor on Linux, same as SizeBottomLeftTopRight on other platforms
    SizeTopRight // Top-right arrow cursor on Linux, same as SizeBottomLeftTopRight on other platforms
    SizeAll // Combination of SizeHorizontal and SizeVertical
    Cross // Crosshair cursor
    Help // Help cursor
    NotAllowed // Action not allowed cursor
)

/**
 * Cursor defines the appearance of a system cursor.
 *
 * **Warning:** Features related to Cursor are not supported on
 * iOS and Android.
 *
 * This class abstracts the operating system resources
 * associated with either a native system cursor or a custom
 * cursor.
 *
 * After loading the cursor graphical appearance
 * with either the constructor or `CursorType`, the
 * cursor can be changed with `Window.setMouseCursor()`.
 *
 * The behavior is undefined if the cursor is destroyed while
 * in use by the window.
 *
 * Usage example:
 * ```
 * let window = Window(...)
 *
 * // ... create window as usual ...
 *
 * let cursor = Cursor(cursorType: CursorType.Hand)
 * window.setMouseCursor(cursor)
 * ```
 *
 * @see `Window.setMouseCursor`
 */
public class Cursor <: ResourceHandle & Equatable<Cursor> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a cursor with the provided image.
     *
     * `pixels` must be an array of `size` pixels in
     * 32-bit RGBA format. If not, this will cause undefined behavior.
     *
     * If `pixels` is empty or either of `size`'s
     * properties are 0, the current cursor is left unchanged
     * and the function will return `false`.
     *
     * In addition to specifying the pixel data, you can also
     * specify the location of the hotspot of the cursor. The
     * hotspot is the pixel coordinate within the cursor image
     * which will be located exactly where the mouse pointer
     * position is. Any mouse actions that are performed will
     * return the window/screen location of the hotspot.
     *
     * **Warning:** On Unix platforms which do not support colored
     *          cursors, the pixels are mapped into a monochrome
     *          bitmap: pixels with an alpha channel to 0 are
     *          transparent, black if the RGB channel are close
     *          to zero, and white otherwise.
     *
     * @param pixels  Array of pixels of the image
     * @param size    Width and height of the image
     * @param hotspot (x,y) location of the hotspot
     *
     * @throws SFMLNullHandleException if the cursor could not be constructed
     * @throws SFMLOutOfBoundsException if the pixel array is too small
     */
    public init(pixels: Array<UInt8>, size: Vector2u, hotspot: Vector2u) {
        if (pixels.size < Int64(size.x) * Int64(size.y)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                m_handle = sfCursor_createFromPixels(rawData.pointer, size, hotspot)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Create a native system cursor.
     *
     * Refer to the list of cursor available on each system
     * (see `CursorType`) to know whether a given cursor is
     * expected to load successfully or is not supported by
     * the operating system.
     *
     * @param type Native system cursor type
     *
     * @throws SFMLNullHandleException if the corresponding cursor
     *         is not natively supported by the operating
     *         system
     */
    public init(cursorType: CursorType) {
        m_handle = unsafe { sfCursor_createFromSystem(cursorType) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfCursor_destroy(m_handle) }
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
        unsafe { sfCursor_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: Cursor): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Cursor): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }
}
