package dgengine

public class ActToggleVisible <: Action {
    public ActToggleVisible(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            item.visible = !item.visible
        }
        return true
    }
}

public class ActSetVisible <: Action {
    public ActSetVisible(
        private let id: String,
        private let visible: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(item) <- game.resources.getDrawable(id)) {
            item.visible = visible
        }
        return true
    }
}
