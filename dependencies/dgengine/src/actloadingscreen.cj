package dgengine

public class ActLoadingScreenSetProgress <: Action {
    public ActLoadingScreenSetProgress(private let progress: Int32) {}

    public operator func ()(game: Game): Bool {
        if (let Some(loadingScreen) <- game.loadingScreen) {
            loadingScreen.progress = progress
            game.drawLoadingScreen()
            if (loadingScreen.isComplete) {
                game.events.addBack(loadingScreen.getAction("complete"))
            }
        }
        return true
    }
}

public class ActLoadingScreenClear <: Action {
    public operator func ()(game: Game): Bool {
        game.loadingScreen = None
        return true
    }
}
