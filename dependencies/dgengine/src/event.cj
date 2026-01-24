package dgengine

import cjsfml.system.*

public class Event <: Action {
    private var m_id: String = String.empty
    private var m_action: ?Action
    private var m_elapsedTime: ElapsedTime

    public init(action: ?Action, timeout!: Time = Time.ZERO) {
        m_action = action
        m_elapsedTime = ElapsedTime(timeout: timeout)
    }

    // Action

    public operator func ()(game: Game): Bool {
        if (let Some(action) <- m_action) {
            if (m_elapsedTime.currentTime == Time.ZERO) {
                // prevents executing events created while loading big files immediately
                m_elapsedTime.currentTime = Time(microseconds: 1)
                return false
            }
            if (m_elapsedTime.timeout == Time.ZERO || m_elapsedTime.update(game.elapsedTime) == true) {
                let ret = action(game)
                if (ret == true || m_elapsedTime.timeout == Time.ZERO) {
                    resetTime()
                }
                return ret
            }
            return false
        }
        return true
    }

    // Event

    public mut prop id: String {
        get() {
            m_id
        }
        set(value) {
            m_id = value
        }
    }

    public mut prop action: ?Action {
        get() {
            m_action
        }
        set(value) {
            m_action = value
        }
    }

    public func resetTime(): Unit {
        m_elapsedTime.reset()
    }

    public func timeout(): Unit {
        m_elapsedTime.currentTime = m_elapsedTime.timeout
    }
}
