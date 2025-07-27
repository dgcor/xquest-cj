package dgengine

import cjsfml.graphics.*
import cjsfml.system.*

public enum FadeType {
    | FadeIn
    | FadeOut

    public static func get(isFadeOut: Bool) {
        match (isFadeOut) {
            case true => FadeOut
            case false => FadeIn
        }
    }
}

// fade out - hide
// fade in - show
public class FadeInOut {
    private var m_color: Color = Color.transparent
    private var m_fadeType: FadeType = FadeIn
    private var m_enableInput: Bool = false
    private var m_fadeOffset: UInt8 = 0
    private var m_elapsedTime: ElapsedTime = ElapsedTime()
    private var m_action: ?Action = None
    private var m_running: Bool = false
    private var m_updateEnableInput: Bool = false

    private func HasFadeEnded(): Bool {
        match (m_fadeType) {
            case FadeIn => m_color.a == 0
            case FadeOut => m_color.a == 255
        }
    }

    private func UpdateFade(): Unit {
        match (m_fadeType) {
            case FadeIn =>
                if (Int64(color.a) - Int64(m_fadeOffset) > 0) {
                    m_color.a -= m_fadeOffset
                } else {
                    m_color.a = 0
                }
            case FadeOut =>
                if (Int64(color.a) + Int64(m_fadeOffset) < 255) {
                    m_color.a += m_fadeOffset
                } else {
                    m_color.a = 255
                }
        }
    }

    public prop color: Color {
        get() {
            m_color
        }
    }

    public func reset(color!: Color, fadeType!: FadeType, enableInput!: Bool, fadeOffset!: UInt8, timeout!: Time,
        action!: ?Action): Unit {
        m_color = color
        if (m_enableInput != enableInput) {
            m_updateEnableInput = true
        }
        m_fadeType = fadeType
        m_enableInput = enableInput
        m_fadeOffset = fadeOffset
        m_elapsedTime = ElapsedTime(timeout: timeout)
        m_action = action
        m_running = true
    }

    public func update(game: Game): Unit {
        if (m_running == false) {
            return
        }
        if (m_updateEnableInput == true) {
            m_updateEnableInput = false
            game.enableInput = m_enableInput
        }

        m_elapsedTime.update(
            game.elapsedTime,
            {
                => if (HasFadeEnded() == true) {
                    game.events.addBack(m_action)
                    if (m_enableInput == false) {
                        game.enableInput = true
                    }
                    m_action = None
                    m_running = false
                    m_color.a = 0
                } else {
                    UpdateFade()
                }
            }
        )
    }
}
