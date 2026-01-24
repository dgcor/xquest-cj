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

public class RenderWindow <: RenderTarget & SFMLWindow & Equatable<RenderWindow> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
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

    public operator override func ==(right: RenderWindow): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: RenderWindow): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // WindowBase

    public func closeWindow(): Unit {
        unsafe { sfRenderWindow_close(m_handle) }
    }

    public prop isOpen: Bool {
        get() {
            unsafe { sfRenderWindow_isOpen(m_handle) }
        }
    }

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

    public mut prop position: Vector2i {
        get() {
            unsafe { sfRenderWindow_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfRenderWindow_setPosition(m_handle, value) }
        }
    }

    public mut prop size: Vector2u {
        get() {
            unsafe { sfRenderWindow_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfRenderWindow_setSize(m_handle, value) }
        }
    }

    public func setMinimumSize(size: ?Vector2u): Unit {
        match (size) {
            case Some(size) =>
                var size2 = size
                unsafe { sfRenderWindow_setMinimumSize(m_handle, inout size2) }
            case None => unsafe { sfRenderWindow_setMinimumSize(m_handle, CPointer()) }
        }
    }

    public func setMaximumSize(size: ?Vector2u): Unit {
        match (size) {
            case Some(size) =>
                var size2 = size
                unsafe { sfRenderWindow_setMaximumSize(m_handle, inout size2) }
            case None => unsafe { sfRenderWindow_setMaximumSize(m_handle, CPointer()) }
        }
    }

    public func setTitle(title: String): Unit {
        unsafe {
            try (titleRes = (title |> toCStringUtf32).asResource()) {
                sfRenderWindow_setUnicodeTitle(m_handle, titleRes.value)
            }
        }
    }

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

    public func setIcon(size: Vector2u, pixels: CPointer<UInt8>): Unit {
        unsafe {
            sfRenderWindow_setIcon(m_handle, size, pixels)
        }
    }

    public func setVisible(visible: Bool): Unit {
        unsafe { sfRenderWindow_setVisible(m_handle, visible) }
    }

    public func setMouseCursorVisible(visible: Bool): Unit {
        unsafe { sfRenderWindow_setMouseCursorVisible(m_handle, visible) }
    }

    public func setMouseCursorGrabbed(grabbed: Bool): Unit {
        unsafe { sfRenderWindow_setMouseCursorGrabbed(m_handle, grabbed) }
    }

    public func setMouseCursor(cursor: Cursor): Unit {
        unsafe { sfRenderWindow_setMouseCursor(m_handle, cursor.handle) }
    }

    public func setKeyRepeatEnabled(enabled: Bool): Unit {
        unsafe { sfRenderWindow_setKeyRepeatEnabled(m_handle, enabled) }
    }

    public func setJoystickThreshold(threshold: Float32): Unit {
        unsafe { sfRenderWindow_setJoystickThreshold(m_handle, threshold) }
    }

    public func requestFocus(): Unit {
        unsafe { sfRenderWindow_requestFocus(m_handle) }
    }

    public prop hasFocus: Bool {
        get() {
            unsafe { sfRenderWindow_hasFocus(m_handle) }
        }
    }

    public prop nativeHandle: CPointer<Unit> {
        get() {
            unsafe { sfRenderWindow_getNativeHandle(m_handle) }
        }
    }

    // Window

    public prop settings: ContextSettings {
        get() {
            unsafe { sfRenderWindow_getSettings(m_handle) }
        }
    }

    public func setVerticalSyncEnabled(enabled: Bool): Unit {
        unsafe { sfRenderWindow_setVerticalSyncEnabled(m_handle, enabled) }
    }

    public func setFramerateLimit(limit: UInt32): Unit {
        unsafe { sfRenderWindow_setFramerateLimit(m_handle, limit) }
    }

    public func setActive(active: Bool): Bool {
        unsafe { sfRenderWindow_setActive(m_handle, active) }
    }

    public func display(): Unit {
        unsafe { sfRenderWindow_display(m_handle) }
    }

    // RenderTarget

    public func clear(color: Color): Unit {
        unsafe { sfRenderWindow_clear(m_handle, color) }
    }

    public func clearStencil(stencilValue: UInt32): Unit {
        unsafe { sfRenderWindow_clearStencil(m_handle, stencilValue) }
    }

    public func clear(color: Color, stencilValue: UInt32): Unit {
        unsafe { sfRenderWindow_clearColorAndStencil(m_handle, color, stencilValue) }
    }

    public mut prop view: View {
        get() {
            unsafe { View(sfRenderWindow_getView(m_handle), isOwner: false) }
        }
        set(value) {
            unsafe { sfRenderWindow_setView(m_handle, value.handle) }
        }
    }

    public prop defaultView: View {
        get() {
            unsafe { View(sfRenderWindow_getDefaultView(m_handle), isOwner: false) }
        }
    }

    public func getViewport(view: View): IntRect {
        unsafe { sfRenderWindow_getViewport(m_handle, view.handle) }
    }

    public func getScissor(view: View): IntRect {
        unsafe { sfRenderWindow_getScissor(m_handle, view.handle) }
    }

    public func mapPixelToCoords(point: Vector2i, view: View): Vector2f {
        unsafe { sfRenderWindow_mapPixelToCoords(m_handle, point, view.handle) }
    }

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

    public func draw(vertexBuffer: VertexBuffer, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexBuffer(m_handle, vertexBuffer.handle, inout states2)
        }
    }

    public func draw(vertexBuffer: VertexBuffer, firstVertex: Int64, vertexCount: Int64, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawVertexBufferRange(m_handle, vertexBuffer.handle, UIntNative(firstVertex),
                UIntNative(vertexCount), inout states2)
        }
    }

    public prop isSrgb: Bool {
        get() {
            unsafe { sfRenderWindow_isSrgb(m_handle) }
        }
    }

    public func pushGLStates(): Unit {
        unsafe { sfRenderWindow_pushGLStates(m_handle) }
    }

    public func popGLStates(): Unit {
        unsafe { sfRenderWindow_popGLStates(m_handle) }
    }

    public func resetGLStates(): Unit {
        unsafe { sfRenderWindow_resetGLStates(m_handle) }
    }

    // RenderWindow

    public mut prop mousePosition: Vector2i {
        get() {
            unsafe { sfMouse_getPositionRenderWindow(m_handle) }
        }
        set(value) {
            unsafe { sfMouse_setPositionRenderWindow(value, m_handle) }
        }
    }

    public func getTouchPosition(finger: UInt32): Vector2i {
        unsafe { sfTouch_getPositionRenderWindow(finger, m_handle) }
    }
}
