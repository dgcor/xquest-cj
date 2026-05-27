package cjsfml.window

import cjsfml.system.{ResourceHandle, Time, Vector2i, Vector2u}

/**
 * Common interface for windows.
 *
 * `SFMLWindow` serves as the base interface for all Windows.
 *
 * The `SFMLWindow` interface provides a simple interface for manipulating
 * the window: move, resize, show/hide, control mouse cursor, etc.
 * It also provides event handling through its `pollEvent()` and `waitEvent()`
 * functions.
 */
public interface SFMLWindow <: ResourceHandle {
    /**
     * Close the window and destroy all the attached resources.
     *
     * After calling this function, the `Window` instance remains
     * valid and you can call `create()` to recreate the window.
     * All other functions such as `pollEvent()` or `display()` will
     * still work (i.e. you don't have to test `isOpen()` every time),
     * and will have no effect on closed windows.
     */
    func closeWindow(): Unit

    /**
     * Tell whether or not the window is open.
     *
     * This function returns whether the window exists or not.
     * Note that a hidden window `(setVisible(false))` is open
     * (therefore this function would return `true`).
     *
     * @return `true` if the window is open, `false` if it has been closed
     */
    prop isOpen: Bool

    /**
     * Pop the next event from the front of the FIFO event queue, if any, and return it.
     *
     * This function is not blocking: if there's no pending event then
     * it will return `None`. Note that more than one event may be
     * present in the event queue, thus you should always call this
     * function in a loop to make sure that you process every pending event.
     *
     * @return The event, or `None` if the event queue is empty
     */
    func pollEvent(): ?Event

    /**
     * Wait for an event and return it.
     *
     * This function is blocking: if there's no pending event then
     * it will wait until an event is received.
     * If there's no event arriving, this function will block forever.
     *
     * @return The event, or `None` if window was closed
     */
    func waitEvent(): ?Event {
        waitEvent(Time.ZERO)
    }

    /**
     * Wait for an event and return it, with a timeout.
     *
     * This function is blocking: if there's no pending event then
     * it will wait until an event is received or until the provided
     * timeout elapses. Only if an error or a timeout occurs the
     * returned event will be `None`.
     * This function is typically used when you have a thread that is
     * dedicated to events handling: you want to make this thread sleep
     * as long as no new event is received.
     *
     * @param timeout Maximum time to wait (`Time.ZERO` for infinite)
     *
     * @return The event, or `None` on timeout or if window was closed
     */
    func waitEvent(timeout: Time): ?Event

    /**
     * Get the position of the window.
     *
     * @return Position of the window, in pixels
     */
    mut prop position: Vector2i

    /**
     * Get the size of the rendering region of the window.
     *
     * The size doesn't include the titlebar and borders of the window.
     *
     * @return Size in pixels
     */
    mut prop size: Vector2u

    /**
     * Set the minimum window rendering region size.
     *
     * Pass `None` to unset the minimum size.
     *
     * @param size New minimum size, in pixels
     */
    func setMinimumSize(size: ?Vector2u): Unit

    /**
     * Set the maximum window rendering region size.
     *
     * Pass `None` to unset the maximum size.
     *
     * @param size New maximum size, in pixels
     */
    func setMaximumSize(size: ?Vector2u): Unit

    /**
     * Change the title of the window.
     *
     * @param title New title
     */
    func setTitle(title: String): Unit

    /**
     * Change the window's icon.
     *
     * `pixels` must be an array of `size` pixels
     * in 32-bits RGBA format.
     * The OS default icon is used by default.
     *
     * @param size   Icon's width and height, in pixels
     * @param pixels Array of pixel data. The pixels are copied, so you need not keep the
     *               source alive after calling this function.
     */
    func setIcon(size: Vector2u, pixels: Array<UInt8>): Unit

    /**
     * Change the window's icon.
     *
     * `pixels` must be an array of `size` pixels
     * in 32-bits RGBA format.
     * The OS default icon is used by default.
     *
     * @param size   Icon's width and height, in pixels
     * @param pixels Pointer to the array of pixels in memory. The
     *               pixels are copied, so you need not keep the
     *               source alive after calling this function.
     */
    func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit

    /**
     * Show or hide the window.
     *
     * The window is shown by default.
     *
     * @param visible `true` to show the window, `false` to hide it
     */
    func setVisible(visible: Bool): Unit

    /**
     * Show or hide the mouse cursor.
     *
     * The mouse cursor is visible by default.
     *
     * @warning On Windows, this function needs to be called from the
     *          thread that created the window.
     *
     * @param visible `true` to show the mouse cursor, `false` to hide it
     */
    func setMouseCursorVisible(visible: Bool): Unit

    /**
     * Grab or release the mouse cursor.
     *
     * If set, grabs the mouse cursor inside this window's client
     * area so it may no longer be moved outside its bounds.
     * Note that grabbing is only active while the window has
     * focus.
     *
     * @param grabbed `true` to enable, `false` to disable
     */
    func setMouseCursorGrabbed(grabbed: Bool): Unit

    /**
     * Set the displayed cursor to a native system cursor.
     *
     * Upon window creation, the arrow cursor is used by default.
     *
     * @warning The cursor must not be destroyed while in use by
     *          the window.
     *
     * @warning Features related to Cursor are not supported on
     *          iOS and Android.
     *
     * @param cursor Native system cursor type to display
     */
    func setMouseCursor(cursor: Cursor): Unit

    /**
     * Enable or disable automatic key-repeat.
     *
     * If key repeat is enabled, you will receive repeated
     * KeyPressed events while keeping a key pressed. If it is disabled,
     * you will only get a single event when the key is pressed.
     *
     * Key repeat is enabled by default.
     *
     * @param enabled `true` to enable, `false` to disable
     */
    func setKeyRepeatEnabled(enabled: Bool): Unit

    /**
     * Change the joystick threshold.
     *
     * The joystick threshold is the value below which
     * no JoystickMoved event will be generated.
     *
     * The threshold value is 0.1 by default.
     *
     * @param threshold New threshold, in the range [0, 100]
     */
    func setJoystickThreshold(threshold: Float32): Unit

    /**
     * Request the current window to be made the active foreground window.
     *
     * At any given time, only one window may have the input focus
     * to receive input events such as keystrokes or mouse events.
     * If a window requests focus, it only hints to the operating
     * system, that it would like to be focused. The operating system
     * is free to deny the request.
     * This is not to be confused with `setActive()`.
     */
    func requestFocus(): Unit

    /**
     * Check whether the window has the input focus.
     *
     * At any given time, only one window may have the input focus
     * to receive input events such as keystrokes or most mouse
     * events.
     *
     * @return `true` if window has focus, `false` otherwise
     */
    prop hasFocus: Bool

    /**
     * Get the OS-specific handle of the window.
     *
     * The type of the returned handle is `CPointer<Unit>`
     * on Windows and `CPointer<Unit>` (Window) on Unix (X11).
     * You shouldn't need to use this function, unless you have
     * very specific stuff to implement that SFML doesn't support,
     * or implement a temporary workaround until a bug is fixed.
     *
     * @return System handle of the window
     */
    prop nativeHandle: CPointer<Unit>

    // extra

    /**
     * Enable or disable vertical synchronization.
     *
     * Activating vertical synchronization will limit the number
     * of frames displayed to the refresh rate of the monitor.
     * This can avoid some visual artifacts, and limit the framerate
     * to a good value (but not constant across different computers).
     *
     * Vertical synchronization is disabled by default.
     *
     * @param enabled `true` to enable v-sync, `false` to deactivate it
     */
    func setVerticalSyncEnabled(enabled: Bool): Unit

    /**
     * Display on screen what has been rendered to the window so far.
     *
     * This function is typically called after all OpenGL rendering
     * has been done for the current frame, in order to show
     * it on screen.
     */
    func display(): Unit
}
