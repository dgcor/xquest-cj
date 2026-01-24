package dgengine

import std.collection.*

public enum ConditionOp {
    | CoAnd
    | CoOr
    | CoLeftBracket
    | CoRightBracket
    | CoCondition(String, VarOrPredicate, VarOrPredicate)
}

// use brackets to force order
// ex: var1 == 2 and (var2 == 3 or var2 = 4)
public class IfCondition {
    private let m_elements: ArrayList<ConditionOp> = ArrayList<ConditionOp>()

    public static func getVariable(game: Game, varOrPred: VarOrPredicate): Variable {
        match (varOrPred) {
            case VaVariable(value) =>
                if (let VaString(str) <- value) {
                    if (str.isEmpty() == false && Rune(str[0]) == r'#') {
                        let strNoShebang = str[1..str.size]
                        let str2 = GameUtils.replaceStringWithVarOrProp(strNoShebang, game, token: '!')
                        if (let Some(value) <- game.getVarOrProp(str2)) {
                            return value
                        }
                        return VaString(str2)
                    }
                    if (let Some(value) <- game.getVarOrProp(str)) {
                        return value
                    }
                    return value
                }
                return value
            case VaPredicate(predicate) => return predicate?(game) ?? VaString(String.empty)
        }
    }

    public static func evalCondition(condition: String, var1: Variable, var2: Variable): Bool {
        match (condition) {
            case "==" => var1 == var2
            case "!=" => var1 != var2
            case ">" => var1 > var2
            case ">=" => var1 >= var2
            case "<" => var1 < var2
            case "<=" => var1 <= var2
            case "regex" =>
                var regexMatch = false
                if (let VaString(str) <- var1) {
                    regexMatch = Regex.matchPattern(str, var2.toString())
                }
                regexMatch
            case _ => var1 == var2
        }
    }

    public func addCondition(op: ConditionOp): Unit {
        m_elements.add(op)
    }

    public func addCondition(name: String, param1: VarOrPredicate, param2: VarOrPredicate): Unit {
        m_elements.add(CoCondition(name, param1, param2))
    }

    public prop empty: Bool {
        get() {
            m_elements.isEmpty()
        }
    }

    private func eval(index: Box<Int64>, game: Game): Bool {
        var val = false
        let firstIteration = index.value == 0
        var currOp = CoOr

        while (index.value < m_elements.size) {
            let elem = m_elements[index.value]
            index.value++
            var val2 = false
            match (elem) {
                case CoCondition(name, var1, var2) =>
                    let param1 = getVariable(game, var1)
                    let param2 = getVariable(game, var2)
                    val2 = evalCondition(name, param1, param2)
                case CoAnd | CoOr =>
                    currOp = elem
                    continue
                case CoLeftBracket => val2 = eval(index, game)
                case CoRightBracket => return val
            }
            match (currOp) {
                case CoAnd =>
                    val = match ((val, val2)) {
                        case (true, true) => true
                        case _ => false
                    }
                    if (firstIteration == true && val == false) {
                        return false
                    }
                case CoOr =>
                    val = match ((val, val2)) {
                        case (false, false) => false
                        case _ => true
                    }
                    continue
                case _ => ()
            }
        }
        return val
    }

    public func eval(game: Game): Bool {
        let index = Box(0)
        return eval(index, game)
    }
}
