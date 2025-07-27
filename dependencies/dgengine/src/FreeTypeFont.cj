package dgengine

import cjsfml.graphics.{Color, Font as SFMLFont}

public class FreeTypeFont <: Resource {
    private let m_font: SFMLFont
    private let m_file: PhysFSStream
    private var m_defaultColor: Color
    private var m_defaultCharSize: UInt32

    public init(file: PhysFSStream) {
        m_font = SFMLFont(file)
        m_file = file
        m_defaultColor = Color.white
        m_defaultCharSize = 0
    }

    protected init(font!: SFMLFont, file!: PhysFSStream, defaultColor!: Color, defaultCharSize!: UInt32) {
        m_font = font
        m_file = file
        m_defaultColor = defaultColor
        m_defaultCharSize = defaultCharSize
    }

    public func clone(): FreeTypeFont {
        FreeTypeFont(
            font: m_font.clone(),
            file: m_file,
            defaultColor: m_defaultColor,
            defaultCharSize: m_defaultCharSize
        )
    }

    // Resource

    public func isClosed(): Bool {
        m_font.isClosed()
    }

    public func close(): Unit {
        m_font.close()
    }

    // FreeTypeFont

    public prop font: SFMLFont {
        get() {
            m_font
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

    public mut prop characterSize: UInt32 {
        get() {
            m_defaultCharSize
        }
        set(value) {
            m_defaultCharSize = value
        }
    }

    public mut prop smooth: Bool {
        get() {
            m_font.smooth
        }
        set(value) {
            m_font.smooth = value
        }
    }
}
