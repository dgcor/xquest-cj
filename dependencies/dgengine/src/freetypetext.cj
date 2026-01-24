package dgengine

import cjsfml.graphics.*
import cjsfml.graphics.Text as SFMLText
import cjsfml.system.*

public class FreeTypeText <: DrawableText {
    private let m_text: SFMLText
    private var m_font: FreeTypeFont
    private var m_pos: Vector2f = Vector2f()
    private var m_horizAlign: HorizontalAlign = AlignLeft
    private var m_vertAlign: VerticalAlign = AlignBottom
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_color: Color = Color.WHITE
    private var m_charSize: UInt32 = 0
    private var m_visible: Bool = true

    public init(font: FreeTypeFont, characterSize!: UInt32) {
        m_text = SFMLText(font.font, characterSize: characterSize)
        m_font = font
        m_charSize = characterSize
        updateCharSize()
        updateColor()
    }

    // Resource

    public func isClosed(): Bool {
        m_text.isClosed()
    }

    public func close(): Unit {
        m_text.close()
    }

    // DrawableText

    private func calculateDrawPosition(): Unit {
        var drawPos = GameUtils.getAlignmentPosition(m_pos, size, m_horizAlign, m_vertAlign)
        let bounds = m_text.localBounds
        drawPos -= bounds.position
        m_text.position = drawPos
    }

    private func updateCharSize(): Unit {
        if (m_charSize == 0) {
            var val = m_font.characterSize
            if (val == 0) {
                val = 12
            }
            m_text.characterSize = val
        } else {
            m_text.characterSize = m_charSize
        }
    }

    private func updateColor(): Unit {
        if (m_color == Color.WHITE) {
            m_text.fillColor = m_font.color
        } else {
            m_text.fillColor = color
        }
    }

    public override func clone(): FreeTypeText {
        let copy = FreeTypeText(m_font, characterSize: m_text.characterSize)
        copy.m_pos = m_pos
        copy.m_horizAlign = m_horizAlign
        copy.m_vertAlign = m_vertAlign
        copy.m_anchor = m_anchor
        copy.m_color = m_color
        copy.m_visible = m_visible
        return copy
    }

    public prop text: String {
        get() {
            m_text.string
        }
    }

    public func setText(str: String): Bool {
        if (m_text.string == str) {
            return false
        }
        m_text.string = str
        calculateDrawPosition()
        return true
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
            m_color
        }
        set(value) {
            if (m_color != value) {
                m_color = value
                updateColor()
            }
        }
    }

    public mut prop horizontalAlign: HorizontalAlign {
        get() {
            m_horizAlign
        }
        set(value) {
            if (m_horizAlign != value) {
                m_horizAlign = value
                let style = match (value) {
                    case AlignLeft => TextStyle.Regular
                    case AlignCenter => TextStyle.HorizontalAlignCenter
                    case AlignRight => TextStyle.HorizontalAlignRight
                }
                m_text.style = style
                calculateDrawPosition()
            }
        }
    }

    public mut prop verticalAlign: VerticalAlign {
        get() {
            m_vertAlign
        }
        set(value) {
            if (m_vertAlign != value) {
                m_vertAlign = value
                calculateDrawPosition()
            }
        }
    }

    public mut prop horizontalSpaceOffset: Int32 {
        get() {
            0
        }
        set(value) {
            var factor = 1.0f32
            if (value != 0) {
                factor = Float32(Int32(m_text.characterSize) + value) / Float32(m_text.characterSize)
            }
            m_text.letterSpacing = factor
            calculateDrawPosition()
        }
    }

    public mut prop verticalSpaceOffset: Int32 {
        get() {
            0
        }
        set(value) {
            var factor = 1.0f32
            if (value != 0) {
                factor = Float32(Int32(m_text.characterSize) + value) / Float32(m_text.characterSize)
            }
            m_text.lineSpacing = factor
            calculateDrawPosition()
        }
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_anchor
        }
        set(value) {
            if (m_anchor != value) {
                m_anchor = value
                calculateDrawPosition()
            }
        }
    }

    public func updateSize(game: Game): Unit {
        var pos = Box(position)
        var size = Box(size)
        m_anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_pos = pos.value
        calculateDrawPosition()
    }

    public prop drawPosition: Vector2f {
        get() {
            m_text.position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_pos
        }
        set(value) {
            m_pos = value
            calculateDrawPosition()
        }
    }

    public mut prop size: Vector2f {
        get() {
            if (m_text.string.isEmpty() == true) {
                return Vector2f(0.0, Float32(m_text.characterSize))
            }
            return m_text.localBounds.size
        }
        set(_) {}
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public func draw(_: Game, target: RenderTarget): Unit {
        if (m_visible == true) {
            target.draw(m_text)
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "charCount" => VaInteger(m_text.string.runes().count())
            case "length" => VaInteger(m_text.string.size)
            case "lineCount" => VaInteger(Int64(m_text.lineCount))
            case "text" => VaString(m_text.string)
            case _ => getProperty(props[0], props[1])
        }
    }

    // FreeTypeText

    public mut prop font: FreeTypeFont {
        get() {
            m_font
        }
        set(value) {
            m_font = value
            m_text.font = value.font
            updateCharSize()
            updateColor()
        }
    }
}
