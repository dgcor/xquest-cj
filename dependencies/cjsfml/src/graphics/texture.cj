package cjsfml.graphics

import cjsfml.system.{InputStream, InputStreamData, ResourceHandle, SFMLNullHandleException, Vector2u}
import cjsfml.window.Window

foreign {
    func sfTexture_create(size: Vector2u): CPointer<Unit>

    func sfTexture_createSrgb(size: Vector2u): CPointer<Unit>

    func sfTexture_createFromFile(filename: CString, area: IntRect): CPointer<Unit>

    func sfTexture_createSrgbFromFile(filename: CString, area: IntRect): CPointer<Unit>

    func sfTexture_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative, area: IntRect): CPointer<Unit>

    func sfTexture_createSrgbFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative, area: IntRect): CPointer<Unit>

    func sfTexture_createFromStream(stream: CPointer<InputStreamData>, area: IntRect): CPointer<Unit>

    func sfTexture_createSrgbFromStream(stream: CPointer<InputStreamData>, area: IntRect): CPointer<Unit>

    func sfTexture_createFromImage(image: CPointer<Unit>, area: IntRect): CPointer<Unit>

    func sfTexture_createSrgbFromImage(image: CPointer<Unit>, area: IntRect): CPointer<Unit>

    func sfTexture_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfTexture_destroy(handle: CPointer<Unit>): Unit

    func sfTexture_resize(handle: CPointer<Unit>, size: Vector2u): Bool

    func sfTexture_resizeSrgb(handle: CPointer<Unit>, size: Vector2u): Bool

    func sfTexture_getSize(handle: CPointer<Unit>): Vector2u

    func sfTexture_copyToImage(handle: CPointer<Unit>): CPointer<Unit>

    func sfTexture_updateFromPixels(handle: CPointer<Unit>, pixels: CPointer<Unit>, size: Vector2u, offset: Vector2u): Unit

    func sfTexture_updateFromTexture(handle: CPointer<Unit>, source: CPointer<Unit>, offset: Vector2u): Unit

    func sfTexture_updateFromImage(handle: CPointer<Unit>, image: CPointer<Unit>, offset: Vector2u): Unit

    func sfTexture_updateFromWindow(handle: CPointer<Unit>, window: CPointer<Unit>, offset: Vector2u): Unit

    func sfTexture_updateFromRenderWindow(handle: CPointer<Unit>, renderWindow: CPointer<Unit>, offset: Vector2u): Unit

    func sfTexture_setSmooth(handle: CPointer<Unit>, smooth: Bool): Unit

    func sfTexture_isSmooth(handle: CPointer<Unit>): Bool

    func sfTexture_isSrgb(handle: CPointer<Unit>): Bool

    func sfTexture_setRepeated(handle: CPointer<Unit>, repeated: Bool): Unit

    func sfTexture_isRepeated(handle: CPointer<Unit>): Bool

    func sfTexture_generateMipmap(handle: CPointer<Unit>): Bool

    func sfTexture_swap(handle: CPointer<Unit>, right: CPointer<Unit>): Unit

    func sfTexture_getNativeHandle(handle: CPointer<Unit>): UInt32

    func sfTexture_bind(handle: CPointer<Unit>, coordType: CoordinateType): Unit

    func sfTexture_getMaximumSize(): UInt32
}

public class Texture <: ResourceHandle & Equatable<Texture> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * @throws SFMLNullHandleException
     */
    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(size: Vector2u, sRgb!: Bool = false) {
        unsafe {
            m_handle = match (sRgb) {
                case false => sfTexture_create(size)
                case true => sfTexture_createSrgb(size)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(filename: String, sRgb!: Bool = false, area!: IntRect = IntRect()) {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                m_handle = match (sRgb) {
                    case false => sfTexture_createFromFile(filenameRes.value, area)
                    case true => sfTexture_createSrgbFromFile(filenameRes.value, area)
                }
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(data: Array<Byte>, sRgb!: Bool = false, area!: IntRect = IntRect()) {
        unsafe {
            let rawData = acquireArrayRawData(data) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                m_handle = match (sRgb) {
                    case false => sfTexture_createFromMemory(rawData.pointer, UIntNative(data.size), area)
                    case true => sfTexture_createSrgbFromMemory(rawData.pointer, UIntNative(data.size), area)
                }
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(stream: InputStream, sRgb!: Bool = false, area!: IntRect = IntRect()) {
        unsafe {
            var stream2 = stream.stream
            m_handle = match (sRgb) {
                case false => sfTexture_createFromStream(inout stream2, area)
                case true => sfTexture_createSrgbFromStream(inout stream2, area)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    /**
     * @throws SFMLNullHandleException
     */
    public init(image: Image, sRgb!: Bool = false, area!: IntRect = IntRect()) {
        unsafe {
            m_handle = match (sRgb) {
                case false => sfTexture_createFromImage(image.handle, area)
                case true => sfTexture_createSrgbFromImage(image.handle, area)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

    ~init() {
        if (m_handle.isNotNull() && m_isOwner) {
            unsafe { sfTexture_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
            return
        }
        unsafe { sfTexture_destroy(m_handle) }
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

    public operator override func ==(right: Texture): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Texture): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Texture

    public func copyToImage(): Image {
        Image(unsafe { sfTexture_copyToImage(m_handle) })
    }

    public func resize(size: Vector2u, sRgb!: Bool = false): Bool {
        match (sRgb) {
            case false => unsafe { sfTexture_resize(m_handle, size) }
            case true => unsafe { sfTexture_resizeSrgb(m_handle, size) }
        }
    }

    public prop size: Vector2u {
        get() {
            unsafe { sfTexture_getSize(m_handle) }
        }
    }

    public func update(pixels: Array<UInt8>, size: Vector2u, offset: Vector2u): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                sfTexture_updateFromPixels(m_handle, CPointer(rawData.pointer), size, offset)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func update(pixels: Array<Color>, size: Vector2u, offset: Vector2u): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                sfTexture_updateFromPixels(m_handle, CPointer(rawData.pointer), size, offset)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func update(texture: Texture): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, Vector2u()) }
    }

    public func update(texture: Texture, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, offset) }
    }

    public func update(image: Image): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, Vector2u()) }
    }

    public func update(image: Image, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, offset) }
    }

    public func update(window: Window): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, Vector2u()) }
    }

    public func update(window: Window, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, offset) }
    }

    public func update(window: RenderWindow): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, Vector2u()) }
    }

    public func update(window: RenderWindow, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, offset) }
    }

    public mut prop smooth: Bool {
        get() {
            unsafe { sfTexture_isSmooth(m_handle) }
        }
        set(value) {
            unsafe { sfTexture_setSmooth(m_handle, value) }
        }
    }

    public prop isSrgb: Bool {
        get() {
            unsafe { sfTexture_isSrgb(m_handle) }
        }
    }

    public mut prop repeated: Bool {
        get() {
            unsafe { sfTexture_isRepeated(m_handle) }
        }
        set(value) {
            unsafe { sfTexture_setRepeated(m_handle, value) }
        }
    }

    public func generateMipmap(): Bool {
        unsafe { sfTexture_generateMipmap(m_handle) }
    }

    public func swap(right: Texture): Unit {
        unsafe { sfTexture_swap(m_handle, right.m_handle) }
    }

    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfTexture_getNativeHandle(m_handle) }
        }
    }

    public func bind(coordtype: CoordinateType): Unit {
        unsafe { sfTexture_bind(m_handle, coordtype) }
    }

    public static prop maximumSize: UInt32 { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfTexture_getMaximumSize() }
        }
    }
}
