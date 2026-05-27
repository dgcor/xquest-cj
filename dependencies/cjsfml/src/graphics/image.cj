package cjsfml.graphics

import cjsfml.system.{Buffer, InputStream, InputStreamData, ResourceHandle, SFMLNullHandleException, 
    SFMLOutOfBoundsException, Vector2u}

foreign {
    func sfImage_create(size: Vector2u): CPointer<Unit>

    func sfImage_createFromColor(size: Vector2u, color: Color): CPointer<Unit>

    func sfImage_createFromPixels(size: Vector2u, pixels: CPointer<UInt8>): CPointer<Unit>

    func sfImage_createFromFile(filename: CString): CPointer<Unit>

    func sfImage_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfImage_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfImage_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfImage_destroy(handle: CPointer<Unit>): Unit

    func sfImage_saveToFile(handle: CPointer<Unit>, filename: CString): Bool

    func sfImage_saveToMemory(handle: CPointer<Unit>, buffer: CPointer<Unit>, format: CString): Bool

    func sfImage_getSize(handle: CPointer<Unit>): Vector2u

    func sfImage_createMaskFromColor(handle: CPointer<Unit>, color: Color, alpha: UInt8): Unit

    func sfImage_copyImage(handle: CPointer<Unit>, sourceHandle: CPointer<Unit>, dest: Vector2u, sourceRect: IntRect,
        applyAlpha: Bool): Bool

    @FastNative
    func sfImage_setPixel(handle: CPointer<Unit>, coords: Vector2u, color: Color): Unit

    @FastNative
    func sfImage_getPixel(handle: CPointer<Unit>, coords: Vector2u): Color

    @FastNative
    func sfImage_getPixelsPtr(handle: CPointer<Unit>): CPointer<UInt8>

    func sfImage_flipHorizontally(handle: CPointer<Unit>): Unit

    func sfImage_flipVertically(handle: CPointer<Unit>): Unit
}

/**
 * Class for loading, manipulating and saving images.
 *
 * `Image` is an abstraction to manipulate images
 * as bi-dimensional arrays of pixels. The class provides
 * functions to load, read, write and save pixels, as well
 * as many other useful functions.
 *
 * `Image` can handle a unique internal representation of
 * pixels, which is RGBA 32 bits. This means that a pixel
 * must be composed of 8 bit red, green, blue and alpha
 * channels -- just like a `Color`.
 * All the functions that return an array of pixels follow
 * this rule, and all parameters that you pass to `Image`
 * functions (such as `loadFromMemory`) must use this
 * representation as well.
 *
 * A `Image` can be copied, but it is a heavy resource and
 * if possible you should always use [const] references to
 * pass or return them to avoid useless copies.
 *
 * Usage example:
 * ```
 * // Load an image file from a file
 * let background = Image("background.jpg");
 *
 * // Create a 20x20 image filled with black color
 * let image = Image(Vector2u(20, 20), Color.BLACK);
 *
 * // Copy background on image at position (10, 10)
 * if (!image.copy(background, Vector2u(10, 10))) {
 *     return -1;
 * }
 *
 * // Make the top-left pixel transparent
 * var color = image.getPixel(Vector2u(0, 0));
 * color.a = 0;
 * image.setPixel(Vector2u(0, 0), color);
 *
 * // Save the image to a file
 * if (!image.saveToFile("result.png")) {
 *     return -1;
 * }
 * ```
 *
 * @see `Texture`
 */
public class Image <: ResourceHandle & Equatable<Image> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the image and fill it with a unique color.
     *
     * @param size  Width and height of the image
     * @param color Fill color
     *
     * @throws SFMLNullHandleException
     */
    public init(size: Vector2u) {
        m_handle = unsafe { sfImage_create(size) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image and fill it with a unique color.
     *
     * @param size  Width and height of the image
     * @param color Fill color
     *
     * @throws SFMLNullHandleException
     */
    public init(size: Vector2u, color: Color) {
        m_handle = unsafe { sfImage_createFromColor(size, color) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image from an array of pixels.
     *
     * The pixel array is assumed to contain 32-bits RGBA pixels,
     * and have the given `size`. If not, this is an undefined behavior.
     *
     * @param size   Width and height of the image
     * @param pixels Array of pixels to copy to the image
     *
     * @throws SFMLNullHandleException
     * @throws SFMLOutOfBoundsException
     */
    public init(size: Vector2u, pixels: Array<Color>) {
        if (pixels.size < Int64(size.x) * Int64(size.y)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                m_handle = sfImage_createFromPixels(size, CPointer<UInt8>(rawData.pointer))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image from an array of pixels.
     *
     * The pixel array is assumed to contain 32-bits RGBA pixels,
     * and have the given `size`. If not, this is an undefined behavior.
     *
     * @param size   Width and height of the image
     * @param pixels Array of pixels to copy to the image
     *
     * @throws SFMLNullHandleException
     * @throws SFMLOutOfBoundsException
     */
    public init(size: Vector2u, pixels: Array<UInt8>) {
        if (pixels.size < Int64(size.x) * Int64(size.y)) {
            throw SFMLOutOfBoundsException()
        }
        unsafe {
            let rawData = acquireArrayRawData(pixels) // cjlint-ignore !G.VAR.02 minimize scope
            try {
                m_handle = sfImage_createFromPixels(size, rawData.pointer)
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image from a file on disk.
     *
     * The supported image formats are bmp, png, tga, jpg, gif,
     * psd, hdr, pic and pnm. Some format options are not supported,
     * like jpeg with arithmetic coding or ASCII pnm.
     *
     * @param filename Path of the image file to load
     *
     * @throws SFMLNullHandleException if loading was unsuccessful
     */
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

    /**
     * Construct the image from a file in memory.
     *
     * The supported image formats are bmp, png, tga, jpg, gif,
     * psd, hdr, pic and pnm. Some format options are not supported,
     * like jpeg with arithmetic coding or ASCII pnm.
     *
     * @param data Pointer to the file data in memory
     * @param size Size of the data to load, in bytes
     *
     * @throws SFMLNullHandleException if loading was unsuccessful
     */
    public init(data: Array<Byte>) {
        unsafe {
            let rawData = acquireArrayRawData(data)
            try {
                m_handle = sfImage_createFromMemory(rawData.pointer, UIntNative(data.size))
            } finally {
                releaseArrayRawData(rawData)
            }
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image from a custom stream.
     *
     * The supported image formats are bmp, png, tga, jpg, gif,
     * psd, hdr, pic and pnm. Some format options are not supported,
     * like jpeg with arithmetic coding or ASCII pnm.
     *
     * @param stream Source stream to read from
     *
     * @throws SFMLNullHandleException if loading was unsuccessful
     */
    public init(stream: InputStream) {
        unsafe {
            var stream2 = stream.stream
            m_handle = sfImage_createFromStream(inout stream2)
        }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
    }

    /**
     * Construct the image from an existing handle.
     *
     * @param handle The handle to use.
     *
     * @throws SFMLNullHandleException
     */
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

    /**
     * Create a copy of the image.
     *
     * @return A new image instance that is a copy of this one.
     */
    public func clone(): Image {
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

    public override operator func ==(right: Image): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Image): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Image

    /**
     * Save the image to a file on disk.
     *
     * The format of the image is automatically deduced from
     * the extension. The supported image formats are bmp, png,
     * tga and jpg. The destination file is overwritten
     * if it already exists. This function fails if the image is empty.
     *
     * @param filename Path of the file to save
     *
     * @return `true` if saving was successful
     */
    public func saveToFile(filename: String): Bool {
        unsafe {
            try (filenameRes = LibC.mallocCString(filename).asResource()) {
                return sfImage_saveToFile(m_handle, filenameRes.value)
            }
        }
        return false
    }

    /**
     * Save the image to a buffer in memory.
     *
     * The format of the image must be specified.
     * The supported image formats are bmp, png, tga and jpg.
     * This function fails if the image is empty, or if
     * the format was invalid.
     *
     * @param format Encoding format to use
     *
     * @return Buffer with encoded data if saving was successful,
     *         otherwise `None`
     */
    public func saveToMemory(format: String): ?Array<Byte> {
        unsafe {
            try (buffer = Buffer(), formatRes = LibC.mallocCString(format).asResource()) { // cjlint-ignore !G.VAR.02 minimize scope
                if (sfImage_saveToMemory(m_handle, buffer.handle, formatRes.value)) {
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

    /**
     * Return the size (width and height) of the image.
     *
     * @return Size of the image, in pixels
     */
    public prop size: Vector2u {
        get() {
            unsafe { sfImage_getSize(m_handle) }
        }
    }

    /**
     * Create a transparency mask from a specified color-key.
     *
     * This function sets the alpha value of every pixel matching
     * the given color to `alpha` (0 by default), so that they
     * become transparent.
     *
     * @param color Color to make transparent
     * @param alpha Alpha value to assign to transparent pixels
     */
    public func createMaskFromColor(color: Color, alpha!: UInt8 = 0): Unit {
        unsafe { sfImage_createMaskFromColor(m_handle, color, alpha) }
    }

    /**
     * Copy pixels from another image onto this one.
     *
     * This function does a slow pixel copy and should not be
     * used intensively. It can be used to prepare a complex
     * static image from several others, but if you need this
     * kind of feature in real-time you'd better use `RenderTexture`.
     *
     * If `sourceRect` is empty, the whole image is copied.
     * If `applyAlpha` is set to `true`, alpha blending is
     * applied from the source pixels to the destination pixels
     * using the **over** operator. If it is `false`, the source
     * pixels are copied unchanged with their alpha value.
     *
     * Note that this function can fail if either image is invalid
     * (i.e. zero-sized width or height), or if `sourceRect` is
     * not within the boundaries of the `source` parameter, or
     * if the destination area is out of the boundaries of this image.
     *
     * On failure, the destination image is left unchanged.
     *
     * @param source     Source image to copy
     * @param dest       Coordinates of the destination position
     * @param sourceRect Sub-rectangle of the source image to copy
     * @param applyAlpha Should the copy take into account the source transparency?
     *
     * @return `true` if the operation was successful, `false` otherwise
     */
    public func copy(source: Image, dest: Vector2u, sourceRect!: IntRect = IntRect(), applyAlpha!: Bool = false): Bool {
        unsafe { sfImage_copyImage(m_handle, source.m_handle, dest, sourceRect, applyAlpha) }
    }

    /**
     * Get the color of a pixel.
     *
     * This function doesn't check the validity of the pixel
     * coordinates, using out-of-range values will result in
     * an undefined behavior.
     *
     * @param coords Coordinates of pixel to change
     *
     * @return Color of the pixel at given coordinates
     *
     * @see `setPixel`
     */
    public func getPixel(coords: Vector2u): Color {
        unsafe { sfImage_getPixel(m_handle, coords) }
    }

    /**
     * Change the color of a pixel.
     *
     * This function doesn't check the validity of the pixel
     * coordinates, using out-of-range values will result in
     * an undefined behavior.
     *
     * @param coords Coordinates of pixel to change
     * @param color  New color of the pixel
     *
     * @see `getPixel`
     */
    public func setPixel(coords: Vector2u, color: Color): Unit {
        unsafe { sfImage_setPixel(m_handle, coords, color) }
    }

    /**
     * Get a read-only pointer to the array of pixels.
     *
     * The returned value points to an array of RGBA pixels made of
     * 8 bit integer components. The size of the array is
     * `width * height * 4 (getSize().x * getSize().y * 4)`.
     * Warning: the returned pointer may become invalid if you
     * modify the image, so you should never store it for too long.
     * If the image is empty, a null pointer is returned.
     *
     * @return Read-only pointer to the array of pixels
     */
    public prop pixelsPtr: CPointer<UInt8> {
        get() {
            unsafe { sfImage_getPixelsPtr(m_handle) }
        }
    }

    /**
     * Flip the image horizontally (left <-> right).
     */
    public func flipHorizontally(): Unit {
        unsafe { sfImage_flipHorizontally(m_handle) }
    }

    /**
     * Flip the image vertically (top <-> bottom).
     */
    public func flipVertically(): Unit {
        unsafe { sfImage_flipVertically(m_handle) }
    }
}
