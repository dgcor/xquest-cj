package dgengine

public class ActMoviePause <: Action {
    public ActMoviePause(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(movie) <- game.resources.getDrawable<Movie>(id)) {
            movie.pause()
        }
        return true
    }
}

public class ActMoviePlay <: Action {
    public ActMoviePlay(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (let Some(movie) <- game.resources.getDrawable<Movie>(id)) {
            movie.play()
        }
        return true
    }
}
