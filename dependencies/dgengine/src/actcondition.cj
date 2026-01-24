package dgengine

public class ActIfCondition <: Action {
    public ActIfCondition(
        private let condition: String,
        private let param1: VarOrPredicate,
        private let param2: VarOrPredicate,
        private let condThen: ?Action,
        private let condElse: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        let var1 = IfCondition.getVariable(game, param1) // cjlint-ignore !G.VAR.02 minimize scope
        let var2 = IfCondition.getVariable(game, param2) // cjlint-ignore !G.VAR.02 minimize scope

        if (IfCondition.evalCondition(condition, var1, var2) == true) {
            if (let Some(action) <- condThen) {
                action(game)
            }
            return true
        } else {
            if (let Some(action) <- condElse) {
                action(game)
            }
            return false
        }
    }
}

public class ActInListCondition <: Action {
    public ActInListCondition(
        private let param: VarOrPredicate,
        private let list: Array<Variable>,
        private let condThen: ?Action,
        private let condElse: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        if (list.isEmpty() == false) {
            let var1 = IfCondition.getVariable(game, param) // cjlint-ignore !G.VAR.02 minimize scope
            for (elem in list) {
                if (var1 == IfCondition.getVariable(game, VaVariable(elem))) {
                    if (let Some(action) <- condThen) {
                        action(game)
                    }
                    return true
                }
            }
        }
        if (let Some(action) <- condElse) {
            action(game)
        }
        return false
    }
}

public class ActMultiIfCondition <: Action {
    private let m_conditions: IfCondition = IfCondition()

    public ActMultiIfCondition(
        private let condThen: ?Action,
        private let condElse: ?Action
    ) {}

    public prop conditions: IfCondition {
        get() {
            m_conditions
        }
    }

    public operator func ()(game: Game): Bool {
        if (m_conditions.eval(game) == true) {
            if (let Some(action) <- condThen) {
                action(game)
            }
            return true
        } else {
            if (let Some(action) <- condElse) {
                action(game)
            }
            return false
        }
    }
}

public class ActSwitchCondition <: Action {
    public ActSwitchCondition(
        private let param: VarOrPredicate,
        private let conditions: Array<(Variable, ?Action)>,
        private let defaultAction: ?Action
    ) {}

    public operator func ()(game: Game): Bool {
        if (conditions.isEmpty() == false) {
            let var1 = IfCondition.getVariable(game, param) // cjlint-ignore !G.VAR.02 minimize scope
            for ((elem, action) in conditions) {
                if (var1 == IfCondition.getVariable(game, VaVariable(elem))) {
                    if (let Some(action) <- action) {
                        action(game)
                    }
                    return true
                }
            }
        }
        if (let Some(action) <- defaultAction) {
            action(game)
        }
        return false
    }
}
