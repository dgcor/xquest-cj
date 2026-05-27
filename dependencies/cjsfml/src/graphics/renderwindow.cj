package cjsfml.graphics

import cjsfml.system.{SFMLNullHandleException, Time, toCStringUtf32, Vector2f, Vector2i, Vector2u}
import cjsfml.window.{ContextSettings, Cursor, Event, SFMLWindow, VideoMode, WindowState, WindowStyle}

foreign {
    func sfRenderWindow_createUnicode(mode: VideoMode, title: CPointer<UInt32>, style: WindowStyle, state: WindowState,
        settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfRenderWindow_createFromHandle(handle: CPointer<Unit>, settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfRenderWindow_destroy(handle: CPointer<Unit>): Unit

    // WindowBase

    func sfRenderWindow_close(handle: CPointer<Unit>): Unit

    func sfRenderWindow_isOpen(handle: CPointer<Unit>): Bool

    func sfRenderWindow_pollEvent(handle: CPointer<Unit>, event: CPointer<Byte>): Bool

    func sfRenderWindow_waitEvent(handle: CPointer<Unit>, timeout: Time, event: CPointer<Byte>): Bool

    func sfRenderWindow_getPosition(handle: CPointer<Unit>): Vector2i

    func sfRenderWindow_setPosition(handle: CPointer<Unit>, position: Vector2i): Unit

    func sfRenderWindow_getSize(handle: CPointer<Unit>): Vector2u

    func sfRenderWindow_setSize(handle: CPointer<Unit>, size: Vector2u): Unit

    func sfRenderWindow_setMinimumSize(handle: CPointer<Unit>, minimumSize: CPointer<Vector2u>): Unit

    func sfRenderWindow_setMaximumSize(handle: CPointer<Unit>, maximumSize: CPointer<Vector2u>): Unit

    func sfRenderWindow_setUnicodeTitle(handle: CPointer<Unit>, title: CPointer<UInt32>): Unit

    func sfRenderWindow_setIcon(handle: CPointer<Unit>, size: Vector2u, pixels: CPointer<UInt8>): Unit

    func sfRenderWindow_setVisible(handle: CPointer<Unit>, visible: Bool): Unit

    func sfRenderWindow_setMouseCursorVisible(handle: CPointer<Unit>, visible: Bool): Unit

    func sfRenderWindow_setMouseCursorGrabbed(handle: CPointer<Unit>, grabbed: Bool): Unit

    func sfRenderWindow_setMouseCursor(handle: CPointer<Unit>, cursor: CPointer<Unit>): Unit

    func sfRenderWindow_setKeyRepeatEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfRenderWindow_setJoystickThreshold(handle: CPointer<Unit>, threshold: Float32): Unit

    func sfRenderWindow_requestFocus(handle: CPointer<Unit>): Unit

    func sfRenderWindow_hasFocus(handle: CPointer<Unit>): Bool

    func sfRenderWindow_getNativeHandle(handle: CPointer<Unit>): CPointer<Unit>

    // Window

    func sfRenderWindow_getSettings(handle: CPointer<Unit>): ContextSettings

    func sfRenderWindow_setVerticalSyncEnabled(handle: CPointer<Unit>, enabled: Bool): Unit

    func sfRenderWindow_setFramerateLimit(handle: CPointer<Unit>, limit: UInt32): Unit

    func sfRenderWindow_setActive(handle: CPointer<Unit>, active: Bool): Bool

    func sfRenderWindow_display(handle: CPointer<Unit>): Unit

    // RenderTarget

    func sfRenderWindow_clear(handle: CPointer<Unit>, color: Color): Unit

    func sfRenderWindow_clearStencil(handle: CPointer<Unit>, stencilValue: UInt32): Unit

    func sfRenderWindow_clearColorAndStencil(handle: CPointer<Unit>, color: Color, stencilValue: UInt32): Unit

    func sfRenderWindow_setView(handle: CPointer<Unit>, view: CPointer<Unit>): Unit

    func sfRenderWindow_getView(handle: CPointer<Unit>): CPointer<Unit>

    func sfRenderWindow_getDefaultView(handle: CPointer<Unit>): CPointer<Unit>

    func sfRenderWindow_getViewport(handle: CPointer<Unit>, view: CPointer<Unit>): IntRect

    func sfRenderWindow_getScissor(handle: CPointer<Unit>, view: CPointer<Unit>): IntRect

    func sfRenderWindow_mapPixelToCoords(handle: CPointer<Unit>, point: Vector2i, view: CPointer<Unit>): Vector2f

    func sfRenderWindow_mapCoordsToPixel(handle: CPointer<Unit>, point: Vector2f, view: CPointer<Unit>): Vector2i

    func sfRenderWindow_drawSprite(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawText(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>, states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>, states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawCircleShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawConvexShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawRectangleShape(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawVertexArray(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawVertexBuffer(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawVertexBufferRange(handle: CPointer<Unit>, drawablehandle: CPointer<Unit>,
        firstVertex: UIntNative, vertexCount: UIntNative, states: CPointer<RenderStates>): Unit

    func sfRenderWindow_drawPrimitives(handle: CPointer<Unit>, vertices: CPointer<Vertex>, vertexCount: UIntNative,
        primitiveType: PrimitiveType, states: CPointer<RenderStates>): Unit

    func sfRenderWindow_isSrgb(handle: CPointer<Unit>): Bool

    func sfRenderWindow_pushGLStates(handle: CPointer<Unit>): Unit

    func sfRenderWindow_popGLStates(handle: CPointer<Unit>): Unit

    func sfRenderWindow_resetGLStates(handle: CPointer<Unit>): Unit

    // RenderWindow

    func sfMouse_getPositionRenderWindow(relativeTo: CPointer<Unit>): Vector2i

    func sfMouse_setPositionRenderWindow(position: Vector2i, relativeTo: CPointer<Unit>): Unit

    func sfTouch_getPositionRenderWindow(finger: UInt32, relativeTo: CPointer<Unit>): Vector2i
}

/**
 * Window that can serve as a target for 2D drawing.
 *
 * `RenderWindow` is the main class of the Graphics module.
 * It defines an OS window that can be painted using the other
 * classes of the graphics module.
 *
 * `RenderWindow` is derived from `Window`, thus it inherits
 * all its features: events, window management, OpenGL rendering,
 * etc. See the documentation of `Window` for a more complete
 * description of all these features, as well as code examples.
 *
 * On top of that, `RenderWindow` adds more features related to
 * 2D drawing with the graphics module (see its base class
 * `RenderTarget` for more details).
 * Here is a typical rendering and event loop with a `RenderWindow`:
 *
 * ```
 * // Declare and create a new render-window
 * let window = RenderWindow(VideoMode(Vector2u(800, 600)), "SFML window");
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
 *    // Clear the whole window before rendering a new frame
 *    window.clear(Color.BLACK);
 *
 *    // Draw some graphical entities
 *    window.draw(sprite);
 *    window.draw(circle);
 *    window.draw(text);
 *
 *    // End the current frame and display its contents on screen
 *    window.display();
 * }
 * ```
 *
 * Like `Window`, `RenderWindow` is still able to render direct
 * OpenGL stuff. It is even possible to mix together OpenGL calls
 * and regular SFML drawing commands.
 *
 * @see `Window`, `RenderTarget`, `RenderTexture`, `View`
 */
public class RenderWindow <: RenderTarget & SFMLWindow & Equatable<RenderWindow> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct a new window.
     *
     * This constructor creates the window with the size and pixel
     * depth defined in `mode`. An optional style can be passed to
     * customize the look and behavior of the window (borders,
     * title bar, resizable, closable, ...).
     *
     * The last parameter is an optional structure specifying
     * advanced OpenGL context settings such as anti-aliasing,
     * depth-buffer bits, etc. You shouldn't care about these
     * parameters for a regular usage of the graphics module.
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
                m_handle = sfRenderWindow_createUnicode(mode, titleRes.value, style, state, inout settings2)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the window from an existing control.
     *
     * Use this constructor if you want to create an SFML
     * rendering area into an already existing control.
     *
     * The second parameter is an optional structure specifying
     * advanced OpenGL context settings such as anti-aliasing,
     * depth-buffer bits, etc. You shouldn't care about these
     * parameters for a regular usage of the graphics module.
     *
     * @param handle   Platform-specific handle of the control
     * @param settings Additional settings for the underlying OpenGL context
     *
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, settings!: ContextSettings = ContextSettings()) {
        unsafe {
            var settings2 = settings
            m_handle = sfRenderWindow_createFromHandle(handle, inout settings2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfRenderWindow_destroy(m_handle) }
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
     * After calling this function, the `RenderWindow` instance remains
     * valid and you can call `create()` to recreate the window.
     * All other functions such as `pollEvent()` or `display()` will
     * still work (i.e. you don't have to test `isOpen` every time),
     * and will have no effect on closed windows.
     */
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfRenderWindow_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public prop isOwner: Bool {
        get() {
            true
        }
    }

    // Equatable

    public override operator func ==(right: RenderWindow): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: RenderWindow): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // WindowBase

    public func closeWindow(): Unit {
        unsafe { sfRenderWindow_close(m_handle) }
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
            unsafe { sfRenderWindow_isOpen(m_handle) }
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
                if (sfRenderWindow_pollEvent(m_handle, rawData.pointer)) {
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
            let rawData = acquireArrayRawData(data)
            try {
                if (sfRenderWindow_waitEvent(m_handle, timeout, rawData.pointer)) {
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
            unsafe { sfRenderWindow_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfRenderWindow_setPosition(m_handle, value) }
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
            unsafe { sfRenderWindow_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfRenderWindow_setSize(m_handle, value) }
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
                unsafe { sfRenderWindow_setMinimumSize(m_handle, inout size2) }
            case None => unsafe { sfRenderWindow_setMinimumSize(m_handle, CPointer()) }
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
                unsafe { sfRenderWindow_setMaximumSize(m_handle, inout size2) }
            case None => unsafe { sfRenderWindow_setMaximumSize(m_handle, CPointer()) }
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
                sfRenderWindow_setUnicodeTitle(m_handle, titleRes.value)
            }
        }
    }

    /**
     * Change the window's icon.
     *
     * @param size   Icon width and height, in pixels
     * @param pixels Array of pixel data. The pixels are copied, so you need not keep the
     *               source alive after calling this function.
     */
    public func setIcon(size: Vector2u, pixels: Array<UInt8>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                sfRenderWindow_setIcon(m_handle, size, CPointer(rawData.pointer))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Change the window's icon.
     *
     * @param size   Icon width and height, in pixels
     * @param pixels Pointer to the array of pixels in memory. The
     *               pixels are copied, so you need not keep the
     *               source alive after calling this function.
     */
    public func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit {
        unsafe {
            sfRenderWindow_setIcon(m_handle, size, pixels)
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
        unsafe { sfRenderWindow_setVisible(m_handle, visible) }
    }

    /**
     * Show or hide the mouse cursor.
     *
     * The mouse cursor is visible by default.
     *
     * @param visible `true` to show the mouse cursor, `false` to hide it
     */
    public func setMouseCursorVisible(visible: Bool): Unit {
        unsafe { sfRenderWindow_setMouseCursorVisible(m_handle, visible) }
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
        unsafe { sfRenderWindow_setMouseCursorGrabbed(m_handle, grabbed) }
    }

    /**
     * Set the displayed cursor to a native system cursor.
     *
     * Upon window creation, the arrow cursor is used by default.
     *
     * @param cursor Native system cursor type to display
     */
    public func setMouseCursor(cursor: Cursor): Unit {
        unsafe { sfRenderWindow_setMouseCursor(m_handle, cursor.handle) }
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
        unsafe { sfRenderWindow_setKeyRepeatEnabled(m_handle, enabled) }
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
        unsafe { sfRenderWindow_setJoystickThreshold(m_handle, threshold) }
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
        unsafe { sfRenderWindow_requestFocus(m_handle) }
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
            unsafe { sfRenderWindow_hasFocus(m_handle) }
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
            unsafe { sfRenderWindow_getNativeHandle(m_handle) }
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
            unsafe { sfRenderWindow_getSettings(m_handle) }
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
        unsafe { sfRenderWindow_setVerticalSyncEnabled(m_handle, enabled) }
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
        unsafe { sfRenderWindow_setFramerateLimit(m_handle, limit) }
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
        unsafe { sfRenderWindow_setActive(m_handle, active) }
    }

    /**
     * Display on screen what has been rendered to the window so far.
     *
     * This function is typically called after all OpenGL rendering
     * has been done for the current frame, in order to show
     * it on screen.
     */
    public func display(): Unit {
        unsafe { sfRenderWindow_display(m_handle) }
    }

    // RenderTarget

    /**
     * Clear the entire target with a single color.
     *
     * This function is usually called once every frame,
     * to clear the previous contents of the target.
     *
     * @param color Fill color to use to clear the render target
     */
    public func clear(color: Color): Unit {
        unsafe { sfRenderWindow_clear(m_handle, color) }
    }

    /**
     * Clear the stencil buffer.
     *
     * @param stencilValue Value to use to clear the stencil buffer
     */
    public func clearStencil(stencilValue: UInt32): Unit {
        unsafe { sfRenderWindow_clearStencil(m_handle, stencilValue) }
    }

    /**
     * Clear the entire target with a single color and clear the stencil buffer.
     *
     * @param color        Fill color to use to clear the render target
     * @param stencilValue Value to use to clear the stencil buffer
     */
    public func clear(color: Color, stencilValue: UInt32): Unit {
        unsafe { sfRenderWindow_clearColorAndStencil(m_handle, color, stencilValue) }
    }

    /**
     * Change the current active view.
     *
     * The view is like a 2D camera, it controls which part of
     * the 2D scene is visible, and how it is viewed by the target.
     *
     * @param value New view to use
     */
    public mut prop view: View {
        get() {
            unsafe { View(sfRenderWindow_getView(m_handle), isOwner: false) }
        }
        set(value) {
            unsafe { sfRenderWindow_setView(m_handle, value.handle) }
        }
    }

    /**
     * Get the default view of the render target.
     *
     * The default view has the initial size of the render target,
     * and never changes after the target has been created.
     *
     * @return The default view of the render target
     */
    public prop defaultView: View {
        get() {
            unsafe { View(sfRenderWindow_getDefaultView(m_handle), isOwner: false) }
        }
    }

    /**
     * Get the viewport of a view, applied to this render target.
     *
     * The viewport is defined in the view as a ratio, this function
     * simply converts this ratio into pixels.
     *
     * @param view The view for which we want to compute the viewport
     *
     * @return Viewport rectangle, expressed in pixels
     */
    public func getViewport(view: View): IntRect {
        unsafe { sfRenderWindow_getViewport(m_handle, view.handle) }
    }

    /**
     * Get the scissor rectangle of a view, applied to this render target.
     *
     * The scissor rectangle is defined in the view as a ratio, this function
     * simply converts this ratio into pixels.
     *
     * @param view The view for which we want to compute the scissor rectangle
     *
     * @return Scissor rectangle, expressed in pixels
     */
    public func getScissor(view: View): IntRect {
        unsafe { sfRenderWindow_getScissor(m_handle, view.handle) }
    }

    /**
     * Convert a point from target coordinates to world coordinates.
     *
     * This function uses the current view.
     *
     * @param point Pixel to convert
     * @param view  The view to use for converting the point
     *
     * @return The converted point, in "world" coordinates
     */
    public func mapPixelToCoords(point: Vector2i, view: View): Vector2f {
        unsafe { sfRenderWindow_mapPixelToCoords(m_handle, point, view.handle) }
    }

    /**
     * Convert a point from world coordinates to target coordinates.
     *
     * This function uses the current view.
     *
     * @param point Point to convert
     * @param view  The view to use for converting the point
     *
     * @return The converted point, in target coordinates (pixels)
     */
    public func mapCoordsToPixel(point: Vector2f, view: View): Vector2i {
        unsafe { sfRenderWindow_mapCoordsToPixel(m_handle, point, view.handle) }
    }

    // cjlint-ignore -start !G.ITF.04 using interface as type parameter

    public func drawRenderTarget(drawable: RenderTargetDrawable, states: RenderStates): Unit {
        drawable.draw(this, states)
    }

    public func draw(drawable: Drawable, states: RenderStates): Unit {
        drawable.draw(this, states)
    }

    // cjlint-ignore -end using interface as type parameter

    /**
     * Draw primitives defined by an array of vertices.
     *
     * @param vertices      Array of vertices to draw
     * @param primitiveType Type of primitives to draw
     * @param states        Render states to use for drawing
     */
    public func draw(vertices: Array<Vertex>, primitiveType: PrimitiveType, states: RenderStates): Unit {
        unsafe {
            let rawData = acquireArrayRawData(vertices) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                var states2 = states
                sfRenderWindow_drawPrimitives(m_handle, rawData.pointer, UIntNative(vertices.size), primitiveType,
                    inout states2)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    /**
     * Draw a vertex buffer.
     *
     * @param vertexBuffer Vertex buffer to draw
     * @param states       Render states to use for drawing
     */
    public func draw(vertexBuffer: VertexBuffer, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexBuffer(m_handle, vertexBuffer.handle, inout states2)
        }
    }

    /**
     * Draw a range of a vertex buffer.
     *
     * @param vertexBuffer Vertex buffer to draw
     * @param firstVertex  Index of the first vertex to draw
     * @param vertexCount  Number of vertices to draw
     * @param states       Render states to use for drawing
     */
    public func draw(vertexBuffer: VertexBuffer, firstVertex: Int64, vertexCount: Int64, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexBufferRange(m_handle, vertexBuffer.handle, UIntNative(firstVertex),
                UIntNative(vertexCount), inout states2)
        }
    }

    /**
     * Tell if the window will use sRGB encoding when drawing on it.
     *
     * You can request sRGB encoding for a window by having the sRgbCapable flag set in the `ContextSettings`
     *
     * @return `true` if the window use sRGB encoding, `false` otherwise
     */
    public prop isSrgb: Bool {
        get() {
            unsafe { sfRenderWindow_isSrgb(m_handle) }
        }
    }

    /**
     * Save the current OpenGL render states.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func pushGLStates(): Unit {
        unsafe { sfRenderWindow_pushGLStates(m_handle) }
    }

    /**
     * Restore the previously saved OpenGL render states.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func popGLStates(): Unit {
        unsafe { sfRenderWindow_popGLStates(m_handle) }
    }

    /**
     * Reset the internal OpenGL states so that the target is ready for drawing.
     *
     * This function is for users who need to mix SFML drawing
     * and raw OpenGL rendering.
     */
    public func resetGLStates(): Unit {
        unsafe { sfRenderWindow_resetGLStates(m_handle) }
    }

    // RenderWindow

    /**
     * Get the position of the mouse cursor, relative to the window.
     *
     * @return Mouse position, relative to the window
     */
    public mut prop mousePosition: Vector2i {
        get() {
            unsafe { sfMouse_getPositionRenderWindow(m_handle) }
        }
        set(value) {
            unsafe { sfMouse_setPositionRenderWindow(value, m_handle) }
        }
    }

    /**
     * Get the position of a touch, relative to the window.
     *
     * @param finger Finger index
     *
     * @return Touch position, relative to the window
     */
    public func getTouchPosition(finger: UInt32): Vector2i {
        unsafe { sfTouch_getPositionRenderWindow(finger, m_handle) }
    }
}
