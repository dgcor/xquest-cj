package dgengine

public class PredFileExists <: Predicate {
    public PredFileExists(private let file: String) {}

    public operator func ()(game: Game): Variable {
        let file2 = GameUtils.replaceStringWithVarOrProp(file, game)
        if (file2.isEmpty() == false) {
            return VaBoolean(FileUtils.exists(file2))
        }
        return VaBoolean(false)
    }
}

public class PredGamefileExists <: Predicate {
    public PredGamefileExists(private let file: String) {}

    public operator func ()(game: Game): Variable {
        let file2 = GameUtils.replaceStringWithVarOrProp(game.path + file, game)
        if (file2.isEmpty() == false) {
            return VaBoolean(FileUtils.gamefileExists(file2))
        }
        return VaBoolean(false)
    }
}
