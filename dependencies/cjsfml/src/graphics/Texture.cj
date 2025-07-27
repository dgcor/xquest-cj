package cjsfml.graphics

import cenum.*
import cjsfml.system.*
import cjsfml.window.*

foreign {
    func sfTexture_create(width: UInt32, height: UInt32): CPointer<Unit>

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

    func sfTexture_getSize(handle: CPointer<Unit>): Vector2u

    func sfTexture_copyToImage(handle: CPointer<Unit>): CPointer<Unit>

    func sfTexture_updateFromPixels(handle: CPointer<Unit>, pixels: CPointer<Unit>, width: UInt32, height: UInt32,
        x: UInt32, y: UInt32): Unit

    func sfTexture_updateFromTexture(handle: CPointer<Unit>, source: CPointer<Unit>, x: UInt32, y: UInt32): Unit

    func sfTexture_updateFromImage(handle: CPointer<Unit>, image: CPointer<Unit>, x: UInt32, y: UInt32): Unit

    func sfTexture_updateFromWindow(handle: CPointer<Unit>, window: CPointer<Unit>, x: UInt32, y: UInt32): Unit

    func sfTexture_updateFromRenderWindow(handle: CPointer<Unit>, renderWindow: CPointer<Unit>, x: UInt32, y: UInt32): Unit

    func sfTexture_setSmooth(handle: CPointer<Unit>, smooth: SfBool): Unit

    func sfTexture_isSmooth(handle: CPointer<Unit>): SfBool

    func sfTexture_isSrgb(handle: CPointer<Unit>): SfBool

    func sfTexture_setRepeated(handle: CPointer<Unit>, repeated: SfBool): Unit

    func sfTexture_isRepeated(handle: CPointer<Unit>): SfBool

    func sfTexture_generateMipmap(handle: CPointer<Unit>): SfBool

    func sfTexture_swap(handle: CPointer<Unit>, right: CPointer<Unit>): Unit

    func sfTexture_getNativeHandle(handle: CPointer<Unit>): UInt32

    func sfTexture_bind(handle: CPointer<Unit>, coordType: TextureCoordinateType): Unit

    func sfTexture_getMaximumSize(): UInt32
}

@CEnum[public TextureCoordinateType](
    Normalized
    Pixels
)

public class Texture <: ResourceHandle & Equatable<Texture> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    public init(handle: CPointer<Unit>, isOwner!: Bool = true) {
        if (handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_handle = handle
        m_isOwner = isOwner
    }

    public init(width: UInt32, height: UInt32) {
        m_handle = unsafe { sfTexture_create(width, height) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        m_isOwner = true
    }

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

    public init(data: Array<Byte>, sRgb!: Bool = false, area!: IntRect = IntRect()) {
        unsafe {
            let rawData = acquireArrayRawData(data)
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
        if (m_handle.isNull() || m_isOwner == false) {
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

    public prop size: Vector2u {
        get() {
            unsafe { sfTexture_getSize(m_handle) }
        }
    }

    public func update(pixels: Array<UInt8>, width: UInt32, height: UInt32, x: UInt32, y: UInt32): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels)
            try {
                sfTexture_updateFromPixels(m_handle, CPointer(rawData.pointer), width, height, x, y)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func update(pixels: Array<Color>, width: UInt32, height: UInt32, x: UInt32, y: UInt32): Unit {
        unsafe {
            let rawData = acquireArrayRawData(pixels)
            try {
                sfTexture_updateFromPixels(m_handle, CPointer(rawData.pointer), width, height, x, y)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
    }

    public func update(texture: Texture): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, 0, 0) }
    }

    public func update(texture: Texture, x: UInt32, y: UInt32): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, x, y) }
    }

    public func update(image: Image): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, 0, 0) }
    }

    public func update(image: Image, x: UInt32, y: UInt32): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, x, y) }
    }

    public func update(window: Window): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, 0, 0) }
    }

    public func update(window: Window, x: UInt32, y: UInt32): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, x, y) }
    }

    public func update(window: RenderWindow): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, 0, 0) }
    }

    public func update(window: RenderWindow, x: UInt32, y: UInt32): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, x, y) }
    }

    public mut prop smooth: Bool {
        get() {
            unsafe { sfTexture_isSmooth(m_handle).toBool() }
        }
        set(value) {
            unsafe { sfTexture_setSmooth(m_handle, SfBool.fromBool(value)) }
        }
    }

    public prop isSrgb: Bool {
        get() {
            unsafe { sfTexture_isSrgb(m_handle).toBool() }
        }
    }

    public mut prop repeated: Bool {
        get() {
            unsafe { sfTexture_isRepeated(m_handle).toBool() }
        }
        set(value) {
            unsafe { sfTexture_setRepeated(m_handle, SfBool.fromBool(value)) }
        }
    }

    public func generateMipmap(): Bool {
        unsafe { sfTexture_generateMipmap(m_handle).toBool() }
    }

    public func swap(right: Texture): Unit {
        unsafe { sfTexture_swap(m_handle, right.m_handle) }
    }

    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfTexture_getNativeHandle(m_handle) }
        }
    }

    public func bind(coordtype: TextureCoordinateType): Unit {
        unsafe { sfTexture_bind(m_handle, coordtype) }
    }

    public static prop maximumSize: UInt32 {
        get() {
            unsafe { sfTexture_getMaximumSize() }
        }
    }
}
