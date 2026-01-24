package dgengine

import stdx.encoding.json.*

public func getMovieObj(game: Game, elem: JsonValue): ?Movie {
    let action = getActionKey(game, elem, "onComplete")
    let movie = Movie(getStringCharKey(elem, "file"))
    if (movie.load() == false) {
        game.events.addBack(action)
        return None
    } else if (action.isSome()) {
        movie.setAction("complete", action)
    }

    let size = Box(getSizeKey(elem, "size", default: movie.size))
    parseDrawableProperties(game, elem, movie, size)

    let volume = getVariableKey(elem, "volume")
    var vol = clamp(game.getVarOrProp(volume, default: Int64(game.musicVolume)), 0, 100)
    movie.volume = Float32(vol)

    return movie
}

public func parseMovie(game: Game, elem: JsonValue): Unit {
    parseValidIdAndAddDrawable(
        game,
        elem,
        {
            game, elem =>
                if (let Some(movie) <- getMovieObj(game, elem)) {
                    movie.play()
                    return movie
                }
                return None
        }
    )
}
