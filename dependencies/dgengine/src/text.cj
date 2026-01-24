package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public open class Text <: ActionQueryable & UIObject {
    protected let m_text: DrawableText
    protected var m_changeAction: ?Action
    protected var m_triggerOnChange: Bool

    public init(font: Font, characterSize!: UInt32 = 0) {
        m_text = match (font) {
            case FontBitmap(font) => BitmapText(font)
            case FontFreeType(font) => FreeTypeText(font, characterSize: characterSize)
        }
        m_changeAction = None
        m_triggerOnChange = false
    }

    protected init(text!: DrawableText, changeAction!: ?Action, triggerOnChange!: Bool) {
        m_text = text
        m_changeAction = changeAction
        m_triggerOnChange = triggerOnChange
    }

    public open func clone(): Text {
        Text(
            text: m_text.clone(),
            changeAction: m_changeAction,
            triggerOnChange: m_triggerOnChange
        )
    }

    // Resource

    public func isClosed(): Bool {
        if (let Some(text) <- (m_text as Resource)) {
            return text.isClosed()
        }
        return false
    }

    public func close(): Unit {
        if (let Some(text) <- (m_text as Resource)) {
            return text.close()
        }
    }

    // ActionQueryable

    public open func getAction(name: String): ?Action {
        match (name) {
            case "change" => m_changeAction
            case _ => None
        }
    }

    public open func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "change" => m_changeAction = action
            case _ => return false
        }
        return true
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_text.anchor
        }
        set(value) {
            m_text.anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        m_text.updateSize(game)
    }

    public prop drawPosition: Vector2f {
        get() {
            m_text.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_text.position
        }
        set(value) {
            m_text.position = value
        }
    }

    public mut prop size: Vector2f {
        get() {
            m_text.size
        }
        set(value) {
            m_text.size = value
        }
    }

    public mut prop visible: Bool {
        get() {
            m_text.visible
        }
        set(value) {
            m_text.visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        m_text.draw(game, target)
    }

    public open func update(game: Game): Unit {
        if (m_triggerOnChange == true) {
            m_triggerOnChange = false
            if (let Some(action) <- m_changeAction) {
                action(game)
            }
        }
    }

    public open func getProperty(propName: String): ?Variable {
        m_text.getProperty(propName)
    }

    // Text

    public mut prop text: String {
        get() {
            m_text.text
        }
        set(value) {
            m_triggerOnChange = m_text.setText(value)
        }
    }

    public prop localBounds: FloatRect {
        get() {
            m_text.localBounds
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            m_text.globalBounds
        }
    }

    public prop lineCount: UInt32 {
        get() {
            m_text.lineCount
        }
    }

    public mut prop color: Color {
        get() {
            m_text.color
        }
        set(value) {
            m_text.color = value
        }
    }

    public mut prop horizontalAlign: HorizontalAlign {
        get() {
            m_text.horizontalAlign
        }
        set(value) {
            m_text.horizontalAlign = value
        }
    }

    public mut prop verticalAlign: VerticalAlign {
        get() {
            m_text.verticalAlign
        }
        set(value) {
            m_text.verticalAlign = value
        }
    }

    public mut prop horizontalSpaceOffset: Int32 {
        get() {
            m_text.horizontalSpaceOffset
        }
        set(value) {
            m_text.horizontalSpaceOffset = value
        }
    }

    public mut prop verticalSpaceOffset: Int32 {
        get() {
            m_text.verticalSpaceOffset
        }
        set(value) {
            m_text.verticalSpaceOffset = value
        }
    }

    public mut prop font: Font {
        /**
         * @throws IllegalStateException
         */
        get() {
            if (let Some(text) <- (m_text as BitmapText)) {
                return FontBitmap(text.font)
            } else if (let Some(text) <- (m_text as FreeTypeText)) {
                return FontFreeType(text.font)
            }
            throw IllegalStateException("Unknown DrawableText class")
        }
        set(value) {
            match (value) {
                case FontBitmap(font) =>
                    if (let Some(text) <- (m_text as BitmapText)) {
                        text.font = font
                    }
                case FontFreeType(font) =>
                    if (let Some(text) <- (m_text as FreeTypeText)) {
                        text.font = font
                    }
            }
        }
    }
}
