package xquest

enum LevelState {
    | GameOver
    | AddLevelObjects
    | Detonate
    | Exploding
    | CheckStatus

    static func create(num: Int64): LevelState {
        match (num) {
            case 1 => AddLevelObjects
            case 2 => Detonate
            case 3 => Exploding
            case 4 => CheckStatus
            case _ => GameOver
        }
    }

    func toInt(): Int64 {
        match (this) {
            case GameOver => 0
            case AddLevelObjects => 1
            case Detonate => 2
            case Exploding => 3
            case CheckStatus => 4
        }
    }

    prop isGameOver: Bool {
        get() {
            match (this) {
                case GameOver => true
                case _ => false
            }
        }
    }
}
