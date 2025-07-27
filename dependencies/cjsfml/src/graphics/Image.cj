package cjsfml.graphics

import cjsfml.system.*

foreign {
    func sfImage_create(width: UInt32, height: UInt32): CPointer<Unit>

    func sfImage_createFromColor(width: UInt32, height: UInt32, color: Color): CPointer<Unit>

    func sfImage_createFromPixels(width: UInt32, height: UInt32, pixels: CPointer<UInt8>): CPointer<Unit>

    func sfImage_createFromFile(filename: CString): CPointer<Unit>

    func sfImage_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfImage_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfImage_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfImage_destroy(handle: CPointer<Unit>): Unit

    func sfImage_saveToFile(handle: CPointer<Unit>, filename: CString): SfBool

    func sfImage_saveToMemory(handle: CPointer<Unit>, buffer: CPointer<Unit>, format: CString): SfBool

    func sfImage_getSize(handle: CPointer<Unit>): Vector2u

    func sfImage_createMaskFromColor(handle: CPointer<Unit>, color: Color, alpha: UInt8): Unit

    func sfImage_copyImage(handle: CPointer<Unit>, sourceHandle: CPointer<Unit>, destX: UInt32, destY: UInt32,
        sourceRect: IntRect, applyAlpha: SfBool): Unit

    @FastNative
    func sfImage_setPixel(handle: CPointer<Unit>, x: UInt32, y: UInt32, color: Color): Unit

    @FastNative
    func sfImage_getPixel(handle: CPointer<Unit>, x: UInt32, y: UInt32): Color

    @FastNative
    func sfImage_getPixelsPtr(handle: CPointer<Unit>): CPointer<UInt8>

    func sfImage_flipHorizontally(handle: CPointer<Unit>): Unit

    func sfImage_flipVertically(handle: CPointer<Unit>): Unit
}

public class Image <: ResourceHandle & Equatable<Image> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init(width: UInt32, height: UInt32) {
        m_handle = unsafe { sfImage_create(width, height) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(width: UInt32, height: UInt32, color: Color) {
        m_handle = unsafe { sfImage_createFromColor(width, height, color) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(width: UInt32, height: UInt32, pixels: Array<Color>) {
        if (pixels.size < Int64(width) * Int64(height)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels)
            try {
                m_handle = sfImage_createFromPixels(width, height, CPointer<UInt8>(rawData.pointer))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(width: UInt32, height: UInt32, pixels: Array<UInt8>) {
        if (pixels.size < Int64(width) * Int64(height)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels)
            try {
                m_handle = sfImage_createFromPixels(width, height, rawData.pointer)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(filename: String) {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                m_handle = sfImage_createFromFile(filenameRes.value)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(data: Array<Byte>) {
        unsafe {
            let rawData = acquireArrayRawData(data)
            m_handle = sfImage_createFromMemory(rawData.pointer, UIntNative(data.size))
            releaseArrayRawData(rawData)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    public init(stream: InputStream) {
        unsafe {
            var stream2 = stream.stream
            m_handle = sfImage_createFromStream(inout stream2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    protected init(handle: CPointer<Unit>) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfImage_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone() {
        Image(unsafe { sfImage_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfImage_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public operator override func ==(right: Image): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Image): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Image

    public func saveToFile(filename: String): Bool {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                return sfImage_saveToFile(m_handle, filenameRes.value).toBool()
            }
        }
        return false
    }

    public func saveToMemory(format: String): ?Array<Byte> {
        unsafe {
            try (buffer = Buffer(), formatRes = LibC.mallocCString(format).asResource()) {
                if (sfImage_saveToMemory(m_handle, buffer.handle, formatRes.value).toBool()) {
                    let data = buffer.data
                    return Array<Byte>(
                        buffer.size,
                        {
                            index => data.read(index)
                        }
                    )
                }
            }
        }
        return None
    }

    public prop size: Vector2u {
        get() {
            unsafe { sfImage_getSize(m_handle) }
        }
    }

    public func createMaskFromColor(color: Color, alpha!: UInt8 = 0): Unit {
        unsafe { sfImage_createMaskFromColor(m_handle, color, alpha) }
    }

    public func copy(source: Image, destX: UInt32, destY: UInt32, sourceRect!: IntRect = IntRect(),
        applyAlpha!: Bool = false): Unit {
        unsafe { sfImage_copyImage(m_handle, source.m_handle, destX, destY, sourceRect, SfBool.fromBool(applyAlpha)) }
    }

    public func getPixel(x: UInt32, y: UInt32): Color {
        unsafe { sfImage_getPixel(m_handle, x, y) }
    }

    public func setPixel(x: UInt32, y: UInt32, color: Color): Unit {
        unsafe { sfImage_setPixel(m_handle, x, y, color) }
    }

    public prop pixelsPtr: CPointer<UInt8> {
        get() {
            unsafe { sfImage_getPixelsPtr(m_handle) }
        }
    }

    public func flipHorizontally(): Unit {
        unsafe { sfImage_flipHorizontally(m_handle) }
    }

    public func flipVertically(): Unit {
        unsafe { sfImage_flipVertically(m_handle) }
    }
}
