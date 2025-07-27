package dgengine

import cjsfml.audio.*
import cjsfml.graphics.*
import std.collection.*

public class BitmapButton <: Image & Button {
    private var m_button: ButtonImpl

    public init() {
        super()
        m_button = ButtonImpl()
    }

    public init(texture: Texture, palette!: ?Palette = None) {
        super(texture, palette: palette)
        m_button = ButtonImpl()
    }

    public init(ti: TextureInfo) {
        super(ti)
        m_button = ButtonImpl()
    }

    public init(ti: ArrayList<TextureInfo>, drawAfter!: Bool = false) {
        super(ti, drawAfter: drawAfter)
        m_button = ButtonImpl()
    }

    // ActionQueryable

    public func getAction(name: String): ?Action {
        m_button.getAction(name)
    }

    public func setAction(name: String, action: ?Action): Bool {
        m_button.setAction(name, action)
    }

    // UIObject

    public override func update(game: Game): Unit {
        if (visible == false) {
            return
        }
        let contains = m_sprite.globalBounds.contains(game.mousePositionf)
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
