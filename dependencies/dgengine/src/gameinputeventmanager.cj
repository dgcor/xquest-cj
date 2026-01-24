package dgengine

import cjsfml.window.Event as SFMLEvent
import std.collection.*

public class GameInputEventManager {
    private var m_gameInputEvents: HashMap<String, ArrayList<SFMLEvent>> = HashMap<String, ArrayList<SFMLEvent>>()

    public func clear(key: String): Unit {
        m_gameInputEvents.remove(key)
    }

    public func get(key: String): ArrayList<SFMLEvent> {
        m_gameInputEvents.get(key) ?? ArrayList<SFMLEvent>()
    }

    public func set(key: String, value: SFMLEvent): Unit {
        if (let Some(inputEvents) <- m_gameInputEvents.get(key)) {
            for (evt in inputEvents) {
                if (evt == value) {
                    return
                }
            }
            inputEvents.add(value)
        } else {
            m_gameInputEvents.add(key, ArrayList<SFMLEvent>(1, {_ => value}))
        }
    }
}
