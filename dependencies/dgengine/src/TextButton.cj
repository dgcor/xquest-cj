package dgengine

import cjsfml.audio.*
import cjsfml.graphics.*
import std.collection.*

public class TextButton <: BindableText & Button {
    private var m_button: ButtonImpl

    public init(font: Font, characterSize!: UInt32 = 0) {
        super(font, characterSize: characterSize)
        m_button = ButtonImpl()
    }

    protected init(text!: DrawableText, changeAction!: ?Action, triggerOnChange!: Bool, format!: String,
        bindings!: ArrayList<String>, flags!: BindingFlags, button!: ButtonImpl) {
        super(
            text: text,
            changeAction: changeAction,
            triggerOnChange: triggerOnChange,
            format: format,
            bindings: bindings,
            flags: flags
        )
        m_button = button
    }

    public override func clone(): TextButton {
        TextButton(
            text: m_text.clone(),
            changeAction: m_changeAction,
            triggerOnChange: m_triggerOnChange,
            format: m_format,
            bindings: m_bindings,
            flags: m_flags,
            button: m_button
        )
    }

    // ActionQueryable

    public func getAction(name: String): ?Action {
        let action = m_button.getAction(name)
        if (action.isSome()) {
            return action
        }
        return super.getAction(name)
    }

    public func setAction(name: String, action: ?Action): Bool {
        if (m_button.setAction(name, action) == true) {
            return true
        }
        return super.setAction(name, action)
    }

    // UIObject

    public override func update(game: Game): Unit {
        super.update(game)
        if (visible == false) {
            return
        }
        let contains = globalBounds.contains(game.mousePositionf)
        m_button.update(this, game, contains: contains)
    }

    public override func getProperty(propName: String): ?Variable {
        let value = m_button.getProperty(propName)
        if (value.isSome()) {
            return value
        }
        return super.getProperty(propName)
    }

    // Button

    public func click(game: Game, playSound!: Bool): Bool {
        m_button.click(this, game, playSound: playSound)
    }

    public func rightClick(game: Game, playSound!: Bool): Bool {
        m_button.rightClick(this, game, playSound: playSound)
    }

    public func focus(game: Game): Unit {
        m_button.focus(game)
    }

    public mut prop captureInputEvents: InputEventType {
        get() {
            m_button.captureInputEvents
        }
        set(value) {
            m_button.captureInputEvents = value
        }
    }

    public prop isEnabled: Bool {
        get() {
            m_button.enabled
        }
    }

    public func enable(enable: Bool): Unit {
        m_button.enabled = enable
    }

    public prop isFocusEnabled: Bool {
        get() {
            m_button.focusEnable
        }
    }

    public func setFocusEnabled(focusOnClick!: Bool): Unit {
        m_button.setFocusEnabled(focusOnClick: focusOnClick)
    }

    public mut prop clickUp: Bool {
        get() {
            m_button.clickUp
        }
        set(value) {
            m_button.clickUp = value
        }
    }

    public mut prop clickSound: ?SoundBuffer {
        get() {
            m_button.clickSound
        }
        set(value) {
            m_button.clickSound = value
        }
    }

    public mut prop focusSound: ?SoundBuffer {
        get() {
            m_button.focusSound
        }
        set(value) {
            m_button.focusSound = value
        }
    }
}
