package dgengine

import cjsfml.system.*

public class ActEventAdd <: Action {
    public ActEventAdd(
        private let id: String,
        private let action: ?Action,
        private let time: Time,
        private let addToFront: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(action) <- action) {
            let evt = Event(action, timeout: time)
            evt.id = id
            if (addToFront == true) {
                game.events.addFront(evt)
            } else {
                game.events.addBack(evt)
            }
        }
        return true
    }
}

public class ActEventDelete <: Action {
    public ActEventDelete(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.events.remove(id)
        return true
    }
}

public class ActEventDeleteAll <: Action {
    public operator func ()(game: Game): Bool {
        game.events.removeAll()
        return true
    }
}

public class ActEventResetTime <: Action {
    public ActEventResetTime(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.events.resetTime(id)
        return true
    }
}

public class ActEventTimeout <: Action {
    public ActEventTimeout(private let id: String) {}

    public operator func ()(game: Game): Bool {
        game.events.timeout(id)
        return true
    }
}
