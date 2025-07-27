package dgengine

public class ActPanelAddDrawable <: Action {
    public ActPanelAddDrawable(
        private let id: String,
        private let idDrawable: String
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(panel) <- game.resources.getDrawable<Panel>(id)) {
            if (let Some(drawable) <- game.resources.getDrawable(idDrawable)) {
                if (panel.addDrawable(drawable) == true) {
                    game.resources.deleteDrawable(drawable)
                }
            }
        }
        return true
    }
}
