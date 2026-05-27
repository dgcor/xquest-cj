package cjsfml.window

import cjsfml.system.{SFMLNullHandleException, Time, toCStringUtf32, Vector2i, Vector2u}

foreign {
    func sfWindow_createUnicode(mode: VideoMode, title: CPointer<UInt32>, style: WindowStyle, state: WindowState,
        settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfWindow_createFromHandle(handle: CPointer<Unit>, settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfWindow_destroy(handle: CPointer<Unit>): Unit

    // WindowBase

    func sfWindow_close(handle: CPointer<Unit>): Unit

    func sfWindow_isOpen(handle: CPointer<Unit>): Bool

    func sfWindow_pollEvent(handle: CPointer<Unit>, event: CPointer<Byte>): Bool

    func sfWindow_waitEvent(handle: CPointer<Unit>, timeout: Time, event: CPointer<Byte>): Bool

    func sfWindow_getPosition(handle: CPointer<Unit>): Vector2i

    func sfWindow_setPosition(handle: CPointer<Unit>, position: Vector2i): Unit

    func sfWindow_getSize(handle: CPointer<Unit>): Vector2u

    func sfWindow_setSize(handle: CPointer<Unit>, size: Vector2u): Unit

    func sfWindow_setMinimumSize(handle: CPointer<Unit>, minimumSize: CPointer<Vector2u>): Unit

    func sfWindow_setMaximumSize(handle: CPointer<Unit>, maximumSize: CPointer<Vector2u>): Unit

    func sfWindow_setUnicodeTitle(handle: CPointer<Unit>, title: CPointer<UInt32>): Unit

    func sfWindow_setIcon(handle: CPointer<Unit>, size: Vector2u, pixels: CPointer<UInt8>): Unit

    func sfWindow_setVisible(handle: CPointer<Unit>, visible: Bool): Unit

    func sfWindow_setMouseCursorVisible(handle: CPointer<Unit>, visible: Bool): Unit

    func sfWindow_setMouseCursorGrabbed(handle: CPointer<Unit>, grabbed: Bool): Unit

    func sfWindow_setMouseCursor(handle: CPointer<Unit>, cursor: CPointer<Unit>): Unit

    func sfWindow_setKeyRepeatEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfWindow_setJoystickThreshold(handle: CPointer<Unit>, threshold: Float32): Unit

    func sfWindow_requestFocus(handle: CPointer<Unit>): Unit

    func sfWindow_hasFocus(handle: CPointer<Unit>): Bool

    func sfWindow_getNativeHandle(handle: CPointer<Unit>): CPointer<Unit>

    // Window

    func sfWindow_getSettings(handle: CPointer<Unit>): ContextSettings

    func sfWindow_setVerticalSyncEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfWindow_setFramerateLimit(handle: CPointer<Unit>, limit: UInt32): Unit

    func sfWindow_setActive(handle: CPointer<Unit>, active: Bool): Bool

    func sfWindow_display(handle: CPointer<Unit>): Unit
}

/**
 * Window that serves as a target for OpenGL rendering.
 *
 * `Window` is the main class of the Window module. It defines
 * an OS window that is able to receive an OpenGL rendering.
 *
 * A `Window` can create its own new window, or be embedded into
 * an already existing control using the `init(handle)` function.
 * This can be useful for embedding an OpenGL rendering area into
 * a view which is part of a bigger GUI with existing windows,
 * controls, etc. It can also serve as embedding an OpenGL rendering
 * area into a window created by another (probably richer) GUI library
 * like Qt or wxWidgets.
 *
 * The `Window` class provides a simple interface for manipulating
 * the window: move, resize, show/hide, control mouse cursor, etc.
 * It also provides event handling through its `pollEvent()` and `waitEvent()`
 * functions.
 *
 * Note that OpenGL experts can pass their own parameters (anti-aliasing
 * level, bits for the depth and stencil buffers, etc.) to the
 * OpenGL context attached to the window, with the `ContextSettings`
 * structure which is passed as an optional argument when creating the
 * window.
 *
 * Usage example:
 * ```
 * // Declare and create a new window
 * let window = Window(VideoMode(Vector2u(800, 600)), "SFML window");
 *
 * // Limit the framerate to 60 frames per second (this step is optional)
 * window.setFramerateLimit(60);
 *
 * // The main loop - ends as soon as the window is closed
 * while (window.isOpen) {
 *    // Event processing
 *    while (let Some(event) = window.pollEvent()) {
 *        // Request for closing the window
 *        if (event.isClosed()) {
 *            window.close();
 *        }
 *    }
 *
 *    // Activate the window for OpenGL rendering
 *    window.setActive();
 *
 *    // OpenGL drawing commands go here...
 *
 *    // End the current frame and display its contents on screen
 *    window.display();
 * }
 * ```
 */
public class Window <: SFMLWindow & Equatable<Window> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a new window.
     *
     * This constructor creates the window with the size and pixel
     * depth defined in `mode`. An optional style can be passed to
     * customize the look and behavior of the window (borders,
     * title bar, resizable, closable, ...). An optional state can
     * be provided. If `state` is `WindowState.Fullscreen`, then `mode`
     * must be a valid video mode.
     *
     * The last parameter is an optional structure specifying
     * advanced OpenGL context settings such as anti-aliasing,
     * depth-buffer bits, etc.
     *
     * @param mode     Video mode to use (defines the width, height and depth of the rendering area of the window)
     * @param title    Title of the window
     * @param style    %Window style, a bitwise OR combination of `WindowStyle` enumerators
     * @param state    %Window state
     * @param settings Additional settings for the underlying OpenGL context
     *
     * @throws SFMLNullHandleException
     */
    public init(mode: VideoMode, title: String, style!: WindowStyle = WindowStyle.Default,
        state!: WindowState = WindowState.Windowed, settings!: ContextSettings = ContextSettings()) {
        unsafe {
            try (titleRes = (title |> toCStringUtf32).asResource()) {
                var settings2 = settings
                m_handle = sfWindow_createUnicode(mode, titleRes.value, style, state, inout settings2)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the window from an existing control.
     *
     * Use this constructor if you want to create an OpenGL
     * rendering area into an already existing control.
     *
     * The second parameter is an optional structure specifying
     * advanced OpenGL context settings such as anti-aliasing,
     * depth-buffer bits, etc.
     *
     * @param handle   Platform-specific handle of the control
     * @param settings Additional settings for the underlying OpenGL context
     *
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, settings!: ContextSettings = ContextSettings()) {
        unsafe {
            var settings2 = settings
            m_handle = sfWindow_createFromHandle(handle, inout settings2)
            if (m_handle.isNull()) {
                throw SFMLNullHandleException()
            }
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfWindow_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    /**
     * Close the window and destroy all the attached resources.
     *
     * After calling this function, the `Window` instance remains
     * valid and you can call `create()` to recreate the window.
     * All other functions such as `pollEvent()` or `display()` will
     * still work (i.e. you don't have to test `isOpen` every time),
     * and will have no effect on closed windows.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfWindow_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: Window): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Window): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // WindowBase

    public func closeWindow(): Unit {
        unsafe { sfWindow_close(m_handle) }
    }

    /**
     * Tell whether or not the window is open.
     *
     * This function returns whether the window exists or not.
     * Note that a hidden window `(setVisible(false))` is open
     * (therefore this function would return `true`).
     *
     * @return `true` if the window is open, `false` if it has been closed
     */
    public prop isOpen: Bool {
        get() {
            unsafe { sfWindow_isOpen(m_handle) }
        }
    }

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
    public func pollEvent(): ?Event {
        unsafe {
            var data = Event.getEmpty()
            let rawData = acquireArrayRawData(data)
            try {
                if (sfWindow_pollEvent(m_handle, rawData.pointer)) {
                    return Event.create(data)
                }
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        return None
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
    public func waitEvent(timeout: Time): ?Event {
        unsafe {
            var data = Event.getEmpty()
            let rawData = acquireArrayRawData(data) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                if (sfWindow_waitEvent(m_handle, timeout, rawData.pointer)) {
                    return Event.create(data)
                }
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        return None
    }

    /**
     * Get the position of the window.
     *
     * @return Position of the window, in pixels
     */
    public mut prop position: Vector2i {
        get() {
            unsafe { sfWindow_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfWindow_setPosition(m_handle, value) }
        }
    }

    /**
     * Get the size of the rendering region of the window.
     *
     * The size doesn't include the titlebar and borders of the window.
     *
     * @return Size in pixels
     */
    public mut prop size: Vector2u {
        get() {
            unsafe { sfWindow_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfWindow_setSize(m_handle, value) }
        }
    }

    /**
     * Set the minimum window rendering region size.
     *
     * Pass `None` to unset the minimum size.
     *
     * @param size New minimum size, in pixels
     */
    public func setMinimumSize(size: ?Vector2u): Unit {
        match (size) {
            case Some(size) =>
                var size2 = size
                unsafe { sfWindow_setMinimumSize(m_handle, inout size2) }
            case None => unsafe { sfWindow_setMinimumSize(m_handle, CPointer()) }
        }
    }

    /**
     * Set the maximum window rendering region size.
     *
     * Pass `None` to unset the maximum size.
     *
     * @param size New maximum size, in pixels
     */
    public func setMaximumSize(size: ?Vector2u): Unit {
        match (size) {
            case Some(size) =>
                var size2 = size
                unsafe { sfWindow_setMaximumSize(m_handle, inout size2) }
            case None => unsafe { sfWindow_setMaximumSize(m_handle, CPointer()) }
        }
    }

    /**
     * Change the title of the window.
     *
     * @param title New title
     */
    public func setTitle(title: String): Unit {
        unsafe {
            try (titleRes = (title |> toCStringUtf32).asResource()) {
                sfWindow_setUnicodeTitle(m_handle, titleRes.value)
            }
        }
    }

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
    public func setIcon(size: Vector2u, pixels: Array<UInt8>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                sfWindow_setIcon(m_handle, size, CPointer(rawData.pointer))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

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
    public func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit {
        unsafe {
            sfWindow_setIcon(m_handle, size, pixels)
        }
    }

    /**
     * Show or hide the window.
     *
     * The window is shown by default.
     *
     * @param visible `true` to show the window, `false` to hide it
     */
    public func setVisible(visible: Bool): Unit {
        unsafe { sfWindow_setVisible(m_handle, visible) }
    }

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
    public func setMouseCursorVisible(visible: Bool): Unit {
        unsafe { sfWindow_setMouseCursorVisible(m_handle, visible) }
    }

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
    public func setMouseCursorGrabbed(grabbed: Bool): Unit {
        unsafe { sfWindow_setMouseCursorGrabbed(m_handle, grabbed) }
    }

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
    public func setMouseCursor(cursor: Cursor): Unit {
        unsafe { sfWindow_setMouseCursor(m_handle, cursor.handle) }
    }

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
    public func setKeyRepeatEnabled(enabled: Bool): Unit {
        unsafe { sfWindow_setKeyRepeatEnabled(m_handle, enabled) }
    }

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
    public func setJoystickThreshold(threshold: Float32): Unit {
        unsafe { sfWindow_setJoystickThreshold(m_handle, threshold) }
    }

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
    public func requestFocus(): Unit {
        unsafe { sfWindow_requestFocus(m_handle) }
    }

    /**
     * Check whether the window has the input focus.
     *
     * At any given time, only one window may have the input focus
     * to receive input events such as keystrokes or most mouse
     * events.
     *
     * @return `true` if window has focus, `false` otherwise
     */
    public prop hasFocus: Bool {
        get() {
            unsafe { sfWindow_hasFocus(m_handle) }
        }
    }

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
    public prop nativeHandle: CPointer<Unit> {
        get() {
            unsafe { sfWindow_getNativeHandle(m_handle) }
        }
    }

    // Window

    /**
     * Get the settings of the OpenGL context of the window.
     *
     * Note that these settings may be different from what was
     * passed to the constructor or the `create()` function,
     * if one or more settings were not supported. In this case,
     * SFML chose the closest match.
     *
     * @return Structure containing the OpenGL context settings
     */
    public prop settings: ContextSettings {
        get() {
            unsafe { sfWindow_getSettings(m_handle) }
        }
    }

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
    public func setVerticalSyncEnabled(enabled: Bool): Unit {
        unsafe { sfWindow_setVerticalSyncEnabled(m_handle, enabled) }
    }

    /**
     * Limit the framerate to a maximum fixed frequency.
     *
     * If a limit is set, the window will use a small delay after
     * each call to `display()` to ensure that the current frame
     * lasted long enough to match the framerate limit.
     * SFML will try to match the given limit as much as it can,
     * but since it internally uses `sleep`, whose precision
     * depends on the underlying OS, the results may be a little
     * imprecise as well (for example, you can get 65 FPS when
     * requesting 60).
     *
     * @param limit Framerate limit, in frames per seconds (use 0 to disable limit)
     */
    public func setFramerateLimit(limit: UInt32): Unit {
        unsafe { sfWindow_setFramerateLimit(m_handle, limit) }
    }

    /**
     * Activate or deactivate the window as the current target for OpenGL rendering.
     *
     * A window is active only on the current thread, if you want to
     * make it active on another thread you have to deactivate it
     * on the previous thread first if it was active.
     * Only one window can be active on a thread at a time, thus
     * the window previously active (if any) automatically gets deactivated.
     * This is not to be confused with `requestFocus()`.
     *
     * @return `true` if operation was successful, `false` otherwise
     */
    public func setActive(): Bool {
        setActive(true)
    }

    /**
     * Activate or deactivate the window as the current target for OpenGL rendering.
     *
     * A window is active only on the current thread, if you want to
     * make it active on another thread you have to deactivate it
     * on the previous thread first if it was active.
     * Only one window can be active on a thread at a time, thus
     * the window previously active (if any) automatically gets deactivated.
     * This is not to be confused with `requestFocus()`.
     *
     * @param active `true` to activate, `false` to deactivate
     *
     * @return `true` if operation was successful, `false` otherwise
     */
    public func setActive(active: Bool): Bool {
        unsafe { sfWindow_setActive(m_handle, active) }
    }

    /**
     * Display on screen what has been rendered to the window so far.
     *
     * This function is typically called after all OpenGL rendering
     * has been done for the current frame, in order to show
     * it on screen.
     */
    public func display(): Unit {
        unsafe { sfWindow_display(m_handle) }
    }

    // Mouse

    public mut prop mousePosition: Vector2i {
        get() {
            unsafe { sfMouse_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfMouse_setPosition(value, m_handle) }
        }
    }

    // Touch

    public func getTouchPosition(finger: UInt32): Vector2i {
        unsafe { sfTouch_getPosition(finger, m_handle) }
    }
}
