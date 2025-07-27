package XQuest

enum LevelState {
    | GameOver
    | AddUnits
    | Detonate
    | Exploding
    | CheckStatus

    public static func create(num: Int64) {
        match (num) {
            case 1 => AddUnits
            case 2 => Detonate
            case 3 => Exploding
            case 4 => CheckStatus
            case _ => GameOver
        }
    }

    public func toInt(): Int64 {
        match (this) {
            case GameOver => 0
            case AddUnits => 1
            case Detonate => 2
            case Exploding => 3
            case CheckStatus => 4
        }
    }

    public prop isGameOver: Bool {
        get() {
            match (this) {
                case GameOver => true
                case _ => false
            }
        }
    }
}
