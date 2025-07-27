package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*

public class BitmapText <: DrawableText {
    private let m_vertexText: VertexArray2 = VertexArray2()
    private var m_text: String = String.empty
    private var m_font: BitmapFont
    private var m_pos: Vector2f = Vector2f()
    private var m_drawPos: Vector2f = Vector2f()
    private var m_size: Vector2f = Vector2f()
    private var m_horizAlign: HorizontalAlign = AlignLeft
    private var m_vertAlign: VerticalAlign = AlignBottom
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_color: Color = Color.white
    private var m_horizSpaceOffset: Int32 = 0
    private var m_vertSpaceOffset: Int32 = 0
    private var m_lineCount: UInt32 = 0
    private var m_visible: Bool = true
    private var m_closed: Bool = false

    public init(font: BitmapFont) {
        m_font = font
        m_size.y = Float32(font.newLine)
    }

    // Resource

    public func isClosed(): Bool {
        m_closed
    }

    public func close(): Unit {
        m_closed = true
    }

    // DrawableText

    private func calculateDrawPosition(): Unit {
        m_drawPos = GameUtils.getAlignmentPosition(m_pos, m_size, m_horizAlign, m_vertAlign)
    }

    private func calculateSize(): Unit {
        let lineCount = Box(0u32)
        m_size = m_font.calculateSize(m_text, m_horizSpaceOffset, m_vertSpaceOffset, lineCount: lineCount)
        m_lineCount = lineCount.value
    }

    private func updateVertexText(): Unit {
        m_font.updateVertexString(m_vertexText.vertices, m_text, m_color, m_horizSpaceOffset, m_vertSpaceOffset,
            m_size.x, m_horizAlign)
    }

    public override func clone(): BitmapText {
        let copy = BitmapText(m_font)
        copy.m_text = m_text
        copy.m_pos = m_pos
        copy.m_drawPos = m_drawPos
        copy.m_size = m_size
        copy.m_horizAlign = m_horizAlign
        copy.m_vertAlign = m_vertAlign
        copy.m_anchor = m_anchor
        copy.m_color = m_color
        copy.m_horizSpaceOffset = m_horizSpaceOffset
        copy.m_vertSpaceOffset = m_vertSpaceOffset
        copy.m_lineCount = m_lineCount
        copy.m_visible = m_visible
        return copy
    }

    public prop text: String {
        get() {
            m_text
        }
    }

    public func setText(str: String): Bool {
        if (m_text == str) {
            return false
        }
        m_text = str
        calculateSize()
        updateVertexText()
        calculateDrawPosition()
        return true
    }

    public prop localBounds: FloatRect {
        get() {
            FloatRect(m_drawPos, m_size)
        }
    }

    public prop globalBounds: FloatRect {
        get() {
            FloatRect(m_drawPos, m_size)
        }
    }

    public prop lineCount: UInt32 {
        get() {
            m_lineCount
        }
    }

    public mut prop color: Color {
        get() {
            m_color
        }
        set(value) {
            if (m_color != value) {
                m_color = value
                for ((index, vertex) in m_vertexText.vertices |> enumerate) {
                    m_vertexText.vertices[index] = Vertex(position: vertex.position, color: value,
                        texCoords: vertex.texCoords)
                }
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
            m_horizSpaceOffset
        }
        set(value) {
            if (m_horizSpaceOffset != value) {
                m_horizSpaceOffset = value
                calculateSize()
                updateVertexText()
                calculateDrawPosition()
            }
        }
    }

    public mut prop verticalSpaceOffset: Int32 {
        get() {
            m_vertSpaceOffset
        }
        set(value) {
            if (m_vertSpaceOffset != value) {
                m_vertSpaceOffset = value
                calculateSize()
                updateVertexText()
                calculateDrawPosition()
            }
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
        var pos = Box(m_pos)
        var size = Box(m_size)
        m_anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_pos = pos.value
        m_size = size.value
        calculateDrawPosition()
    }

    public prop drawPosition: Vector2f {
        get() {
            m_drawPos
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
            m_size
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

    public func draw(game: Game, target: RenderTarget): Unit {
        if (m_visible == true) {
            m_font.draw(m_vertexText, m_drawPos, m_size, game.shaders.sprite, target)
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "charCount" => VaInteger(m_text.runes().count())
            case "length" => VaInteger(m_text.size)
            case "lineCount" => VaInteger(Int64(m_lineCount))
            case "text" => VaString(m_text)
            case _ => getProperty(props[0], props[1])
        }
    }

    // BitmapText

    public mut prop font: BitmapFont {
        get() {
            m_font
        }
        set(value) {
            m_font = value
            calculateSize()
            updateVertexText()
            calculateDrawPosition()
        }
    }
}
