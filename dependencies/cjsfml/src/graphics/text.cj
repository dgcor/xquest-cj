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

@CFlagEnum[public TextStyle UInt32](
    Regular               = 0
    Bold                  = 1 << 0
    Italic                = 1 << 1
    Underlined            = 1 << 2
    StrikeThrough         = 1 << 3
    HorizontalAlignCenter = 1 << 4
    HorizontalAlignRight  = 1 << 5
)

public class Text <: ResourceHandle & RenderTargetDrawable & Transformable & Equatable<Text> {
    private var m_handle: CPointer<Unit> = CPointer()

    public init(font: Font, characterSize!: UInt32 = 30) {
        this(font, String.empty, characterSize: characterSize)
    }

    /**
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

    public operator override func ==(right: Text): Bool {
        m_handle.toUIntNative() == right.m_handle.toUIntNative()
    }

    public operator override func !=(right: Text): Bool {
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

    public mut prop font: Font {
        get() {
            Font(unsafe { sfText_getFont(m_handle) }, isOwner: false)
        }
        set(value) {
            unsafe { sfText_setFont(m_handle, value.handle) }
        }
    }

    public mut prop characterSize: UInt32 {
        get() {
            unsafe { sfText_getCharacterSize(m_handle) }
        }
        set(value) {
            unsafe { sfText_setCharacterSize(m_handle, value) }
        }
    }

    public mut prop lineSpacing: Float32 {
        get() {
            unsafe { sfText_getLineSpacing(m_handle) }
        }
        set(value) {
            unsafe { sfText_setLineSpacing(m_handle, value) }
        }
    }

    public mut prop letterSpacing: Float32 {
        get() {
            unsafe { sfText_getLetterSpacing(m_handle) }
        }
        set(value) {
            unsafe { sfText_setLetterSpacing(m_handle, value) }
        }
    }

    public mut prop style: TextStyle {
        get() {
            unsafe { sfText_getStyle(m_handle) }
        }
        set(value) {
            unsafe { sfText_setStyle(m_handle, value) }
        }
    }

    public mut prop fillColor: Color {
        get() {
            unsafe { sfText_getFillColor(m_handle) }
        }
        set(value) {
            unsafe { sfText_setFillColor(m_handle, value) }
        }
    }

    public mut prop outlineColor: Color {
        get() {
            unsafe { sfText_getOutlineColor(m_handle) }
        }
        set(value) {
            unsafe { sfText_setOutlineColor(m_handle, value) }
        }
    }

    public mut prop outlineThickness: Float32 {
        get() {
            unsafe { sfText_getOutlineThickness(m_handle) }
        }
        set(value) {
            unsafe { sfText_setOutlineThickness(m_handle, value) }
        }
    }

    public prop lineCount: UInt32 {
        get() {
            unsafe { sfText_getLineCount(m_handle) }
        }
    }

    public func findCharacterPos(index: UInt32): Vector2f {
        unsafe { sfText_findCharacterPos(m_handle, UIntNative(index)) }
    }

    public prop localBounds: FloatRect {
        get() {
            unsafe { sfText_getLocalBounds(m_handle) }
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            unsafe { sfText_getGlobalBounds(m_handle) }
        }
    }
}
