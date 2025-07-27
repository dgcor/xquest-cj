package dgengine

import cjsfml.system.*

public class ActScrollableSetSpeed <: Action {
    public ActScrollableSetSpeed(
        private let id: String,
        private let speed: Time
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(obj) <- game.resources.getDrawable<Scrollable>(id)) {
            obj.speed = speed
        }
        return true
    }
}
