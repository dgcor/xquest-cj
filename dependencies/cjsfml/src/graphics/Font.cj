package cjsfml.graphics

import cjsfml.system.*

foreign {
    func sfFont_createFromFile(filename: CString): CPointer<Unit>

    func sfFont_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfFont_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfFont_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfFont_destroy(handle: CPointer<Unit>): Unit

    func sfFont_getGlyph(handle: CPointer<Unit>, codePoint: UInt32, characterSize: UInt32, bold: SfBool,
        outlineThickness: Float32): Glyph

    func sfFont_hasGlyph(handle: CPointer<Unit>, codePoint: UInt32): SfBool

    func sfFont_getKerning(handle: CPointer<Unit>, first: UInt32, second: UInt32, characterSize: UInt32): Float32

    func sfFont_getBoldKerning(handle: CPointer<Unit>, first: UInt32, second: UInt32, characterSize: UInt32): Float32

    func sfFont_getLineSpacing(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getUnderlinePosition(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getUnderlineThickness(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getTexture(handle: CPointer<Unit>, characterSize: UInt32): CPointer<Unit>

    func sfFont_setSmooth(handle: CPointer<Unit>, smooth: SfBool): Unit

    func sfFont_isSmooth(handle: CPointer<Unit>): SfBool

    func sfFont_getInfo(handle: CPointer<Unit>): CString
}

public class Font <: ResourceHandle & Equatable<Font> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    public init(filename: String) {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                m_handle = sfFont_createFromFile(filenameRes.value)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    public init(data: Array<Byte>) {
        unsafe {
            let rawData = acquireArrayRawData(data)
            try {
                m_handle = sfFont_createFromMemory(rawData.pointer, UIntNative(data.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    public init(stream: InputStream) {
        unsafe {
            var stream2 = stream.stream
            m_handle = sfFont_createFromStream(inout stream2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfFont_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    public func clone() {
        Font(unsafe { sfFont_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || m_isOwner == false) {
            return
        }
        unsafe { sfFont_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    public override prop isOwner: Bool {
        get() {
            m_isOwner
        }
    }

    // Equatable

    public operator override func ==(right: Font): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Font): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Font

    public func getGlyph(codePoint: Rune, characterSize: UInt32, bold!: Bool, outlineThickness!: Float32 = 0.0): Glyph {
        unsafe { sfFont_getGlyph(m_handle, UInt32(codePoint), characterSize, SfBool.fromBool(bold), outlineThickness) }
    }

    public func hasGlyph(codePoint: Rune): Bool {
        unsafe { sfFont_hasGlyph(m_handle, UInt32(codePoint)).toBool() }
    }

    public func getKerning(first: UInt32, second: UInt32, characterSize: UInt32, bold!: Bool = false): Float32 {
        match (bold) {
            case false => unsafe { sfFont_getKerning(m_handle, first, second, characterSize) }
            case true => unsafe { sfFont_getBoldKerning(m_handle, first, second, characterSize) }
        }
    }

    public func getLineSpacing(characterSize: UInt32): Float32 {
        unsafe { sfFont_getLineSpacing(m_handle, characterSize) }
    }

    public func getUnderlinePosition(characterSize: UInt32): Float32 {
        unsafe { sfFont_getUnderlinePosition(m_handle, characterSize) }
    }

    public func getUnderlineThickness(characterSize: UInt32): Float32 {
        unsafe { sfFont_getUnderlineThickness(m_handle, characterSize) }
    }

    public func getTexture(characterSize: UInt32): Texture {
        Texture(unsafe { sfFont_getTexture(m_handle, characterSize) }, isOwner: false)
    }

    public mut prop smooth: Bool {
        get() {
            unsafe { sfFont_isSmooth(m_handle).toBool() }
        }
        set(value) {
            unsafe { sfFont_setSmooth(m_handle, SfBool.fromBool(value)) }
        }
    }

    public prop info: String {
        get() {
            unsafe { sfFont_getInfo(m_handle).toString() }
        }
    }
}
