package dgengine

import std.collection.*

public class EventManager {
    private var m_events = LinkedList<Action>()

    public func addBack(action: Action): Unit {
        m_events.addLast(action)
    }

    public func addFront(action: Action): Unit {
        m_events.addFirst(action)
    }

    public func addBack(action: ?Action): Unit {
        if (let Some(action) <- action) {
            m_events.addLast(action)
        }
    }

    public func addFront(action: ?Action): Unit {
        if (let Some(action) <- action) {
            m_events.addFirst(action)
        }
    }

    public func exists(id: String): Bool {
        if (id.isEmpty() == false) {
            for (evt in m_events) {
                if (let Some(actionEvt) <- (evt as Event)) {
                    if (actionEvt.id == id) {
                        return true
                    }
                }
            }
        }
        return false
    }

    public func remove(id: String): Unit {
        if (id.isEmpty() == false) {
            for (evt in m_events) {
                if (let Some(actionEvt) <- (evt as Event)) {
                    if (actionEvt.id == id) {
                        actionEvt.action = None
                    }
                }
            }
        }
    }

    public func removeAll(): Unit {
        for (evt in m_events) {
            if (let Some(actionEvt) <- (evt as Event)) {
                actionEvt.action = None
            }
        }
    }

    public func resetTime(id: String): Unit {
        if (id.isEmpty() == false) {
            for (evt in m_events) {
                if (let Some(actionEvt) <- (evt as Event)) {
                    if (actionEvt.id == id) {
                        actionEvt.resetTime()
                    }
                }
            }
        }
    }

    public func timeout(id: String): Unit {
        if (id.isEmpty() == false) {
            for (evt in m_events) {
                if (let Some(actionEvt) <- (evt as Event)) {
                    if (actionEvt.id == id) {
                        actionEvt.timeout()
                    }
                }
            }
        }
    }

    public func update(game: Game): Unit {
        var nextNode = m_events.firstNode
        while (let Some(node) <- nextNode) {
            nextNode = node.next
            let evt = node.value
            if (evt(game) == true || (evt is Event) == false) {
                m_events.remove(node)
            }
        }
    }
}
