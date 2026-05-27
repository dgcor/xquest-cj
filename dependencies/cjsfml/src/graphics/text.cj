package cjsfml.graphics

import cenum.CFlagEnum
import cjsfml.system.{ResourceHandle, SFMLNullHandleException, toCStringUtf32, toString, Vector2f}

foreign {
    func sfText_create(font: CPointer<Unit>): CPointer<Unit>

    func sfText_copy(handle: CPointer<Unit>): CPointer<Unit>

    func sfText_destroy(handle: CPointer<Unit>): Unit

    // Transformable

    func sfText_setPosition(handle: CPointer<Unit>, position: Vector2f): Unit

    func sfText_setRotation(handle: CPointer<Unit>, angle: Float32): Unit

    func sfText_setScale(handle: CPointer<Unit>, scale: Vector2f): Unit

    func sfText_setOrigin(handle: CPointer<Unit>, origin: Vector2f): Unit

    func sfText_getPosition(handle: CPointer<Unit>): Vector2f

    func sfText_getRotation(handle: CPointer<Unit>): Float32

    func sfText_getScale(handle: CPointer<Unit>): Vector2f

    func sfText_getOrigin(handle: CPointer<Unit>): Vector2f

    func sfText_move(handle: CPointer<Unit>, offset: Vector2f): Unit

    func sfText_rotate(handle: CPointer<Unit>, angle: Float32): Unit

    func sfText_scale(handle: CPointer<Unit>, factors: Vector2f): Unit

    func sfText_getTransform(handle: CPointer<Unit>): Transform

    func sfText_getInverseTransform(handle: CPointer<Unit>): Transform

    // Text

    func sfText_setUnicodeString(handle: CPointer<Unit>, string: CPointer<UInt32>): Unit

    func sfText_setFont(handle: CPointer<Unit>, font: CPointer<Unit>): Unit

    func sfText_setCharacterSize(handle: CPointer<Unit>, size: UInt32): Unit

    func sfText_setLineSpacing(handle: CPointer<Unit>, spacingFactor: Float32): Unit

    func sfText_setLetterSpacing(handle: CPointer<Unit>, spacingFactor: Float32): Unit

    func sfText_setStyle(handle: CPointer<Unit>, style: TextStyle): Unit

    func sfText_setFillColor(handle: CPointer<Unit>, color: Color): Unit

    func sfText_setOutlineColor(handle: CPointer<Unit>, color: Color): Unit

    func sfText_setOutlineThickness(handle: CPointer<Unit>, thickness: Float32): Unit

    func sfText_getLineCount(handle: CPointer<Unit>): UInt32

    func sfText_getUnicodeString(handle: CPointer<Unit>): CPointer<UInt32>

    func sfText_getFont(handle: CPointer<Unit>): CPointer<Unit>

    func sfText_getCharacterSize(handle: CPointer<Unit>): UInt32

    func sfText_getLetterSpacing(handle: CPointer<Unit>): Float32

    func sfText_getLineSpacing(handle: CPointer<Unit>): Float32

    func sfText_getStyle(handle: CPointer<Unit>): TextStyle

    func sfText_getFillColor(handle: CPointer<Unit>): Color

    func sfText_getOutlineColor(handle: CPointer<Unit>): Color

    func sfText_getOutlineThickness(handle: CPointer<Unit>): Float32

    func sfText_findCharacterPos(handle: CPointer<Unit>, index: UIntNative): Vector2f

    func sfText_getLocalBounds(handle: CPointer<Unit>): FloatRect

    func sfText_getGlobalBounds(handle: CPointer<Unit>): FloatRect
}

/**
 * Enumeration of the string drawing styles.
 */
@CFlagEnum[public TextStyle UInt32](
    Regular               = 0 // Regular characters, no style
    Bold                  = 1 << 0 // Bold characters
    Italic                = 1 << 1 // Italic characters
    Underlined            = 1 << 2 // Underlined characters
    StrikeThrough         = 1 << 3 // Strike through characters
    HorizontalAlignCenter = 1 << 4 // Aligns the text horizontally in the center
    HorizontalAlignRight  = 1 << 5 // Aligns the text horizontally to the right
)

/**
 * Graphical text that can be drawn to a render target.
 *
 * `Text` is a drawable class that allows to easily display
 * some text with custom style and color on a render target.
 *
 * It inherits all the functions from `Transformable`:
 * position, rotation, scale, origin. It also adds text-specific
 * properties such as the font to use, the character size,
 * the font style (bold, italic, underlined and strike through), the
 * text color, the outline thickness, the outline color, the character
 * spacing, the line spacing and the text to display of course.
 * It also provides convenience functions to calculate the
 * graphical size of the text, or to get the global position
 * of a given character.
 *
 * `Text` works in combination with the `Font` class, which
 * loads and provides the glyphs (visual characters) of a given font.
 *
 * The separation of `Font` and `Text` allows more flexibility
 * and better performances: indeed a `Font` is a heavy resource,
 * and any operation on it is slow (often too slow for real-time
 * applications). On the other side, a `Text` is a lightweight
 * object which can combine the glyphs data and metrics of a `Font`
 * to display any text on a render target.
 *
 * It is important to note that the `Text` instance doesn't
 * copy the font that it uses, it only keeps a reference to it.
 * Thus, a `Font` must not be destructed while it is
 * used by a `Text` (i.e. never write a function that
 * uses a local `Font` instance for creating a text).
 *
 * Usage example:
 * ```
 * // Open a font
 * let font = Font("arial.ttf");
 *
 * // Create a text
 * let text = Text(font, "hello");
 * text.setCharacterSize(30);
 * text.setStyle(TextStyle.Bold);
 * text.setFillColor(Color.RED);
 *
 * // Draw it
 * window.draw(text);
 * ```
 *
 * @see `Font`, `Transformable`
 */
public class Text <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<Text> {
    private var m_handle: CPointer<Unit> = CPointer()

    /**
     * Construct the text from a font.
     *
     * @param font          Font used to draw the string
     * @param characterSize Base size of characters, in pixels
     */
    public init(font: Font, characterSize!: UInt32 = 30) {
        this(font, String.empty, characterSize: characterSize)
    }

    /**
     * Construct the text from a string, font and size.
     *
     * Note that if the used font is a bitmap font, it is not
     * scalable, thus not all requested sizes will be available
     * to use. This needs to be taken into consideration when
     * setting the character size. If you need to display text
     * of a certain size, make sure the corresponding bitmap
     * font that supports that size is used.
     *
     * @param font          Font used to draw the string
     * @param string        Text assigned to the string
     * @param characterSize Base size of characters, in pixels
     *
     * @throws SFMLNullHandleException
     */
    public init(font: Font, string: String, characterSize!: UInt32 = 30) {
        m_handle = unsafe { sfText_create(font.handle) }
        if (m_handle.isNull()) {
            throw SFMLNullHandleException()
        }
        if (string.size > 0) {
            unsafe {
                try (str = (string |> toCStringUtf32).asResource()) {
                    sfText_setUnicodeString(m_handle, str.value)
                }
            }
        }
        if (characterSize != 30) {
            unsafe { sfText_setCharacterSize(m_handle, characterSize) }
        }
    }

    private init(handle: CPointer<Unit>) {
        m_handle = handle
    }

    ~init() {
        if (m_handle.isNotNull()) {
            unsafe { sfText_destroy(m_handle) }
            m_handle = CPointer()
        }
    }

    /**
     * Create a copy of the text.
     *
     * @return A new text instance that is a copy of this one.
     */
    public func clone(): Text {
        Text(unsafe { sfText_copy(m_handle) })
    }

    // ResourceHandle

    public func isClosed(): Bool {
        m_handle.isNull()
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        unsafe { sfText_destroy(m_handle) }
        m_handle = CPointer()
    }

    public prop handle: CPointer<Unit> {
        get() {
            m_handle
        }
    }

    // Equatable

    public override operator func ==(right: Text): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public override operator func !=(right: Text): Bool {
        m_handle.toUIntNative() != right.m_handle.toUIntNative()
    }

    // RenderTargetDrawable

    public func draw(window: RenderTexture, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderTexture_drawText(window.handle, m_handle, inout states2)
        }
    }

    public func draw(window: RenderWindow, states: RenderStates): Unit {
        unsafe {
            var states2 = states
            sfRenderWindow_drawText(window.handle, m_handle, inout states2)
        }
    }

    // Transformable

    public mut prop position: Vector2f {
        get() {
            unsafe { sfText_getPosition(m_handle) }
        }
        set(value) {
            unsafe { sfText_setPosition(m_handle, value) }
        }
    }

    public mut prop rotation: Float32 {
        get() {
            unsafe { sfText_getRotation(m_handle) }
        }
        set(value) {
            unsafe { sfText_setRotation(m_handle, value) }
        }
    }

    public mut prop scaleVal: Vector2f {
        get() {
            unsafe { sfText_getScale(m_handle) }
        }
        set(value) {
            unsafe { sfText_setScale(m_handle, value) }
        }
    }

    public mut prop origin: Vector2f {
        get() {
            unsafe { sfText_getOrigin(m_handle) }
        }
        set(value) {
            unsafe { sfText_setOrigin(m_handle, value) }
        }
    }

    public func move(offset: Vector2f): Unit {
        unsafe { sfText_move(m_handle, offset) }
    }

    public func rotate(angle: Float32): Unit {
        unsafe { sfText_rotate(m_handle, angle) }
    }

    public func scale(factors: Vector2f): Unit {
        unsafe { sfText_scale(m_handle, factors) }
    }

    public prop transform: Transform {
        get() {
            unsafe { sfText_getTransform(m_handle) }
        }
    }

    public prop inverseTransform: Transform {
        get() {
            unsafe { sfText_getInverseTransform(m_handle) }
        }
    }

    // Text

    /**
     * Set the text's string.
     *
     * A text's string is empty by default.
     *
     * @param value New string
     */
    public mut prop string: String {
        get() {
            unsafe { sfText_getUnicodeString(m_handle) |> toString }
        }
        set(value) {
            unsafe {
                try (str = (value |> toCStringUtf32).asResource()) {
                    sfText_setUnicodeString(m_handle, str.value)
                }
            }
        }
    }

    /**
     * Set the text's font.
     *
     * The `font` argument refers to a font that must
     * exist as long as the text uses it. Indeed, the text
     * doesn't store its own copy of the font, but rather keeps
     * a pointer to the one that you passed to this function.
     * If the font is destroyed and the text tries to
     * use it, the behavior is undefined.
     *
     * @param value New font
     */
    public mut prop font: Font {
        get() {
            Font(unsafe { sfText_getFont(m_handle) }, isOwner: false)
        }
        set(value) {
            unsafe { sfText_setFont(m_handle, value.handle) }
        }
    }

    /**
     * Set the character size.
     *
     * The default size is 30.
     *
     * Note that if the used font is a bitmap font, it is not
     * scalable, thus not all requested sizes will be available
     * to use. This needs to be taken into consideration when
     * setting the character size. If you need to display text
     * of a certain size, make sure the corresponding bitmap
     * font that supports that size is used.
     *
     * @param value New character size, in pixels
     */
    public mut prop characterSize: UInt32 {
        get() {
            unsafe { sfText_getCharacterSize(m_handle) }
        }
        set(value) {
            unsafe { sfText_setCharacterSize(m_handle, value) }
        }
    }

    /**
     * Set the line spacing factor.
     *
     * The default spacing between lines is defined by the font.
     * This method enables you to set a factor for the spacing
     * between lines. By default the line spacing factor is 1.
     *
     * @param value New line spacing factor
     */
    public mut prop lineSpacing: Float32 {
        get() {
            unsafe { sfText_getLineSpacing(m_handle) }
        }
        set(value) {
            unsafe { sfText_setLineSpacing(m_handle, value) }
        }
    }

    /**
     * Set the letter spacing factor.
     *
     * The default spacing between letters is defined by the font.
     * This factor doesn't directly apply to the existing
     * spacing between each character, it rather adds a fixed
     * space between them which is calculated from the font
     * metrics and the character size.
     * Note that factors below 1 (including negative numbers) bring
     * characters closer to each other.
     * By default the letter spacing factor is 1.
     *
     * @param value New letter spacing factor
     */
    public mut prop letterSpacing: Float32 {
        get() {
            unsafe { sfText_getLetterSpacing(m_handle) }
        }
        set(value) {
            unsafe { sfText_setLetterSpacing(m_handle, value) }
        }
    }

    /**
     * Set the text's style.
     *
     * You can pass a combination of one or more styles, for
     * example `TextStyle.Bold | TextStyle.Italic`.
     * The default style is `TextStyle.Regular`.
     *
     * @param value New style
     */
    public mut prop style: TextStyle {
        get() {
            unsafe { sfText_getStyle(m_handle) }
        }
        set(value) {
            unsafe { sfText_setStyle(m_handle, value) }
        }
    }

    /**
     * Set the fill color of the text.
     *
     * By default, the text's fill color is opaque white.
     * Setting the fill color to a transparent color with an outline
     * will cause the outline to be displayed in the fill area of the text.
     *
     * @param value New fill color of the text
     */
    public mut prop fillColor: Color {
        get() {
            unsafe { sfText_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfText_setFillColor(m_handle, value) }
        }
    }

    /**
     * Set the outline color of the text.
     *
     * By default, the text's outline color is opaque black.
     *
     * @param value New outline color of the text
     */
    public mut prop outlineColor: Color {
        get() {
            unsafe { sfText_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfText_setOutlineColor(m_handle, value) }
        }
    }

    /**
     * Set the thickness of the text's outline.
     *
     * By default, the outline thickness is 0.
     *
     * Be aware that using a negative value for the outline
     * thickness will cause distorted rendering.
     *
     * @param value New outline thickness, in pixels
     */
    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfText_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfText_setOutlineThickness(m_handle, value) }
        }
    }

    /**
     * Get the number of lines in this text.
     *
     * @return Number of lines
     */
    public prop lineCount: UInt32 {
        get() {
            unsafe { sfText_getLineCount(m_handle) }
        }
    }

    /**
     * Return the position of the `index`-th character.
     *
     * This function computes the visual position of a character
     * from its index in the string. The returned position is
     * in global coordinates (translation, rotation, scale and
     * origin are applied).
     * If `index` is out of range, the position of the end of
     * the string is returned.
     *
     * @param index Index of the character
     *
     * @return Position of the character
     */
    public func findCharacterPos(index: UInt32): Vector2f {
        unsafe { sfText_findCharacterPos(m_handle, UIntNative(index)) }
    }

    /**
     * Get the local bounding rectangle of the entity.
     *
     * The returned rectangle is in local coordinates, which means
     * that it ignores the transformations (translation, rotation,
     * scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * entity in the entity's coordinate system.
     *
     * @return Local bounding rectangle of the entity
     */
    public prop localBounds: FloatRect {
        get() {
            unsafe { sfText_getLocalBounds(m_handle) }
        }
    }

    /**
     * Get the global bounding rectangle of the entity.
     *
     * The returned rectangle is in global coordinates, which means
     * that it takes into account the transformations (translation,
     * rotation, scale, ...) that are applied to the entity.
     * In other words, this function returns the bounds of the
     * text in the global 2D world's coordinate system.
     *
     * @return Global bounding rectangle of the entity
     */
    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfText_getGlobalBounds(m_handle) }
        }
    }
}
