package dgengine

public class ActVariableAdd <: Action {
    public ActVariableAdd(
        private let key: String,
        private let value: Variable
    ) {}

    public operator func ()(game: Game): Bool {
        if (let Some(value2) <- game.variables.getVariableNoToken(key)) {
            match ((value, value2)) {
                case (VaInteger(value), VaInteger(value2)) => game.variables.setVariable(key, VaInteger(value + value2))
                case (VaDouble(value), VaDouble(value2)) => game.variables.setVariable(key, VaDouble(value + value2))
                case _ => ()
            }
        }
        return true
    }
}

public class ActVariableClear <: Action {
    public ActVariableClear(private let key: String) {}

    public operator func ()(game: Game): Bool {
        if (key.isEmpty() == false) {
            game.variables.clearVariable(key)
        }
        return true
    }
}

public class ActVariableSave <: Action {
    public ActVariableSave(
        private let filePath: String,
        private let vars: Array<String>
    ) {}

    public operator func ()(game: Game): Bool {
        if (filePath.isEmpty() == false) {
            game.variables.saveVariables(filePath, vars)
        }
        return true
    }
}

public class ActVariableSet <: Action {
    public ActVariableSet(
        private let key: String,
        private let value: Variable,
        private let resolveValue: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (key.isEmpty() == false) {
            if (resolveValue == false) {
                game.variables.setVariable(key, value)
            } else {
                let value = game.getVarOrProp(value)
                game.variables.setVariable(key, value)
            }
        }
        return true
    }
}

public class ActVariableSetIfNull <: Action {
    public ActVariableSetIfNull(
        private let key: String,
        private let value: Variable,
        private let resolveValue: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        if (key.isEmpty() == false) {
            if (game.variables.getVariableNoToken(key).isNone()) {
                if (resolveValue == false) {
                    game.variables.setVariable(key, value)
                } else {
                    let value = game.getVarOrProp(value)
                    game.variables.setVariable(key, value)
                }
            }
        }
        return true
    }
}

public class ActVariablesSet <: Action {
    public ActVariablesSet(
        private let variables: Array<(String, Variable)>,
        private let resolveValue: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        for ((key, value) in variables) {
            if (key.isEmpty() == false) {
                if (resolveValue == false) {
                    game.variables.setVariable(key, value)
                } else {
                    let value = game.getVarOrProp(value)
                    game.variables.setVariable(key, value)
                }
            }
        }
        return true
    }
}
