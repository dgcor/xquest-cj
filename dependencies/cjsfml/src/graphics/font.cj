package cjsfml.graphics

import cjsfml.system.{InputStream, InputStreamData, ResourceHandle, SFMLNullHandleException}

foreign {
    func sfFont_createFromFile(filename: CString): CPointer<Unit>

    func sfFont_createFromMemory(data: CPointer<Byte>, sizeInBytes: UIntNative): CPointer<Unit>

    func sfFont_createFromStream(stream: CPointer<InputStreamData>): CPointer<Unit>

    func sfFont_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfFont_destroy(handle: CPointer<Unit>): Unit

    func sfFont_getGlyph(handle: CPointer<Unit>, codePoint: UInt32, characterSize: UInt32, bold: Bool,
        outlineThickness: Float32): Glyph

    func sfFont_hasGlyph(handle: CPointer<Unit>, codePoint: UInt32): Bool

    func sfFont_getKerning(handle: CPointer<Unit>, first: UInt32, second: UInt32, characterSize: UInt32): Float32

    func sfFont_getBoldKerning(handle: CPointer<Unit>, first: UInt32, second: UInt32, characterSize: UInt32): Float32

    func sfFont_getLineSpacing(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getUnderlinePosition(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getUnderlineThickness(handle: CPointer<Unit>, characterSize: UInt32): Float32

    func sfFont_getTexture(handle: CPointer<Unit>, characterSize: UInt32): CPointer<Unit>

    func sfFont_setSmooth(handle: CPointer<Unit>, smooth: Bool): Unit

    func sfFont_isSmooth(handle: CPointer<Unit>): Bool

    func sfFont_getInfo(handle: CPointer<Unit>): CString
}

/**
 * Class for loading and manipulating character fonts.
 *
 * Fonts can be opened from a file, from memory or from a custom
 * stream, and supports the most common types of fonts. See
 * the openFromFile function for the complete list of supported formats.
 *
 * Once it is opened, a `Font` instance provides three
 * types of information about the font:
 * - Global metrics, such as the line spacing
 * - Per-glyph metrics, such as bounding box or kerning
 * - Pixel representation of glyphs
 *
 * Fonts alone are not very useful: they hold the font data
 * but cannot make anything useful of it. To do so you need to
 * use the `Text` class, which is able to properly output text
 * with several options such as character size, style, color,
 * position, rotation, etc.
 * This separation allows more flexibility and better performances:
 * indeed a `Font` is a heavy resource, and any operation on it
 * is slow (often too slow for real-time applications). On the other
 * side, a `Text` is a lightweight object which can combine the
 * glyphs data and metrics of a `Font` to display any text on a
 * render target.
 * Note that it is also possible to bind several `Text` instances
 * to the same `Font`.
 *
 * It is important to note that the `Text` instance doesn't
 * copy the font that it uses, it only keeps a reference to it.
 * Thus, a `Font` must not be destructed while it is
 * used by a `Text` (i.e. never write a function that
 * uses a local `Font` instance for creating a text).
 *
 * Usage example:
 * ```
 * // Open a new font
 * let font = Font("arial.ttf");
 *
 * // Create a text which uses our font
 * let text1 = Text(font);
 * text1.setCharacterSize(30);
 * text1.setStyle(TextStyle.Regular);
 *
 * // Create another text using the same font, but with different parameters
 * let text2 = Text(font);
 * text2.setCharacterSize(50);
 * text2.setStyle(TextStyle.Italic);
 * ```
 *
 * Apart from opening font files, and passing them to instances
 * of `Text`, you should normally not have to deal directly
 * with this class. However, it may be useful to access the
 * font metrics or rasterized glyphs for advanced usage.
 *
 * Note that if the font is a bitmap font, it is not scalable,
 * thus not all requested sizes will be available to use. This
 * needs to be taken into consideration when using `Text`.
 * If you need to display text of a certain size, make sure the
 * corresponding bitmap font that supports that size is used.
 *
 * @see `Text`
 */
public class Font <: ResourceHandle & Equatable<Font> {
    private var m_handle: CPointer<Unit> = CPointer()
    private let m_isOwner: Bool

    /**
     * Construct the font from an existing handle.
     *
     * @param handle The handle to use.
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
     * Construct the font from a file.
     *
     * The supported font formats are: TrueType, Type 1, CFF,
     * OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42.
     * Note that this function knows nothing about the standard
     * fonts installed on the user's system, thus you can't
     * load them directly.
     *
     * @warning SFML cannot preload all the font data in this
     * function, so the file has to remain accessible until
     * the `Font` object opens a new font or is destroyed.
     *
     * @param filename Path of the font file to open
     *
     * @throws SFMLNullHandleException if opening was unsuccessful
     */
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

    /**
     * Construct the font from a file in memory.
     *
     * The supported font formats are: TrueType, Type 1, CFF,
     * OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42.
     *
     * @warning SFML cannot preload all the font data in this
     * function, so the buffer pointed by `data` has to remain
     * valid until the `Font` object opens a new font or
     * is destroyed.
     *
     * @param data Array containing the file data in memory
     *
     * @throws SFMLNullHandleException if loading was unsuccessful
     */
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

    /**
     * Construct the font from a custom stream.
     *
     * The supported font formats are: TrueType, Type 1, CFF,
     * OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42.
     * Warning: SFML cannot preload all the font data in this
     * function, so the contents of `stream` have to remain
     * valid as long as the font is used.
     *
     * @warning SFML cannot preload all the font data in this
     * function, so the stream has to remain accessible until
     * the `Font` object opens a new font or is destroyed.
     *
     * @param stream Source stream to read from
     *
     * @throws SFMLNullHandleException if loading was unsuccessful
     */
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

    /**
     * Create a copy of the font.
     *
     * @return A new font instance that is a copy of this one.
     */
    public func clone(): Font {
        Font(unsafe { sfFont_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (m_handle.isNull() || !m_isOwner) {
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

    public override operator func ==(right: Font): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Font): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // Font

    /**
     * Retrieve a glyph of the font.
     *
     * If the font is a bitmap font, not all character sizes
     * might be available. If the glyph is not available at the
     * requested size, an empty glyph is returned.
     *
     * You may want to use `hasGlyph` to determine if the
     * glyph exists before requesting it. If the glyph does not
     * exist, a font specific default is returned.
     *
     * Be aware that using a negative value for the outline
     * thickness will cause distorted rendering.
     *
     * @param codePoint        Unicode code point of the character to get
     * @param characterSize    Reference character size
     * @param bold             Retrieve the bold version or the regular one?
     * @param outlineThickness Thickness of outline (when != 0 the glyph will not be filled)
     *
     * @return The glyph corresponding to `codePoint` and `characterSize`
     */
    public func getGlyph(codePoint: Rune, characterSize: UInt32, bold!: Bool, outlineThickness!: Float32 = 0.0): Glyph {
        unsafe { sfFont_getGlyph(m_handle, UInt32(codePoint), characterSize, bold, outlineThickness) }
    }

    /**
     * Determine if this font has a glyph representing the requested code point.
     *
     * Most fonts only include a very limited selection of glyphs from
     * specific Unicode subsets, like Latin, Cyrillic, or Asian characters.
     *
     * While code points without representation will return a font specific
     * default character, it might be useful to verify whether specific
     * code points are included to determine whether a font is suited
     * to display text in a specific language.
     *
     * @param codePoint Unicode code point to check
     *
     * @return `true` if the codepoint has a glyph representation, `false` otherwise
     */
    public func hasGlyph(codePoint: Rune): Bool {
        unsafe { sfFont_hasGlyph(m_handle, UInt32(codePoint)) }
    }

    /**
     * Get the kerning offset of two glyphs.
     *
     * The kerning is an extra offset (negative) to apply between two
     * glyphs when rendering them, to make the pair look more "natural".
     * For example, the pair "AV" have a special kerning to make them
     * closer than other characters. Most of the glyphs pairs have a
     * kerning offset of zero, though.
     *
     * @param first         Unicode code point of the first character
     * @param second        Unicode code point of the second character
     * @param characterSize Reference character size
     * @param bold          Retrieve the bold version or the regular one?
     *
     * @return Kerning value for `first` and `second`, in pixels
     */
    public func getKerning(first: UInt32, second: UInt32, characterSize: UInt32, bold!: Bool = false): Float32 {
        match (bold) {
            case false => unsafe { sfFont_getKerning(m_handle, first, second, characterSize) }
            case true => unsafe { sfFont_getBoldKerning(m_handle, first, second, characterSize) }
        }
    }

    /**
     * Get the line spacing.
     *
     * Line spacing is the vertical offset to apply between two
     * consecutive lines of text.
     *
     * @param characterSize Reference character size
     *
     * @return Line spacing, in pixels
     */
    public func getLineSpacing(characterSize: UInt32): Float32 {
        unsafe { sfFont_getLineSpacing(m_handle, characterSize) }
    }

    /**
     * Get the position of the underline.
     *
     * Underline position is the vertical offset to apply between the
     * baseline and the underline.
     *
     * @param characterSize Reference character size
     *
     * @return Underline position, in pixels
     *
     * @see `getUnderlineThickness`
     */
    public func getUnderlinePosition(characterSize: UInt32): Float32 {
        unsafe { sfFont_getUnderlinePosition(m_handle, characterSize) }
    }

    /**
     * Get the thickness of the underline.
     *
     * Underline thickness is the vertical size of the underline.
     *
     * @param characterSize Reference character size
     *
     * @return Underline thickness, in pixels
     *
     * @see `getUnderlinePosition`
     */
    public func getUnderlineThickness(characterSize: UInt32): Float32 {
        unsafe { sfFont_getUnderlineThickness(m_handle, characterSize) }
    }

    /**
     * Retrieve the texture containing the loaded glyphs of a certain size.
     *
     * The contents of the returned texture changes as more glyphs
     * are requested, thus it is not very relevant. It is mainly
     * used internally by `Text`.
     *
     * @param characterSize Reference character size
     *
     * @return Texture containing the glyphs of the requested size
     */
    public func getTexture(characterSize: UInt32): Texture {
        Texture(unsafe { sfFont_getTexture(m_handle, characterSize) }, isOwner: false)
    }

    /**
     * Enable or disable the smooth filter.
     *
     * When the filter is activated, the font appears smoother
     * so that pixels are less noticeable. However if you want
     * the font to look exactly the same as its source file,
     * you should disable it.
     * The smooth filter is enabled by default.
     *
     * @param value `true` to enable smoothing, `false` to disable it
     */
    public mut prop smooth: Bool {
        get() {
            unsafe { sfFont_isSmooth(m_handle) }
        }
        set(value) {
            unsafe { sfFont_setSmooth(m_handle, value) }
        }
    }

    /**
     * Get the font information.
     *
     * @return A structure that holds the font information
     */
    public prop info: String {
        get() {
            unsafe { sfFont_getInfo(m_handle).toString() }
        }
    }
}
