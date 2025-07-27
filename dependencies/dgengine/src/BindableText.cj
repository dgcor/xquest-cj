package dgengine

import std.collection.*

public open class BindableText <: Text {
    protected var m_format: String = String.empty
    protected var m_bindings: ArrayList<String>
    protected var m_flags: BindingFlags

    public init(font: Font, characterSize!: UInt32 = 0) {
        super(font, characterSize: characterSize)
        m_format = String.empty
        m_bindings = ArrayList<String>()
        m_flags = BindingFlags.OnChange
    }

    protected init(text!: DrawableText, changeAction!: ?Action, triggerOnChange!: Bool, format!: String,
        bindings!: ArrayList<String>, flags!: BindingFlags) {
        super(
            text: text,
            changeAction: changeAction,
            triggerOnChange: triggerOnChange
        )
        m_format = format
        m_bindings = bindings
        m_flags = flags
    }

    public open func clone(): BindableText {
        BindableText(
            text: m_text.clone(),
            changeAction: m_changeAction,
            triggerOnChange: m_triggerOnChange,
            format: m_format,
            bindings: m_bindings,
            flags: m_flags
        )
    }

    // UIObject

    public open override func update(game: Game): Unit {
        if (m_bindings.size > 0 && m_flags.isSet(BindingFlags.Once) == false && (m_flags.isSet(BindingFlags.WhenHidden) ==
            true || visible == true)) {
            let str = Box(String())
            let hasText = TextUtils.getFormatString(game, m_format, m_bindings.iterator(), str)
            if (m_flags.isSet(BindingFlags.Always) == true || hasText == true) {
                text = str.value
            }
        }
        super.update(game)
    }

    // BindableText

    public func setBinding(binding: String): Unit {
        m_bindings.clear()
        m_bindings.add(binding)
    }

    public func setBinding(bindings: ArrayList<String>): Unit {
        m_bindings = bindings
    }

    public mut prop format: String {
        get() {
            m_format
        }
        set(value) {
            m_format = value
        }
    }

    public mut prop bindingFlags: BindingFlags {
        get() {
            m_flags
        }
        set(value) {
            m_flags = value
        }
    }

    public func updateText(game: Game): Unit {
        text = TextUtils.getFormatString(game, m_format, m_bindings.iterator())
    }
}
