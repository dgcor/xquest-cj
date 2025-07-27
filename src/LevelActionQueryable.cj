package XQuest

import dgengine.*

extend Level <: ActionQueryable {
    public func getAction(name: String): ?Action {
        match (name) {
            case "click" | "leftClick" => m_leftClickAction
            case "rightClick" => m_rightClickAction
            case "newRound" => m_newRoundAction
            case "gameOver" => m_gameOverAction
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "click" | "leftClick" => m_leftClickAction = action
            case "rightClick" => m_rightClickAction = action
            case "newRound" => m_newRoundAction = action
            case "gameOver" => m_gameOverAction = action
            case _ => return false
        }
        return true
    }
}
