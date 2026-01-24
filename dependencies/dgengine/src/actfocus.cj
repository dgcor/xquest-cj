package dgengine

public class ActFocusAdd <: Action {
    public ActFocusAdd(
        private let id: String,
        private let resource: String,
        private let setFocus: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            game.resources.addFocused(button, resourceId: resource)
            if (setFocus == true) {
                game.resources.setFocused(button)
            }
        }
        return true
    }
}

public class ActFocusClick <: Action {
    public ActFocusClick(private let playSound: Bool) {}

    public operator func ()(game: Game): Bool {
        game.resources.clickFocused(game, playSound: playSound)
        return true
    }
}

public class ActFocusMoveDown <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.moveFocusDown(game)
        return true
    }
}

public class ActFocusMoveUp <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.moveFocusUp(game)
        return true
    }
}

public class ActFocusRightClick <: Action {
    public ActFocusRightClick(private let playSound: Bool) {}

    public operator func ()(game: Game): Bool {
        game.resources.rightClickFocused(game, playSound: playSound)
        return true
    }
}

public class ActFocusSet <: Action {
    public ActFocusSet(
        private let id: String,
        private let focus: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(button) <- game.resources.getDrawable<Button>(id)) {
            if (let Some(focused) <- game.resources.getFocused()) {
                let isButtonFocused = isObjEq(button, focused)
                if (isButtonFocused) {
                    game.resources.setFocused(button)
                    if (focus == true && isButtonFocused) {
                        button.focus(game)
                    }
                }
            }
        }
        return true
    }
}

public class ActFocusUpdate <: Action {
    public operator func ()(game: Game): Bool {
        game.resources.updateFocus()
        return true
    }
}
