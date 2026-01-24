package dgengine

import stdx.encoding.json.*

public func parseMoviePause(elem: JsonValue): ?Action {
    ActMoviePause(getStringCharKey(elem, "id"))
}

public func parseMoviePlay(elem: JsonValue): ?Action {
    ActMoviePlay(getStringCharKey(elem, "id"))
}
