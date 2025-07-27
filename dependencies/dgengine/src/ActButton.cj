package dgengine

import cjsfml.graphics.*

public class ActButtonClick <: Action {
    public ActButtonClick(
        private let id: String,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            button.click(game, playSound: playSound)
        }
        return true
    }
}

public class ActButtonEnable <: Action {
    public ActButtonEnable(
        private let id: String,
        private let enable: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            button.enable(enable)
        }
        return true
    }
}

public class ActButtonRightClick <: Action {
    public ActButtonRightClick(
        private let id: String,
        private let playSound: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            button.rightClick(game, playSound: playSound)
        }
        return true
    }
}

public class ActButtonSetColor <: Action {
    public ActButtonSetColor(
        private let id: String,
        private let color: Color
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            button.color = color
        }
        return true
    }
}
