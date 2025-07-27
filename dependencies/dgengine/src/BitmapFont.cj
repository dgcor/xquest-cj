package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*
import std.math.*

public class BitmapFont {
    private let m_texturePack: TexturePack
    private var m_palette: ?Palette = None
    private var m_defaultColor: Color = Color.white
    private var m_newLine: Int32 = 0
    private var m_space: Int32 = 0
    private var m_tab: Int32 = 0
    private var m_defaultHorizSpaceOffset: Int32 = 0
    private var m_defaultVertSpaceOffset: Int32 = 0

    // draws whitespace using the whitespace image size
    private var m_drawWhitespace: Bool = false

    public init(texturePack: TexturePack, newLine!: Int32, space!: Int32, tab!: Int32) {
        m_texturePack = texturePack
        m_newLine = match (newLine < 0) {
            case true => texturePack.getTextureSize(UInt32(r'\n')).y
            case _ => newLine
        }
        m_space = match (space < 0) {
            case true => texturePack.getTextureSize(UInt32(r' ')).x
            case _ => space
        }
        m_tab = match (tab < 0) {
            case true => texturePack.getTextureSize(UInt32(r'\t')).x
            case _ => tab
        }
    }

    protected init(texturePack: TexturePack) {
        m_texturePack = texturePack
    }

    public func clone(): BitmapFont {
        let copy = BitmapFont(m_texturePack)
        copy.m_palette = m_palette
        copy.m_defaultColor = m_defaultColor
        copy.m_newLine = m_newLine
        copy.m_space = m_space
        copy.m_tab = m_tab
        copy.m_defaultHorizSpaceOffset = m_defaultHorizSpaceOffset
        copy.m_defaultVertSpaceOffset = m_defaultVertSpaceOffset
        return copy
    }

    public mut prop palette: ?Palette {
        get() {
            if (m_palette.isSome()) {
                return m_palette
            }
            return m_texturePack.palette
        }
        set(value) {
            m_palette = value
        }
    }

    public mut prop color: Color {
        get() {
            m_defaultColor
        }
        set(value) {
            m_defaultColor = value
        }
    }

    public prop newLine: Int32 {
        get() {
            m_newLine
        }
    }

    public prop space: Int32 {
        get() {
            m_space
        }
    }

    public prop tab: Int32 {
        get() {
            m_tab
        }
    }

    protected func getHorizontalSpaceOffset(horizSpaceOffset: Int32): Int32 {
        match (horizSpaceOffset != 0) {
            case true => horizSpaceOffset
            case _ => m_defaultHorizSpaceOffset
        }
    }

    protected func getVerticalSpaceOffset(vertSpaceOffset: Int32): Int32 {
        match (vertSpaceOffset != 0) {
            case true => vertSpaceOffset
            case _ => m_defaultVertSpaceOffset
        }
    }

    public mut prop horizontalSpaceOffset: Int32 {
        get() {
            m_defaultHorizSpaceOffset
        }
        set(value) {
            m_defaultHorizSpaceOffset = value
        }
    }

    public mut prop verticalSpaceOffset: Int32 {
        get() {
            m_defaultVertSpaceOffset
        }
        set(value) {
            m_defaultVertSpaceOffset = value
        }
    }

    public mut prop drawWhitespace: Bool {
        get() {
            m_drawWhitespace
        }
        set(value) {
            m_drawWhitespace = value
        }
    }

    protected func calculateLineLength(text: Array<Rune>, horizontalSpaceOffset: Int32): Float32 {
        let horizSpaceOffset = getHorizontalSpaceOffset(horizontalSpaceOffset)

        // Temp offsets
        var curX: Float32 = 0.0

        let runeCount = text.size
        for ((index, ch) in text |> enumerate) {
            // If the current character is a newline
            if (ch == r'\n') {
                return curX
            }
            // If the current character is a space
            if (ch == r' ' && drawWhitespace == false) {
                // Move over
                curX += Float32(m_space)
            } else if (ch == r'\t' && drawWhitespace == false) {
                // If the current character is a tab
                // Move over
                curX += Float32(m_tab)
            } else {
                // Move over the width of the character
                curX += Float32(m_texturePack.getTextureSize(UInt32(ch)).x)
            }
            if (index < runeCount) {
                curX += Float32(horizSpaceOffset)
            }
        }
        return curX
    }

    public func calculateSize(text: String): Vector2f {
        calculateSize(text, 0, 0)
    }

    // returns tuple with size and line count
    public func calculateSize(text: String, horizontalSpaceOffset: Int32, verticalSpaceOffset: Int32,
        lineCount!: ?Box<UInt32> = None): Vector2f {
        let horizSpaceOffset = getHorizontalSpaceOffset(horizontalSpaceOffset)
        let vertSpaceOffset = getHorizontalSpaceOffset(verticalSpaceOffset)

        // Temp offsets
        var maxX: Float32 = 0.0
        var curX: Float32 = 0.0
        var curY: Float32 = 0.0
        var numLines: UInt32 = match (text.isEmpty()) {
            case true => 0
            case false => 1
        }

        let runeCount = text.runes().count()
        for ((index, ch) in text.runes() |> enumerate) {
            // If the current character is a newline
            if (ch == r'\n') {
                // Move down
                curY += Float32(m_newLine + vertSpaceOffset)

                // Move back
                if (curX > maxX) {
                    maxX = curX
                }
                curX = 0.0
                numLines++
            } else {
                // If the current character is a space
                if (ch == r' ' && drawWhitespace == false) {
                    // Move over
                    curX += Float32(m_space)
                } else if (ch == r'\t' && drawWhitespace == false) {
                    // If the current character is a tab
                    // Move over
                    curX += Float32(m_tab)
                } else {
                    // Move over the width of the character
                    curX += Float32(m_texturePack.getTextureSize(UInt32(ch)).x)
                }
                if (index < runeCount) {
                    curX += Float32(horizSpaceOffset)
                }
            }
        }
        if (let Some(lineCount) <- lineCount) {
            lineCount.value = numLines
        }
        return Vector2f(max(maxX, curX), Float32(m_newLine) + curY)
    }

    public func updateVertexString(vertexText: ArrayList<Vertex>, text: String, color: Color,
        horizontalSpaceOffset: Int32, verticalSpaceOffset: Int32, sizeX: Float32, align: HorizontalAlign): Unit {
        let horizSpaceOffset = getHorizontalSpaceOffset(horizontalSpaceOffset)
        let vertSpaceOffset = getHorizontalSpaceOffset(verticalSpaceOffset)
        let runes = text.toRuneArray()

        var vertexColor = color
        if (m_palette.isSome() == true) {
            vertexColor = Color.white
        } else if (color == Color.white) {
            vertexColor = m_defaultColor
        }

        vertexText.clear()
        vertexText.reserve(text.size * 6)

        // Temp offsets
        var curX: Float32 = 0.0
        var curY: Float32 = 0.0

        match (align) {
            case AlignCenter =>
                let textLength = calculateLineLength(runes, horizSpaceOffset)
                curX += round((sizeX / 2.0) - (textLength / 2.0))
            case AlignRight =>
                let textLength = calculateLineLength(runes, horizSpaceOffset)
                curX += (sizeX - textLength)
            case _ => ()
        }

        // Iterate the UTF32 runes
        let runeCount = runes.size
        for ((index, ch) in runes |> enumerate) {
            // If the current character is a newline
            if (ch == r'\n') {
                // Move down
                curY += Float32(m_newLine + vertSpaceOffset)

                // Move back
                curX = 0.0
                match (align) {
                    case AlignCenter =>
                        let textLength = calculateLineLength(runes[index + 1..runeCount], horizSpaceOffset)
                        curX += round((sizeX / 2.0) - (textLength / 2.0))
                    case AlignRight =>
                        let textLength = calculateLineLength(runes[index + 1..runeCount], horizSpaceOffset)
                        curX += (sizeX - textLength)
                    case _ => ()
                }
            } else {
                // If the current character is a space
                if (ch == r' ' && drawWhitespace == false) {
                    // Move over
                    curX += Float32(m_space)
                } else if (ch == r'\t' && drawWhitespace == false) {
                    // If the current character is a tab
                    // Move over
                    curX += Float32(m_tab)
                } else {
                    // create the character vertex
                    if (let Some(ti) <- m_texturePack.get(UInt32(ch))) {
                        // triangle 1

                        // top left
                        vertexText.add(
                            Vertex(
                                position: Vector2f(curX, curY),
                                color: vertexColor,
                                texCoords: Vector2f(Float32(ti.textureRect.left), Float32(ti.textureRect.top))
                            )
                        )

                        // top right
                        vertexText.add(
                            Vertex(
                                position: Vector2f(curX + Float32(ti.textureRect.width), curY),
                                color: vertexColor,
                                texCoords: Vector2f(Float32(ti.textureRect.left) + Float32(ti.textureRect.width),
                                    Float32(ti.textureRect.top))
                            )
                        )

                        // bottom left
                        vertexText.add(
                            Vertex(
                                position: Vector2f(curX, curY + Float32(ti.textureRect.height)),
                                color: vertexColor,
                                texCoords: Vector2f(Float32(ti.textureRect.left),
                                    Float32(ti.textureRect.top) + Float32(ti.textureRect.height))
                            )
                        )

                        // triangle 2

                        // top right
                        vertexText.add(vertexText[vertexText.size - 2])

                        // bottom left
                        vertexText.add(vertexText[vertexText.size - 2])

                        // bottom right
                        vertexText.add(
                            Vertex(
                                position: Vector2f(curX + Float32(ti.textureRect.width),
                                    curY + Float32(ti.textureRect.height)),
                                color: vertexColor,
                                texCoords: Vector2f(Float32(ti.textureRect.left) + Float32(ti.textureRect.width),
                                    Float32(ti.textureRect.top) + Float32(ti.textureRect.height))
                            )
                        )

                        // Move over the width of the character
                        curX += Float32(ti.textureRect.width)
                    }
                }
                if (index + 1 < runeCount) {
                    curX += Float32(horizSpaceOffset)
                }
            }
        }
    }

    public func draw(vertexText: VertexArray2, pos: Vector2f, size: Vector2f, spriteShader: ?GameShader,
        target: RenderTarget): Unit {
        if (let Some(texture) <- m_texturePack.texture) {
            vertexText.draw(texture, pos, size, palette, spriteShader, target)
        }
    }
}
