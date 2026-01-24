package dgengine

import cjsfml.system.*

public class ActAnimationPause <: Action {
    public ActAnimationPause(
        private let id: String,
        private let pause: Bool,
        private let reset: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(animation) <- game.resources.getDrawable<Animation>(id)) {
            animation.pause = pause
            if (reset == true) {
                animation.reset()
                animation.updateTexture()
            }
        }
        return true
    }
}

public class ActAnimationSetAnimation <: Action {
    public ActAnimationSetAnimation(
        private let id: String,
        private let idTexturePack: String,
        private let groupIdx: Int32,
        private let directionIdx: Int32,
        private let refresh: Time,
        private let resetAnimation: Bool,
        private let updateAnimationType: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(animation) <- game.resources.getDrawable<Animation>(id)) {
            if (let Some(texPack) <- game.resources.getTexturePack(idTexturePack)) {
                animation.setAnimation(texPack, groupIdx, directionIdx, resetAnimation, updateAnimationType)
            } else {
                animation.setAnimation(groupIdx, directionIdx, resetAnimation, updateAnimationType)
            }
            if (refresh.microseconds > 0) {
                animation.frameTime = refresh
            }
        }
        return true
    }
}

public class ActAnimationSetRefresh <: Action {
    public ActAnimationSetRefresh(
        private let id: String,
        private let refresh: Time
    ) {}

    public operator func ()(game: Game): Bool {
        if (refresh.microseconds > 0) {
            if (let Some(animation) <- game.resources.getDrawable<Animation>(id)) {
                animation.frameTime = refresh
            }
        }
        return true
    }
}
