package dgengine

public class ActInputTextClick <: Action {
    public ActInputTextClick(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(text) <- game.resources.getDrawable<InputText>(id)) {
            text.click(game)
        }
        return true
    }
}
