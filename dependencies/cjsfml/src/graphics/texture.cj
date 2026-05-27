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

/**
 * Image living on the graphics card that can be used for drawing.
 *
 * `Texture` stores pixels that can be drawn, with a sprite
 * for example. A texture lives in the graphics card memory,
 * therefore it is very fast to draw a texture to a render target,
 * or copy a render target to a texture (the graphics card can
 * access both directly).
 *
 * Being stored in the graphics card memory has some drawbacks.
 * A texture cannot be manipulated as freely as a `Image`,
 * you need to prepare the pixels first and then upload them
 * to the texture in a single operation (see `Texture.update`).
 *
 * `Texture` makes it easy to convert from/to `Image`, but
 * keep in mind that these calls require transfers between
 * the graphics card and the central memory, therefore they are
 * slow operations.
 *
 * A texture can be loaded from an image, but also directly
 * from a file/memory/stream. The necessary shortcuts are defined
 * so that you don't need an image first for the most common cases.
 * However, if you want to perform some modifications on the pixels
 * before creating the final texture, you can load your file to a
 * `Image`, do whatever you need with the pixels, and then call
 * `init(image)`.
 *
 * Since they live in the graphics card memory, the pixels of a texture
 * cannot be accessed without a slow copy first. And they cannot be
 * accessed individually. Therefore, if you need to read the texture's
 * pixels (like for pixel-perfect collisions), it is recommended to
 * store the collision information separately, for example in an array
 * of booleans.
 *
 * Like `Image`, `Texture` can handle a unique internal
 * representation of pixels, which is RGBA 32 bits. This means
 * that a pixel must be composed of 8 bit red, green, blue and
 * alpha channels -- just like a `Color`.
 *
 * When providing texture data from an image file or memory, it can
 * either be stored in a linear color space or an sRGB color space.
 * Most digital images account for gamma correction already, so they
 * would need to be "uncorrected" back to linear color space before
 * being processed by the hardware. The hardware can automatically
 * convert it from the sRGB color space to a linear color space when
 * it gets sampled. When the rendered image gets output to the final
 * framebuffer, it gets converted back to sRGB.
 *
 * This option is only useful in conjunction with an sRGB capable
 * framebuffer. This can be requested during window creation.
 *
 * Usage example:
 * ```
 * // This example shows the most common use of Texture:
 * // drawing a sprite
 *
 * // Load a texture from a file
 * let texture = Texture("texture.png");
 *
 * // Assign it to a sprite
 * let sprite = Sprite(texture);
 *
 * // Draw the textured sprite
 * window.draw(sprite);
 * ```
 *
 * ```
 * // This example shows another common use of Texture:
 * // streaming real-time data, like video frames
 *
 * // Create an empty texture
 * let texture = Texture(Vector2u(640, 480));
 *
 * // Create a sprite that will display the texture
 * let sprite = Sprite(texture);
 *
 * while (true) { // the main loop
 *     // ...
 *
 *     // update the texture
 *     let pixels = Array<UInt8>(...); // get a fresh chunk of pixels (the next frame of a movie, for example)
 *     texture.update(pixels, texture.size, Vector2u());
 *
 *     // draw it
 *     window.draw(sprite);
 *
 *     // ...
 * }
 * ```
 *
 * @see `Sprite`, `Image`, `RenderTexture`
 */
public class Texture <: ResourceHandle & Equatable<Texture> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * Construct the texture from an existing handle.
     *
     * @param handle  The handle to use.
     * @param isOwner Whether this instance owns the handle.
     *
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
     * Construct the texture with a given size.
     *
     * @param size Width and height of the texture
     * @param sRgb `true` to enable sRGB conversion, `false` to disable it
     *
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
     * Construct the texture from a file on disk.
     *
     * The maximum size for a texture depends on the graphics
     * driver and can be retrieved with the `maximumSize` function.
     *
     * @param filename Path of the image file to load
     * @param sRgb     `true` to enable sRGB conversion, `false` to disable it
     * @param area     Area of the image to load
     *
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
     * Construct the texture from a file in memory.
     *
     * The maximum size for a texture depends on the graphics
     * driver and can be retrieved with the `maximumSize` function.
     *
     * @param data Pointer to the file data in memory
     * @param sRgb `true` to enable sRGB conversion, `false` to disable it
     * @param area Area of the image to load
     *
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
     * Construct the texture from a custom stream.
     *
     * The maximum size for a texture depends on the graphics
     * driver and can be retrieved with the `maximumSize` function.
     *
     * @param stream Source stream to read from
     * @param sRgb   `true` to enable sRGB conversion, `false` to disable it
     * @param area   Area of the image to load
     *
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
     * Construct the texture from an image.
     *
     * The maximum size for a texture depends on the graphics
     * driver and can be retrieved with the `maximumSize` function.
     *
     * @param image Image to load into the texture
     * @param sRgb  `true` to enable sRGB conversion, `false` to disable it
     * @param area  Area of the image to load
     *
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

    public override operator func ==(right: Texture): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Texture): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Texture

    /**
     * Copy the texture pixels to an image.
     *
     * This function performs a slow operation that downloads
     * the texture's pixels from the graphics card and copies
     * them to a new image, potentially applying transformations
     * to pixels if necessary (texture may be padded or flipped).
     *
     * @return Image containing the texture's pixels
     */
    public func copyToImage(): Image {
        Image(unsafe { sfTexture_copyToImage(m_handle) })
    }

    /**
     * Resize the texture.
     *
     * If this function fails, the texture is left unchanged.
     *
     * @param size Width and height of the texture
     * @param sRgb `true` to enable sRGB conversion, `false` to disable it
     *
     * @return `true` if resizing was successful, `false` if it failed
     */
    public func resize(size: Vector2u, sRgb!: Bool = false): Bool {
        match (sRgb) {
            case false => unsafe { sfTexture_resize(m_handle, size) }
            case true => unsafe { sfTexture_resizeSrgb(m_handle, size) }
        }
    }

    /**
     * Return the size of the texture.
     *
     * @return Size in pixels
     */
    public prop size: Vector2u {
        get() {
            unsafe { sfTexture_getSize(m_handle) }
        }
    }

    /**
     * Update a part of the texture from an array of pixels.
     *
     * The size of the pixel array must match the `size` argument,
     * and it must contain 32-bits RGBA pixels.
     *
     * No additional check is performed on the size of the pixel
     * array or the bounds of the area to update. Passing invalid
     * arguments will lead to an undefined behavior.
     *
     * This function does nothing if `pixels` is null or if the
     * texture was not previously created.
     *
     * @param pixels Array of pixels to copy to the texture
     * @param size   Width and height of the pixel region contained in `pixels`
     * @param offset Coordinates of the destination position
     */
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

    /**
     * Update a part of the texture from an array of pixels.
     *
     * The size of the pixel array must match the `size` argument,
     * and it must contain 32-bits RGBA pixels.
     *
     * No additional check is performed on the size of the pixel
     * array or the bounds of the area to update. Passing invalid
     * arguments will lead to an undefined behavior.
     *
     * This function does nothing if `pixels` is null or if the
     * texture was not previously created.
     *
     * @param pixels Array of pixels to copy to the texture
     * @param size   Width and height of the pixel region contained in `pixels`
     * @param offset Coordinates of the destination position
     */
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

    /**
     * Update a part of this texture from another texture.
     *
     * No additional check is performed on the size of the passed
     * texture. Passing a texture bigger than this texture
     * will lead to an undefined behavior.
     *
     * This function does nothing if either texture was not
     * previously created.
     *
     * @param texture Source texture to copy to this texture
     */
    public func update(texture: Texture): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, Vector2u()) }
    }

    /**
     * Update a part of this texture from another texture.
     *
     * No additional check is performed on the size of the texture.
     * Passing an invalid combination of texture size and destination
     * will lead to an undefined behavior.
     *
     * This function does nothing if either texture was not
     * previously created.
     *
     * @param texture Source texture to copy to this texture
     * @param offset  Coordinates of the destination position
     */
    public func update(texture: Texture, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromTexture(m_handle, texture.handle, offset) }
    }

    /**
     * Update the texture from an image.
     *
     * Although the source image can be smaller than the texture,
     * this function is usually used for updating the whole texture.
     *
     * No additional check is performed on the size of the image.
     * Passing an image bigger than the texture will lead to an
     * undefined behavior.
     *
     * This function does nothing if the texture was not
     * previously created.
     *
     * @param image Image to copy to the texture
     */
    public func update(image: Image): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, Vector2u()) }
    }

    /**
     * Update a part of the texture from an image.
     *
     * No additional check is performed on the size of the image.
     * Passing an invalid combination of image size and destination
     * will lead to an undefined behavior.
     *
     * This function does nothing if the texture was not
     * previously created.
     *
     * @param image  Image to copy to the texture
     * @param offset Coordinates of the destination position
     */
    public func update(image: Image, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromImage(m_handle, image.handle, offset) }
    }

    /**
     * Update the texture from the contents of a window.
     *
     * Although the source window can be smaller than the texture,
     * this function is usually used for updating the whole texture.
     *
     * No additional check is performed on the size of the window.
     * Passing a window bigger than the texture will lead to an
     * undefined behavior.
     *
     * This function does nothing if either the texture or the window
     * was not previously created.
     *
     * @param window Window to copy to the texture
     */
    public func update(window: Window): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, Vector2u()) }
    }

    /**
     * Update a part of the texture from the contents of a window.
     *
     * No additional check is performed on the size of the window.
     * Passing an invalid combination of window size and destination
     * will lead to an undefined behavior.
     *
     * This function does nothing if either the texture or the window
     * was not previously created.
     *
     * @param window Window to copy to the texture
     * @param offset Coordinates of the destination position
     */
    public func update(window: Window, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromWindow(m_handle, window.handle, offset) }
    }

    /**
     * Update the texture from the contents of a render window.
     *
     * Although the source window can be smaller than the texture,
     * this function is usually used for updating the whole texture.
     *
     * No additional check is performed on the size of the window.
     * Passing a window bigger than the texture will lead to an
     * undefined behavior.
     *
     * This function does nothing if either the texture or the window
     * was not previously created.
     *
     * @param window Render window to copy to the texture
     */
    public func update(window: RenderWindow): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, Vector2u()) }
    }

    /**
     * Update a part of the texture from the contents of a render window.
     *
     * No additional check is performed on the size of the window.
     * Passing an invalid combination of window size and destination
     * will lead to an undefined behavior.
     *
     * This function does nothing if either the texture or the window
     * was not previously created.
     *
     * @param window Render window to copy to the texture
     * @param offset Coordinates of the destination position
     */
    public func update(window: RenderWindow, offset: Vector2u): Unit {
        unsafe { sfTexture_updateFromRenderWindow(m_handle, window.handle, offset) }
    }

    /**
     * Enable or disable the smooth filter.
     *
     * When the filter is activated, the texture appears smoother
     * so that pixels are less noticeable. However if you want
     * the texture to look exactly the same as its source file,
     * you should leave it disabled.
     * The smooth filter is disabled by default.
     *
     * @param value `true` to enable smoothing, `false` to disable it
     */
    public mut prop smooth: Bool {
        get() {
            unsafe { sfTexture_isSmooth(m_handle) }
        }
        set(value) {
            unsafe { sfTexture_setSmooth(m_handle, value) }
        }
    }

    /**
     * Tell whether the texture source is converted from sRGB or not.
     *
     * @return `true` if the texture source is converted from sRGB, `false` if not
     */
    public prop isSrgb: Bool {
        get() {
            unsafe { sfTexture_isSrgb(m_handle) }
        }
    }

    /**
     * Enable or disable repeating.
     *
     * Repeating is involved when using texture coordinates
     * outside the texture rectangle [0, 0, width, height].
     * In this case, if repeat mode is enabled, the whole texture
     * will be repeated as many times as needed to reach the
     * coordinate (for example, if the X texture coordinate is
     * 3 * width, the texture will be repeated 3 times).
     * If repeat mode is disabled, the "extra space" will instead
     * be filled with border pixels.
     * Warning: on very old graphics cards, white pixels may appear
     * when the texture is repeated. With such cards, repeat mode
     * can be used reliably only if the texture has power-of-two
     * dimensions (such as 256x128).
     * Repeating is disabled by default.
     *
     * @param value `true` to repeat the texture, `false` to disable repeating
     */
    public mut prop repeated: Bool {
        get() {
            unsafe { sfTexture_isRepeated(m_handle) }
        }
        set(value) {
            unsafe { sfTexture_setRepeated(m_handle, value) }
        }
    }

    /**
     * Generate a mipmap using the current texture data.
     *
     * Mipmaps are pre-computed chains of optimized textures. Each
     * level of texture in a mipmap is generated by halving each of
     * the previous level's dimensions. This is done until the final
     * level has the size of 1x1. The textures generated in this process may
     * make use of more advanced filters which might improve the visual quality
     * of textures when they are applied to objects much smaller than they are.
     * This is known as minification. Because fewer texels (texture elements)
     * have to be sampled from when heavily minified, usage of mipmaps
     * can also improve rendering performance in certain scenarios.
     *
     * Mipmap generation relies on the necessary OpenGL extension being
     * available. If it is unavailable or generation fails due to another
     * reason, this function will return `false`. Mipmap data is only valid from
     * the time it is generated until the next time the base level image is
     * modified, at which point this function will have to be called again to
     * regenerate it.
     *
     * @return `true` if mipmap generation was successful, `false` if unsuccessful
     */
    public func generateMipmap(): Bool {
        unsafe { sfTexture_generateMipmap(m_handle) }
    }

    /**
     * Swap the contents of this texture with those of another.
     *
     * @param right Instance to swap with
     */
    public func swap(right: Texture): Unit {
        unsafe { sfTexture_swap(m_handle, right.m_handle) }
    }

    /**
     * Get the underlying OpenGL handle of the texture.
     *
     * You shouldn't need to use this function, unless you have
     * very specific stuff to implement that SFML doesn't support,
     * or implement a temporary workaround until a bug is fixed.
     *
     * @return OpenGL handle of the texture or 0 if not yet created
     */
    public prop nativeHandle: UInt32 {
        get() {
            unsafe { sfTexture_getNativeHandle(m_handle) }
        }
    }

    /**
     * Bind a texture for rendering.
     *
     * This function is not part of the graphics API, it mustn't be
     * used when drawing SFML entities. It must be used only if you
     * mix `Texture` with OpenGL code.
     *
     * The `coordtype` argument controls how texture
     * coordinates will be interpreted. If Normalized (the default), they
     * must be in range [0 .. 1], which is the default way of handling
     * texture coordinates with OpenGL. If Pixels, they must be given
     * in pixels (range [0 .. size]). This mode is used internally by
     * the graphics classes of SFML, it makes the definition of texture
     * coordinates more intuitive for the high-level API, users don't need
     * to compute normalized values.
     *
     * @param coordtype Type of texture coordinates to use
     */
    public func bind(coordtype: CoordinateType): Unit {
        unsafe { sfTexture_bind(m_handle, coordtype) }
    }

    /**
     * Get the maximum texture size allowed.
     *
     * This maximum size is defined by the graphics driver.
     * You can expect a value of 512 pixels for low-end graphics
     * card, and up to 8192 pixels or more for newer hardware.
     *
     * @return Maximum size allowed for textures, in pixels
     */
    public static prop maximumSize: UInt32 { // cjlint-ignore !G.NAM.05 use all capital letters for static variable
        get() {
            unsafe { sfTexture_getMaximumSize() }
        }
    }
}
