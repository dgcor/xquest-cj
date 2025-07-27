package XQuest

struct LevelStateObject {
    public var state = GameOver

    public var level: Int64 = 0
    public var score: Int64 = 0

    public var lives: Int64 = 0
    public var smartBombs: Int64 = 0

    public var selectedPosition: (Int64, Int64) = (0, 0)
}
