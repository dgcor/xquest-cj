package cjsfml.window

import cjsfml.system.*

foreign {
    func sfWindow_createUnicode(mode: VideoMode, title: CPointer<UInt32>, style: WindowStyle,
        settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfWindow_createFromHandle(handle: CPointer<Unit>, settings: CPointer<ContextSettings>): CPointer<Unit>

    func sfWindow_destroy(handle: CPointer<Unit>): Unit

    // WindowBase

    func sfWindow_close(handle: CPointer<Unit>): Unit

    func sfWindow_isOpen(handle: CPointer<Unit>): SfBool

    func sfWindow_pollEvent(handle: CPointer<Unit>, event: CPointer<Byte>): SfBool

    func sfWindow_waitEvent(handle: CPointer<Unit>, event: CPointer<Byte>): SfBool

    func sfWindow_getPosition(handle: CPointer<Unit>): Vector2i

    func sfWindow_setPosition(handle: CPointer<Unit>, position: Vector2i): Unit

    func sfWindow_getSize(handle: CPointer<Unit>): Vector2u

    func sfWindow_setSize(handle: CPointer<Unit>, size: Vector2u): Unit

    func sfWindow_setUnicodeTitle(handle: CPointer<Unit>, title: CPointer<UInt32>): Unit

    func sfWindow_setIcon(handle: CPointer<Unit>, width: UInt32, height: UInt32, pixels: CPointer<UInt8>): Unit

    func sfWindow_setVisible(handle: CPointer<Unit>, visible: SfBool): Unit

    func sfWindow_setMouseCursorVisible(handle: CPointer<Unit>, visible: SfBool): Unit

    func sfWindow_setMouseCursorGrabbed(handle: CPointer<Unit>, grabbed: SfBool): Unit

    func sfWindow_setMouseCursor(handle: CPointer<Unit>, cursor: CPointer<Unit>): Unit

    func sfWindow_setKeyRepeatEnabled(handle: CPointer<Unit>, enabled: SfBool): Unit

    func sfWindow_setJoystickThreshold(handle: CPointer<Unit>, threshold: Float32): Unit

    func sfWindow_requestFocus(handle: CPointer<Unit>): Unit

    func sfWindow_hasFocus(handle: CPointer<Unit>): SfBool

    func sfWindow_getSystemHandle(handle: CPointer<Unit>): CPointer<Unit>

    // Window

    func sfWindow_getSettings(handle: CPointer<Unit>): ContextSettings

    func sfWindow_setVerticalSyncEnabled(handle: CPointer<Unit>, enabled: SfBool): Unit

    func sfWindow_setFramerateLimit(handle: CPointer<Unit>, limit: UInt32): Unit

    func sfWindow_setActive(handle: CPointer<Unit>, active: SfBool): SfBool

    func sfWindow_display(handle: CPointer<Unit>): Unit
}

public class Window <: SFMLWindow & Equatable<Window> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init(mode: VideoMode, title: String, style!: WindowStyle = WindowStyle.Default,
        settings!: ContextSettings = ContextSettings()) {
        unsafe {
            try (titleRes = (title |> toCStringUtf32).asResource()) {
                var settings2 = settings
                m_handle = sfWindow_createUnicode(mode, titleRes.value, style, inout settings2)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(handle: CPointer<Unit>, settings!: ContextSettings = ContextSettings()) {
        var settings2 = settings
        m_handle = unsafe { sfWindow_createFromHandle(handle, inout settings2) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
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

    public operator override func ==(right: Window): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Window): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // WindowBase

    public func closeWindow(): Unit {
        unsafe { sfWindow_close(m_handle) }
    }

    public prop isOpen: Bool {
        get() {
            unsafe { sfWindow_isOpen(m_handle).toBool() }
        }
    }

    public func pollEvent(): ?Event {
        var data = Event.getEmpty()
        unsafe {
            let rawData = acquireArrayRawData(data)
            try {
                if (sfWindow_pollEvent(m_handle, rawData.pointer).toBool()) {
                    return Event.create(data)
                }
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        return None
    }

    public func waitEvent(): ?Event {
        var data = Event.getEmpty()
        unsafe {
            let rawData = acquireArrayRawData(data)
            try {
                if (sfWindow_waitEvent(m_handle, rawData.pointer).toBool()) {
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
            unsafe { sfWindow_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfWindow_setPosition(m_handle, value) }
        }
    }

    public mut prop size: Vector2u {
        get() {
            unsafe { sfWindow_getSize(m_handle) }
        }
        set(value) {
            unsafe { sfWindow_setSize(m_handle, value) }
        }
    }

    public func setTitle(title: String): Unit {
        unsafe {
            try (titleRes = (title |> toCStringUtf32).asResource()) {
                sfWindow_setUnicodeTitle(m_handle, titleRes.value)
            }
        }
    }

    public func setIcon(width: UInt32, height: UInt32, pixels: Array<UInt8>): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels)
            try {
                sfWindow_setIcon(m_handle, width, height, CPointer(rawData.pointer))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func setIcon(width: UInt32, height: UInt32, pixels: CPointer<UInt8>): Unit {
        unsafe {
            sfWindow_setIcon(m_handle, width, height, pixels)
        }
    }

    public func setVisible(visible: Bool): Unit {
        unsafe { sfWindow_setVisible(m_handle, SfBool.fromBool(visible)) }
    }

    public func setMouseCursorVisible(visible: Bool): Unit {
        unsafe { sfWindow_setMouseCursorVisible(m_handle, SfBool.fromBool(visible)) }
    }

    public func setMouseCursorGrabbed(grabbed: Bool): Unit {
        unsafe { sfWindow_setMouseCursorGrabbed(m_handle, SfBool.fromBool(grabbed)) }
    }

    public func setMouseCursor(cursor: Cursor): Unit {
        unsafe { sfWindow_setMouseCursor(m_handle, cursor.handle) }
    }

    public func setKeyRepeatEnabled(enabled: Bool): Unit {
        unsafe { sfWindow_setKeyRepeatEnabled(m_handle, SfBool.fromBool(enabled)) }
    }

    public func setJoystickThreshold(threshold: Float32): Unit {
        unsafe { sfWindow_setJoystickThreshold(m_handle, threshold) }
    }

    public func requestFocus(): Unit {
        unsafe { sfWindow_requestFocus(m_handle) }
    }

    public prop hasFocus: Bool {
        get() {
            unsafe { sfWindow_hasFocus(m_handle).toBool() }
        }
    }

    public prop systemHandle: CPointer<Unit> {
        get() {
            unsafe { sfWindow_getSystemHandle(m_handle) }
        }
    }

    // Window

    public prop settings: ContextSettings {
        get() {
            unsafe { sfWindow_getSettings(m_handle) }
        }
    }

    public func setVerticalSyncEnabled(enabled: Bool): Unit {
        unsafe { sfWindow_setVerticalSyncEnabled(m_handle, SfBool.fromBool(enabled)) }
    }

    public func setFramerateLimit(limit: UInt32): Unit {
        unsafe { sfWindow_setFramerateLimit(m_handle, limit) }
    }

    public func setActive(): Bool {
        setActive(true)
    }

    public func setActive(active: Bool): Bool {
        unsafe { sfWindow_setActive(m_handle, SfBool.fromBool(active)).toBool() }
    }

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
