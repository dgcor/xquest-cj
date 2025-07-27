package dgengine

import std.collection.*

public class ActRandomList <: Action {
    private let actions: ArrayList<Action> = ArrayList<Action>()

    public func add(action: ?Action): Unit {
        if (let Some(action) <- action) {
            actions.add(action)
        }
    }

    public func isEmpty(): Bool {
        actions.isEmpty()
    }

    public operator func ()(game: Game): Bool {
        if (actions.isEmpty() == false) {
            let idx = Random.get(actions.size - 1)
            actions[idx](game)
        }
        return true
    }
}

public class ActRandom <: Action {
    public ActRandom(
        private let percentage: Float64,
        private let action1: ?Action,
        private let action2: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        if (Random.getf64() < percentage) {
            if (let Some(action) <- action1) {
                action(game)
            }
        } else {
            if (let Some(action) <- action2) {
                action(game)
            }
        }
        return true
    }
}
