package dgengine

import std.convert.*

public class InputText <: Text {
    private var m_enterAction: ?Action
    private var m_minLengthAction: ?Action
    private var m_minLength: UInt32
    private var m_maxLength: UInt32
    private var m_minValue: ?Variable
    private var m_maxValue: ?Variable
    private var m_regex: Regex

    public init(font: Font, characterSize!: UInt32 = 0) {
        super(font, characterSize: characterSize)
        m_enterAction = None
        m_minLengthAction = None
        m_minLength = 0
        m_maxLength = 0
        m_minValue = None
        m_maxValue = None
        m_regex = Regex()
    }

    protected init(text!: DrawableText, changeAction!: ?Action, triggerOnChange!: Bool, enterAction!: ?Action,
        minLengthAction!: ?Action, minLength!: UInt32, maxLength!: UInt32, minValue!: ?Variable, maxValue!: ?Variable,
        regex!: Regex) {
        super(
            text: text,
            changeAction: changeAction,
            triggerOnChange: triggerOnChange
        )
        m_enterAction = enterAction
        m_minLengthAction = minLengthAction
        m_minLength = minLength
        m_maxLength = maxLength
        m_minValue = minValue
        m_maxValue = maxValue
        m_regex = regex
    }

    public func clone(): InputText {
        InputText(
            text: m_text.clone(),
            changeAction: m_changeAction,
            triggerOnChange: m_triggerOnChange,
            enterAction: m_enterAction,
            minLengthAction: m_minLengthAction,
            minLength: m_minLength,
            maxLength: m_maxLength,
            minValue: m_minValue,
            maxValue: m_maxValue,
            regex: m_regex
        )
    }

    // ActionQueryable

    public override func getAction(name: String): ?Action {
        match (name) {
            case "change" => m_changeAction
            case "click" | "enter" => m_enterAction
            case "minLength" => m_minLengthAction
            case _ => super.getAction(name)
        }
    }

    public override func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "change" => m_changeAction = action
            case "click" | "enter" => m_enterAction = action
            case "minLength" => m_minLengthAction = action
            case _ => return super.setAction(name, action)
        }
        return true
    }

    // UIObject

    public override func update(game: Game): Unit {
        if (visible == false) {
            return
        }
        if (let Some(textEntered) <- game.textEntered) {
            let unicode = UInt32(textEntered.unicode)
            if (unicode < 256 && unicode != 0) {
                while (true) {
                    var txt = text
                    if (unicode == 8 && txt.size > 0) {
                        // backspace
                        txt = txt[0..txt.size - 1]
                        text = txt
                    } else if (unicode < 0 || unicode >= 32) {
                        txt += textEntered.unicode.toString()
                        if (isValidMax(txt) == false) {
                            break
                        }
                        if (m_regex.matcher(txt) == false) {
                            break
                        }
                        text = txt
                    }
                    m_triggerOnChange = true
                    break
                }
            }
        }
        super.update(game)
    }

    public override func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "number" => VaInteger(Int64.tryParse(text) ?? 0)
            case "double" => VaDouble(Float64.tryParse(text) ?? 0.0)
            case _ => super.getProperty(propName)
        }
    }

    // InputText

    public mut prop minLength: UInt32 {
        get() {
            m_minLength
        }
        set(value) {
            m_minLength = value
        }
    }

    public mut prop maxLength: UInt32 {
        get() {
            m_maxLength
        }
        set(value) {
            m_maxLength = value
        }
    }

    public mut prop minValue: ?Variable {
        get() {
            m_minValue
        }
        set(value) {
            m_minValue = value
        }
    }

    public mut prop maxValue: ?Variable {
        get() {
            m_maxValue
        }
        set(value) {
            m_maxValue = value
        }
    }

    private func isValidMin(str: String): Bool {
        if (str.size < Int64(minLength)) {
            return false
        }
        if (let Some(minValue) <- m_minValue) {
            return match (minValue) {
                case VaString(value) => value <= str
                case VaInteger(value) => value <= (Int64.tryParse(str) ?? 0)
                case VaDouble(value) => value <= (Float64.tryParse(str) ?? 0.0)
                case _ => false
            }
        }
        return true
    }

    private func isValidMax(str: String): Bool {
        if (m_maxLength > 0 && str.size > Int64(maxLength)) {
            return false
        }
        if (let Some(minValue) <- m_minValue) {
            return match (minValue) {
                case VaString(value) => value >= str
                case VaInteger(value) => value >= (Int64.tryParse(str) ?? 0)
                case VaDouble(value) => value >= (Float64.tryParse(str) ?? 0.0)
                case _ => false
            }
        }
        return true
    }

    public func setRegex(regex: String): Unit {
        m_regex = Regex(regex)
    }

    public func click(game: Game): Unit {
        if (isValidMin(text) == false) {
            game.events.addBack(m_minLengthAction)
            return
        }
        game.events.addBack(m_enterAction)
    }
}
