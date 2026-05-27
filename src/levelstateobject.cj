package xquest

struct LevelStateObject {
    var state: LevelState = GameOver

    var level: Int64 = 0
    var score: Int64 = 0

    var lives: Int64 = 0
    var smartBombs: Int64 = 0

    var selectedPosition: (Int64, Int64) = (0, 0)
}
