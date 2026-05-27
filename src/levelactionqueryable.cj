package xquest

import dgengine.*

extend Level <: ActionQueryable {
    public func getAction(name: String): ?Action {
        match (name) {
            case "click" | "leftClick" => leftClickAction
            case "rightClick" => rightClickAction
            case "newRound" => newRoundAction
            case "gameOver" => gameOverAction
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "click" | "leftClick" => leftClickAction = action
            case "rightClick" => rightClickAction = action
            case "newRound" => newRoundAction = action
            case "gameOver" => gameOverAction = action
            case _ => return false
        }
        return true
    }
}
