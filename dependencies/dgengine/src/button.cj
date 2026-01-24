package dgengine

import cjsfml.audio.*
import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*

public interface Button <: ActionQueryable & UIObject {
    func click(game: Game, playSound!: Bool): Bool

    func rightClick(game: Game, playSound!: Bool): Bool

    func focus(game: Game): Unit

    mut prop captureInputEvents: InputEventType

    prop isEnabled: Bool

    func enable(enable: Bool): Unit

    prop isFocusEnabled: Bool

    func setFocusEnabled(focusOnClick!: Bool): Unit

    mut prop clickUp: Bool

    mut prop clickSound: ?SoundBuffer

    mut prop focusSound: ?SoundBuffer

    mut prop color: Color
}

public struct ButtonImpl {
    protected var clickAction: ?Action = None
    protected var rightClickAction: ?Action = None
    protected var doubleClickAction: ?Action = None
    protected var clickDragAction: ?Action = None
    protected var clickInAction: ?Action = None
    protected var clickOutAction: ?Action = None
    protected var focusAction: ?Action = None
    protected var hoverEnterAction: ?Action = None
    protected var hoverLeaveAction: ?Action = None
    protected var clickSound: ?SoundBuffer = None
    protected var focusSound: ?SoundBuffer = None
    protected var mouseDblClickClock: Clock = Clock()
    protected var enabled: Bool = true
    protected var focusEnable: Bool = false
    protected var focusOnClick: Bool = false
    protected var hovered: Bool = false
    protected var clickUp: Bool = false
    protected var beingDragged: Bool = false
    protected var wasLeftClicked: Bool = false
    protected var wasRightClicked: Bool = false
    protected var captureInputEvents: InputEventType = InputEventType.None

    // ActionQueryable

    public func getAction(name: String): ?Action {
        match (name) {
            case "click" => clickAction
            case "rightClick" => rightClickAction
            case "doubleClick" => doubleClickAction
            case "clickDrag" => clickDragAction
            case "clickIn" => clickInAction
            case "clickOut" => clickOutAction
            case "focus" => focusAction
            case "hoverEnter" => hoverEnterAction
            case "hoverLeave" => hoverLeaveAction
            case _ => None
        }
    }

    public mut func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "click" => clickAction = action
            case "rightClick" => rightClickAction = action
            case "doubleClick" => doubleClickAction = action
            case "clickDrag" => clickDragAction = action
            case "clickIn" => clickInAction = action
            case "clickOut" => clickOutAction = action
            case "focus" => focusAction = action
            case "hoverEnter" => hoverEnterAction = action
            case "hoverLeave" => hoverLeaveAction = action
            case _ => return false
        }
        return true
    }

    // UIObject

    private mut func onHover(game: Game, contains: Bool): Unit {
        if (contains == true) {
            if (hovered == false) {
                hovered = true
                game.events.addBack(hoverEnterAction)
            }
        } else {
            if (hovered == true) {
                hovered = false
                game.events.addFront(hoverLeaveAction)
            }
        }
    }

    private mut func onMouseButtonPressed(button: Button, game: Game, contains: Bool): Unit {
        if (contains == false) {
            return
        }
        let event = game.mousePress.getOrThrow()
        if (event.button == MouseButton.Left) {
            beingDragged = true
            wasLeftClicked = true
            game.events.addBack(clickInAction)
            if (clickUp == false) {
                if (doubleClickAction.isSome() && mouseDblClickClock.restart().milliseconds <= GameUtils
                    .DOUBLE_CLICK_DELAY) {
                    game.mousePress = None
                    game.events.addBack(doubleClickAction)
                } else {
                    if (click(button, game, playSound: true) == true) {
                        game.mousePress = None
                    }
                }
            }
        } else if (event.button == MouseButton.Right) {
            wasRightClicked = true
            if (clickUp == false) {
                if (rightClick(button, game, playSound: true) == true) {
                    game.mousePress = None
                }
            }
        }
    }

    private mut func onMouseButtonReleased(button: Button, game: Game, contains: Bool): Unit {
        let event = game.mouseRelease.getOrThrow()
        if (event.button == MouseButton.Left) {
            if (wasLeftClicked == false) {
                return
            }
            wasLeftClicked = false
            if (clickUp == true && contains == true) {
                if (click(button, game, playSound: true) == true) {
                    game.mouseRelease = None
                }
            }
            beingDragged = false
            game.events.addBack(clickOutAction)
        } else if (event.button == MouseButton.Right) {
            if (wasRightClicked == false) {
                return
            }
            wasRightClicked = false
            if (clickUp == true && contains == true) {
                if (rightClick(button, game, playSound: true) == true) {
                    game.mouseRelease = None
                }
            }
        }
    }

    private func onMouseMoved(game: Game): Unit {
        if (beingDragged == true) {
            game.events.addBack(clickDragAction)
        }
    }

    private mut func onTouchBegan(game: Game, contains: Bool): Unit {
        if (contains == false) {
            return
        }
        let event = game.touchBegan.getOrThrow()
        if (event.finger == 0) {
            beingDragged = true
            wasLeftClicked = true
            game.events.addBack(clickInAction)
        }
        if (event.finger == 1) {
            wasRightClicked = true
        }
    }

    private mut func onTouchEnded(button: Button, game: Game, contains: Bool): Unit {
        let event = game.touchEnded.getOrThrow()
        if (event.finger == 0) {
            if (wasLeftClicked == false) {
                return
            }
            wasLeftClicked = false
            if (contains == true) {
                if (doubleClickAction.isSome() && mouseDblClickClock.restart().milliseconds <= GameUtils
                    .DOUBLE_CLICK_DELAY) {
                    game.touchEnded = None
                    game.events.addBack(doubleClickAction)
                } else {
                    if (click(button, game, playSound: true) == true) {
                        game.touchEnded = None
                    }
                }
            }
            beingDragged = false
            game.events.addBack(clickOutAction)
        }
        if (event.finger == 1) {
            if (wasRightClicked == false) {
                return
            }
            wasRightClicked = false
            if (contains == true) {
                if (rightClick(button, game, playSound: true) == true) {
                    game.touchEnded = None
                }
            }
        }
    }

    public mut func update(button: Button, game: Game, contains!: Bool): Unit {
        if (game.mousePress.isSome() == true) {
            onMouseButtonPressed(button, game, contains)
        }
        if (game.mouseRelease.isSome() == true) {
            onMouseButtonReleased(button, game, contains)
        }
        if (game.mouseMove.isSome() == true) {
            onHover(game, contains)
            onMouseMoved(game)
        }
        if (game.touchBegan.isSome() == true) {
            onTouchBegan(game, contains)
        }
        if (game.touchMoved.isSome() == true) {
            onHover(game, contains)
            onMouseMoved(game)
        }
        if (game.touchEnded.isSome() == true) {
            onTouchEnded(button, game, contains)
        }
        if (contains == true && captureInputEvents != InputEventType.None) {
            game.clearInputEvents(captureInputEvents)
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "clickUp" => VaBoolean(clickUp)
            case "enabled" => VaBoolean(enabled)
            case _ => None
        }
    }

    // Button

    private func click(button: Button, game: Game, playSound!: Bool, action!: ?Action): Bool {
        if (enabled == true) {
            if (let Some(action) <- action) {
                if (focusEnable == true) {
                    game.resources.setFocused(button)
                    if (focusOnClick == true) {
                        game.events.addBack(focusAction)
                    }
                }
                if (playSound == true) {
                    game.addPlayingSound(clickSound)
                }
                game.events.addBack(action)
                return true
            }
        }
        return false
    }

    public func click(button: Button, game: Game, playSound!: Bool): Bool {
        click(button, game, playSound: playSound, action: clickAction)
    }

    public func rightClick(button: Button, game: Game, playSound!: Bool): Bool {
        click(button, game, playSound: playSound, action: rightClickAction)
    }

    public func focus(game: Game): Unit {
        game.addPlayingSound(focusSound)
        game.events.addFront(focusAction)
    }

    public mut func setFocusEnabled(focusOnClick!: Bool): Unit {
        focusEnable = true
        this.focusOnClick = focusOnClick
    }
}
