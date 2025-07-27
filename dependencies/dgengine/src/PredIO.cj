package dgengine

public class PredFileExists <: Predicate {
    public PredFileExists(private let file: String) {}

    public operator func ()(game: Game): Variable {
        let file = GameUtils.replaceStringWithVarOrProp(file, game)
        if (file.isEmpty() == false) {
            return VaBoolean(FileUtils.exists(file))
        }
        return VaBoolean(false)
    }
}

public class PredGamefileExists <: Predicate {
    public PredGamefileExists(private let file: String) {}

    public operator func ()(game: Game): Variable {
        let file = GameUtils.replaceStringWithVarOrProp(game.path + file, game)
        if (file.isEmpty() == false) {
            return VaBoolean(FileUtils.gamefileExists(file))
        }
        return VaBoolean(false)
    }
}
