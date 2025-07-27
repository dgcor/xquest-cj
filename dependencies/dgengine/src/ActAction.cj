package dgengine

public class ActActionSet <: Action {
    public ActActionSet(
        private let key: String,
        private let action: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        if (key.isEmpty() == false) {
            game.resources.setAction(key, action)
        }
        return true
    }
}
