package cjsfml.window

import cenum.*
import cjsfml.system.*

foreign {
    func sfCursor_createFromPixels(pixels: CPointer<UInt8>, size: Vector2u, hotspot: Vector2u): CPointer<Unit>

    func sfCursor_createFromSystem(cursorType: CursorType): CPointer<Unit>

    func sfCursor_destroy(handle: CPointer<Unit>): Unit
}

@CEnum[public CursorType](
    Arrow
    ArrowWait
    Wait
    Text
    Hand
    SizeHorizontal
    SizeVertical
    SizeTopLeftBottomRight
    SizeBottomLeftTopRight
    SizeLeft
    SizeRight
    SizeTop
    SizeBottom
    SizeTopLeft
    SizeBottomRight
    SizeBottomLeft
    SizeTopRight
    SizeAll
    Cross
    Help
    NotAllowed
)

public class Cursor <: ResourceHandle & Equatable<Cursor> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init(pixels: Array<UInt8>, size: Vector2u, hotspot: Vector2u) {
        if (pixels.size < Int64(size.x) * Int64(size.y)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels)
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

    public operator override func ==(right: Cursor): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Cursor): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }
}
